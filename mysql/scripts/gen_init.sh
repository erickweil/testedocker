#!/bin/bash
export USUARIO=$1
export SENHA=$2
OUTPUT=$3

# Avisa como usar caso não prover argumentos
[ $# -lt 3 ] && { echo "Usage: $0 <usuario> <senha> <output>"; exit 1; }

envsubst '${USUARIO} ${SENHA}' < "create_user.template.sql" > $OUTPUT/$USUARIO.sql