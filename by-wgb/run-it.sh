echo
echo "Starting the run ..."
echo "--------------------------------"

IMAGE_DIRECTORY="wgbdev/"
STAGE_2_IMAGE_AS_BUILT="fai-image-stage2"
IMAGE_TAG=":latest"
CONTAINER_NAME="tmp-fai-container"

CMDLINE_OPTION=""
REPO_CMD=""

if [ $# -gt 0 ] ; then
	CMDLINE_OPTION=${1}
	echo "Command line Option = [${CMDLINE_OPTION}]"

	REPO_CMD="${CMDLINE_OPTION}"

	echo "REPO_CMD=[${REPO_CMD}]"
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
		-e REPO=${REPO_CMD} \
		-v $(pwd)/faiconfig:/srv/fai/config \
		--privileged \
		--rm \
		-it ${IMAGE_DIRECTORY}${STAGE_2_IMAGE_AS_BUILT}${IMAGE_TAG} /bin/bash

echo
