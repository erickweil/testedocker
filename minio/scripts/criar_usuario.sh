#!/bin/bash
# Irá parar se 1 comando falhar
set -e

# 1. Verificar se o nome do bucket foi passado como argumento
USER_NAME=$1
USER_PASSW=$2
if [ -z "$USER_NAME" ] || [ -z "$USER_PASSW" ]; then
    echo -e "Uso: ./criar_usuario.sh <nome-da-conta> <senha-da-conta>"
    exit 1
fi

# 2. Criar usuário
# https://docs.min.io/community/minio-object-store/administration/identity-access-management/minio-user-management.html
mc admin user add myminio "${USER_NAME}" "${USER_PASSW}"
