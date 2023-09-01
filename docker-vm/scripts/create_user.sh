#!/bin/bash
# Este script pega a imagem com o usuário 'admin', deleta ele e cria um novo
#
# É possível que o diretório home do usuário já exista (volume mapeado), 
# mas não o usuário em si, por isso o chmod e todos os if's
export USERNAME=$1
export PASSWORD=$2
export CODEAUTH=password
export WORKSPACE=${DEFAULT_WORKSPACE:-"/home/$USERNAME/Desktop"}
export NGINXROOT=${DEFAULT_NGINXROOT:-"$WORKSPACE/public_html"}
CODESERVERPATH="/home/$USERNAME/.local"
# Este script deve rodar apenas uma vez, se rodar denovo ele não faz nada
# Basicamente se o /home/admin não existir é porque está rodando denovo
if [ ! -d /home/admin ]; then
	echo $(date -u) "Container já foi configurado, não é necessário rodar este script novamente."
else
	echo $(date -u) "Primeira vez do container, configurando criação do usuário..."
	# Tudo isso só acontece se for a primeira vez do container

	# JACRIOU será 1 se o volume do usuário já existir. (Para impedir que algumas coisas sejam sobrescritas)
	# (Basicamente estamos supondo que se o .local existir é porque o volume já existe)
	if [ -d $CODESERVERPATH ]; then
		JACRIOU=1
	fi

	# Desativa o usuário admin
	echo "Removendo usuário admin"
	systemctl stop code-server@admin
	systemctl disable code-server@admin

	if [ ! $JACRIOU ]; then
		# Salva a pasta .local do vscode antes de deletar o usuário
		mv /home/admin/.local ~/.local
	fi

	userdel --remove admin
	# Adiciona o novo usuário com diretório home
	echo "Criando usuário $USERNAME"
	useradd --create-home --shell /bin/bash $USERNAME

	# Muda a sua senha e adiciona ao grupo sudo
	echo "$USERNAME:$PASSWORD" | chpasswd
	adduser $USERNAME sudo
	# Adiciona ao grupo docker
	usermod -aG docker $USERNAME

	# Operações que só serão feitas se o volume da pasta do usuário estava vazio
	if [ ! $JACRIOU ]; then
		# Copia o skel manualmente, porque quando tem volume não funciona
		# https://www.dba-db2.com/2013/07/useradd-in-linux-not-copying-any-file-from-skel-directory-into-it.html
		# Depois tem que ver parece que o bash_history ta salvando em algum lugar diferente do normal (fora do $HOME)
		cp -r /etc/skel/. /home/$USERNAME

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
	mkdir -p $WORKSPACE

	{ echo "[Service]"; 
	  echo "ExecStart=";
	  echo "ExecStart=/usr/bin/code-server $WORKSPACE";
	} > ~/override.conf
	# Não funciona em TTY, Tem que copiar para o caminho msm
	#env SYSTEMD_EDITOR="cp $HOME/override.conf" systemctl edit code-server@$USERNAME
	mkdir "/etc/systemd/system/code-server@.service.d"
	cp ~/override.conf "/etc/systemd/system/code-server@.service.d/override.conf"

	systemctl daemon-reload

	# Configurar nginx
	envsubst '${NGINXROOT}' < "php-nginx-default.conf" > "/etc/nginx/sites-available/default"

	# cria um index.html padrão se for a primeira vez
	if [ ! $JACRIOU ]; then
		mkdir -p $NGINXROOT
		envsubst '${NGINXROOT} ${USERNAME}' < "index.html" > "$NGINXROOT/index.html"
	fi

	# Para aplicar a configuração nova
	systemctl reload nginx

	# Garante que as permissões estão corretas, corrige possíveis problemas com volumes
	chown -R $USERNAME:$USERNAME /home/$USERNAME

	# Será necessário se o volume já existe? 
	if [ ! $JACRIOU ]; then
		# https://winaero.com/run-chmod-separately-for-files-and-directories/
		chmod -R 644 /home/$USERNAME && find /home/$USERNAME -type d -print0 |xargs -0 chmod 755
	fi

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
fi