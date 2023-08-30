#!/bin/bash
# https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-20-04

# Será configurado para escutar na porta 80 e hospedar os sites no diretóio /var/www/html por padrão
echo "Instalar Nginx e PHP" \
	&& apt-get install nginx -y \
	&& apt-get install --no-install-recommends -y php8.1 \
	&& apt-get install -y \
	php8.1-cli \
	php8.1-common \
	php8.1-mysql \
	php8.1-zip \
	php8.1-gd \
	php8.1-mbstring \
	php8.1-curl \
	php8.1-xml \
	php8.1-bcmath \
	php8.1-fpm;

#cp -f php-nginx-default.conf /etc/nginx/sites-available/default;

export NGINXROOT="/var/www/html";
envsubst '${NGINXROOT}' < "php-nginx-default.conf" > "/etc/nginx/sites-available/default";

nginx -t;