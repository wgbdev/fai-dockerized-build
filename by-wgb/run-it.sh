echo
echo "Starting the run ..."
echo "--------------------------------"

IMAGE_DIRECTORY="wgbdev/"
STAGE_2_IMAGE_AS_BUILT="fai-image-stage2"
IMAGE_TAG=":latest"
CONTAINER_NAME="tmp-fai-container"

CMDLINE_OPTION=""
REPO_OVERRIDE=""
DEBUG_SOURCE=""

if [ $# -gt 0 ] ; then
	CMDLINE_OPTION=${1}
	echo "Command line Option = [${CMDLINE_OPTION}]"

	REPO_OVERRIDE="${CMDLINE_OPTION}"

	echo "REPO_OVERRIDE=[${REPO_OVERRIDE}]"


DEBUG_SOURCE="-v $(pwd)/tmp-wrk:/usr -v $(pwd)/bin:/usr/local/bin"

## ENV WGB_DEBUG=true
## ENV WGB_VERBOSE=true


fi

#
# NOTE by wgb:
# --------------
#
# On a Mac, you can't use ~ for the come directory
#
echo
echo "Execute ./what-is-next.sh for futher instructions...."
echo
#
#
# [-e REPO=pa.archive.ubuntu.com]
# BTW, no longer works....
#

docker run \
		--name ${CONTAINER_NAME} \
		-e REPO=${REPO_OVERRIDE} \
		-v $(pwd)/faiconfig:/srv/fai/config \
		${DEBUG_SOURCE} \
		--privileged \
		--rm \
		-it ${IMAGE_DIRECTORY}${STAGE_2_IMAGE_AS_BUILT}${IMAGE_TAG} /bin/bash

echo
