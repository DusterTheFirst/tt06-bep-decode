FROM mcr.microsoft.com/devcontainers/base:alpine-3.19

ARG ARCHIVE="oss-cad-suite-linux-x64-20240316"

RUN --mount=type=bind,source=${ARCHIVE}.tgz,target=${ARCHIVE}.tgz \
    set -eux; \
    tar -xzvf ${ARCHIVE}.tgz;

RUN set -eux; \
    echo "source /oss-cad-suite/environment;" >> /home/vscode/.bashrc; \
    echo "unset VERILATOR_ROOT;" >> /home/vscode/.bashrc;