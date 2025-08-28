ARG PYTORCH_IMAGE=nvcr.io/nvidia/pytorch:24.07-py3
FROM ${PYTORCH_IMAGE}

ARG NVF_VERSION=main
ENV NVF_BRANCH=${NVF_VERSION}

RUN <<EOT
python3 -m pip install --root-user-action --upgrade pip
python3 -m pip install --root-user-action --upgrade setuptools
python3 -m pip install --root-user-action \
 kubernetes \
 nvflare
EOT

WORKDIR /workspace/
RUN git clone https://github.com/NVIDIA/NVFlare.git --branch ${NVF_BRANCH} --single-branch NVFlare
