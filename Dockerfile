FROM python:3.9.5-alpine AS ansible
ENV ANSIBLE_VERISON=2.10.6

RUN apk add --update --no-cache \
    rust \
    cargo \
    openssl-dev \
    gcc \
    build-base \
    libffi-dev && \
  pip install ansible==${ANSIBLE_VERISON} awscli

FROM alpine:latest AS packer
ENV PACKER_VERSION=1.7.3

RUN apk add --update --no-cache curl zip
RUN curl -sLo /tmp/packer_linux_amd64.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip
RUN unzip '/tmp/*_linux_amd64.zip' -d /usr/bin/

FROM alpine:latest

COPY --from=ansible /usr/local/bin /usr/local/bin
COPY --from=ansible /usr/local/lib /usr/local/lib
COPY --from=packer /usr/bin/packer /usr/bin/packer

ENTRYPOINT [ "packer" ]