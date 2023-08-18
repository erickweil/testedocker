#!/bin/bash

# https://github.com/nestybox/dockerfiles/blob/5b7ec2230af7fb65eb820277e8c408cfa68f79b7/ubuntu-jammy-systemd-docker/Dockerfile

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh get-docker.sh \
    # Add user "admin" to the Docker group
    && usermod -a -G docker admin \
    # Bash Completion
    && curl -fsSL https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh
