#!/bin/bash
echo "Build started"
cd repo
mkdir -p /project/src/github.com/leaf-ai
cp -rT `pwd` /project/src/github.com/leaf-ai/studio-go-runner
cd /project/src/github.com/leaf-ai/studio-go-runner
export GOPATH=/project
set -e ; set -o pipefail ; (go get github.com/karlmutch/duat && go get github.com/karlmutch/enumer && dep ensure && go build -o $GOPATH/bin/build -tags NO_CUDA *.go && $GOPATH/bin/build -r -dirs internal && $GOPATH/bin/build -dirs cmd/runner) 2>&1 | tee $RUNNER_BUILD_LOG
