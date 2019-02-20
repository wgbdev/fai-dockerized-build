echo
echo "Commit the build..."
echo "--------------------------------"

TMP_FILE_TO_USE="/tmp/PRIOR_FAI_BUILD.TMP-delete-me-at-will"

IMAGE_DIRECTORY="wgbdev/"
STAGE_1_IMAGE_TO_BUILD="fai-image-stage1"
STAGE_2_IMAGE_TO_BUILD="fai-image-stage2"
IMAGE_TAG=":latest"
TEMP_CONTAINER_NAME="tmp-fai-container"

docker commit ${TEMP_CONTAINER_NAME} ${IMAGE_DIRECTORY}${STAGE_2_IMAGE_TO_BUILD}${IMAGE_TAG} && docker rm -v ${TEMP_CONTAINER_NAME}

echo
