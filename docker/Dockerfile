FROM nvcr.io/nvidia/tensorflow:22.12-tf2-py3

# where external files are mapped to
ARG APP_DIR="/app"

# build directory
WORKDIR /tmp

# for vs code, see https://aka.ms/vscode-docker-python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# use bash as a default shell
ENV SHELL=/bin/bash
ENV force_color_prompt=yes

# path to app modules
ENV PYTHONPATH=${APP_DIR}:${APP_DIR}/lib:${APP_DIR}/src

# apt setup
RUN apt-get update
ENV TZ=America/Los_Angles
ENV DEBIAN_FRONTEND=noninteractive

# node js (required by for jupyterlab_code_formatter and plotly)
RUN apt-get install -y nodejs npm
RUN npm install -g n && n lts

# pip
RUN pip install --upgrade pip

# jupyter lab
RUN pip install jupyterlab==v3.5.0

# jupyterlab_code_formatter extension
RUN jupyter labextension install @ryantam626/jupyterlab_code_formatter@v1.5.3 --no-build
RUN pip install jupyterlab_code_formatter
RUN jupyter server extension enable --py jupyterlab_code_formatter
RUN pip install isort yapf black

# plotly jl extension
RUN pip install "ipywidgets>=7.5"
RUN jupyter labextension install jupyterlab-plotly --no-build
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager plotlywidget --no-build
RUN pip install plotly

# lsp jl extension
# https://github.com/krassowski/jupyterlab-lsp
RUN pip install jupyterlab-lsp
RUN pip install python-language-server[all]

# jl debugger extension
# RUN pip install xeus-python
# RUN jupyter labextension install @jupyterlab/debugger --no-build

# build jupyter lab assets
RUN jupyter lab build

# startup commands
ARG JUPYTER_TOKEN="mytoken"
RUN echo "tensorboard --logdir=${APP_DIR}/.tensorboard --bind_all &" >> /cmd
RUN echo "jupyter lab --ServerApp.ip=0.0.0.0 --ServerApp.allow_root=true --no-browser --IdentityProvider.token='${JUPYTER_TOKEN}' &" >> /cmd
RUN echo "sleep infinity" >> /cmd
CMD ["sh", "/cmd"]

# python packages
RUN pip install pandas
RUN pip install numpy
RUN pip install matplotlib

# copy external resources and tools
ENV PATH="/opt:${PATH}"
COPY docker/res /

# cleanup
# RUN rm -rf /var/lib/apt/lists/*
# RUN rm -rf /tmp/*
# RUN jupyter lab clean
# RUN jlpm cache clean
# RUN npm cache clean --force

WORKDIR ${APP_DIR}
