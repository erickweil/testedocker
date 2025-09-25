FROM minio/minio:latest

# Criando um bucket padrão que estará acessível de forma pública (static)
# https://gist.github.com/harshavardhana/f05b60fe6f96803743f38bea4b565bbf
# https://stackoverflow.com/questions/66412289/minio-add-a-public-bucket-with-docker-compose

WORKDIR /root

COPY scripts/* ./
RUN chmod +x ./*.sh

ENTRYPOINT ["/bin/bash", "/root/my-entrypoint.sh"]