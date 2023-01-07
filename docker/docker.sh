#!/bin/bash

UP1_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. >/dev/null && pwd)"
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
IMAGE_NAME=`cd "${UP1_DIR}" && echo ${PWD##*/} | tr '[:upper:]' '[:lower:]' | sed -e 's/[-_ ]+/-/g'`

KILL=1
CMD=""
BUILD=1
FOREVER=0
GPUS="all"
JUPYTER_PORT=8888
TENSORBORAD_PORT=6006
DOCKER_RUN_FLAGS="it"

# process named arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --jupyter_port=*|--jp=*)
      JUPYTER_PORT="${1#*=}"
      ;;
    --tensorboard_port=*|--tp=*)
      TENSORBORAD_PORT="${1#*=}"
      ;;
    --image_suffix=*)
      IMAGE_NAME="${IMAGE_NAME}-${1#*=}"
      ;;
    --gpus=*)
      GPUS="${1#*=}"
      ;;
    --forever|-f)
      DOCKER_RUN_FLAGS+="d"
      ;;
    --no-kill)
      KILL=0
      ;;
    --no-build)
      BUILD=0
      ;;
    --help|-h)
      echo "Usage: docker.sh [--jupyter_port=####|8888] [--tensorboard_port=####|6006] [--help] [CMD]"
      exit
      ;;
    *)
      CMD="${1}"
  esac
  shift
done

if [ $KILL -ge 1 ]
  then
    echo "Killing ${IMAGE_NAME}..."
    docker kill "${IMAGE_NAME}" 2>/dev/null
fi

if [ $BUILD -ge 1 ]
  then
    echo "Building ${IMAGE_NAME}..."
    docker build -f "${THIS_DIR}/Dockerfile" -t $IMAGE_NAME "${UP1_DIR}" || exit 1
fi

# only map jupyter/tensorboard ports if command is not specified
if [ -z "$CMD" ]
  then
    PORT_MAPPINGS_ARG="-p ${JUPYTER_PORT}:8888  -p ${TENSORBORAD_PORT}:6006"
fi

# only add --gpus switch if GPUs are present
if [ `uname` != 'Darwin' ] && [ `lspci | grep -i nvidia | wc -l` -ge 1 ]
  then
    GPUS_ARG="--gpus=\"${GPUS}\""
fi

docker run --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 \
  --rm "-${DOCKER_RUN_FLAGS}" \
  -v "${UP1_DIR}:/app" \
  --name="${IMAGE_NAME}" \
  $PORT_MAPPINGS_ARG \
  ${GPUS_ARG} \
  $IMAGE_NAME \
  $CMD
