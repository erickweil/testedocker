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
# EXPOSE 22

EXPOSE 80
# Code-Server
EXPOSE 8080

WORKDIR /root
# VER DEPOIS: Configurar que programas instalar ou não via alguma variável de ambiente
# Por enquanto é só comentar ou descomentar aqui na hora de fazer o build
COPY scripts/*.sh ./
COPY configs/* ./
RUN export DEBIAN_FRONTEND=noninteractive && chmod +x *.sh && \
	/bin/bash ./install.sh \
	&& /bin/bash ./install_locale.sh \
	&& /bin/bash ./install_code.sh \
#	&& /bin/bash ./install_docker.sh \
#	&& /bin/bash ./install_php_nginx.sh \
#	&& /bin/bash ./install_ssh.sh \
#	&& /bin/bash ./install_node.sh \
#	&& /bin/bash ./install_python.sh \
#	&& /bin/bash ./install_java.sh \
#	&& /bin/bash ./install_kubectl.sh \
#	&& /bin/bash ./install_mariadb_client.sh \
# Por último... Limpar cache do apt
	&& rm -rf /var/lib/apt/lists/*

# Realizar build e arrumar as coisas iniciais
# docker build -t erickweil/container-vm:code .
# Executar container:
# docker rm -f vm01; docker run -d --name vm01 -p 3000:8080 --privileged erickweil/container-vm:code
# 1. Abre no navegador http://localhost:3000/ e instala a extensão ms-ceintl.vscode-language-pack-pt-br
# 2. Clicar botão para reiniciar com o locale pt-br
# 3. Escolher temas -> Modo escuro
# 4. Configuração "Terminal > Integrated: Allow Chords" desmarcar (Para funcionar crtl+k usando o nano) 
# Aplicar container que foi modificado para ser uma imagem
# docker stop vm01; docker commit vm01 erickweil/container-vm:code-ptbr-v2

ENTRYPOINT ["sh","/root/docker-entrypoint.sh"]
CMD ["/sbin/init", "--log-level=err"]