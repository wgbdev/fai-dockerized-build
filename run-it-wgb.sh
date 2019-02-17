echo
echo "Starting the build..."
echo "--------------------------------"
#docker run . -t wgbdev/fai:1.0.0
docker run --name wgb-fai --privileged -it wgbdev/fai:1.0.0
echo
