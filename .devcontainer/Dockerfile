FROM mcr.microsoft.com/devcontainers/base:alpine-3.19

ARG ARCHIVE="oss-cad-suite-linux-x64-20240316"

COPY ${ARCHIVE}.tgz .
RUN set -eux; \
    tar -xzf ${ARCHIVE}.tgz; \
    rm ${ARCHIVE}.tgz; \
    echo "source /oss-cad-suite/environment" >> /home/vscode/.bashrc