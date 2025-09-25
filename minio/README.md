# Minio simple iam

Disponível no docker hub: erickweil/minio-simple-iam:latest

Configuração, Variáveis necessárias (Ver .env.example e docker-compose.yml):
```sh
# Usado pelo script .sh ao iniciar o container
# =======================================
MINIO_URL="http://localhost:9000"
MINIO_ROOT_USER="minio"
MINIO_ROOT_PASSWORD="minio123"
MINIO_USER="user"
MINIO_PASSWORD="minio123"
BUCKET_NAME="bucket"
BUCKET_ACCESS_KEY="CHAVE-DE-ACESSO"
BUCKET_SECRET_KEY="CHAVE-SECRETA"

# Usado só pelo docker compose ao subir o container do minio
# =======================================
MINIO_SERVER_EXPOSE_PORT=9000
MINIO_CONSOLE_EXPOSE_PORT=9001
# Descomente a linha abaixo se quiser que o volume docker seja mapeado para a pasta local
# MINIO_VOLUME="./data/minio"
```

A ideia é que MINIO_USER e MINIO_PASSWORD será um usuário com acesso limitado, 

Inicialmente é criado um bucket BUCKET_NAME, e o par de chaves BUCKET_ACCESS_KEY BUCKET_SECRET_KEY dá acesso a apenas esse bucket

## Como adicionar usuários / permissões:

1. Primeiro rode o docker-compose.yml com `docker compose up -d`

- **Para adicionar um novo bucket:**

./criar_bucket.sh NOME-BUCKET

```sh
user@machine:~/git/testedocker$ docker exec -it minio ./criar_bucket.sh NOVO
Bucket created successfully `myminio/NOVO`.
Access permission for `myminio/NOVO` is set to `download`
```

- **Criar usuário**

./criar_usuario.sh NOME-USUARIO SENHA-USUARIO

```sh
user@machine:~/git/testedocker$ docker exec -it minio ./criar_usuario.sh NOME-USUARIO SENHA-USUARIO
Added user `NOME-USUARIO` successfully.
```

- **Criar chave de acesso para bucket (associada ao usuário)**

./criar_chave.sh NOME-USUARIO NOME-BUCKET CHAVE-DE-ACESSO CHAVE-SECRETA

```sh
user@machine:~/git/testedocker$ docker exec -it minio ./criar_chave.sh NOME-USUARIO NOVO CHAVE-DE-ACESSO-1 CHAVE-SECRETA-1
Created policy `NOVO-policy` successfully.
Attached Policies: [NOVO-policy]
To User: NOME-USUARIO
```

Dessa forma você consegue ter vários usuários em uma mesma instância do minio, cada um com vários buckets,
e cada chave de acesso só terá acesso a um bucket específico.