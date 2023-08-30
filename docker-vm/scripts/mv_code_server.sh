#!/bin/bash

# O objetivo é renomear os arquivos necessários para o funcionamento do code-server após ser movido de
# um diretório para outro.
# No caso o mv já aconteceu

# https://stackoverflow.com/questions/525592/find-and-replace-inside-a-text-file-from-a-bash-command
export CODESERVERPATH=$1 #"/home/erick/.local/share/code-server"
export ENCONTRAR="\/home\/$2"
export SUBSTITUIR="\/home\/$3"
export REGEX="s/$ENCONTRAR/$SUBSTITUIR/g"

rm -r -f CachedProfilesData

sed -i -e $REGEX $CODESERVERPATH/extensions/extensions.json
sed -i -e $REGEX $CODESERVERPATH/languagepacks.json