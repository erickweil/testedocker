# Docker VM

Criar containers docker que funcionam quase idêntico à uma máquina virtual. Com capacidade de executar outros containers docker e programas, apenas dentro do container sem afetar o host.

# Utilização Rápida

## Criar um novo container para um aluno:
Considerando que ao montar um volume docker o mesmo inicia-se vazio, o processo de iniciar o container de um aluno consiste em:

1. Iniciar o novo container com o `docker run`, utilizando o container runtime Sysbox:
2. Executar o script de criação do usuário com `docker exec`
```bash
bash ./novo_container.sh usuario senha 8080 22
```

## Como funciona:

Objetivos:
- Prover a experiência de uma máquina virtual para cada aluno.
- Desacoplar a dependência do aluno com computadores específicos, desenvolver em qualquer lugar e a qualquer hora.
- Eliminar a exigência de um computador/notebook com sistema operacional específico e softwares pré-instalados.
- Permitir subir aplicações online na internet publicamente de forma fácil.

Todos esse objetivos serão atendidos com o uso de um container docker que se comporta como uma máquina virtual para cada aluno, contendo o Code-Server, o VSCode direto do navegador.

Existem imagens docker do code-server ([codercom/code-server:latest](https://coder.com/docs/code-server/latest/install#docker) ou [linuxserver/code-server](https://hub.docker.com/r/linuxserver/code-server)) porém estas imagens docker possuem pouco ou quase nenhum software pré-instalado, e considerando as necessidades específicas deste cenário foi preciso a criação de uma imagem Docker própria.

> Pode-se perguntar: Mas e porquê utilizar containers docker e não criar logo uma Máquina virtual para cada um? A vantagem de containers docker é que os recursos de memória, cpu e armazenamento serão compartilhados quase como numa internet banda larga a banda é compartilhada, não é necessário possuir todos os recursos previstos pré-reservados, apenas os recursos que se tornarem realmente necessários pelo uso. Leitura relacionada: https://blog.nestybox.com/2020/09/23/perf-comparison.html

## Imagem Docker

O arquivo Dockerfile e scripts necessários desta imagem Docker estão disponíveis no diretório docker-vm do repositório: https://github.com/erickweil/testedocker/tree/main/docker-vm

A imagem Docker Base, com usuário admin:admin está publicada no DockerHub [container-vm](https://hub.docker.com/r/erickweil/container-vm)

A imagem basicamente constrói um ambiente que imita uma máquina virtual, contendo vários utilitários de linha de comando (nano, ping, nslookup, curl, wget, etc...), systemd para gerenciar os serviços, um servidor ssh, instalação code-server via script, e programas que são comumentes utilizados no desenvolvimento (docker, git, node, python3).

## Sysbox

Para subir um container docker dentro do docker, é necessário executá-lo com a flag `--privileged`, o que abre uma série de [brechas de segurança](https://www.trendmicro.com/pt_br/research/19/l/why-running-a-privileged-container-in-docker-is-a-bad-idea.html), portanto seguindo algumas recomendações desta postagem de um blog que os próprios desenvolvedores do docker:dind sugerem ( https://github.com/jpetazzo/dind -> http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/ ) chega-se à solução [Sysbox](http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/).

O Sysbox é um **container runtime** open-source e gratuito que melhora containers por prover maior isolamento e permitindo executar softwares à nível de sistema (Como docker) sem a necessidade da flag `--privileged`, eliminando então parte dos problemas de segurança e garantindo maior simplicidade no processo como um todo.

Qualquer imagem docker pode ser executada neste container runtime, o que muda é apenas como o container se comporta. Não há nada de especial a não ser a necessidade de instalar o Sysbox na máquina host e passar a opção `--runtime=sysbox-runc` ao executar o container.

> É importante notar que a instalação do Sysbox exige o **Shiftfs** instalado caso o kernel do linux seja menor que 5.19 (uname -a para ver a versão do kernel). Veja: [https://github.com/nestybox/sysbox/blob/master/docs/distro-compat.md](https://github.com/nestybox/sysbox/blob/master/docs/distro-compat.md) - A solução para isso é ou fazer upgrade do kernel ou utilizar uma distribuição mais recente (O Ubuntu Lunar Lobster já está no kernel 6.2)

