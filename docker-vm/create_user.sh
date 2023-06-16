userdel --remove admin
export USERNAME=$USERNAME
export PASSWORD=$PASSWORD
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

#Pegar Instalação do node do root e colocar para o usuário
chown -R $USERNAME:$USERNAME /opt/nvm
echo 'export NVM_DIR="/opt/nvm"' >> /home/$USERNAME/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/$USERNAME/.bashrc # This loads nvm
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /home/$USERNAME/.bashrc # This loads nvm bash_completion

# Configurar code-server
# https://stackoverflow.com/questions/14155596/how-to-substitute-shell-variables-in-complex-text-files
mkdir -p /home/$USERNAME/.config/code-server
envsubst < "code-server/config.yaml" > "/home/$USERNAME/.config/code-server/config.yaml"

# Iniciar code-server
systemctl enable code-server@$USERNAME
# Configuração do usuário
cp install_user.sh /home/$USERNAME/install_user.sh

cd /home/$USERNAME
chown $USERNAME:$USERNAME ./install_user.sh
sudo -H -u $USERNAME bash ./install_user.sh

rm ./install_user.sh