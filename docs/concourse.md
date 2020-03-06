# Tekton based CI

The studio go runner project is current experimenting with a variety of CI pipeline tools in order to reduce the complexity of building and releasing the offering.

Tekton has a number of desirable characteristics for this project.  The runner pipeline needs to be buildable and deployable on hardware that is typically fairly expensive to source on monthly plans offered by CI SaaS vendors.  Tekton is thought to be a good fit as it can be deployed using generic Kubernetes clusters on traditional PC equipment with GPU cards and therefore offers a solution across the varied needs of its diverse users.  Tekton also offers a way of generating container images within Kubernetes without concerning developers with a arduous installation process needed for users of tooling such as Kaniko or Makisu.

This document details the instructions and progress on experimenting with Tekton.

This document make the assumtion that the microk8s Kubernetes distribution is being used.  microk8s is an Ubuntu distribution of Kubernetes that is designed for individual developer workstations.  To make use of kubectl in other contexts drop the 'microk8s.' prefix on the commands documented in this document.

# Audience

This document is targetted at devops roles for people with a working knowledge of Kubernetes and and container oriented development and releases.

## Installation

Tekton can be deployed using the instructions found at https://github.com/tektoncd/pipeline/blob/master/docs/install.md.

A CLI is available for Tekton and can be installed using the following, https://github.com/tektoncd/cli#getting-started.

In order to configure sharing between pipelines an S3 server can be configured, see instructions at https://github.com/tektoncd/pipeline/blob/master/docs/install.md#configuring-tekton-pipelines.  S3 is considered the best option in our case due to being an independent state store that can also be configured as an on-premises store using minio.

An example of using S3 configurations can be found in the tekton/storage.yaml file of this present github repository and could be applied using the stencil tool found at, https://github.com/karlmutch/duat/releases/download/0.12.0/stencil-linux-amd64

```
microk8s.kubectl apply -f <(stencil < tekton/storage.yaml)
```

Pay special attention to the requirement that the S3 storage bucket should reside in the us-east-1 zone due to internal tekton tooling.

Be sure to go through the tutorial(s) provided by Tekton to gain an appreciation of its features, https://github.com/tektoncd/pipeline/blob/master/docs/tutorial.md.

# Concourse Pipeline

# Install helm 3

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add funkypenguin https://funkypenguin.github.io/helm-charts
helm repo update
helm init
helm install funkypenguin/concourse --version 8.2.5
```

Enabling priv containers to run to allow the workers to be started for concourse can be done by adding the line ```--allow-privileged`` into /var/snap/microk8s/current/args/kube-apiserver file and then by using the following commands:

```
sudo systemctl restart snap.microk8s.daemon-kubelet.service
sudo systemctl restart snap.microk8s.daemon-apiserver.service
```

```
export POD_NAME=$(kubectl get pods --namespace default -l "app=tinseled-pug-web" -o jsonpath="{.items[0].metadata.name}")
echo "Visit http://127.0.0.1:8080 to use Concourse"
kubectl port-forward --namespace default $POD_NAME 8080:8080 &
wget -o ~/.local/bin/fly 'http://127.0.0.1:8080/api/v1/cli?arch=amd64&platform=linux'
chmod +x ~/.local/bin/fly
fly --target studioml-go-runner login -u test -p test --concourse-url http://127.0.0.1:8080
fly -t studioml-go-runner set-pipeline --pipeline test --config pipeline.yml
```

```
SEMVER=`semver`
docker tag leafai/studio-go-runner-standalone-build:$SEMVER localhost:32000/leafai/studio-go-runner-standalone-build:$SEMVER
docker push localhost:32000/leafai/studio-go-runner-standalone-build:$SEMVER
fly -t studioml-go-runner execute -c task.yml --input repo=.
```

https://github.com/pivotalservices/concourse-pipeline-samples/tree/master/concourse-pipeline-hacks/fly-execute

Copyright &copy 2019-2020 Cognizant Digital Business, Evolutionary AI. All rights reserved. Issued under the Apache 2.0 license.
