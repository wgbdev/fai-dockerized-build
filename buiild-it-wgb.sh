echo
echo "Starting the build..."
eho "--------------------------------"
docker build . -t wgbdev/fai-image-stage1
docker run --name tmp-fai-container -v $(pwd)/faiconfig:/srv/fai/config --privileged -it wgbdev/fai-image-stage1 /bin/bash ./dofai-setup-stage2.sh
docker commit tmp-fai-container wgbdev/fai-image-stage2 && docker rm -v tmp-fai-container

#docker build Dockerfile.stage2 -t wgbdev/fai-run-image
# No need for a commit with above....
echo
