#!/bin/bash
# Este script pega a imagem com o usuário 'admin', deleta ele e cria um novo
#
# É possível que o diretório home do usuário já exista (volume mapeado), 
# mas não o usuário em si, por isso o chmod e todos os if's
export USERNAME=$1
export PASSWORD=$2

export INSTALL_OLDUSER="$INSTALL_USER"
export INSTALL_OLDHOME="$INSTALL_HOME"
export INSTALL_USER="$USERNAME"
export INSTALL_HOME="/home/$USERNAME"
export WORKSPACE=${DEFAULT_WORKSPACE:-"$INSTALL_HOME/Desktop"}
# Este script deve rodar apenas uma vez, se rodar denovo ele não faz nada
# Basicamente se o /home/admin não existir é porque está rodando denovo
if [ ! -d /home/admin ]; then
	echo $(date -u) "Container já foi configurado, não é necessário rodar este script novamente."
else
	echo $(date -u) "Primeira vez do container, configurando criação do usuário $USERNAME..."
	# Tudo isso só acontece se for a primeira vez do container

	# Adiciona o novo usuário com diretório home
	echo "Criando usuário $USERNAME"
	useradd --create-home --home-dir $INSTALL_HOME --shell /bin/bash $USERNAME

	# Muda a sua senha e adiciona ao grupo sudo
	echo "$USERNAME:$PASSWORD" | chpasswd
	adduser $USERNAME sudo

	if [ ! -f "$INSTALL_HOME/.bashrc" ]; then
		# Copia o skel manualmente, porque quando tem volume não funciona
		# https://www.dba-db2.com/2013/07/useradd-in-linux-not-copying-any-file-from-skel-directory-into-it.html
		# Depois tem que ver parece que o bash_history ta salvando em algum lugar diferente do normal (fora do $HOME)
		cp -r /etc/skel/. $INSTALL_HOME
	fi

	# Executa scripts de configuração do usuário para cada programa
	/bin/bash ./install_code_user.sh "$REPLACE_EXISTING_INSTALL"
	/bin/bash ./install_docker_user.sh
	/bin/bash ./install_php_nginx_user.sh

	# Garante que as permissões estão corretas, corrige possíveis problemas com volumes
	chown -R $USERNAME:$USERNAME /home/$USERNAME

	# Será necessário se o volume já existe? 
	# if [ ! $JACRIOU ]; then
		# https://winaero.com/run-chmod-separately-for-files-and-directories/
		# NÃO !!!! ISSO ESTRAGA OS BINÁRIOS FICAM SEM PERMISSÃO DE EXECUTÁVEL (EXTENSÃO JAVA NÃO FUNCIONA MAIS)
		#chmod -R 644 /home/$USERNAME && find /home/$USERNAME -type d -print0 |xargs -0 chmod 755
	# fi

	# Configuração do usuário, configuração git e criação de chave ssh padrão
	# Tem que rodar como usuário comum
	if [ ! -d "$INSTALL_HOME/.ssh" ]; then
		cp install_git_user.sh /home/$USERNAME/install_git_user.sh
		cd /home/$USERNAME
		chown $USERNAME:$USERNAME ./install_git_user.sh
		sudo -H -u $USERNAME bash ./install_git_user.sh
		rm ./install_git_user.sh
	fi

	# Por último... desativa o usuário admin
	echo "Removendo usuário admin"
	userdel --remove admin || true
fi