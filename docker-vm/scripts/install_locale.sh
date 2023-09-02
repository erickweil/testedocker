#!/bin/bash
set -e # Se falhar 1 comando falha tudo.

# Para ajustar a Timezone
# https://serverfault.com/questions/949991/how-to-install-tzdata-on-a-ubuntu-docker-image
# https://dev.to/0xbf/set-timezone-in-your-docker-image-d22
TZ=${TZ:="America/New_York"}
# set noninteractive installation
export DEBIAN_FRONTEND=noninteractive
# install tzdata package
apt-get install -y tzdata
# set your timezone
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

# Para funcionar nano com acentos
# https://serverfault.com/questions/362903/how-do-you-set-a-locale-non-interactively-on-debian-ubuntu
LANG=${LANG:=pt_BR.UTF-8}
echo "Arrumando Locale para $LANG"
apt-get install -y locales

sed -i -e "s/# $LANG.*/$LANG UTF-8/" /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=$LANG