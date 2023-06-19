# Script a ser executado na máquina com docker e sysbox instalado
# para iniciar um container com usuário criado
export USERNAME=$1
export PASSWORD=$2
export CODEPORT=$3
export SSHPORT=$4
export CONTAINER="vm-$USERNAME"

docker run -d --runtime=sysbox-runc \
	--name $CONTAINER \
	-v vol-$USERNAME:/home/$USERNAME \
	-p $CODEPORT:8080 \
	-p $SSHPORT:22 \
	erickweil/container-vm

docker exec $CONTAINER bash -c "bash /root/create_user.sh $USERNAME $PASSWORD"