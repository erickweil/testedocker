#!/bin/bash
set -e # Se falhar 1 comando falha tudo.

# Instalar node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
# Para funcionar o comando nvm agora
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install v20.3.0

# Mover nvm para pasta fora do /root
mv .nvm /opt/nvm
chmod -R 777 /opt/nvm # Permissão para todos

#Pegar Instalação do node e colocar para todos os usuários
echo 'export NVM_DIR="/opt/nvm"' >> /etc/profile.d/02-nvm.sh
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /etc/profile.d/02-nvm.sh # This loads nvm
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /etc/profile.d/02-nvm.sh # This loads nvm bash_completion
