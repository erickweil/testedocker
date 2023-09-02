#!/bin/bash
# Configurar nginx para o novo usuário
set -e # Se falhar 1 comando falha tudo.

# Se não tiver instalação do nginx, não precisa fazer nada
if [ ! -d "/etc/nginx" ]; then
	exit 0
fi

export NGINXROOT=${DEFAULT_NGINXROOT:-"$WORKSPACE/public_html"}
envsubst '${NGINXROOT}' < "php-nginx-default.conf" > "/etc/nginx/sites-available/default"

# cria um index.html padrão se for a primeira vez
if [ ! -d "$NGINXROOT" ]; then
	mkdir -p $NGINXROOT
	envsubst '${NGINXROOT} ${USERNAME}' < "index.html" > "$NGINXROOT/index.html"
fi

# Para aplicar a configuração nova
systemctl reload nginx || true