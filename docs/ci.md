# Continuous Integration Setup

This document describes setting up a CI pipline that can be used to prepare releases for studio go runner.

The steps described in this document can also be used by individual developers to perform build and release tasks on locally checked out code.

studio go runner is intended to run in diverse hardware environments using GPU enabled machines. As a result providing a free, and publically hosted CI/CD platform is cost prohibitive. As an alternative the studio go runner CI and CD pipeline has been designed to center around the use of container images and is flexible about the hosting choices of specific steps in the pipeline.  Steps within the pipeline use image registries to demark the boundaries between pipeline steps.  Pipeline steps are typically implemented as jobs within a Kubernetes cluster, allowing the pipeline to be hosted using Kubernetes deployed on laptops through to fully productionized clusters.

Triggering steps in the pipeline can be predicated on local/remote git commits, or any form of image publishing/releasing action against the image registr. Image registries may be hosted on self provisioned Kubernetes provisioned cluster either within the cloud, or on private infrastructure.  This allows testing to be done using the CI pipeline on both local laptops, workstations and in cloud or data center environments.  The choice of docker.io as the registry for the resulting build images is due to its support of selectively exposing only public repositories from github accounts preserving privacy.

Pipelines can also be entirely self hosted upon the microk8s Kubernetes distribution, for example.  This style of pipeline is inteded to be used in circumstances where individuals have access to a single machine, have limited internet bandwidth, and so who do not wish to host images on external services or hosts or do not wish to incur costs for cloud resources and mightfor example have a local GPU that can be used for testing.

These instructions first detail how a docker.io or local microk8s registry can be setup to trigger builds on github commits.  Instructions then detail how to make use of Keel, https://keel.sh/, to pull CI images into a cluster and run the pipeline.  Finally this document describes the use of Uber's Makisu to deliver production images to the docker.io / quay.io image hosting service(s).  docker hub is used as this is the most reliable of the image registries that Makisu supports, quay.io could not be made to work for this step.

<!--ts-->

Table of Contents
=================

* [Continuous Integration Setup](#continuous-integration-setup)
* [Table of Contents](#table-of-contents)
* [Pipeline Overview](#pipeline-overview)
* [Prerequisties](#prerequisties)
  * [duat tools](#duat-tools)
  * [github administration and release tooling](#github-administration-and-release-tooling)
  * [docker and the microk8s Kubernetes distribution installation](#docker-and-the-microk8s-kubernetes-distribution-installation)
  * [Optional tooling and Image Registries](#optional-tooling-and-image-registries)
* [A word about privacy and supply chain security](#a-word-about-privacy-and-supply-chain-security)
* [Build step Images (CI)](#build-step-images-ci)
  * [CUDA and Compilation builder image preparation](#cuda-and-compilation-builder-image-preparation)
  * [Code quality scanning](#code-quality-scanning)
  * [Internet based registra build images](#internet-based-registra-build-images)
    * [quay.io account](#quayio-account)
    * [quay.io release configuration](#quayio-release-configuration)
  * [Development and local build image bootstrapping](#development-and-local-build-image-bootstrapping)
* [Continuous Integration](#continuous-integration)
  * [CI front office setup](#ci-front-office-setup)
  * [Triggering builds](#triggering-builds)
    * [Local source image builds](#local-source-image-builds)
    * [git based source image builds](#git-based-source-image-builds)
  * [Locally deployed keel testing and CI](#locally-deployed-keel-testing-and-ci)
* [Monitoring and fault checking](#monitoring-and-fault-checking)
  * [Bootstrapping](#bootstrapping)
  * [microk8s Registry](#microk8s-registry)
  * [Image Builder](#image-builder)
  * [Keel components](#keel-components)
<!--te-->

# Pipeline Overview

The CI pipeline for the studio go runner project uses docker images as inputs to a series of processing steps making up the pipeline.  The following sections describe the pipeline components, and an additional section describing build failure diagnosis and tracking.  This pipeline is designed for use by engineers with Kubernetes familiarity without a complex CI/CD platform and the chrome that typically accompanies domain specific platforms and languages employed by dedicated build-engineer roles.

The pipeline is initiated through the creation of a builder docker image that contains a copy of the source code and tooling needed to perform the builds and testing.

The first stage in the pipeline is to execute the build and test steps using a builder image.  If these are succesful the pipeline will then trigger a production image creation step that will also push the resulting production image to an image registry.

As described above the major portions of the pipeline can be illustrated by the following figure:

```console
+---------------+       +---------------------+      +---------------+        +-------------------+      +----------------------+      +-----------------+
|               |       |                     |      |               |        |                   |      |                      |      |                 |
|   Reference   |       |      git-watch      |      |     Makisu    |        |                   +----> |    Keel Triggers     |      | Container Based |
|    Builder    +-----> |    Bootstrapping    +----> |               +------> |  Image Registry   |      |                      +----> |  CI Build Test  |
|     Image     |       |      Copy Pod       |      | Image Builder |        |                   | <----+ Build, Test, Release |      |                 |
|               |       |                     |      |               |        |                   |      |                      |      |                 |
+---------------+       +---------------------+      +---------------+        +-------------------+      +----------------------+      +-----------------+
```

Inputs and Outputs to pipeline steps consist of Images that when pushed to a registry will trigger downstream build steps.

Before using the pipeline there are several user/developer requirements for familiarity with several technologies.

1. Kubernetes

   A good technical and working knowledge is needed including knowing the Kubernetes resource abstractions as well as operational know-how
   of how to navigate between and within clusters, how to use pods and extract logs and pod descriptions to located and diagnose failures.

   Kubernetes forms a base level skill for developers and users of studio go runner open source code.

   This does not exclude users that wish to user or deploy Kubernetes free installations of studio go runner binary releases.

2. Docker and Image registry functionality

   Experience with image registries an understanding of tagging and knowledge of semantic versioning 2.0.

3. git and github.com

   Awareness of the release, tagging, branching features of github.

Other software systems used include

1. keel.sh
2. Makisu from Uber
3. Go from Google
4. Kustomize from the Kubernetes sigs

Montoring the progress of tasks within the pipeline can be done by inspecting pod states, and extracting logs of pods responsible for various processing steps.  The monitoring and diagnosis section at the end of this document contains further information.

# Prerequisties

## duat tools

Instructions within this document make use of the go based stencil tool.  This tool can be obtained for Linux from the github release point, https://github.com/karlmutch/duat/releases/download/0.15.5/stencil-linux-amd64.

```console
$ mkdir -p ~/bin
$ wget -O ~/bin/semver https://github.com/karlmutch/duat/releases/download/0.15.5/semver-linux-amd64
$ chmod +x ~/bin/semver
$ wget -O ~/bin/stencil https://github.com/karlmutch/duat/releases/download/0.15.5/stencil-linux-amd64
$ chmod +x ~/bin/stencil
$ wget -O ~/bin/git-watch https://github.com/karlmutch/duat/releases/download/0.15.5/git-watch-linux-amd64
$ chmod +x ~/bin/git-watch
$ export PATH=~/bin:$PATH
```

For self hosted images using microk8s the additional git-watch tool is used to trigger CI/CD image bootstrapping as the alternative to using docker.io based image builds.

Some tools such as petname are installed by the build scripts using 'go get' commands.


## github administration and release tooling

The github CLI command is used for performing release activities and can be performed using the following:

```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages
sudo apt update
sudo apt install gh
```

## docker and the microk8s Kubernetes distribution installation

You will also need to install docker, and microk8s using Ubuntu snap.  When using docker installs only the snap distribution for docker is compatible with the microk8s deployment.

```console
sudo snap install docker --classic
sudo snap install microk8s --classic
```
When using microk8s during development builds the setup involved simply setting up the services that you to run under microk8s to support a docker registry and also to enable any GPU resources you have present to aid in testing.

```console
export LOGXI='*=DBG'
export LOGXI_FORMAT='happy,maxcol=1024'

export SNAP=/snap
export PATH=$SNAP/bin:$PATH

export KUBE_CONFIG=~/.kube/microk8s.config
export KUBECONFIG=~/.kube/microk8s.config

microk8s.stop
microk8s.start
microk8s.config > $KUBECONFIG
microk8s.enable registry:size=30Gi storage dns gpu
```

Now we need to perform some customization, the first step then is to locate the IP address for the host that can be used and then define an environment variable to reference the registry.  

```console
export RegistryIP=`microk8s.kubectl --namespace container-registry get pod --selector=app=registry -o jsonpath="{.items[*].status.hostIP}"`
export RegistryPort=32000
echo $RegistryIP
172.31.39.52
```

Now we have an IP Address for our unsecured microk8s registry we need to add it to the containerd configuration file being used by microk8s to mark this specific endpoint as being permitted for use with HTTP rather than HTTPS, as follows:
 
```console
sudo vim /var/snap/microk8s/current/args/containerd-template.toml
```
 
And add the last two lines in the following example to the file substituting in the IP Address we selected
 
```console
  # 'plugins."io.containerd.grpc.v1.cri".registry' contains config related to the registry
  [plugins."io.containerd.grpc.v1.cri".registry]

    # 'plugins."io.containerd.grpc.v1.cri".registry.mirrors' are namespace to mirror mapping for all namespaces.
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
        endpoint = ["https://registry-1.docker.io", ]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:32000"]
        endpoint = ["http://localhost:32000"]        
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors."172.31.39.52:32000"]
        endpoint = ["http://172.31.39.52:32000"]
```
 
```console
sudo vim /var/snap/docker/current/config/daemon.json
```
 
And add the insecure-registries line in the following example to the file substituting in the IP Address we obtained from the $RegistryIP
 
```console
{
    "log-level":        "error",
    "storage-driver":   "overlay2",
    "insecure-registries" : ["172.31.39.52:32000"]
}
```
 
The services then need restarting, note that the image registry will be cleared of any existing images in this step:
 
```console
microk8s.disable registry
microk8s.stop
sudo snap disable docker
sudo snap enable docker
microk8s.start
microk8s.enable registry:size=30Gi
```

## Optional tooling and Image Registries

There are some optional steps that you should complete prior to using the build system depending upon your goal such as releasing the build for example.

If you intend on marking a tagged github version of the build once successful you will need to export a GITHUB\_TOKEN environment variable.  Without this defined the build will not write any release tags etc to github.

If you intend on releasing the container images then you will need to populate docker login credentials for the quay.io repository:

```console
$ docker login quay.io
Username: [Your quay.io user name]
Password: [Your quay.io password]
WARNING! Your password will be stored unencrypted in /home/kmutch/snap/docker/423/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

# A word about privacy and supply chain security

Many of the services that provide image hosting use Single Sign On and credentials management with your source code control platform of choice.  As a consequence of this often these services will gain access to any and all repositories private or otherwise that you might have access to within your account.  In order to preserve privacy and maintain fine grained control over the visibility of your private repositories it is recommended that when using docker hub and other services that you create a service account that has the minimal level of access to repositories as necessary to implement your CI/CD features.

If the choice is made to use self hosted microk8s a container registry is deployed on our laptop or desktop that is not secured and relies on listening only to the local host network interface.  Using a network in-conjunction with this means you will need to secure your equipment and access to networks to prevent exposing the images produced by the build, and also to prevent other actors from placing docker images onto your machine.

Images produced by the CI/CD pipeline as detailed within this document remain unsigned when pushed to public image repositories.  Image signing is a seperate step performed externally to the CI system and makes use of the cosign facility.  cosign is used externally to the pipeline by an authorized individual until such time as the project is able to be asured that the security of the OCI signing credentials in a CI/CD pipeline can be maintained.

For information about cosign please see, https://github.com/sigstore/cosign.  

When using cosign the first action is to create a keypair for use with the signing and validation operations.  cosign can support direct operations with key management stores when using Google Cloud. AWS support for image signing was scheduled to be released this year, 2021, but has yet to appear.

The first operation is to generate a keypair.  This action is done once and only once. The machine on which these keys must be managed securely.

Should this machine be compromised older versions of images can be articially created and signed as if they were genuine.  Should a compromise happen then the procedure should to announce that the projects public key has been compromised and that all future releases will be done using a new key-pair.  In addition users should be informed that older images should be checked for their advertised hash and these should be validated when pulling new images.  In any event it should be noted that images should be loaded using their SHAR256 hash rather than tag names.

```
$ cosign generate-key-pair
Enter password for private key:
Enter again: 
Private key written to cosign.key
Public key written to cosign.pub
$ mv cosign.key ~/.ssh
$ mv cosign.pub ~/.ssh
```

Our next set of examples show the process for manual signing and then the subsequent steps done after signing to prevent problems drifting into the deployed artifacts. 

An example of performing image signing appears as follows:

```
$ QUAY_IO_USERNAME=`echo "quay.io" | crane auth get | jq ".Username" -r`
$ QUAY_IO_SECRET=`echo "quay.io" | crane auth get | jq ".Secret" -r`
$ crane auth login quay.io -u $QUAY_IO_USERNAME -p $QUAY_IO_SECRET
$ crane ls quay.io/leafai/studio-go-runner
0.13.2-main-aaaagqrvxyo
0.13.2-main-aaaagqusrgk
0.13.2
0.14.0-main-aaaagqwnnzd
0.14.0-main-aaaagqxwidj
0.14.0-main-aaaagraydfq
0.14.0-main-aaaagrfcxkq
0.14.0
0.14.1-main-aaaagrfzssz
0.14.1-main-aaaagrhimez
0.14.1-main-aaaagriedbz
$ cosign -key ~/.ssh/cosign.key index.docker.io/leafai/studio-go-runner:0.14.1-main-aaaagriedbz
$ cosign -key ~/.ssh/cosign.key index.docker.io/leafai/azure-studio-go-runner:0.14.1-main-aaaagriedbz
$ cosign -key ~/.ssh/cosign.key index.docker.io/leafai/studio-serving-bridge:0.14.1-main-aaaagriedbz
```

At the time of writing this section quay.io was not yet fully compliant with the new OCI registry API and did not support signing. A list of the registries that can support signing can be found at, https://github.com/sigstore/cosign#registry-support.

# Build step Images (CI)

The studio go runner project uses Docker images to completely encapsulate build steps, including a full git clone of the source comprising releases or development source tree(s) copied into the image.  Using image registries, or alternatively the duat git-watch tool, it is possible to build an image from the git repository as commits occur and to then host the resulting image.  A local registry can be used to host builder images using microk8s, or Internet registries offer hosting for open source projects for free, and also offer paid hosted plans for users requiring privacy.

If you intend on using this pipeline to compile locally modified code then this can be done by creating the build step images and then running the containers using volume mounts that point at your locally checked-out source code, or in the case of pipeline updating the build step images with code and pushing them to a docker registry that the pipeline is observing.

The git-watch option serves on-premises users, and individual contributors, or small teams that do not have large financial resources to employ cloud hosted subscription sevices, or for whom the latency of moving images and data through residential internet connections is prohibitive.

Before commencing a build of the runner a reference, or base image is created that contains all of the build tooling needed.  This image changes only when the build tooling needs upgrading or changing.  The reason for doing this is that this image is both time consuming and quite large due to dependencies on NVidia CUDA, Python, and Tensorflow.  Because of this the base image build is done manually and then propogated to image registries that your build environment can access.  Typically unless there is a major upgrade most developers will be able to simply perform a docker pull from the docker.io registry to get a copy of this image. The first of instructions detail building the base image.

## CUDA and Compilation builder image preparation

In order to prepare for producing product specific build images a base image is employed that contains the infrequently changing build software on which the StudioML and AI frameworks depend.

If you wish to simply use an existing build configuration then you can pull the prebuilt image into your local docker registry, or from docker hub using the following command:

```
docker pull leafai/studio-go-runner-dev-base:0.0.9
docker pull leafai/studio-go-runner-dev-stack:0.0.3
```

For situations where an on-premise or single developer machine the base image can be built with the `Dockerfile_base`, and `Dockerfile_stack` files using the following command:

```console
docker build -t studio-go-runner-dev-base:working -f Dockerfile_base .
BaseRepoImage=`docker inspect studio-go-runner-dev-base:working --format '{{ index .Config.Labels "registry.repo" }}:{{ index .Config.Labels "registry.version"}}'`
docker tag studio-go-runner-dev-base:working $BaseRepoImage
docker tag $BaseRepoImage docker.io/$BaseRepoImage
docker push docker.io/$BaseRepoImage
docker tag $BaseRepoImage quay.io/$BaseRepoImage
docker push quay.io/$BaseRepoImage
docker rmi studio-go-runner-dev-base:working
docker push $BaseRepoImage

docker build -t studio-go-runner-dev-stack:working -f Dockerfile_stack .
StackRepoImage=`docker inspect studio-go-runner-dev-stack:working --format '{{ index .Config.Labels "registry.repo" }}:{{ index .Config.Labels "registry.version"}}'`
docker tag studio-go-runner-dev-stack:working $StackRepoImage
docker tag $StackRepoImage docker.io/$StackRepoImage
docker push docker.io/$StackRepoImage
docker tag $StackRepoImage quay.io/$StackRepoImage
docker push quay.io/$StackRepoImage
docker rmi studio-go-runner-dev-stack:working
docker push $StackRepoImage
```

If you are performing a build of a new version of the base images you can push the new version for others to use if you have the credentials needed to access the leafai account on github.

```console
$ docker tag $BaseRepoImage $DockerUsername/$BaseRepoImage
$ docker tag $StackRepoImage $DockerUsername/$StackRepoImage
$ docker login docker.io
Authenticating with existing credentials...
WARNING! Your password will be stored unencrypted in /home/kmutch/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
$ docker push $BaseRepoImage
c7125c35d2a0: Pushing [>                                                  ]  25.01MB/2.618GB
1a5dc4559fc9: Pushing [===================>                               ]  62.55MB/163MB
150f158a1cca: Pushing [=====>                                             ]   72.4MB/721.3MB
e9fe4eadf101: Pushed
7499c2deaea7: Pushing [====>                                              ]  67.39MB/705.3MB
5e0543625ca3: Pushing [====>                                              ]  61.79MB/660.9MB
fb88fc3593c5: Waiting
5f6ee5ba06b5: Waiting
3249250da32f: Waiting
31d600707965: Waiting
b67f23c2fd52: Waiting
297fd071ca2f: Waiting
2f0d1e8214b2: Waiting
7dd604ffa87f: Waiting
aa54c2bc1229: Waiting
$ docker push $StackRepoImage
```

The next section instructions, give a summary of what needs to be done in order to use the docker hub service, or local docker registry to provision an image repository that auto-builds builder images from the studio go runner project and pushes these to the docker hub image registra.  The second section covers use cases for secured environment, along with developer workstations and laptops.

## Code quality scanning

Code is scanned using github actions as pull requests are generated.

At this time scanning includes:

. semgrep which is a semantic rules checking engine that supports Go and can perform rules based checking using the abstract syntax tree
. Shiftleft scan which is a metalinter and source checking tool handling CVE's, CWE's and some additional Go specific checking using static check
. CodeQL originally a Microsoft project is now a community project and well support on github.  Currently a local version is not used and instead branch based development and pushing to github is the best option for this scanner.

To run code checks your self you can use the following commands:

```
docker run --rm -v "${PWD}:/src" returntocorp/semgrep --lang go --config=p/ci --exclude=vendor
docker run --rm -e "WORKSPACE=$(pwd)" -e GITHUB_TOKEN -e "SCAN_AUTO_BUILD=true" -v "$(pwd):/app" shiftleft/scan scan $*
```

## Internet based registra build images

### quay.io account

The first step is to create or login to an account on quay.io.  When creating an account it is best to ensure before starting that you have a browser window open to github.com using the account that you wish to use for accessing code on github to prevent any unintended accesses to private repositories from other github accounts.  As you create the account on quay.io you can choose to link it automatically to github granting application access from docker to your github authorized applications.  This is needed in order that docker can poll your projects for any pushed git commit changes in order to trigger image building, if you choose to use that feature.

Having logged in you can now create a repository using the "Create Repository +" button at the top right corner of your web page underneath the account related drop down menu.

The first screen will allow you to specify that you wish to create an image repository and assign it a name, also set the visibility to public, and to 'Link to a GitHub Repository Push', this indicates that any push of a commit or tag will result in a container build being triggered.

Depending on access permissions you may need to fork the studio-go-runner repository to your personal github account to be able to have docker be able to find the github repository.

Pushing the next button will then cause the browser to request github to authorize access from docker to github and will prompt you to allow this authorization to be setup for future interactions between the two platform.  Again, be sure you are assuming the role of the most recently logged in github user and that the one being authorized is the one you intend to allow Quay to obtain access to.

After the authorization is enabled, the next web page is displayed which allows the organization and account to be choosen from which the image will be built.  Step through the next two screens to then select the repository that will be used and then push the continue button.

You can then specify the branch(es) that can then be used for the builds to meet you own needs.  Pushing continue will then allow you to select the Dockerfile that will act as your source for the new image.  When using studio go runner a Dockerfile called Dockerfile\_standalone is versioned in the source code repository that will allow a fully standalone container to be created that can be perform the entire build, test, release life cycle for the software.  usign a slash indicates the top level of the go runner repo.

Using continue will then prompt for the Context of the build which should be set to '/'.  You can now click through the rest of the selections and will end up with a fully populated trigger for the repository.

You can now trigger the first build and test cycle for the repository.  Once the repository has been built you can proceed to setting up a Kubernetes test cluster than can pull the image(s) from the repository as they are updated via git commits followed by a git push.

### quay.io release configuration

Now that we have a quay.io account to be used for software releases we now configure the local build environment to use this account.  This is done by using the Registry environment variable to store a yaml block with the account details in it.

When adding a pasword to your registry.yaml with quay.io you should generate an encrypted password then place that into your registry.yaml file.  To do this go into the 'Account Setting' menu at the top right of the quay.io screen and the botton menu item "User Settings" has at the top a "Docker CLI Password" entry that has a highlighted link "Generate Encrypted Password' which will generate a long encrypted string that is then used in your file.

```
cat registry.yaml
quay.io:
  .*:
    security:
      tls:
        client:
          disabled: false
      basic:
        username: [account_name]
        password: [account_password]
```

The next step is to store the registry yaml settings into an environment variable for use with the rest of these instructions:

```
export Registry=`cat registry.yaml`
```

## Development and local build image bootstrapping

 This use case uses git commits to trigger builds of CI/CD workflow images occuring within a locally deployed Kubernetes cluster.  In order to support local Kubernetes clusters the microk8s tool is used, https://microk8s.io/.

Uses cases for local clusters include unsecured local host, snap based installation of the microk8s tool can be used.  Another option is to download a git export of the microk8s tool and build it within your secured environment.  If you are using a secured environment adequate preparations should also be made for obtaining copies of any images that you will need for running your applications and also reference images needed by the microk8s install such as the images for the DNS server, the container registry, the Makisu image from docker hub and other images that will be used.  In order to be able to do this you can pre-pull images for build and push then to a private registry. If you need access to multiple registries, you can create one secret for each registry. Kubelet will merge any imagePullSecrets into a single virtual .docker/config.json. For more information please see, https://kubernetes.io/docs/concepts/containers/images/#using-a-private-registry.

While you can run within a walled garden secured network environment the microk8s cluster does use an unsecured registry which means that the machine and any accounts on which builds are running should be secured independently.  If you wish to secure images that are produced by your pipeline then you should modify your ci\_containerize\_microk8s.yaml file to point at a private secured registry, such as a self hosted https://trow.io/ instance.

The CI bootstrap step is the name given to the initial CI pipeline image creation step.  The purpose of this step is to generate a docker image containing all of the source code needed for a build and test.

When using container based pipelines the image registry being used becomes a critical part of the pipeline for storing the images that are pulled into processing steps and also for acting as a repository of images produced during pipeline execution.  When using microk8s two registries will exist within the local system one provisioned by docker in the host system, and a second hosted by microk8s that acts as your kubernetes registry.

Images moving within the pipeline will generally be handled by the Kubernetes microk8s hosted registry, in order for the pipeline to access this registry there are two ways of doing so, the first using the Kubernetes APIs, and the second to treat the registry as a server openly available outside of the cluster.  These requirements can be met by using the internal Kubernetes registry using the microk8s IP addresses and also the address of the host all referencing the same registry.

The first step is the loading of the images containing the needed build tooling.  The images can be loaded into your local docker environment and then subsequently pushed to the cluster registry.  If you have followed the instructions in the 'CUDA and Compilation base image preparation' section then this image when pulled will come from the locally stored image, alternatively the image should be pulled from the docker.io repository.

```console
docker pull leafai/studio-go-runner-dev-base:0.0.9
docker tag leafai/studio-go-runner-dev-base:0.0.9 localhost:$RegistryPort/leafai/studio-go-runner-dev-base:0.0.9
docker push localhost:$RegistryPort/leafai/studio-go-runner-dev-base:0.0.9
docker tag leafai/studio-go-runner-dev-base:0.0.9 $RegistryIP:$RegistryPort/leafai/studio-go-runner-dev-base:0.0.9
docker push $RegistryIP:$RegistryPort/leafai/studio-go-runner-dev-base:0.0.9

docker pull leafai/studio-go-runner-dev-stack:0.0.3
docker tag leafai/studio-go-runner-dev-stack:0.0.3 localhost:$RegistryPort/leafai/studio-go-runner-dev-stack:0.0.3
docker push localhost:$RegistryPort/leafai/studio-go-runner-dev-stack:0.0.3
docker tag leafai/studio-go-runner-dev-stack:0.0.3 $RegistryIP:$RegistryPort/leafai/studio-go-runner-dev-stack:0.0.3
docker push $RegistryIP:$RegistryPort/leafai/studio-go-runner-dev-stack:0.0.3
```

Once the images are loaded and has been pushed into the kubernetes container registry, git-watch is used to initiate image builds inside the cluster that, use the base image, git clone source code from fresh commits, and build scripts etc to create an entirely encapsulated CI image.

# Continuous Integration

## CI front office setup

Having an image repository store build images with everything needed to build will allow a suitably configured Kubernetes cluster to query for bootstrapped build images output by manually building the source image, or using a tool like git-watch and to use these for triggering a building, testing, and integration.

The git-watch tool monitors a git repository and polls looking for pushed commits.  Once a change is detected the code is cloned to be built a Makisu pod is started for creating images within the Kubernetes cluster.  The Makisu build then pushes build images to a user nominated repository which becomes the triggering point for the CI/CD downstream steps.

Because localized images are intended to assist in conditions where image transfers are expensive time wise it is recommended that the first step be to deploy the redis cache as a Kubernetes service.  This cache will be employed by Makisu when container images builds are performed by Makisu. The cache pods can be started by using the following commands:

```console
$ microk8s.kubectl apply -f ci_containerize_cache.yaml
namespace/makisu-cache created
pod/redis created
service/redis created
```

Because we can run both in a local developer mode to build images inside the Kubernetes cluster running on our local machine or as a fully automatted CI pipeline in an unsupervised manner the git-watch can be run both using a shell inside a checked-out code based, or as a pod inside a Kubernetes cluster in an unattended fashion.

The studio go runner standalone build image can be used within a go runner deployment to perform testing and validation against a live minio (s3 server) and a RabbitMQ (queue server) instances deployed within a single Kubernetes namespace.  The definition of the deployment is stored within the source code repository, in the ci\_keel.yaml.

The build deployment contains an annotated kubernetes deployment of the build image that when deployed alongside a keel Kubernetes instance can react to fresh build images to cycle automatically through build, test, release image cycles.

Keel is documented at https://keel.sh/, installation instruction can also be found at, https://keel.sh/guide/installation.html.  Once deployed keel can be left to run as a background service observing Kubernetes deployments that contain annotations it is designed to react to.  Keel will watch for changes to image repositories and will automatically upgrade the Deployment pods as new images are seen causing the CI/CD build logic encapsulated inside the images to be triggered as they they are launched as part of a pod.

If you are using a recent version of Kubernetes then the deployment-rbac.yaml file will need changing of "apiVersion: app/v1beta2" to "apiVersion: app./v1".

The commands that you might perform in order to deploy keel into an existing Kubernetes deploy might well appear as follows:

```
mkdir -p ~/project/src/github.com/keel-hq
cd ~/project/src/github.com/keel-hq
git clone https://github.com/keel-hq/keel.git
cd keel
git checkout 0.16.0
microk8s.kubectl create -f ~/project/src/github.com/keel-hq/keel/deployment/deployment-rbac.yaml
mkdir -p ~/project/src/github.com/leaf-ai
cd ~/project/src/github.com/leaf-ai
git clone https://github.com/leaf-ai/studio-go-runner.git
cd studio-go-runner
git checkout [branch name]

export GIT_BRANCH=`echo '{{.duat.gitBranch}}'|stencil -supress-warnings - | tr '_' '-' | tr '\/' '-'`

# Follow the instructions for setting up the Prerequisites for compilation in the main README.md file
```

The image name for the build Deployment is used by keel to watch for updates, as defined in the ci\_keel.yaml Kubernetes configuration file(s).  The keel yaml file is supplied as part of the service code inside the Deployment resource definition. The keel labels within the ci\_keel.yaml file dictate under what circumstances the keel server will trigger a new pod for the build and test to be created in response to the reference build image changing as git commit and push operations are performed.  Information about these labels can be found at, https://keel.sh/v1/guide/documentation.html#Policies.

## Triggering builds

In order for the CI to run a source build image is generated as the very first step.  Generally creation of the source build image is either done manually, or triggered via git commit activity.

The appearance of the source build image within a docker image repository will then act as a trigger for the CI build to occur.

### Local source image builds

One of the options that exists for build and release is to make use of a locally checked out source tree and to perform the build, test, release cycle locally.  Local source builds will make use of Kubernetes typically using locally deployed clusters using microk8s, a Kubernetes distribution for Ubuntu that runs on a single physical host.  A typical full build is initiated using the build.sh script found in the root directory, assuming you have already completed the installation steps previously documented above.

```console
$ ./build.sh
```

Another faster developement cycle option is to perform the build directly at the command line which shortens the cycle to just include a refresh of the source code before pushing the build to the docker image registry which is being monitored by the CI pipeline.

```
working_file=$$.studio-go-runner-working
stencil -input Dockerfile_standalone > ${working_file}
docker build -t leafai/studio-go-runner-standalone-build:$GIT_BRANCH -f ${working_file} .
rm ${working_file}
```

The next step then is to push the image to the docker image registry being used by the CI pipeline.

```
docker tag leafai/studio-go-runner-standalone-build:$GIT_BRANCH $RegistryIP:32000/leafai/studio-go-runner-standalone-build:$GIT_BRANCH
docker push $RegistryIP:32000/leafai/studio-go-runner-standalone-build:$GIT_BRANCH
```

Remember that each time you wish to run the CI pipeline simply rebuild the source build image and then CI pipeline will restart itself and run.  You are now ready to deploy the [CI pipeline](#) using keel.

### git based source image builds

Triggering builds can also be done via a locally checked out git repository, or a reference to a remote repository.  In both cases git-watch is used to monitor for changes.

git-watcher is a tool from the duat toolset used to initiate builds on detecting git commit events.  Commits need not be pushed when performing a locally triggered build.

Once git watcher detects changes to the code base it will use a Microk8s Kubernetes job to dispatch the build in the form of a container image to an instance of keel running inside a Kubernetes cluster.  The 

git-watcher uses the first argument as the git repository location to be polled as well as the branch name of interest denoted by the '^' character.  Configuring the git-watcher downstream actions once a change is registered occurs using the ci\_containerize\_microk8s.yaml, or ci\_containerize\_local.yaml.  The yaml file contains references to the location of the container registry that will receive the image only it has been built.  The intent is that a Kubernetes task such as keel.sh will further process the image as part of a CI/CD pipeline after the Makisu step has completed, please see the section describing Continuous Integration.

The following shows an example of running the git-watcher locally specifing a remote git origin:

```console
$ git-watch -v --job-template ci_containerize_microk8s.yaml https://github.com/leaf-ai/studio-go-runner.git^`git rev-parse --abbrev-ref HEAD`
```

In cases where a locally checked-out copy of the source repository is used and commits are done locally, then the following can be used to watch commits without pushes and trigger builds from those using the local file path as the source code location:

```console
$ git-watch -v --ignore-aws-errors --job-template ci_containerize_local.yaml `pwd`^`git rev-parse --abbrev-ref HEAD`
```

You are now ready to deploy the [CI pipeline](#) using keel.

## Locally deployed keel testing and CI

The next step is to modify the ci\_keel.yaml or use the duat stencil templating tool to inject the branch name on which the development is being performed or the release prepared, and then deploy the continuous integration (CI) stack.

The $Registry environment variable is used to pass your image registry username, and password to any keel containers and to the release image builder, Makisu, using a kubernetes secret.  An example of how to set this value is included in the [quay.io release configuration](#quay.io-release-configuration) section above.

You will also needs the K8S_NAMESPACE environment variable defined to create a sandbox for the builds to occur in.

```
export K8S_NAMESPACE=ci-go-runner-$USER
```

The $RegistryIP and $RegistryPort are defined in the [docker and the microk8s Kubernetes distribution installation](#docker-and-the-microk8s-Kubernetes-distribution-installation) section.

The $Registry environment variable is used to define the repository into which any released images will be pushed.  Before using the registry setting you should copy registry-template.yaml to registry.yaml, modify the contents, and set environment variables as detailed in the [Internet based registra build images](#Internet-based-registra-build-images) section.

When a CI build is initiated multiple containers will be created to cover the two dependencies of the runner, the rabbitMQ and minio servers, along with the source builder container.  These will run together to deplicate a production system for building, testing and validating the runner system.

As a CI build finishes the stack will scale down the testing dependencies it uses for queuing and storage and will keep the build container alive so that logs can be examined.  At this point the CI will spin off container image builds for the various platforms runner is deployed too using Makisu.  Makisu will push images that are released to quay.io.

If the environment variable GITHUB\_TOKEN is present when deploying an integration stack it will be placed as a Kubernetes secret into the integration stack.  If the secret is present then upon successful build and test cycles the running container will attempt to create and deploy a release using the github release pages.

```console
export GITHUB_TOKEN=[Place a github personal account token here]
```

Any changes to the build source images are ignored while builds are running.  Once the build completes upgrades will only then be used to trigger new builds in order to prevent premature termination.  When the build, testing, and image releases have completed and pushed commits have been seen for the code base then the pod will be shutdown for the latest build and a new pod created.

When the build completes the pods that are present that are only useful during the actual build and test steps will be scaled back to 0 instances.  The CI script, ci.sh, will spin up and down specific kubernetes jobs and deployments when they are needed automatically by using the Kubernetes microk8s.kubectl command.  Because of this your development and build cluster will need access to the Kubernetes API server to complete these tasks.  The Kubernetes API access is enabled by the ci\_keel.yaml file when the standalone build container is initialized.

In the case that microk8s is being used to host images moving through the pipeline then the $Registry setting must contain the IP address that the microk8s registry will be using that is accessible across the system, that is the $RegistryIP and the port number $RegistryPort.  The $Image value can be used to specify the name of the container image that is being used, its host name will differ because the image gets pushed from a localhost development machine and therefore is denoted by the localhost host name rather than the IP address for the registry.

The following example configures build images to come from a localhost registry.

```console
stencil -input ci_keel.yaml -values Registry=${Registry},Image=$RegistryIP:$RegistryPort/leafai/studio-go-runner-standalone-build:${GIT_BRANCH},Namespace=${K8S_NAMESPACE}| microk8s.kubectl apply -f -
export K8S_POD_NAME=`microk8s.kubectl --namespace=$K8S_NAMESPACE get pods -o json | jq '.items[].metadata.name | select ( startswith("build-"))' --raw-output`
microk8s.kubectl --namespace $K8S_NAMESPACE logs -f $K8S_POD_NAME
```

These instructions will be useful to those using a locally deployed Kubernetes distribution such as microk8s.  If you wish to use microk8s you should first deploy using the workstations instructions found in this souyrce code repository at docs/workstation.md.  You can then return to this section for further information on deploying the keel based CI/CD within your microk8s environment.

In the case that a test of a locally pushed docker image is needed you can build your image locally and then when the build.sh is run it will do a docker push to a microk8s cluster instance running on your workstation or laptop.  In order for the keel deployment to select the locally hosted image registry you set the Image variable for stencil to substitute into the ci\_keel.yaml file.

When the release features are used the CI/CD system will make use of the Makisu image builder, authored by Uber.  Makisu allows docker containers to build images entirely within an existing container with no specialized dependencies and also without needing dind (docker in docker), or access to a docker server socket.

```console
$ ./build.sh
$ stencil -input ci_keel.yaml -values Registry=${Registry},Image=localhost:32000/leafai/studio-go-runner-standalone-build:${GIT_BRANCH},Namespace=${K8S_NAMESPACE}| microk8s.kubectl apply -f -
```

If you are using the Image bootstrapping features of git-watch the commands would appear as follows:

```console
$ stencil -input ci_keel.yaml -values Registry=$Registry,Image=$RegistryIP:$RegistryPort/leafai/studio-go-runner-standalone-build:latest,Namespace=${K8S_NAMESPACE} | microk8s.kubectl apply -f -
```

In the above case the branch you are currently on dictates which bootstrapped images based on their image tag will be collected and used for CI/CD operations.


If you wish to watch the build as it proceeds within the CI pipeline the containers output, or log, can be examined.  For interactive monitoring of the build process kubebox can be used, [c.f. github.com/astefanutti/kubebox](https://github.com/astefanutti/kubebox).


# Monitoring and fault checking

This section contains a description of the CI pipeline using the microk8s deployment model.  The pod related portions of the pipeline can be translated directly to cases where a full Kubernetes cluster is being used, typically when GPU testing is being undertaken.  The principal differences will be in how the image registry portions of the pipeline present.

As described above the major portions of the pipeline can be illustrated by the following figure:

```console
+---------------------+      +---------------+        +-------------------+      +----------------------+
|                     |      |               |        |                   |      |                      |
|                     |      |     Makisu    |        |                   +----> |    Keel Deployed     |
|    Bootstrapping    +----> |               +------> |  Image Registry   |      |                      |
|      Copy Pod       |      | Image Builder |        |                   | <----+ Build, Test, Release |
|                     |      |               |        |                   |      |                      |
+---------------------+      +---------------+        +-------------------+      +----------------------+
```

## Bootstrapping

The first two steps of the pipeline are managed via the duat git-watch tool.  The git-watch tool as documented within these instructions is run using a a local shell but can be containerized.  In any event the git-watch tool can also be deployed using a docker container/pod.  The git-watch tool will output logging directly on the console and can be monitored either directly via the shell, or a docker log command, or a microk8s.kubectl log [pod name] command depending on the method choosen to start it.

The logging for the git-watch is controlled via environment variables documented in the following documentation, https://github.com/karlmutch/duat/blob/master/README.md.  It can be a good choice to run the git-watch tool in debug mode all the time as this allows the last known namespaces used for builds to be retained after the build is complete for examination of logs etc at the expense of some extra kubernetes resource consumption.

```console
$ export LOGXI='*=DBG'
$ export LOGXI_FORMAT='happy,maxcol=1024'
$ git-watch -v --debug --job-template ci_containerize_microk8s.yaml https://github.com/leaf-ai/studio-go-runner.git^feature/212_kops_1_11
10:33:05.219071 DBG git-watch git-watch-linux-amd64 built at 2019-04-16_13:30:30-0700, against commit id 7b7ba25c05061692e3a907a2f42a302f68f3a2cf
15:02:35.519322 DBG git-watch git-watch-linux-amd64 built at 2019-04-22_11:41:41-0700, against commit id 5ff93074afd789ed8ae24d79d1bd3004daeeba86
15:03:12.667279 INF git-watch task update id: d962a116-6ccb-4c56-89c8-5081e7172cbe text: volume update volume: d962a116-6ccb-4c56-89c8-5081e7172cbe phase: (v1.PersistentVolumeClaimPhase) (len=5) "Bound" namespace: gw-0-9-14-feature-212-kops-1-11-aaaagjhioon
15:03:25.612810 INF git-watch task update id: d962a116-6ccb-4c56-89c8-5081e7172cbe text: pod update id: d962a116-6ccb-4c56-89c8-5081e7172cbe namespace: gw-0-9-14-feature-212-kops-1-11-aaaagjhioon phase: Pending
15:03:32.427939 INF git-watch task update id: d962a116-6ccb-4c56-89c8-5081e7172cbe text: pod update id: d962a116-6ccb-4c56-89c8-5081e7172cbe namespace: gw-0-9-14-feature-212-kops-1-11-aaaagjhioon phase: Failed
15:03:46.553206 INF git-watch task update id: d962a116-6ccb-4c56-89c8-5081e7172cbe text: running dir: /tmp/git-watcher/9qvdLJYmoCmquvDfjv7rbVF7BETblcb3hBBw50vUgp id: d962a116-6ccb-4c56-89c8-5081e7172cbe namespace: gw-0-9-14-feature-212-kops-1-11-aaaagjhioon
15:03:46.566524 INF git-watch task completed id: d962a116-6ccb-4c56-89c8-5081e7172cbe dir: /tmp/git-watcher/9qvdLJYmoCmquvDfjv7rbVF7BETblcb3hBBw50vUgp namespace: gw-0-9-14-feature-212-kops-1-11-aaaagjhioon
15:38:54.655816 INF git-watch task update id: 8d1da39a-c7f7-45ad-b332-b09750b9dd8c text: volume update namespace: gw-0-9-14-feature-212-kops-1-11-aaaagjhioon volume: 8d1da39a-c7f7-45ad-b332-b09750b9dd8c phase: (v1.PersistentVolumeClaimPhase) (len=5) "Bound"
15:39:06.145428 INF git-watch task update id: 8d1da39a-c7f7-45ad-b332-b09750b9dd8c text: pod update id: 8d1da39a-c7f7-45ad-b332-b09750b9dd8c namespace: gw-0-9-14-feature-212-kops-1-11-aaaagjhioon phase: Pending
15:39:07.735691 INF git-watch task update id: 8d1da39a-c7f7-45ad-b332-b09750b9dd8c text: pod update id: 8d1da39a-c7f7-45ad-b332-b09750b9dd8c namespace: gw-0-9-14-feature-212-kops-1-11-aaaagjhioon phase: Running
```

Logging records Kubernetes operations that will first create a persistent volume and then copy the source code for the present commit to the volume using a proxy pod and SSH.  SSH is used to tunnel data across a socket and to the persistent volume via a terminal session streaming the data.  Once the copy operation has completed the git-watch then initiates the second step using the Kubernetes core APIs.

In order to observe the copy-pod the following commands are useful:

```console
$ export KUBE_CONFIG=~/.kube/microk8s.config
$ export KUBECONFIG=~/.kube/microk8s.config
$ microk8s.kubectl get ns
ci-go-runner                                  Active   2d18h
container-registry                            Active   6d1h
default                                       Active   6d18h
gw-0-9-14-feature-212-kops-1-11-aaaagjhioon   Active   1s
keel                                          Active   3d
kube-node-lease                               Active   6d1h
kube-public                                   Active   6d18h
kube-system                                   Active   6d18h
makisu-cache                                  Active   4d19h

$ microk8s.kubectl --namespace gw-0-9-14-feature-212-kops-1-11-aaaagjhioon get pods
NAME                 READY   STATUS      RESTARTS   AGE
copy-pod             0/1     Completed   0          2d15h
imagebuilder-ts669   0/1     Completed   0          2d15h
```

## microk8s Registry

The microk8s registry can become large as the number of builds mounts up.  To perform a garbage collection on the registry use the following command:

```
microk8s.kubectl exec --namespace container-registry -it $(microk8s.kubectl get pods --namespace="container-registry" --field-selector=status.phase=Running -o jsonpath={.items..metadata.name}) -- bin/registry garbage-collect /etc/docker/registry/config.yml
```

## Image Builder

Using the image building pod ID you may now extract logs from within the pipeline, using the -f option to follow the log until completion.

```console
$ microk8s.kubectl --namespace gw-0-9-14-feature-212-kops-1-11-aaaagjhioon logs -f imagebuilder-qc429
{"level":"warn","ts":1555972746.9400618,"msg":"Blacklisted /var/run because it contains a mountpoint inside. No changes of that directory will be reflected in the final image."}
{"level":"info","ts":1555972746.9405785,"msg":"Starting Makisu build (version=v0.1.9)"}
{"level":"info","ts":1555972746.9464102,"msg":"Using build context: /makisu-context"}
{"level":"info","ts":1555972746.9719934,"msg":"Using redis at makisu-cache:6379 for cacheID storage"}
{"level":"error","ts":1555972746.9831564,"msg":"Failed to fetch intermediate layer with cache ID 276f9a51: find layer 276f9a51: layer not found in cache"}
{"level":"info","ts":1555972746.9832165,"msg":"* Stage 1/1 : (alias=0,latestfetched=-1)"}
{"level":"info","ts":1555972746.983229,"msg":"* Step 1/19 (commit,modifyfs) : FROM microk8s-registry:5000/leafai/studio-go-runner-dev-base:0.0.5  (96902554)"}
...
{"level":"info","ts":1555973113.7649434,"msg":"Stored cacheID mapping to KVStore: c5c81535 => MAKISU_CACHE_EMPTY"}
{"level":"info","ts":1555973113.7652907,"msg":"Stored cacheID mapping to KVStore: a0dcd605 => MAKISU_CACHE_EMPTY"}
{"level":"info","ts":1555973113.766166,"msg":"Computed total image size 7079480773","total_image_size":7079480773}
{"level":"info","ts":1555973113.7661939,"msg":"Successfully built image leafai/studio-go-runner-standalone-build:feature_212_kops_1_11"}
{"level":"info","ts":1555973113.7662325,"msg":"* Started pushing image 10.1.1.46:5000/leafai/studio-go-runner-standalone-build:feature_212_kops_1_11"}
{"level":"info","ts":1555973113.9430845,"msg":"* Started pushing layer sha256:d18d76a881a47e51f4210b97ebeda458767aa6a493b244b4b40bfe0b1ddd2c42"}
{"level":"info","ts":1555973113.9432425,"msg":"* Started pushing layer sha256:34667c7e4631207d64c99e798aafe8ecaedcbda89fb9166203525235cc4d72b9"}
{"level":"info","ts":1555973114.0487752,"msg":"* Started pushing layer sha256:119c7358fbfc2897ed63529451df83614c694a8abbd9e960045c1b0b2dc8a4a1"}
{"level":"info","ts":1555973114.4315908,"msg":"* Finished pushing layer sha256:d18d76a881a47e51f4210b97ebeda458767aa6a493b244b4b40bfe0b1ddd2c42"}
{"level":"info","ts":1555973114.5885575,"msg":"* Finished pushing layer sha256:119c7358fbfc2897ed63529451df83614c694a8abbd9e960045c1b0b2dc8a4a1"}
...
{"level":"info","ts":1555973479.759059,"msg":"* Finished pushing image 10.1.1.46:5000/leafai/studio-go-runner-standalone-build:feature_212_kops_1_11 in 6m5.99280605s"}
{"level":"info","ts":1555973479.7590847,"msg":"Successfully pushed 10.1.1.46:5000/leafai/studio-go-runner-standalone-build:feature_212_kops_1_11 to 10.1.1.46:5000"}
{"level":"info","ts":1555973479.759089,"msg":"Finished building leafai/studio-go-runner-standalone-build:feature_212_kops_1_11"}
```

The last action of pushing the built image from the Miksau pod into our local docker registry can be seen above.  The image pushed is now available in this case to a keel.sh namespace and any pods waiting on new images for performing the product build and test steps.

## Keel components

The CI portion of the pipeline will seek to run the tests in a real deployment.  If you look below you will see three pods that are running within keel.  Two pods are support pods for testing, the minio pod runs a blob server that mimics the AWS S3 protocols, the rabbitMQ server provides the queuing capability of a production deployment.  The two support pods will run with either 0 or 1 replica and will be scaled up and down by the main build pod as the test is started and stopped.

```console
$ microk8s.kubectl get ns
ci-go-runner         Active   5s
container-registry   Active   39m
default              Active   6d23h
kube-node-lease      Active   47m
kube-public          Active   6d23h
kube-system          Active   6d23h
makisu-cache         Active   17m
$ microk8s.kubectl --namespace ci-go-runner get pods                      
NAME                                READY   STATUS              RESTARTS   AGE
build-5f6c54b658-8grpm              0/1     ContainerCreating   0          82s
minio-deployment-7f49449779-2s9d7   1/1     Running             0          82s
rabbitmq-controller-dbgc7           0/1     ContainerCreating   0          82s
$ microk8s.kubectl --namespace ci-go-runner logs -f build-5f6c54b658-8grpm
Warning : env variable azure_registry_name not set
Mon Apr 22 23:03:27 UTC 2019 - building ...
2019-04-22T23:03:27+0000 DBG stencil stencil built at 2019-04-12_17:28:28-0700, against commit id 2842db335d8e7d3b4ca97d9ace7d729754032c59
2019-04-22T23:03:27+0000 DBG stencil leaf-ai/studio-go-runner/studio-go-runner:0.9.14-feature-212-kops-1-11-aaaagjhioon
declare -x AMQP_URL="amqp://\${RABBITMQ_DEFAULT_USER}:\${RABBITMQ_DEFAULT_PASS}@\${RABBITMQ_SERVICE_SERVICE_HOST}:\${RABBITMQ_SERVICE_SERVICE_PORT}/%2f?connection_attempts=2&retry_delay=.5&socket_timeout=5"
declare -x CUDA_8_DEB="https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb"
declare -x CUDA_9_DEB="https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-ubuntu1604-9-0-local_9.0.176-1_amd64-deb"
...
--- PASS: TestStrawMan (0.00s)
=== RUN   TestS3MinioAnon
2019-04-22T23:04:31+0000 INF s3_anon_access Alive checked _: [addr 10.152.183.12:9000 host build-5f6c54b658-8grpm]
--- PASS: TestS3MinioAnon (7.33s)
PASS
ok      github.com/leaf-ai/studio-go-runner/internal/runner     7.366s
2019-04-22T23:04:33+0000 INF build.go building internal/runner
...
i2019-04-22T23:10:44+0000 WRN runner stopping k8sStateLogger _: [host build-5f6c54b658-8grpm] in:
2019-04-22T23:10:44+0000 INF runner forcing test mode server down _: [host build-5f6c54b658-8grpm]
2019-04-22T23:10:44+0000 WRN runner http: Server closedstack[monitor.go:69] _: [host build-5f6c54b658-8grpm] in:
ok      github.com/leaf-ai/studio-go-runner/cmd/runner  300.395s
2019-04-22T23:10:46+0000 INF build.go building cmd/runner
2019-04-22T23:11:07+0000 INF build.go renaming ./bin/runner-linux-amd64 to ./bin/runner-linux-amd64-cpu
2019-04-22T23:11:27+0000 INF build.go github releasing [/project/src/github.com/leaf-ai/studio-go-runner/cmd/runner/bin/runner-linux-amd64 /project/src/github.com/leaf-ai/studio-go-runner/cmd/runner/bin/runner-linux-amd64-cpu /project/src/github.com/leaf-ai/studio-go-runner/build-.log]
imagebuild-mounted starting build-5f6c54b658-8grpm
2019-04-22T23:12:00+0000 DBG stencil stencil built at 2019-04-12_17:28:28-0700, against commit id 2842db335d8e7d3b4ca97d9ace7d729754032c59
2019-04-22T23:12:00+0000 DBG stencil leaf-ai/studio-go-runner/studio-go-runner:0.9.14--aaaagjihjms
job.batch/imagebuilder created
```

You can now head over to github and if you had the github token loaded as a secret you will be able to see the production binaries release.

The next step if enabled is for the keel build to dispatch a production container build within the Kubernetes cluster and then for the image to be pushed using the credentials supplied as a part of the original command line that deployed the keel driven CI.  Return to the first section of the continuous integration for more information.


Copyright © 2019-2021 Cognizant Digital Business, Evolutionary AI. All rights reserved. Issued under the Apache 2.0 license.
