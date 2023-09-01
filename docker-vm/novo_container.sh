#!/bin/bash
export USERNAME=$1
export PASSWORD=$2

export USER_CONTAINER_IMAGE="erickweil/container-vm:code-ptbr"
export DOCKER_NETWORK="alunos"

echo "Criando arquivos de configuração"
mkdir -p "./usuarios/$USERNAME"

ENVFILE="./usuarios/$USERNAME/.env"
envsubst < ".env.template" > $ENVFILE

COMPOSEFILE="./usuarios/$USERNAME/docker-compose.yml"
cp "./usuarios/docker-compose.yml" $COMPOSEFILE

SQLFILE="./usuarios/$USERNAME/create_user.sql"
envsubst '${USERNAME} ${PASSWORD}' < "create_user.template.sql" > $SQLFILE
#sed -i -e "s/\-/\\\-/g" $SQLFILE

echo "Criando usuário no banco de dados"
mysql -h 127.0.0.1 < $SQLFILE

echo "Iniciando o container"
bash ./subir_container.sh $COMPOSEFILE $ENVFILE up