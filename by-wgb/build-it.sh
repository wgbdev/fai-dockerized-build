echo
echo "Starting the build..."
echo "--------------------------------"

TMP_FILE_TO_USE="/tmp/PRIOR_FAI_BUILD.TMP-delete-me-at-will"

IMAGE_DIRECTORY="wgbdev/"

STAGE_1_IMAGE_TO_BUILD="fai-image-stage1"
STAGE_1_PRIOR_IMAGE_TO_BUILD="fai-image-stage1-prior"

STAGE_2_IMAGE_TO_BUILD="fai-image-stage2"

IMAGE_TAG=":latest"
TEMP_CONTAINER_NAME="tmp-fai-container"

# -------------------------
# Minimize builds....
# -------------------------
#
# Take the Image ID that is output from the prior build and compare it with the one from the just happened build
# and if they match, it means that their is no reason to do the run and commit steps because the container is 
# already up to date.
#
# This will expedite the whole fai-setup from being run twice.
#
#

echo
echo "Building...."
echo

# Test to see if there are any prior builds


PRIOR_BUILD=$( docker images -q ${IMAGE_DIRECTORY}${STAGE_1_PRIOR_IMAGE_TO_BUILD}${IMAGE_TAG} )

docker build . -t ${IMAGE_DIRECTORY}${STAGE_1_IMAGE_TO_BUILD}${IMAGE_TAG}

CURRENT_BUILD=$( docker images -q ${IMAGE_DIRECTORY}${STAGE_1_IMAGE_TO_BUILD}${IMAGE_TAG} ) 

echo
echo "Current Build: ${IMAGE_DIRECTORY}${STAGE_1_IMAGE_TO_BUILD}${IMAGE_TAG} = [${CURRENT_BUILD}]"
echo "Prior Build: ${IMAGE_DIRECTORY}${STAGE_1_PRIOR_IMAGE_TO_BUILD}${IMAGE_TAG} = [${PRIOR_BUILD}]"
echo

if [ "${PRIOR_BUILD}" != "${CURRENT_BUILD}" ] ; then

	echo "Doing the fai-setup stage...patience please..."
	echo

	docker run --name ${TEMP_CONTAINER_NAME} -v $(pwd)/faiconfig:/srv/fai/config --privileged -it ${IMAGE_DIRECTORY}${STAGE_1_IMAGE_TO_BUILD}${IMAGE_TAG} /bin/bash ./dofai-setup-stage2.sh

	echo "Committing...."
	# Disable following temporarily
	docker commit ${TEMP_CONTAINER_NAME} ${IMAGE_DIRECTORY}${STAGE_2_IMAGE_TO_BUILD}${IMAGE_TAG} && docker rm -v ${TEMP_CONTAINER_NAME}
	echo "Committed."
	docker image tag ${IMAGE_DIRECTORY}${STAGE_1_IMAGE_TO_BUILD}${IMAGE_TAG} ${IMAGE_DIRECTORY}${STAGE_1_PRIOR_IMAGE_TO_BUILD}${IMAGE_TAG}
	echo
else
	echo "Nothing changed..., skipping the LONG fai-setup step...."
fi

echo
exit 0
