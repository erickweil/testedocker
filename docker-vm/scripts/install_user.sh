# Script de instalação / Configuração que executa como usuário comum

# Configurar o git e chave ssh
cd $HOME
git config --global user.name $USER &&
git config --global user.email $USER@local &&
git config --global core.editor nano &&
ssh-keygen -t ed25519 -q -f $HOME/.ssh/id_ed25519 -N ""