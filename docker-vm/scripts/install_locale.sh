#!/bin/bash

# Para funcionar nano com acentos
# https://serverfault.com/questions/362903/how-do-you-set-a-locale-non-interactively-on-debian-ubuntu
LANG=${LANG:=pt_BR.UTF-8}
echo "Arrumando Locale para $LANG"
apt-get install -y locales && \
    sed -i -e "s/# $LANG.*/$LANG UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG