#!/bin/bash
# https://www.linode.com/docs/guides/how-to-install-openjdk-ubuntu-22-04/
echo "Instalar Java"
wget https://download.java.net/java/GA/jdk20.0.2/6e380f22cbe7469fa75fb448bd903d8e/9/GPL/openjdk-20.0.2_linux-x64_bin.tar.gz
tar xvf openjdk-20.0.2_linux-x64_bin.tar.gz -C /opt
update-alternatives --install /usr/bin/java java /opt/jdk-20.0.2/bin/java 1000
update-alternatives --install /usr/bin/javac javac /opt/jdk-20.0.2/bin/javac 1000

echo "Configurar Path"

#Pegar Instalação do java e colocar para todos os usuários
echo 'export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))' >> /etc/profile.d/03-java.sh
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile.d/03-java.sh