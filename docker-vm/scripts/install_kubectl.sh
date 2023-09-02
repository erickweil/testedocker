#!/bin/bash
set -e # Se falhar 1 comando falha tudo.
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# https://www.cherryservers.com/blog/install-kubectl-ubuntu
# https://kubectl.docs.kubernetes.io/installation/kustomize/binaries/

echo "Instalar Kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin
echo "Instalar kustomize"

curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
mv ./kustomize  /usr/local/bin/kustomize
#export PATH=$PATH:/usr/local/bin/kustomize

# Deveria instalar o Helm?
