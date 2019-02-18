echo
echo "Starting the build..."
eho "--------------------------------"
docker build . -t wgbdev/fai-image-stage1
docker run --name tmp-fai-container -v $(pwd)/faiconfig:/srv/fai/config --privileged -it wgbdev/fai-image-stage1 /bin/bash ./dofai-setup-stage2.sh
docker commit tmp-fai-container wgbdev/fai-image-stage2 && docker rm -v tmp-fai-container

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
