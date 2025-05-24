#!/bin/sh
set -e

# Gerar o .htpasswd
htpasswd -cb /etc/nginx/.htpasswd "$BASICAUTH_USER" "$BASICAUTH_PWD"

./docker-entrypoint.sh "$@"