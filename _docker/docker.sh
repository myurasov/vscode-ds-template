#!/bin/bash

UP1_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. >/dev/null && pwd)"
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
IMAGE_NAME=`cd "${UP1_DIR}" && echo ${PWD##*/} | tr '[:upper:]' '[:lower:]' | sed -e 's/[-_ ]//g'`
IMAGE_NAME="${IMAGE_NAME}-jupyter"
JUPYTER_PORT=8888
CMD=""

echo "Building ${IMAGE_NAME}..."

# process named arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --jupyter_port=*)
      JUPYTER_PORT="${1#*=}"
      ;;
    --help)
      echo "Usage: docker.sh [--jupyter_port=####|8888] [--help] [command]"
      exit
      ;;
    *)
      CMD="${1}"
  esac
  shift
done

docker kill "${IMAGE_NAME}"

docker build -f "${THIS_DIR}/Dockerfile" -t $IMAGE_NAME "${THIS_DIR}" && \
docker run --gpus=all --rm ${_OPTIONS_:-'-it'} -p $JUPYTER_PORT:8888 \
	-v "${UP1_DIR}:/app" --name="${IMAGE_NAME}" \
	$IMAGE_NAME $CMD
