#!/bin/bash
# Script a ser executado na máquina com docker e sysbox instalado
# para iniciar um container com usuário criado
export USERNAME=$1
export PASSWORD=$2
export CODEPORT=$3
export SSHPORT=$4
export CONTAINER=$USERNAME

docker network create net-vm

# A fazer: Limitar o tamanho do volume
# https://github.com/moby/moby/issues/16670
# https://github.com/moby/moby/issues/41328
docker volume create vol-$USERNAME

# https://docs.docker.com/engine/reference/run/
# A opção --storage-opt não afeta os volumes, apenas dados salvos
# no sistema de arquivos overlay do próprio container. o valor padrão é 10GB e só funciona em alguns sistemas de arquivos
# A opção --memory-reservation deve sempre ser menor que --memory e serve apenas
# para dar uma 'dica' para o container tentar usar menos memória.
docker run -d --runtime=sysbox-runc \
	--name $CONTAINER \
	-v vol-$USERNAME:/home/$USERNAME \
	--network net-vm \
	--restart=unless-stopped \
	-p $CODEPORT:8080 \
	-p $SSHPORT:22 \
	--memory="2G" \
	--memory-reservation="1G" \
	--cpus=1 \
	erickweil/container-vm

# Obs:
# 2G de memória não foi suficiente para rodar os testes
# quando em paralelo. lembrar da opção do jest para rodar 
# um por vez --runInBand

# Cria o usuário, configura o code-server, git, chave ssh, node, e permissões do /home do usuário
docker exec $CONTAINER bash -c "bash /root/create_user.sh $USERNAME $PASSWORD"