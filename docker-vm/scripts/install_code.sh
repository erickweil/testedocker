#!/bin/bash
# Instalar code-server
curl -fsSL https://code-server.dev/install.sh | sh
# Configurar code-server
# https://stackoverflow.com/questions/14155596/how-to-substitute-shell-variables-in-complex-text-files
mkdir -p /home/admin/.config/code-server
export CODEAUTH=none
export PASSWORD=none
envsubst < "config.yaml" > "/home/admin/.config/code-server/config.yaml"

# Iniciar code-server
systemctl enable --now code-server@admin || true

echo "TERMINADA INSTALAÇÃO DO CODE-SERVER"