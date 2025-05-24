FROM minio/minio:latest

# Criando um bucket padrão que estará acessível de forma pública (static)
# https://gist.github.com/harshavardhana/f05b60fe6f96803743f38bea4b565bbf
# https://stackoverflow.com/questions/66412289/minio-add-a-public-bucket-with-docker-compose

COPY <<-EOF /my-entrypoint.sh
    #!/bin/sh
    # https://stackoverflow.com/questions/11821378/what-does-bashno-job-control-in-this-shell-mean
    set -m

    exec minio "\$@" &

    sleep 3

    mc alias set myminio http://localhost:9000 \${MINIO_ROOT_USER} \${MINIO_ROOT_PASSWORD}
    mc mb myminio/\${MINIO_BUCKET} --ignore-existing

    mc anonymous set download myminio/\${MINIO_BUCKET}

    mc admin accesskey create myminio/ \${MINIO_ROOT_USER} --access-key \${MINIO_ACCESS_KEY} --secret-key \${MINIO_SECRET_KEY}

    fg
EOF
RUN chmod +x /my-entrypoint.sh

ENTRYPOINT ["/bin/sh", "/my-entrypoint.sh"]
CMD ["server", "/data", "--console-address", ":9001"]