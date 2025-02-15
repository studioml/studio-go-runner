#!/bin/bash -e

[ -z "$GOPATH" ] && echo "Error: env variable GOPATH must be set" && exit 1;
[ -z "$GITHUB_TOKEN" ] && echo "Warning : env variable GITHUB_TOKEN should be set in the event that a release is to be generated" ;
[ -z ${azure_registry_name+x} ] && echo "Warning : env variable azure_registry_name not set";

if [[ ":$PATH:" != *":$GOPATH/bin:"* ]]; then
    export PATH=$PATH:$GOPATH/bin
fi

export LOGXI="*=DBG"
export LOGXI_FORMAT="happy,maxcol=1024"

[ -z "$TERM" ] && export TERM=xterm+256color;

if [ -n "$(type -t travis_fold)" ] && [ "$(type -t travis_fold)" = function ]; then
    type travis_fold
    type travis_nanoseconds
    type travis_time_start
    type travis_time_finish
:
else
declare -i travis_start_time
declare -i travis_end_time

	function travis_nanoseconds () {
		local cmd="date";
		local format="+%s%N";
		local os=$(uname);
		if hash gdate > /dev/null 2>&1; then
			cmd="gdate";
		else
			if [[ "$os" = Darwin ]]; then
				format="+%s000000000";
			fi;
		fi;
		$cmd -u $format
	}

    function travis_fold() {
        local action=$1;
        local name=$2;
        echo -en "travis_fold:${action}:${name}\r${ANSI_CLEAR}"
    }
    function travis_time_start() {
        travis_timer_id=$(printf %08x $(( RANDOM * RANDOM )));
        travis_start_time=$(travis_nanoseconds);
        echo -en "travis_time:start:$travis_timer_id\r${ANSI_CLEAR}"
    }
    function travis_time_finish() {
        local result=$?;
        travis_end_time=$(travis_nanoseconds);
        local duration=$(($travis_end_time-$travis_start_time));
        echo -en "\ntravis_time:end:$travis_timer_id:start=$travis_start_time,finish=$travis_end_time,duration=$duration\r${ANSI_CLEAR}";
        return $result

    }
fi

go get -u google.golang.org/protobuf/cmd/protoc-gen-go

bash -c "while true; do echo \$(date) - building ...; sleep 180s; done" &
PING_LOOP_PID=$!

function cleanup {
    # nicely terminate the ping output loop
    kill $PING_LOOP_PID > /dev/null 2>&1 || true
}

trap cleanup EXIT

function ExitWithError
{
    echo "$*">&2
    rm -f $working_file
    exit 1
}

function Tidyup
{
    ExitWithError "Abort"
}

umask 077
working_file=$$.studio-go-runner-working
rm -f $working_file
trap Tidyup 1 2 3 15

export SEM_VER=`echo '{{.duat.version | replace "/" "-" | replace "_" "-"}}' | stencil -error-warnings`
if [ $? -ne 0 ] ; then
     echo "Failure "
fi
export RUNNER_BUILD_LOG=build-$SEM_VER.log

exit_code=0

# Determine if we are running under a keel based CI build and if so ...
export

travis_fold start "build.image"
    travis_time_start
        export LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/lib/nvidia:$LD_LIBRARY_PATH
        source base-build.sh
        if [ $exit_code -ne 0 ] ; then
            echo "Failure " $exit_code
        fi
    travis_time_finish
travis_fold end "build.image"

rm -rf /build/*

if [ $exit_code -eq 0 ]; then
    cd cmd
    rsync --recursive --relative . /build/cmd
    cd ../tools
    rsync --recursive --relative . /build/tools
    cd .. 
fi

# Here we take the job template and run a Mikasu build based on the volume
# we have within this script

ls /build -alcrt
cleanup

echo "Scale testing dependencies to 0" $K8S_POD_NAME
kubectl scale --namespace $K8S_NAMESPACE --replicas=0 rc/rabbitmq-controller
kubectl scale --namespace $K8S_NAMESPACE --replicas=0 deployment/minio-deployment

if [ $exit_code -eq 0 ]; then
    kubectl --namespace $K8S_NAMESPACE delete job/imagebuilder-stock || true
    kubectl --namespace $K8S_NAMESPACE delete job/imagebuilder-azure || true
    kubectl --namespace $K8S_NAMESPACE delete job/imagebuilder-serving-bridge || true
    echo "imagebuild-mounted starting" $K8S_POD_NAME
# Run the docker image build using Mikasu within the same namespace we are occupying and
# the context for the image build will be the /build mount
    stencil -values Namespace=$K8S_NAMESPACE -input ci_release_image_microk8s.yaml | kubectl --namespace $K8S_NAMESPACE create -f -
    until kubectl --namespace $K8S_NAMESPACE  get job/imagebuilder-serving-bridge -o jsonpath='{.status.conditions[].status}' | grep True ; do sleep 3 ; done
    kubectl --namespace $K8S_NAMESPACE logs job/imagebuilder-serving-bridge
    kubectl --namespace $K8S_NAMESPACE describe job/imagebuilder-serving-bridge
    kubectl --namespace $K8S_NAMESPACE delete job/imagebuilder-serving-bridge

    until kubectl --namespace $K8S_NAMESPACE  get job/imagebuilder-stock -o jsonpath='{.status.conditions[].status}' | grep True ; do sleep 3 ; done
    until kubectl --namespace $K8S_NAMESPACE  get job/imagebuilder-azure -o jsonpath='{.status.conditions[].status}' | grep True ; do sleep 3 ; done
    echo "imagebuild-mounted complete" $K8S_POD_NAME
    kubectl --namespace $K8S_NAMESPACE logs job/imagebuilder-stock
    kubectl --namespace $K8S_NAMESPACE describe job/imagebuilder-stock
    kubectl --namespace $K8S_NAMESPACE delete job/imagebuilder-stock
    kubectl --namespace $K8S_NAMESPACE logs job/imagebuilder-azure
    kubectl --namespace $K8S_NAMESPACE describe job/imagebuilder-azure
    kubectl --namespace $K8S_NAMESPACE delete job/imagebuilder-azure
fi

echo "Return pod back to the ready state for keel to begin monitoring for new images" $K8S_POD_NAME
kubectl label deployment build keel.sh/policy=force --namespace=$K8S_NAMESPACE

for (( ; ; ))
do
    sleep 600
done

if [ $exit_code -ne 0 ]; then
    exit $exit_code
fi

exit 0
