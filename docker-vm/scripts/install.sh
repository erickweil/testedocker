#!/bin/bash
apt-get update

echo "Instalar programas" 
apt-get install nano vim curl iputils-ping dnsutils git htop gettext python3 -y

# Instalar code-server
curl -fsSL https://code-server.dev/install.sh | sh

# Instalar node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install v20.3.0
# Mover nvm para pasta fora do /root
mv .nvm /opt/nvm
chmod -R 777 /opt/nvm

# Para funcionar nano com acentos
# https://serverfault.com/questions/362903/how-do-you-set-a-locale-non-interactively-on-debian-ubuntu
LANG=${LANG:=pt_BR.UTF-8}
echo "Arrumando Locale para $LANG"
apt-get install -y locales && \
    sed -i -e "s/# $LANG.*/$LANG UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG
