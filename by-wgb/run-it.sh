echo
echo "Starting the run ..."
echo "--------------------------------"

IMAGE_DIRECTORY="wgbdev/"
STAGE_2_IMAGE_AS_BUILT="fai-image-stage2"
IMAGE_TAG=":latest"
CONTAINER_NAME="tmp-fai-container"

#
# NOTE by wgb:
# --------------
#
# On a Mac, you can't use ~ for the come directory
#
echo
echo "Execute ./what-is-next.sh for futher instructions...."
echo
docker run --name ${CONTAINER_NAME} -v $(pwd)/faiconfig:/srv/fai/config --privileged --rm -it ${IMAGE_DIRECTORY}${STAGE_2_IMAGE_AS_BUILT}${IMAGE_TAG} /bin/bash

echo
