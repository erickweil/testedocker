#!/bin/bash
# Apenas necessário se a imagem base não for a com Docker.
# https://github.com/nestybox/dockerfiles/blob/5b7ec2230af7fb65eb820277e8c408cfa68f79b7/ubuntu-jammy-systemd-docker/Dockerfile
apt-get install --no-install-recommends -y openssh-server \
    && mkdir /home/admin/.ssh \
    && chown admin:admin /home/admin/.ssh