FROM erickweil/container-vm:latest

# Estranho... por algum motivo executar o script assim não funciona
# Tive que executar o script no container e então fazer commit em uma imagem
COPY install_swift.sh ./
RUN chmod +x *.sh && \
	/bin/bash ./install_swift.sh

# docker build -t erickweil/container-vm:swift .
# docker run -d -p 8080:8080 --privileged erickweil/container-vm:swift