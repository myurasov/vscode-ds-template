# Docker-based Data Science Template for VS Code

- Python
- Docker
- Jupyter
- TensorFlow
- TensorBoard
- GPU Support

## Starting Jupyter Lab and TensorBoard

`$ _docker/docker-forever.sh [--jupyter_port=####|8888] [--tensorboard_port=####|6006]`

TensorBoard log dir inside container is at `/app/.tensorboard`.

## Running Python from VS Code

- Build docker image with "Build Image" command from the command palette.
- Run or debug, python interpreter in the docker will be used automatically to execute the active file.
