echo
echo "Starting the setup..."
echo "--------------------------------"
#
# NOTE by wgb:
# --------------
#
# On a Mac, you can't use ~ for the come directory
#
docker run --name fai-container --rm -v $(pwd)/faiconfig:/srv/fai/config --privileged -it wgbdev/fai-image
echo
