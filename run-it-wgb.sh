echo
echo "Starting the setup..."
echo "--------------------------------"
#
# NOTE by wgb:
# --------------
#
# On a Mac, you can't use ~ for the come directory
#
docker run --name fai-container -v $(pwd)/faiconfig:/srv/fai/config --privileged --rm -it wgbdev/fai-image-stage2 /bin/bash

#docker run --name fai-container -v $(pwd)/faiconfig:/srv/fai/config --privileged -it wgbdev/fai-image
echo
