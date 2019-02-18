echo
echo "Starting the build..."
eho "--------------------------------"

# Accomodate for an empty images directory but a file on disk
# that says we had a prior image
#
PRIOR_BUILD=$(docker images -q wgbdev/fai-image-stage1)

#echo "IN DOCKER ===> [${PRIOR_BUILD}]"

if [ "${PRIOR_BUILD}" != "" ] ; then
	echo "We have an image in Docker."
	echo "Lets see if it matches what we have recorded."
	PRIOR_BUILD=$(cat .PRIOR_BUILD)

#echo "ON DISK ===> [${PRIOR_BUILD}]"

else
	echo "No prior image in Docker images."
fi

echo "Prior Build [ ${PRIOR_BUILD} ]"

docker build . -t wgbdev/fai-image-stage1

CURRENT_BUILD=$(docker images -q wgbdev/fai-image-stage1)

echo "Current Build [ ${CURRENT_BUILD} ]"
echo "${CURRENT_BUILD}" > .PRIOR_BUILD

if [ "${PRIOR_BUILD}" != "${CURRENT_BUILD}" ] ; then
	echo "Doing the fai-setup stage...patience please..."
	docker run --name tmp-fai-container -v $(pwd)/faiconfig:/srv/fai/config --privileged -it wgbdev/fai-image-stage1 /bin/bash ./dofai-setup-stage2.sh
	docker commit tmp-fai-container wgbdev/fai-image-stage2 && docker rm -v tmp-fai-container
else
	echo "Skipping the LONG fai-setup step...."
fi

# Future Improvements:
# -------------------------
#
# Take the Image ID that is output from the prior build and compare it with the one from the just happened build
# and if they match, it means that their is no reason to do the run and commit steps because the container is 
# already up to date.
#
# This will expedite the whole fai-setup from being run twice.
#

echo
