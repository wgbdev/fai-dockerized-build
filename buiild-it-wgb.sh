echo
echo "Starting the build..."
eho "--------------------------------"
docker build . -t wgbdev/fai-image
#docker build Dockerfile.stage2 -t wgbdev/fai-run-image
# No need for a commit with above....
echo
