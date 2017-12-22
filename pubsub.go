package runner

// This file contains the implementation of googles PubSub message queues
// as they are used by studioML

import (
	"flag"
	"sync/atomic"
	"time"

	"cloud.google.com/go/pubsub"
	"golang.org/x/net/context"
	"google.golang.org/api/iterator"
	"google.golang.org/api/option"

	"github.com/go-stack/stack"
	"github.com/karlmutch/errors"
)

var (
	pubsubTimeoutOpt = flag.Duration("pubsub-timeout", time.Duration(5*time.Second), "the period of time discrete pubsub operations use for timeouts")
)

type PubSub struct {
	project string
	creds   string
}

func NewPubSub(project string, creds string) (ps *PubSub, err errors.Error) {
	return &PubSub{
		project: project,
		creds:   creds,
	}, nil
}

func (ps *PubSub) Refresh(timeout time.Duration) (known map[string]interface{}, err errors.Error) {

	known = map[string]interface{}{}

	ctx, cancel := context.WithTimeout(context.Background(), *pubsubTimeoutOpt)
	defer cancel()

	client, errGo := pubsub.NewClient(ctx, ps.project, option.WithCredentialsFile(ps.creds))
	if errGo != nil {
		return nil, errors.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
	}
	defer client.Close()

	// Get all of the known subscriptions in the project and make a record of them
	subs := client.Subscriptions(ctx)
	for {
		sub, errGo := subs.Next()
		if errGo == iterator.Done {
			break
		}
		if errGo != nil {
			return nil, errors.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
		}
		known[sub.ID()] = true
	}

	return known, nil
}

func (ps *PubSub) Exists(ctx context.Context, subscription string) (exists bool, err errors.Error) {
	client, errGo := pubsub.NewClient(ctx, ps.project, option.WithCredentialsFile(ps.creds))
	if errGo != nil {
		return true, errors.Wrap(errGo).With("stack", stack.Trace().TrimRuntime()).With("project", ps.project)
	}
	defer client.Close()

	exists, errGo = client.Subscription(subscription).Exists(ctx)
	if errGo != nil {
		return true, errors.Wrap(errGo).With("stack", stack.Trace().TrimRuntime()).With("project", ps.project)
	}
	return exists, nil
}

// Work will try to start as many instances of a single item of work that it can and then
// stop and wait for them all to drain
//
func (ps *PubSub) Work(ctx context.Context, qTimeout time.Duration, subscription string, maxJobs uint, handler MsgHandler) (msgs uint64, resource *Resource, err errors.Error) {

	client, errGo := pubsub.NewClient(ctx, ps.project, option.WithCredentialsFile(ps.creds))
	if errGo != nil {
		return 0, nil, errors.Wrap(errGo).With("stack", stack.Trace().TrimRuntime()).With("project", ps.project)
	}
	// defer of the close is not being used to allow the close done later
	// to happen at a predictable time

	sub := client.Subscription(subscription)
	sub.ReceiveSettings.MaxExtension = time.Duration(12 * time.Hour)
	sub.ReceiveSettings.MaxOutstandingMessages = int(maxJobs)

	qCtx, qCancel := context.WithTimeout(context.Background(), qTimeout)

	// Watch both contexts for cancellations and signal the pubsub receiver
	go func() {
		defer recover()
		select {
		case <-ctx.Done():
			qCancel()
		case <-qCtx.Done():
			return
		}
	}()

	// Could block forever so we use a cancel context.  The qCtx will expire either with no messages
	// or several seconds into the procesing of the first message.  The function handling the
	// message however will use the application specific context not the queue receive context
	errGo = sub.Receive(qCtx,
		func(_ context.Context, msg *pubsub.Message) {

			// If we detect that the top level context is cancelled then
			// Nack anything that arrives to prevent messages sent to this subscriber
			// and possibly others being repeated work.  Nacking wont do any harm in any
			// event as the messages will simply be placed back into the queue
			select {
			case <-ctx.Done():
				msg.Nack()
				return
			case <-qCtx.Done():
				msg.Nack()
				return
			default:
			}

			if rsc, ack := handler(ctx, ps.project, subscription, ps.creds, msg.Data); ack {
				msg.Ack()
				resource = rsc
			} else {
				msg.Nack()
				qCancel()
			}
			atomic.AddUint64(&msgs, 1)
		})

	client.Close()

	if errGo != nil && errGo != context.Canceled {
		return msgs, nil, errors.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
	}

	return msgs, resource, nil
}
