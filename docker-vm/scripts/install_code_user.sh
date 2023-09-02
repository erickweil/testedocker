#!/bin/bash
# Configurar code-server para o novo usuário
set -e # Se falhar 1 comando falha tudo.
REPLACE_EXISTING_INSTALL=$1

CODESERVERPATH="$INSTALL_HOME/.local/share/code-server"
OLDCODESERVERPATH="$INSTALL_OLDHOME/.local/share/code-server"

# Se não tiver instalação do code-server, não precisa fazer nada
if [ ! -f $(which code-server || echo 0) ]; then exit 0; fi;

echo "Configurando Code-Sever para o usuário $USERNAME"

# Desativar instalação antiga
systemctl stop code-server@$INSTALL_OLDUSER || true
systemctl disable code-server@$INSTALL_OLDUSER || true

# Para apagar a instalação antiga, causando a padrão ser usada
# Todas as extensões, configurações, workspaces, etc.. configurados serão perdidos
if [ "$REPLACE_EXISTING_INSTALL" == "replace" ]; then
	echo "Deletada instalação Atual"
	rm -r -f $CODESERVERPATH
fi

# Mover a Instalação padrão, se não tiver
if [ ! -d "$CODESERVERPATH" ] && [ -d "$OLDCODESERVERPATH" ]; then
	echo "Movendo instalação Padrão"
	# Mover Instalação do Code-Server
	# diretorio onde fica as configurações do code-server
	# copia de volta a pasta do vscode salva lá do admin

	# Criar apenas os diretórios pai
	mkdir -p $CODESERVERPATH || true
	rmdir $CODESERVERPATH

	# Move sem dar o problema da subpasta
	mv $OLDCODESERVERPATH $CODESERVERPATH

	# O objetivo é renomear os arquivos necessários para o funcionamento do code-server após ser movido de
	# um diretório para outro.
	# https://stackoverflow.com/questions/525592/find-and-replace-inside-a-text-file-from-a-bash-command
	ENCONTRAR="$INSTALL_OLDHOME"
	SUBSTITUIR="$INSTALL_HOME"
	# No caso, O '#' é o separador, porque tem / na variável, apesar que um caminho poderia ter # mas aí é demais né
	REGEX="s#$ENCONTRAR#$SUBSTITUIR#g"

	sed -i -e $REGEX $CODESERVERPATH/extensions/extensions.json || true
	sed -i -e $REGEX $CODESERVERPATH/languagepacks.json || true
	rm -r -f $CODESERVERPATH/CachedProfilesData
fi

# Criar configuração, se não tiver
if [ ! -f "$INSTALL_HOME/.config/code-server/config.yaml" ]; then
	echo "Criando config.yaml"
	# Configuração .yaml do Code-Server
	# Copia a configuração padrão do code-server, substituindo as variáveis USERNAME e PASSWORD
	# https://stackoverflow.com/questions/14155596/how-to-substitute-shell-variables-in-complex-text-files
	mkdir -p $INSTALL_HOME/.config/code-server || true
	
	export CODEAUTH=${CODEAUTH:-"password"}
	envsubst < "config.yaml" > "$INSTALL_HOME/.config/code-server/config.yaml"
fi

echo "Comfigurando Serviço do Code-Server"
# Configurar o serviço do code-server para abrir o Workspace padrão
mkdir -p $WORKSPACE || true

{ echo "[Service]"; 
	echo "ExecStart=";
	echo "ExecStart=/usr/bin/code-server $WORKSPACE";
} > ~/override.conf
# Não funciona em TTY, Tem que copiar para o caminho msm
#env SYSTEMD_EDITOR="cp $HOME/override.conf" systemctl edit code-server@$USERNAME
mkdir "/etc/systemd/system/code-server@.service.d" || true
cp ~/override.conf "/etc/systemd/system/code-server@.service.d/override.conf"

systemctl daemon-reload || true

# Iniciar code-server
systemctl enable --now code-server@$USERNAME || true