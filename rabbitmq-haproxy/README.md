# RabbitMQ com HAProxy e TLS Termination

Este é um exemplo de configuração do HAProxy para atuar como proxy TLS Termination para o RabbitMQ.

Estrutura do projeto:
```
.
├── .env
├── docker-compose.yml
├── haproxy.cfg
├── rabbitmq.conf
└── ssl-certificates/
    ├── combined.pem
    ├── domain.crt
    └── domain.key
```

Para rodar:
1. copie o env de exemplo: `cp .env.example .env`
2. Prepare os certificados na pasta ./ssl-certificates/ (veja seção abaixo para gerar self-signed)
2. `docker-compose up -d --build --force-recreate`

Pronto!
- Para gerenciar, acesse o RabbitMQ Management em http://localhost:15672 (usuário: `guest`, senha: `guest`)
- E você pode conectar no RabbitMQ via AMQPS na porta `5671` (ex: `amqps://guest:guest@localhost:5671`) desde que o cliente confie no certificado utilizado.

# Motivação

Para tornar seguro, a documentação do RabbitMQ oferece duas formas: configurar o RabbitMQ diretamente com TLS ou utilizar um proxy com TLS Termination. https://www.rabbitmq.com/docs/ssl#tls-connectivity-options

Eu gostaria muito de utilizar o Nginx para isso, porém apenas a versão "Plus" possui essa funcionalidade. https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-tcp/#prerequisites

## Certificados TLS

**Opção recomendada:** LetsEncrypt com certbot (gratuito e automático)

Portanto aqui está uma configuração exemplo para iniciar com isso, partindo do pressuposto que você gerou certificados com certbot do letsencrypt.

> É necessário unir os dois certificados em um único combined.pem:
> ```
> cat ./ssl-certificates/fullchain.pem ./ssl-certificates/privkey.pem > ./ssl-certificates/combined.pem
> ```

**Para testes:** Gerando certificados self-signed com OpenSSL

> Obs: isso complica tudo pois terá de configurar o cliente para confiar nesse certificado (pior ainda, confiar em qualquer um é um problema de segurança), o certo é usar letsencrypt com um domínio válido.

https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs#generating-ssl-certificates
```bash
cd ssl-certificates

openssl req \
       -newkey rsa:2048 -nodes -keyout domain.key \
       -x509 -days 3650 -out domain.crt

cat domain.crt domain.key > combined.pem
```
