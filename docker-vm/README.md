# Docker VM

Criar containers docker que funcionam quase idêntico à uma máquina virtual. Com capacidade de executar outros containers docker e programas, apenas dentro do container sem afetar o host.

## Como funciona:

Isso é possível graças ao container runtime [Sysbox](https://github.com/nestybox/sysbox) que permite, como eles mesmos definem, iniciar 'system containers', containers que funcionam quase como uma máquina virtual.

Neste repositório há o Dockerfile base que instala os programas necessários

## Programas

- Systemd (Gerenciador de serviços)
- sshd (Servidor SSH)
- Docker