#!/bin/bash
# https://stackoverflow.com/questions/11821378/what-does-bashno-job-control-in-this-shell-mean
set -m

# exec minio "$@" &
exec minio server /data --console-address :9001 &

sleep 3

mc alias set myminio "${MINIO_URL}" "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}" \
    && ./criar_bucket.sh "${BUCKET_NAME}" \
    && ./criar_usuario.sh "${MINIO_USER}" "${MINIO_PASSWORD}" \
    && ./criar_chave.sh "${MINIO_USER}" "${BUCKET_NAME}" "${BUCKET_ACCESS_KEY}" "${BUCKET_SECRET_KEY}" \
    && fg \
    || echo "ERRO AO CONFIGURAR!" && exit 1