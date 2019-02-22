

MACOS_PREFIX=""

#
# make it work on a mac
MACOS_PREFIX="${HOME}/wgb-var"
# vs = "" for linux?
#

CACHE_BASE_DIRECTORY="/var/cache/apt-cacher-ng"
CACHE_WORKING_DIRECTORY="${MACOS_PREFIX}${CACHE_BASE_DIRECTORY}"

# Make same on both host and container
CONTAINER_BASE_DIRECTORY=${CACHE_BASE_DIRECTORY}

APT_CACHER_NETWORK="apt-cacher-ng"

CONTAINER_NAME="apt-cacher-ng"
IMAGE_NAME=" wgbdev/apt-cacher-ng"

SHELL_CONTAINER="ubuntu-bash-shell"

