FROM nvcr.io/nvidia/tensorflow:20.12-tf2-py3

ARG APP_DIR="/app"
ARG JUPYTER_TOKEN="myToken"

# for vs code, see https://aka.ms/vscode-docker-python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# pip
RUN pip install --upgrade pip

# python packages
RUN pip install pandas numpy matplotlib seaborn

# jupyter
RUN pip install jupyterlab==v3.0.0

# jupyter config saving
RUN echo "cp -r /root/.jupyter ${APP_DIR}/docker/res/root/ && rm -rf ${APP_DIR}/docker/res/root/.jupyter/lab/workspaces && echo \"done\"" \
    >> /usr/bin/save-jupyter-config
RUN chmod +x /usr/bin/save-jupyter-config

# startup commands
RUN echo "tensorboard --logdir=${APP_DIR}/.tensorboard --bind_all &" >> /cmd
RUN echo "jupyter lab --allow-root --ip=0.0.0.0 --no-browser --NotebookApp.token='${JUPYTER_TOKEN}' &" >> /cmd
RUN echo "sleep infinity" >> /cmd
CMD ["sh", "/cmd"]

# copy resources
COPY docker/res /

# cleanup
RUN rm -rf /var/lib/apt/lists/*

WORKDIR ${APP_DIR}