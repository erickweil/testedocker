systemctl stop code-server@admin
systemctl disable code-server@admin
userdel --remove admin
export USERNAME=$1
export PASSWORD=$2
export CODEAUTH=password
# Adiciona o novo usuário com diretório home
useradd --create-home --shell /bin/bash $USERNAME
# Muda a sua senha e adiciona ao grupo sudo
echo "$USERNAME:$PASSWORD" | chpasswd 				
adduser $USERNAME sudo								
# Adiciona ao grupo docker
usermod -aG docker $USERNAME						
# Configura a chave SSH
mkdir -p /home/$USERNAME/.ssh

# Garante que as permissões estão corretas, corrige possíveis problemas com volumes
# https://winaero.com/run-chmod-separately-for-files-and-directories/
chown -R $USERNAME:$USERNAME /home/$USERNAME
chmod -R 644 /home/$USERNAME && find /home/$USERNAME -type d -print0 |xargs -0 chmod 755

# Configurar code-server
# https://stackoverflow.com/questions/14155596/how-to-substitute-shell-variables-in-complex-text-files
mkdir -p /home/$USERNAME/.config/code-server
envsubst < "config.yaml" > "/home/$USERNAME/.config/code-server/config.yaml"

# Iniciar code-server
systemctl enable --now code-server@$USERNAME
# Configuração do usuário, configuração git e criação de chave ssh padrão
cp install_user.sh /home/$USERNAME/install_user.sh
cd /home/$USERNAME
chown $USERNAME:$USERNAME ./install_user.sh
sudo -H -u $USERNAME bash ./install_user.sh
rm ./install_user.sh