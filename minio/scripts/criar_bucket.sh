#!/bin/bash
# Irá parar se 1 comando falhar
set -e

# 1. Verificar se o nome do bucket foi passado como argumento
BUCKET_NAME=$1
if [ -z "$BUCKET_NAME" ]; then
    echo -e "O nome do bucket é obrigatório. Uso: ./criar_bucket.sh <nome-do-bucket>"
    exit 1
fi

# 2. Criar bucket
mc mb "myminio/${BUCKET_NAME}" --ignore-existing

# 3. Tornar o bucket público para download (leitura)
mc anonymous set download "myminio/${BUCKET_NAME}"