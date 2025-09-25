#!/bin/bash
# A ideia é que você irá primeiro executar esse script, e em seguida os outros.

# Irá parar se 1 comando falhar
set -e

echo "Configurando mc (MinIO Client)..."

# https://superuser.com/questions/1727532/load-env-file-from-bash-script
if [ -f ./.env ]; then
    set -o allexport
    source ./.env
    set +o allexport
fi

# Check if alias already exists
mc alias set myminio "${MINIO_URL}" "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}"
