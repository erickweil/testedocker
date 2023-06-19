#
# Ubuntu Bionic + Systemd + sshd + Docker
#
# Usage:
#
# $ docker run --runtime=sysbox-runc -it --rm -P --name=syscont nestybox/ubuntu-bionic-systemd-docker
#
# This will run systemd and prompt for a user login; the default
# user/password in this image is "admin/admin". Once you log in you
# can run Docker inside as usual. You can also ssh into the image:
#
# $ ssh admin@<host-ip> -p <host-port>
#
# where <host-port> is chosen by Docker and mapped into the system container's sshd port.
#

FROM ghcr.io/nestybox/ubuntu-jammy-systemd-docker:latest

EXPOSE 22
EXPOSE 8080
WORKDIR /root

COPY scripts/*.sh ./
COPY code-server/*.yaml ./
RUN chmod +x *.sh && \
	/bin/bash ./install.sh

# Para realizar build
# docker build -t erickweil/container-vm .
# Executar container:
# docker rm -f vm01 && docker run -d --name vm01 -p 3000:22 -p 3001:8080 --privileged erickweil/container-vm
# Instalar usuário
# docker exec vm01 /bin/bash -c "export USERNAME=usuario && PASSWORD=senha && /bin/bash ./create_user.sh"
