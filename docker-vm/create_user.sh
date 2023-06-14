userdel --remove admin 									
# Adiciona o novo usuário com diretório home
useradd --create-home --shell /bin/bash $USERNAME
# Muda a sua senha e adiciona ao grupo sudo
echo "$USERNAME:$PASSWORD" | chpasswd 				
adduser $USERNAME sudo								
# Adiciona ao grupo docker
usermod -aG docker $USERNAME						
# Configura a chave SSH
mkdir -p /home/$USERNAME/.ssh 							
chown -R $USERNAME:$USERNAME /home/$USERNAME
# https://winaero.com/run-chmod-separately-for-files-and-directories/
chmod -R 644 /home/$USERNAME && find /home/$USERNAME -type d -print0 |xargs -0 chmod 755

chmod 744 /home/$USERNAME/.bashrc

# Configuração do usuário
sudo -H -u $USERNAME bash ./install_user.sh

