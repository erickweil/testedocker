#!/bin/bash
echo "Instalar programas essenciais" \
    && apt-get update \
    && apt-get install nano vim curl iputils-ping dnsutils git htop gettext wget -y

# VER DEPOIS: configuração da url que é passada ao detectar uma porta aberta para ser uma própria