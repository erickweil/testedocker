# Script de instalação / Configuração que executa como usuário comum

# Configurar o git e chave ssh
cd $HOME
# NÃO CONFIGURAR O USUARIO E EMAIL DO GIT, POIS IRÁ ESTRAGAR
# O HISTÓRICO DE COMMIT DO REPOSITÓRIO
#git config --global user.name $USER &&
#git config --global user.email $USER@local &&
git config --global core.editor nano &&
ssh-keygen -t ed25519 -q -f $HOME/.ssh/id_ed25519 -N ""