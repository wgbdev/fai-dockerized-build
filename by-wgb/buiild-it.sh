echo
echo "Starting the build..."
echo "--------------------------------"

TMP_FILE_TO_USE="/tmp/PRIOR_FAI_BUILD.TMP-delete-me-at-will"

IMAGE_DIRECTORY="wgbdev/"
STAGE_1_IMAGE_TO_BUILD="fai-image-stage1"
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
PRIOR_BUILD=$( docker images -q ${IMAGE_DIRECTORY}${STAGE_1_IMAGE_TO_BUILD}${IMAGE_TAG} )

#echo "IN DOCKER ===> [${PRIOR_BUILD}]"

# Accomodate for an empty images directory but a file on disk
# that says we had a prior image

if [ "${PRIOR_BUILD}" != "" ] ; then
	echo "We have an image in Docker."
	echo "Lets see if it matches what we have recorded."
	PRIOR_BUILD=$( cat ${TMP_FILE_TO_USE} )

#echo "ON DISK ===> [${PRIOR_BUILD}]"

else
	echo "No prior image in Docker images."
fi

echo "Prior Build [ ${PRIOR_BUILD} ]"

docker build . -t ${IMAGE_DIRECTORY}${STAGE_1_IMAGE_TO_BUILD}${IMAGE_TAG}

CURRENT_BUILD=$( docker images -q ${IMAGE_DIRECTORY}${STAGE_1_IMAGE_TO_BUILD}${IMAGE_TAG} ) 

echo "Current Build [ ${CURRENT_BUILD} ]"
echo "${CURRENT_BUILD}" > ${TMP_FILE_TO_USE}

if [ "${PRIOR_BUILD}" != "${CURRENT_BUILD}" ] ; then
	echo "Doing the fai-setup stage...patience please..."
	docker run --name ${TEMP_CONTAINER_NAME} -v $(pwd)/faiconfig:/srv/fai/config --privileged -it ${IMAGE_DIRECTORY}${STAGE_1_IMAGE_TO_BUILD}${IMAGE_TAG} 
	
	# End of previous line
	# /bin/bash ./dofai-setup-stage2.sh
	#
	
	# Disable following temporarily
	# docker commit ${TEMP_CONTAINER_NAME} ${IMAGE_DIRECTORY}${STAGE_2_IMAGE_TO_BUILD}${IMAGE_TAG} && docker rm -v ${TEMP_CONTAINER_NAME}
else
	echo "Skipping the LONG fai-setup step...."
fi

echo
