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


# Agola pipeline
```
cd ~/projects/src/github.com
git clone https://github.com/agola-io/agola
cd agola
export GOPATH="$HOME/project"
export GOROOT="$HOME/go"
go build -o agola.exe ./cmd/agola/main.go
cd examples/kubernetes/simple
```

```
cat gitea.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gitea-deployment
  labels:
    app: gitea
spec:
  replicas: 1
  selector:
    matchLabels:
      app: gitea
  template:
    metadata:
      labels:
        app: gitea
    spec:
      containers:
      - name: gitea
        image: gitea/gitea:latest
        ports:
        - containerPort: 3000
          name: gitea-http
        - containerPort: 22
          name: git-ssh
        volumeMounts:
        - mountPath: /tmp/gitea
          name: git-data
      volumes:
      - name: git-data
        hostPath:
          path: /mnt/kube-data/gitea
          type: Directory
---
kind: Service
apiVersion: v1
metadata:
  name: gitea
spec:
  selector:
    app: gitea
  ports:
  - name: gitea-http
    port: 3000
    targetPort: gitea-http
  - name: gitea-ssh
    port: 2222
    targetPort: gitea-ssh
kubectl apply -f gitea.yml
export GITEA_IP=`kubectl get service gitea -o json | jq -r .spec.clusterIP`
export GITEA_PORT=`kubectl get service gitea -o json | jq -r ".spec.ports[].port"`
firefox $GITEA_IP:3000
# Click on register
# Change the "Gitea base URL" from http://localhost:3000 to http://[Contents of $GITEA_IP]:3000
# Change the "SSH Server Domain" from localhost to [Contents of $GITEA_IP]
# [Click on "Install Gitea"]
# Click on the [Register] button
# Add an account that will be used later with the agola configuration
# Use the account settings after you have logged in to add your SSH public key from your Linux dev account
# Now create an oauth2 app under your user settings -> Applications -> Manage OAuth2 Applications. As the application name set "Agola" and as redirect uri http://[Contents of $GITEA_IP]:8000/oauth2/callback. Keep note of the provided "Client ID" and "Client Secret".
export GITEA_APP_CLIENTID=4dd1b071-2ee5-45be-bd5f-3cc44b6a6f0b
export GITEA_APP_CLIENTSECRET="8jVbUiqnK_6JSq188cJyx--jnsbDjZUHiKmvSgP5M14="
```

Modify the agola yaml so that the exposed URL entries all have a port of 8000 which is the service port defined in the Kubernetes service resource block.

```
kubectl apply -f ../common/rbac.yml
kubectl apply -f ./agola.yml
```

```
cat microk8s.yml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: agola-vol
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  persistentVolumeReclaimPolicy: Delete
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  local:
    path: "/tmp/agola-vol"
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - $AGOLA_HOST
kubectl apply -f microk8s-volume.yml
```

```
export AGOLA_HOST=`kubectl get nodes -o json | jq -r ".items[0].metadata.labels[\"kubernetes.io/hostname\"]"`
envsubst microk8s-volume.yml | kubectl apply -f -

export AGOLA_IP=`kubectl get service agola -o json | jq -r .spec.clusterIP`
export AGOLA_PORT=`kubectl get service agola -o json | jq -r ".spec.ports[].port"`
```

Go back and modify the agola.yml file to using the $AGOLA_IP value as the host IP address for all of the exposed URL ConfigMap entries.  Then apply the new yml file, and delete the pod and allow the pod to be re-created so that it reads the new ConfigMap entries.  After this we can create the remote resource for the gitea repository that was added.

```
../../../agola.exe --token "admintoken" --gateway-url http://$AGOLA_IP:8000 remotesource create \
--name gitea \
--type gitea \
--api-url http://$GITEA_IP:3000 \
--auth-type oauth2 \
--clientid $GITEA_APP_CLIENTID \
--secret $GITEA_APP_CLIENTSECRET \
--skip-ssh-host-key-check

export AGOLA_TOKEN=`./agola.exe user token create -n karl -u http://$AGOLA_IP:$AGOLA_PORT --token "admintoken" -t default`

firefox $AGOLA_IP:AGOLA_PORT
```

Use the displayed web page to register the gitea repository with the agola user.

Copyright &copy 2019-2020 Cognizant Digital Business, Evolutionary AI. All rights reserved. Issued under the Apache 2.0 license.
