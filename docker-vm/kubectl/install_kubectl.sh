#!/bin/bash
echo "Instalar Kubectl" #https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# https://www.cherryservers.com/blog/install-kubectl-ubuntu
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin

echo "Instalar kustomize"
#https://kubectl.docs.kubernetes.io/installation/kustomize/binaries/
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
mv ./kustomize  /usr/local/bin/kustomize 
export PATH=$PATH:/usr/local/bin/kustomize