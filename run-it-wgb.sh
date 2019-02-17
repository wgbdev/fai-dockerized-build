echo
echo "Starting the setup..."
echo "--------------------------------"
docker run --name fai-container --rm -e REPO=pa.archive.ubuntu.com -v ~/fai:/srv/fai/config --privileged -it wgbdev/fai-image
echo
