
# Setup the varables
# --------------------
. _set-vars.sh
# --------------------

#mkdir -p /var/cache/apt-cacher-ng
# make it work on a mac
mkdir -p ${CACHE_WORKING_DIRECTORY}

echo
echo "Setting up apt-cacher-ng at: ${CONTAINER_BASE_DIRECTORY}"
echo "---------------------------------------------------------"

echo "Mapping -v [${CACHE_WORKING_DIRECTORY} : ${CONTAINER_BASE_DIRECTORY}]"
echo
docker network ls | grep ${APT_CACHER_NETWORK} >/dev/null
if [ $? -gt 0 ] ; then

	echo "Creating Network: ${APT_CACHER_NETWORK}"
	docker network create ${APT_CACHER_NETWORK}
else
	echo "Using Network:"
	docker network ls | grep ${APT_CACHER_NETWORK}
fi

echo
docker run --rm -d --network=${APT_CACHER_NETWORK} -p 3142:3142 -v ${CACHE_WORKING_DIRECTORY}:${CONTAINER_BASE_DIRECTORY} --name ${CONTAINER_NAME} ${IMAGE_NAME}

echo
