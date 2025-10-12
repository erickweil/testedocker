# Motivação

Para tornar seguro, a documentação do RabbitMQ oferece duas formas: configurar o RabbitMQ diretamente com TLS ou utilizar um proxy com TLS Termination. https://www.rabbitmq.com/docs/ssl#tls-connectivity-options

Eu gostaria muito de utilizar o Nginx para isso, porém apenas a versão "Plus" possui essa funcionalidade. https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-tcp/#prerequisites

Portanto aqui está uma configuração exemplo para iniciar com isso, partindo do pressuposto que você gerou certificados com certbot do letsencrypt.

> É necessário unir os dois certificados em um único combined.pem:
> ```
> cat ./ssl-certificates/fullchain.pem ./ssl-certificates/privkey.pem > ./ssl-certificates/combined.pem
> ```
