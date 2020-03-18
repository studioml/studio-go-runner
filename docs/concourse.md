# Concourse based CI

The studio go runner project is current experimenting with a variety of CI pipeline tools in order to reduce the complexity of building and releasing the offering.

Concourse has a number of desirable characteristics for this project.  The runner pipeline needs to be buildable and deployable on hardware that is typically fairly expensive to source on monthly plans offered by CI SaaS vendors.  Concourse is thought to be a good fit as it can be deployed using generic Kubernetes clusters on traditional PC equipment with GPU cards and therefore offers a solution across the varied needs of its diverse users.  Concourse also offers a way of generating container images within Kubernetes without concerning developers with a arduous installation process needed for users of tooling such as Kaniko or Makisu.

This document details the instructions and progress on experimenting with Concourse.

This document make the assumtion that the microk8s Kubernetes distribution is being used.  microk8s is an Ubuntu distribution of Kubernetes that is designed for individual developer workstations.  To make use of kubectl in other contexts drop the 'microk8s.' prefix on the commands documented in this document.

# Audience

This document is targetted at devops roles for people with a working knowledge of Kubernetes and and container oriented development and releases.

# Concourse Pipeline

When wrangling JSON documents the jq tool has proved invaluable, https://stedolan.github.io/jq/, and is used by these instructions.

## Prerequisites

The process uses several tools for the duat toolkit:

```
wget -O $GOPATH/bin/semver https://github.com/karlmutch/duat/releases/download/0.12.0/semver-linux-amd64
wget -O $GOPATH/bin/stencil https://github.com/karlmutch/duat/releases/download/0.12.0/stencil-linux-amd64
chmod +x $GOPATH/bin/semver
chmod +x $GOPATH/bin/stencil
```

## Install helm 3 and the Concourse metadata store and controller

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add funkypenguin https://funkypenguin.github.io/helm-charts
helm repo update
helm init
cat <<EOF >concourse-values.yml
workers:
    enabled: true
    replicas: 1

## Specify if a Pod Security Policy for node-exporter must be created
## Ref: https://kubernetes.io/docs/concepts/policy/pod-security-policy/
##
podSecurityPolicy:
  enabled: false
  annotations: {}
EOF
export CONCOURSE_RELEASE=test
helm install -f concourse-values.yml funkypenguin/concourse --version 8.2.5 --name $CONCOURSE_RELEASE
```

Enabling priv containers to run to allow the workers to be started for concourse can be done by adding the line ```--allow-privileged`` into /var/snap/microk8s/current/args/kube-apiserver file and then by using the following commands:

```
sudo systemctl restart snap.microk8s.daemon-kubelet.service
sudo systemctl restart snap.microk8s.daemon-apiserver.service
```

## Deploy the studioml go runner pipeline

```
export POD_NAME=$(kubectl get pods --namespace default -l "app=$CONCOURSE_RELEASE-web" -o jsonpath="{.items[0].metadata.name}")
echo "Visit http://127.0.0.1:8080 to use Concourse"
kubectl port-forward --namespace default $POD_NAME 8080:8080 &
wget -o ~/.local/bin/fly 'http://127.0.0.1:8080/api/v1/cli?arch=amd64&platform=linux'
chmod +x ~/.local/bin/fly
fly --target studioml-go-runner login -u test -p test --concourse-url http://127.0.0.1:8080
fly -t studioml-go-runner set-pipeline --pipeline test --config pipeline.yml
```

## studioml go runner pipeline builds

Having completed the installation and loaded the pipeline we can now trigger builds by suppling the current repository that we have checked out as input:

```
export SEMVER=`semver`
export GIT_BRANCH=`echo '{{.duat.gitBranch}}'|stencil -supress-warnings - | tr '_' '-' | tr '\/' '-'`
cat <<EOF | envsubst >task.yml
---
platform: linux
image_resource:
    type: docker-image
    source:
        repository: registry.container-registry.svc.cluster.local:5000/leafai/studio-go-runner-concourse-build
        tag: "$GIT_BRANCH"
        insecure_registries: ["registry.container-registry.svc.cluster.local:5000"]

inputs:
    - name: repo

run:
    path: " ./repo/concourse-test.sh'"
EOF
docker tag leafai/studio-go-runner-concourse-build:$GIT_BRANCH localhost:32000/leafai/studio-go-runner-concourse-build:$GIT_BRANCH
docker push localhost:32000/leafai/studio-go-runner-concourse-build:$GIT_BRANCH
fly -t studioml-go-runner execute --include-ignored -c task.yml --input repo=.
```

https://github.com/pivotalservices/concourse-pipeline-samples/tree/master/concourse-pipeline-hacks/fly-execute

In order to extract the output of the one build job you can do the following:

```
export CONCOURSE_JOB_ID=`fly -t studioml-go-runner builds --json | jq -c 'sort_by(.id) | .[-1:] | .[0].id'`
fly -t studioml-go-runner watch $CONCOURSE_JOB_ID
```

# Common problems

If at any point you recieve an error that the port being forwarded from your build cluster is no longer available as follows then the kubectl port forward command should be repeated to reestablish the connectivity.


If you should see the following:

```
Handling connection for 8080
could not find a valid token.
logging in to team 'main'

Handling connection for 8080
navigate to the following URL in your browser:

  http://127.0.0.1:8080/login?fly_port=36463
```

Then you should repeat the login sequence to obtain a token for use with the Concourse server:

```
fly --target studioml-go-runner login -u test -p
 test --concourse-url http://127.0.0.1:8080
logging in to team 'main'

Handling connection for 8080

Handling connection for 8080
target saved
```

Copyright &copy 2019-2020 Cognizant Digital Business, Evolutionary AI. All rights reserved. Issued under the Apache 2.0 license.
