# Script de instalação / Configuração que executa como usuário comum
# Apenas a primeira vez que o container é criado e se o volume estiver vazio

# Configurar o git e chave ssh
cd $HOME
# NÃO CONFIGURAR O USUARIO E EMAIL DO GIT, POIS IRÁ ESTRAGAR
# O HISTÓRICO DE COMMIT DO REPOSITÓRIO
#git config --global user.name $USER &&
#git config --global user.email $USER@local &&
git config --global core.editor nano &&
mkdir -p $HOME/.ssh
ssh-keygen -t ed25519 -q -f $HOME/.ssh/id_ed25519 -N ""

# TEM QUE RODAR NO USUÁRIO QUE VAI USAR O CODE-SERVER
# Como instalar extensões -> https://github.com/coder/code-server/issues/3173
# NÃO FUNCIONA INSTALAR LANGUAGE PELO TERMINAL --> https://github.com/coder/code-server/issues/3372
# Possível solução? https://github.com/coder/code-server/issues/6168
# code-server --install-extension ms-ceintl.vscode-language-pack-pt-br

# Também n funciona, não é assim...
# curl -fL -o language-pack-ptbr.vsix https://marketplace.visualstudio.com/_apis/public/gallery/publishers/MS-CEINTL/vsextensions/vscode-language-pack-pt-BR/1.82.2023083009/vspackage
# code-server --install-extension language-pack-ptbr.vsix