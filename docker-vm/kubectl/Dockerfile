FROM erickweil/container-vm:latest

COPY install_kubectl.sh ./
RUN chmod +x *.sh && \
	/bin/bash ./install_kubectl.sh

# docker build -t erickweil/container-vm:kubectl .
# docker run -d -p 8080:8080 --privileged erickweil/container-vm:kubectl