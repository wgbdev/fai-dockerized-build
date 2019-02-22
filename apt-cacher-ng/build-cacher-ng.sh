# Setup the varables
# --------------------
. _set-vars.sh
# --------------------

docker build -t ${IMAGE_NAME} .
