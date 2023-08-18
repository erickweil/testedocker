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
FROM ghcr.io/nestybox/ubuntu-jammy-systemd:latest

# SSH Server
EXPOSE 22
# Code-Server
EXPOSE 8080

WORKDIR /root

# VER DEPOIS: Configurar que programas instalar ou não via alguma variável de ambiente
# Por enquanto é só comentar ou descomentar aqui na hora de fazer o build
COPY scripts/*.sh ./
COPY code-server/*.yaml ./
RUN chmod +x *.sh && \
	/bin/bash ./install.sh \
#	&& /bin/bash ./install_docker.sh \
	&& /bin/bash ./install_ssh.sh \
#	&& /bin/bash ./install_code.sh \
#	&& /bin/bash ./install_node.sh \
#	&& /bin/bash ./install_python.sh \
#	&& /bin/bash ./install_java.sh \
#	&& /bin/bash ./install_kubectl.sh \
	&& /bin/bash ./install_locale.sh \
# Por último... Limpar cache do apt
	&& rm -rf /var/lib/apt/lists/*

# Para realizar build
# docker build -t erickweil/container-vm .
# Executar container:
# docker rm -f vm01 && docker run -d --name vm01 -p 3000:22 -p 3001:8080 --privileged erickweil/container-vm
# Instalar usuário
# docker exec vm01 /bin/bash -c "export USERNAME=usuario && PASSWORD=senha && /bin/bash ./create_user.sh"
