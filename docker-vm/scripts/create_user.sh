#!/bin/bash

export USERNAME=$1
export PASSWORD=$2
export CODEAUTH=password

systemctl stop code-server@admin
systemctl disable code-server@admin

CODESERVERPATH="/home/$USERNAME/.local"
if [ -d $CODESERVERPATH ]; then
	JACRIOU=1
fi

if [ ! $JACRIOU ]; then
	# Salva a pasta .local do vscode antes de deletar o usuário
	mv /home/admin/.local ~/.local
fi

userdel --remove admin
# Adiciona o novo usuário com diretório home
useradd --create-home --shell /bin/bash $USERNAME
# Copia o skel manualmente, porque quando tem volume não funciona
# https://www.dba-db2.com/2013/07/useradd-in-linux-not-copying-any-file-from-skel-directory-into-it.html
cp -r /etc/skel/. /home/$USERNAME
# Muda a sua senha e adiciona ao grupo sudo
echo "$USERNAME:$PASSWORD" | chpasswd
adduser $USERNAME sudo
# Adiciona ao grupo docker
usermod -aG docker $USERNAME

# Operações que só serão feitas se o usuário não existia
if [ ! $JACRIOU ]; then
	# Configura a chave SSH
	mkdir -p /home/$USERNAME/.ssh

	# Configurar code-server
	# diretorio onde fica as configurações do code-server
	# copia de volta a pasta do vscode salva lá do admin
	mv ~/.local $CODESERVERPATH
	./mv_code_server.sh "$CODESERVERPATH/share/code-server" "admin" "$USERNAME"

	# Copia a configuração padrão do code-server, substituindo as variáveis USERNAME e PASSWORD
	# https://stackoverflow.com/questions/14155596/how-to-substitute-shell-variables-in-complex-text-files
	mkdir -p /home/$USERNAME/.config/code-server
	envsubst < "config.yaml" > "/home/$USERNAME/.config/code-server/config.yaml"
fi

# Configurar o serviço do code-server para utilizar o Workspace padrão
if [ ! -e "/etc/systemd/system/code-server@.service.d/override.conf" ]; then
	export WORKSPACE=${DEFAULT_WORKSPACE:-"/home/$USERNAME/Desktop"};
	
	mkdir -p $WORKSPACE;

	{ echo "[Service]"; 
	  echo "ExecStart=";
	  echo "ExecStart=/usr/bin/code-server $WORKSPACE";
	} > ~/override.conf
	# Não funciona em TTY, Tem que copiar para o caminho msm
	#env SYSTEMD_EDITOR="cp $HOME/override.conf" systemctl edit code-server@$USERNAME
	mkdir "/etc/systemd/system/code-server@.service.d"
	cp ~/override.conf "/etc/systemd/system/code-server@.service.d/override.conf"

	systemctl daemon-reload
fi

# Configurar nginx
export NGINXROOT=${DEFAULT_NGINXROOT:-"$WORKSPACE/public_html"};
envsubst '${NGINXROOT}' < "php-nginx-default.conf" > "/etc/nginx/sites-available/default"
# Se não tem nenhum index.html, cria um padrão
if [ ! -d $NGINXROOT ]; then
	mkdir -p $NGINXROOT;
	envsubst '${NGINXROOT} ${USERNAME}' < "index.html" > "$NGINXROOT/index.html"
fi
# Para aplicar a configuração nova
systemctl reload nginx

# Garante que as permissões estão corretas, corrige possíveis problemas com volumes
# https://winaero.com/run-chmod-separately-for-files-and-directories/
chown -R $USERNAME:$USERNAME /home/$USERNAME
chmod -R 644 /home/$USERNAME && find /home/$USERNAME -type d -print0 |xargs -0 chmod 755

# Iniciar code-server
systemctl enable --now code-server@$USERNAME

# Configuração do usuário, configuração git e criação de chave ssh padrão
if [ ! $JACRIOU ]; then
	cp install_user.sh /home/$USERNAME/install_user.sh
	cd /home/$USERNAME
	chown $USERNAME:$USERNAME ./install_user.sh
	sudo -H -u $USERNAME bash ./install_user.sh
	rm ./install_user.sh
fi