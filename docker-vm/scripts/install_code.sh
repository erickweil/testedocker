#!/bin/bash
# Instalar code-server
set -e # Se falhar 1 comando falha tudo.

curl -fsSL https://code-server.dev/install.sh | sh
# Configurar code-server
# https://stackoverflow.com/questions/14155596/how-to-substitute-shell-variables-in-complex-text-files
mkdir -p $INSTALL_HOME/.config/code-server
export CODEAUTH=none
export PASSWORD=none
envsubst < "config.yaml" > "$INSTALL_HOME/.config/code-server/config.yaml"

# Iniciar code-server
systemctl enable --now code-server@$INSTALL_USER || true

echo "TERMINADA INSTALAÇÃO DO CODE-SERVER"