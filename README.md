# Containers

Considere uma situação onde você precise executar três aplicações que precisam de uma mesma porta de rede, um servidor Java, um proxy reverso nginx e uma api C#.

Problemas:
- Conflito de portas
- Controle de versões
- Recursos de memória e cpu
- Manutenção
  
### Solução 1: Máquinas físicas

Caso se utilize uma máquina física para cada aplicação, resolveria todos os problemas, já que não haveria conflito de portas de rede, recursos de memória e cpu seriam idependentes.

Mas é muito caro possuir 3 máquinas físicas apenas para executar algumas aplicações.

### Solução 2: Máquina virtual

Utilizando máquinas virtuais é possível que seja simulado um ambiente isolado para cada aplicação apesar de estarem todas na mesma máquina física.

Cada máquina virtual executa um inteiro sistema operacional que demanda certa quantidade de cpu, memória armazenamento mesmo sem nenhuma aplicação executando.

### Solução 3: Container

Isola aplicações sem a necessidade de simular um inteiro sistema operacional e recursos que seriam necessários para ele.

- Porque containers são mais leves?
  
Cada container funciona como um processo, e não uma virtualização completa.

- Como garantem o isolamento?

Namespaces: garante que cada container se isole a nível de processos, rede, memória, comunicação entre processos, sistema de arquivos, e a nível de kernel.

- Como funcionam sem instalar um Sistema Operacional?

O isolamento a nível de kernel (UTS) permite que o container utilize outro kernel isolado diferente daquele do sistema hospedeiro.

- Como fica a divisão de recursos?

Cgroups: define como cada container irá consumir recursos de memória e cpu.

# Instalação do Docker

Para instalar o docker basta visitar a página: https://docs.docker.com/get-docker/ e seguir o passo-a-passo

## Windows

Em sistema windows, será necessário ter instalado o WSL 2 (Windows Subsystem for Linux), que pode ser instalado neste passo-a-passo: https://learn.microsoft.com/en-us/windows/wsl/install

## Validando a instalação do docker

Para verificar que o docker foi instalado corretamente, basta abrir um terminal e executar a imagem 'hello-world' que apenas irá escrever uma mensagem na tela e finalizar a execução.

~~~bash
docker run hello-world
~~~
>~~~
>Unable to find image 'hello-world:latest' locally
>latest: Pulling from library/hello-world
>2db29710123e: Pull complete
>Digest: sha256:18a657d0cc1c7d0678a3fbea8b7eb4918bba25968d3e1b0adebfa71caddbc346
>Status: Downloaded newer image for hello-world:latest
>Hello from Docker!
>This message shows that your installation appears to be working correctly.
>
>To generate this message, Docker took the following steps:
> 1. The Docker client contacted the Docker daemon.
> 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
>    (amd64)
> 3. The Docker daemon created a new container from that image which runs the
>    executable that produces the output you are currently reading.
> 4. The Docker daemon streamed that output to the Docker client, which sent it
>    to your terminal.
>
>To try something more ambitious, you can run an Ubuntu container with:
> $ docker run -it ubuntu bash
>
>Share images, automate workflows, and more with a free Docker ID:
> https://hub.docker.com/
>
>For more examples and ideas, visit:
> https://docs.docker.com/get-started/
>~~~

É importante notar que o docker run executa uma série de etapas:

- Procura a imagem localmente
- Baixa a imagem caso não encontre localmente
- Valida o hash da imagem
- Executa o container

Portanto, ao executar um container de uma imagem que não esteja na sua máquina, o docker run realiza o download desta imagem de um repositório de imagens, o **docker hub**

# Docker Hub

Como o docker sabe onde deve procurar os nomes das imagens, como por exemplo, de onde veio o nome 'hello-world'?

O docker hub acessível pelo link: https://hub.docker.com/ contém imagens oficiais e também produzidas pela comunidade.

> É importante notar que imagens não oficiais, isto é, mantidas por alguém que não é uma empresa reconhecida pode muito bem enviar imagens com código malicioso. Portanto se limite a utilizar imagens de container que sejam validadas como imagens 'oficiais' e assim garantirá a segurança de seu uso.

## Executando uma imagem

No docker hub há uma miríade de imagens que você pode escolher para utilizar, entre elas há uma imagem do ubuntu, que permite iniciar um container com o sistema operacional ubuntu (Não é uma máquina virtual).

Veja como é fácil executar a imagem do ubuntu:

~~~bash
docker run -it ubuntu bash
~~~
>root@98b150cadea1:/#

Veja que após baixar e subir o container, o terminal mudou para um terminal do linux ubuntu. A opção -it que permite que isso aconteça, onde que é iniciado o container de forma interativa. 

A opção -i mantém a entrada de dados aberta e a opção -t aloca um terminal interativo para executar comandos no container

Em outro terminal podemos verificar que containers estão executando com o comando `docker ps`

~~~bash
docker ps
~~~
>~~~
>C:\Users\erick>docker ps
>CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS         PORTS     NAMES
>98b150cadea1   ubuntu    "bash"    2 minutes ago   Up 2 minutes             >priceless_einstein
>~~~~

O docker ps sem nenhum argumento apenas exibe imagens que estão executando neste momento, veja que cada container contém algumas colunas na listagem

- CONTAINER ID

Identificador único do container, é este valor que você utilizará nos comandos para parar ou reiniciar.

- IMAGE

O nome da imagem que foi utilizada como base para este container

- COMMAND

o comando que este container executou ao iniciar

- NAMES

Nome aleatório gerado automaticamente pelo docker quando o container é criado sem a opção --name

## Criação de um container

É interessante notar que um container ficará ativo apenas enquanto um processo estiver sendo executado, por exemplo caso executar um comando que faz com que o container faça uma tarefa por algum tempo e então termine, assim que não houver nenhum processo em execução no container ele irá finalizar sua execução.

~~~bash
docker run ubuntu sleep 10
~~~

O comando acima irá criar e executar um container com a imagem do ubuntu executando o comando 'sleep 10' que espera 10 segundos e então finaliza. Veja que ao executar o docker ps, não será exibido este container, já que ele finalizou a sua execução

Para ver todos os containers, inclusive os que não estão executando é necessário passar a opção -a no `docker ps`

~~~bash
C:\Users\erick>docker ps -a
~~~
>~~~
>CONTAINER ID   IMAGE         COMMAND      CREATED          STATUS                      PORTS     NAMES
>a90c9871f67a   ubuntu        "sleep 10"   30 seconds ago   Exited (0) 19 seconds ago             peaceful_allen
>98b150cadea1   ubuntu        "bash"       15 minutes ago   Up 15 minutes                         priceless_einstein
>6013b1ee8f4e   hello-world   "/hello"     22 minutes ago   Exited (0) 22 minutes ago             awesome_hertz
>~~~

Observe que o container da imagem ubuntu que foi executado com o comando 'sleep' executou por 10 segundos e então 'morreu', este comportamento é o padrão de containers: **é necessário pelo menos 1 processo ativo para que o container continue em execução.**

## Gerenciando containers

- Criando um container

    O comando `docker run` permite criar um container a partir de uma imagem, que se não estiver disponível localmente será automaticamente baixada do DockerHub.

    ~~~bash
    docker run nome-da-imagem comando
    ~~~

    Há alguns argumentos que podem ser passados ao docker run:
    ~~~bash
    -d # Detached, por padrão um container trava o terminal durante sua execução, mas com a opção detached, este container continuará a execução em background
    -p 8080:80 # Mapeamento de portas, controla que portas serão redirecionadas, neste caso 8080 no host irá para a porta 80 no container
    
    -t # Aloca um terminal tty para o container
    -i # Mantém a entrada de dados aberta para enviar comandos pelo terminal
    # (Quando se deseja utilizar o container como um terminal interativo deve especificar tanto a opção -t como a -i)

    --name nome-do-container # Especifica um nome para o container (Por padrão é gerado um aleatório)

    --rm # Automaticamente remove o container quando ele terminar a execução

    -e "chave=valor" # Atribui um valor à variáveis de ambiente.
    ~~~

- Parando containers
  
    É possível parar a execução de um container de forma forçada, onde que você utiliza o nome do container ou o seu ID.

    Para parar o container que foi executado anteriormente:

    ~~~bash
    docker stop priceless_einstein
    ~~~

    >Este comando espera por padrão até 10 segundos para que o container pare, se quiser que ele pare imediatamente especifique a opção `t=0`

- Reiniciando containers
  
    O docker run **cria um novo container** com a imagem especificada, mas caso queira reiniciar um container que já foi criado, é necessário apenas executar o comando `docker start`

    ~~~bash
    docker start priceless_einstein
    ~~~

    >Obs: O container deverá possuir um processo em execução para continuar ativo

- Executando comandos em um container

    É possível executar comandos em containers que estiverem ativos, iniciando um novo processo no container (Se está ativo é porque possui pelo menos 1 processo ativo)

    Vamos entrar no container que foi iniciado com o start anteriormente:

    ~~~bash
    docker exec -it priceless_einstein bash
    ~~~

    Veja caso se execute o comando top dentro do terminal do container, há dois processos bash, o processo atual do exec e o que estava sendo executado quando realizou o 'start'

- Pausando / Despausando containers

    É possível pausar a execução de um container, sem parar os processos apenas colocando o container e seus processos em um tipo de hibernação

    Pausando o container
    ~~~bash
    docker pause priceless_einstein
    ~~~

    Voltando a execução do container
    ~~~bash
    docker unpause priceless_einstein
    ~~~

- Removendo um container

    Caso não for utilizar um container mais, é interessante removê-lo para limpar espaço de disco:

    ~~~bash
    docker container rm priceless_einstein
    ~~~

    Isso apagará qualquer modificação feita no container, como arquivos criados, programas que foram instalados, etc...

    É possível que o container não seja removido, por exemplo se ele ainda estiver em execução, se este for o caso pode ser especificada a opção --force para forçar sua remoção:

    ~~~bash
    docker container rm priceless_einstein --force
    ~~~

    >Obs: isto remove apenas o CONTAINER e não a imagem.

    Utilizando de recursos do terminal bash do linux é possível remover todas os containers com um único comando:
    ~~~bash
    docker container rm $(docker container ls -aq)
    ~~~
- Listando Imagens

    É possível listar as imagens que estão baixadas com o `images`

    ~~~bash
    docker images
    ~~~
    >~~~
    >REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
    >nginx         latest    51086ed63d8c   8 days ago      142MB
    >ubuntu        latest    216c552ea5ba   8 days ago      77.8MB
    >hello-world   latest    feb5d9fea6a5   12 months ago   13.3kB
    >~~~

- Removendo Imagens
    
    Para apagar uma imagem do disco, se utiliza o comando `docker rmi`

    ~~~bash
    docker rmi hello-world
    ~~~

    > Obs: só será possível remover uma imagem se ela não estiver sendo utilizada por nenhum container, esteja ele em execução ou não.
# Mapeamento de Portas

Caso inicie um container que funciona com um servidor que espere conexões em uma porta TCP ou UDP, é necessário que seja mapeado as portas deste container, já que os containers são isolados em nível de rede, fazendo com que seja necessário um mapeamento explícito de portas para que o mesmo seja acessível. 

## Acessando um container com Servidor Web

Para exemplificar a configuração necessária para um container que espera conexões, vamos baixar e executar um container com a imagem do nginx, um servidor proxy reverso e também serve páginas estáticas.

~~~bash
docker run -d nginx
~~~

> Obs: A opção `-d` permite que o container continue em execução em background (detached), não bloqueando o terminal que foi usado para executá-lo.

Este container está em execução mas está inacessível, já que a porta 80 que ele espera conexões está dentro do container mas não é visível pelo sistema.

Para ser possível acessar o container na máquina, é necessário mapear esta porta. com a opção -p ao realizar o run ou start.

~~~bash
docker container rm 344cffba6f05 --force
~~~
> A opção --force remove o container mesmo que ele esteja em execução

### Mapeando portas

Agora vamos mapear a porta 80 do container para a porta 8080 da máquina host.
~~~bash
docker run -d -p 8080:80 nginx
~~~

É possível ver os mapeamentos de um container específico com o comando `docker port`

~~~bash
docker port 239d6a387edd
~~~
>80/tcp -> 0.0.0.0:8080

# Imagens

- Como imagens funcionam?
  
    Imagens são conjuntos de camadas, cada camada contém um ID e são idependentes. 
    É possível visualizar exatamente essas camadas com o comando `docker history`

    ~~~bash
    docker history nginx
    ~~~
    >~~~
    >IMAGE          CREATED      CREATED BY                                      SIZE      COMMENT
    >51086ed63d8c   8 days ago   /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B
    ><missing>      8 days ago   /bin/sh -c #(nop)  STOPSIGNAL SIGQUIT           0B
    ><missing>      8 days ago   /bin/sh -c #(nop)  EXPOSE 80                    0B
    ><missing>      8 days ago   /bin/sh -c #(nop)  ENTRYPOINT ["/docker-entr…   0B
    ><missing>      8 days ago   /bin/sh -c #(nop) COPY file:09a214a3e07c919a…   4.61kB
    ><missing>      8 days ago   /bin/sh -c #(nop) COPY file:0fd5fca330dcd6a7…   1.04kB
    ><missing>      8 days ago   /bin/sh -c #(nop) COPY file:0b866ff3fc1ef5b0…   1.96kB
    ><missing>      8 days ago   /bin/sh -c #(nop) COPY file:65504f71f5855ca0…   1.2kB
    ><missing>      8 days ago   /bin/sh -c set -x     && addgroup --system -…   61.1MB
    ><missing>      8 days ago   /bin/sh -c #(nop)  ENV PKG_RELEASE=1~bullseye   0B
    ><missing>      8 days ago   /bin/sh -c #(nop)  ENV NJS_VERSION=0.7.6        0B
    ><missing>      8 days ago   /bin/sh -c #(nop)  ENV NGINX_VERSION=1.23.1     0B
    ><missing>      8 days ago   /bin/sh -c #(nop)  LABEL maintainer=NGINX Do…   0B
    ><missing>      8 days ago   /bin/sh -c #(nop)  CMD ["bash"]                 0B
    ><missing>      8 days ago   /bin/sh -c #(nop) ADD file:b78b777208be08edd…   80.5MB
    >~~~

    Inclusive, o docker é capaz de re-utilizar camadas que existam em mais de uma imagem baixada, não ocupando espaço em disco ou tráfego de rede desnecessário.

    Porém as camadas de uma imagem são de apenas-leitura, quando você realiza alterações em um container de uma imagem, é como uma nova camada **que permite leitura e escrita** que é adicionada na pilha de camadas da imagem. Por isso o espaço em disco que um container ocupa não depende do tamanho da imagem e sim da quantidade de modificações que foi realizada na camada R/W do container.

    Ao se remover um container com o comando docker rm, apenas a camada de modificações do container que é apagada. Perdendo as modificações feitas pelo container. Além disso, como cada container possui a sua camada, é possível possuir vários containers de uma mesma imagem e não irão ocupar muito espaço em disco nem mesmo poderão afetar um ao outro.

- Como criar uma imagem?

    Para se criar uma imagem docker é necessário um arquivo chamado 'Dockerfile'

## Dockerfile

O dockerfile é um arquivo que contém as informações necessárias para criar uma imagem. Para exemplificar o processo de criação de uma imagem, considere um cenário onde se deseja criar a imagem de uma aplicação NodeJs que funcionará como um servidor na porta 8092

Veja o conteúdo do arquivo Dockerfile
~~~dockerfile
FROM node:18
WORKDIR /app-node
ARG PORT_BUILD=8092
ENV PORT=$PORT_BUILD
EXPOSE $PORT_BUILD
COPY . .
RUN npm install
ENTRYPOINT npm start
~~~

- FROM
    
    O Docker executa instruções em uma Dockerfile na ordem de definição. A Dockerfile deve começar com uma instrução FROM. 

    A instrução FROM especifica a imagem pai da qual você está construindo. FROM só pode ser precedido por uma ou mais instruções ARG, que declaram argumentos que são usados ​​em linhas FROM no arquivo Dockerfile.

    No caso foi especificado o valor `node:18`, que informa que esta imagem será construída como uma camada partindo da imagem node versão 18.

    >Talvez você imagine que criar uma imagem seria necessário partir de um sistema operacional como por exemplo Ubuntu e então executar a instalação da aplicação e por último incluir a sua aplicação. Apesar de possível, isso não é necessário, grande parte das aplicações possuem imagens oficiais no Docker Hub, como é o caso do NodeJS, onde que é possível partir da imagem do NodeJS para incluir a sua aplicação.

- WORKDIR

    A instrução WORKDIR define o diretório de trabalho para qualquer instrução após ele (RUN, CMD, ENTRYPOINT, COPY e ADD). Se o diretório não existir, ele será criado mesmo que não seja usado em nenhuma instrução Dockerfile subsequente.

    A instrução WORKDIR pode ser usada várias vezes em um arquivo Dockerfile. Se um caminho relativo for fornecido, ele será relativo ao caminho da instrução WORKDIR anterior.

    As instruções WORKDIR podem receber variáveis de ambiente setadas utilizando ENV.

    Se o WORKDIR não for especificado o padrão é que todos os comandos iriam ser executados no diretório root: /

- ARG

    A instrução ARG define uma variável que pode ser utilizada em tempo de build e que pode ser substituída ao executar o comando docker build, onde que o valor informado no Dockerfile é apenas o valor padrão quando não é especificada.

    Um Dockerfile pode conter várias instruções ARG

    > O comando docker history irá exibir qualquer valor passado pela instrução ARG, portanto não utilize-a para passar chaves ou outros valores que devem se manter secretos.

- ENV

    A instrução ENV é uma variável de ambiente que será acessível na imagem após a build, e sua definição substitui o valor de qualquer ARG do mesmo nome.

    Basicamente deve ser utilizado ENV quando se deseja que o container tenha acesso à variável de ambiente, a instrução ARG carrega variáveis apenas no momento de build da imagem, enquanto a instrução ENV carrega variáveis que serão utilizadas no container.

- EXPOSE

    A instrução EXPOSE informa o docker que o container irá escutar nesta porta durante a execução. O padrão é que a porta é TCP, caso deseja especificar que é UDP é necessário informar com /udp, por exemplo escutar a porta 8080 UDP fica assim: `EXPOSE 8080/udp`

    > Apenas funciona como uma espécie de documentação do container, sendo necessário ainda o mapeamento da porta com o argumento -p ao executar um container da imagem.
- COPY

    Utilização: `COPY origem destino`

    Copia arquivos ou diretórios em `origem` no seu build e adiciona eles à imagem no caminho especificado em `destino`

    Quando especificado o valor `.` copia o diretório atual, onde que no caso da imagem pode ser afetado pelo WORKDIR.

- RUN

    Irá executar qualquer comando em uma nova camada ao topo da imagem e salva os resultados na imagem, onde que serão utilizados nas próximas etapas do Dockerfile.

    A instrução RUN é executado em tempo de build, ou seja, as modificações feitas no RUN serão salvas na imagem resultante e não será executado quando subir o container.

    É possível possuir vários comandos RUN criando cada um uma camada.

- ENTRYPOINT

    Permite configurar o container que será executado, especificando o comando que será executado ao **subir o container**.

> Veja https://docs.docker.com/engine/reference/builder/ para todas as instruções que podem ser utilizadas no Dockerfile

## Realizando o **build** da imagem

Uma vez que o Dockerfile estiver feito, é necessário construir a imagem, realizando o `docker build`, Onde que todas as instruções no arquivo Dockerfile serão executadas para gerar uma imagem com a sua aplicação.

> Caso tenha especificado argumentos ARG em seu Dockerfile, é no `docker build` que estes poderão ser passados.

Em um terminal aberto no mesmo diretório onde se encontra o projeto e o arquivo Dockerfile, basta executar o comando a seguir e a imagem será construída:

~~~bash
docker build -t erickweil/mural:latest .
~~~

Agora ao executar o comando `docker images` é exibido na listagem a imagem:
~~~
REPOSITORY        TAG       IMAGE ID       CREATED         SIZE
erickweil/mural   latest    764a38823659   20 hours ago    1.04GB
nginx             latest    51086ed63d8c   9 days ago      142MB
ubuntu            latest    216c552ea5ba   9 days ago      77.8MB
hello-world       latest    feb5d9fea6a5   12 months ago   13.3kB
~~~

> Se quiser executar a imagem recém-criada basta executar o comando `docker run` com o nome da sua imagem.

## Publicando a imagem no DockerHub

Como vimos anteriormente, o DockerHub é um repositório de imagens para que imagens sejam baixadas e executadas de forma análoga a um `apt-get install`. 

É perfeitamente possível que você crie a sua própria imagem e publique-a no DockerHub. Fazer isso requer apenas um cadastro gratuito na plataforma.

### Passo-a-Passo publicar uma imagem no DockerHub
1. Cadastro: Realize o cadastro no DockerHub (https://hub.docker.com/) e confirme o e-mail.
2. Autenticar sua conta pelo terminal

    execute o comando `docker login` para que seja autenticado na sua conta. Veja abaixo como um usuário criado com o id 'erickweil' faria login:
    ~~~bash
    docker login -u erickweil
    ~~~
2. Renomeie a imagem para conter o prefixo de seu usuário

    Para ser possível realizar o push da imagem, a mesma deve estar criada em sua máquina de forma a conter o exato nome de usuário como prefixo do nome da imagem. Por exemplo, se seu nome de usuário no DockerHub é **erickweil** então o nome da imagem deve ser **erickweil/mural**

    Para criar uma imagem com outro nome a partir de uma existente, se utiliza o comando docker tag:
    ~~~bash
    docker tag nome-errado:versao erickweil/mural:versao
    ~~~

    Basicamente é criada uma outra entrada com os mesmos arquivos de camadas de imagem porém com outro nome, utilizar o docker tag não irá ocupar mais espaço em disco já que não duplica as **camadas**, apenas cria uma nova referência com outro nome aos mesmos arquivos da imagem.

    > Os nomes das imagens podem conter um número de versão, também chamado de **tag**, que se omitido é por padrão `latest`, que significa 'última versão'
3. Realize o **push** da imagem
    Agora, com o nome da imagem contendo o prefixo de seu nome de usuário do DockerHub, basta executar o comando `docker push`
    ~~~bash
    docker push erickweil/mural:latest
    ~~~

    >~~~
    >C:\Users\erick>docker push erickweil/mural:latest
    >The push refers to repository [docker.io/erickweil/mural]
    >0344e4c12994: Pushed
    >f89da93c4ce7: Pushed
    >7512a3717c1b: Pushed
    >73ebbf1d1978: Mounted from library/node
    >40eaad54c8b1: Mounted from library/node
    >7b882706e16e: Mounted from library/node
    >ff5b3ba76c67: Mounted from library/node
    >75ba02937496: Mounted from library/node
    >288cf3a46e32: Mounted from library/node
    >186da837555d: Mounted from library/node
    >955c9335e041: Mounted from library/node
    >8e079fee2186: Mounted from library/node
    >latest: digest: sha256:fe47fa87370ac913babbec250eddf03aaf9958495ebc8fd3edcc217168c9e8d6 size: 2846
    >~~~

    >Veja que foram enviadas apenas as camadas que foram construídas após as camadas do node, já que as camadas do node já existem no DockerHub não foi preciso enviá-las.
4. Agora no DockerHub, ao entra na listagem da aba **Repositories**, pode visualizar suas imagens enviadas.


# Laboratório #1 - criando imagem site estático HTML/CSS/JS

Para demonstrar um outro cenário comum no desenvolvimento de aplicações e a utilização de containers, vamos desde o início ao fim no processo de containerizar uma aplicação que consiste em um site estático apenas com HTML/CSS/JS.

Para que o exemplo seja simples, a aplicação consistirá de um único arquivo index.html com todo o código para exibir uma página simples.

## Primeiro passo, Construindo a aplicação

Em um diretório vazio, será criado um arquivo index.html com o seguinte código HTML/CSS

`index.html`
~~~html
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="pragma" content="no-cache">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página Exemplo</title>
</head>
<body style="background-color: cadetblue;color:white">
    <div class="regionMain">
    <main class="main">
        <div>
            <h1 style="margin: auto;text-align: center; padding-top: 100px;">DOCKER</h1>
        </div>
        <div>
            <section>
                <h2 style="margin: auto;text-align: center; padding: 200px;">Página testando o funcionamento de containers no docker.</h2>
            </section>
        </div> 
    </main>
    </div>
</body>
</html>
~~~

## Escrevendo o arquivo Dockerfile

Para montar a imagem e que seja possível executar este site como um container, é necesário que esteja por trás de um servidor web que responderá a solicitações HTTP.

Poderíamos utilizar qualquer servidor web, mas o nginx é um servidor bastante robusto e que é fácil de configurar para funcionar como um container.

Portanto, a imagem será construída como camadas acima da imagem do **nginx**.

~~~dockerfile
FROM nginx:latest
COPY . /usr/share/nginx/html
~~~

O arquivo Dockerfile ficou tão simples! isto é porque muitas diretivas a própria imagem nginx já define. Por exemplo o Entrypoint será o mesmo, isto é, quando o container de nossa imagem for executado o comando será o mesmo que seria executado em um container de uma imagem do nginx oficial.

Basicamente, com este arquivo Dockerfile estamos incluindo os documentos HTML no diretório que o nginx irá utilizar como origem para servir as páginas. Nenhuma outra configuração é necessária.

## Construindo a imagem

Agora, basta executar o comando abaixo para construir a imagem de acordo com o definido no Dockerfile

~~~bash
docker build -t erickweil/nginx-simples:latest .
~~~

> a opção -t especifica o nome da imagem que será criada, se planeja publicá-la no DockerHub lembre-se de especificar o seu nome de usuário do DockerHub como prefixo do nome da imagem.

## Executando um container da imagem

Agora, basta executar um container para esta imagem, lembrando é claro de mapear a porta 80 que é a porta do protocolo HTTP que o nginx espera conexões.

~~~bash
docker run -d -p 80:80 --name nginxhtml erickweil/nginx-simples   
~~~

Muito bem! agora basta visualizar o site funcionando em http://localhost

# Laboratório #2 - imagem de aplicação python linha de comando

Vamos construir uma imagem que executa um programa em python que escreve em um terminal de forma a imitar a famosa chuva 'digital' do filme Matrix.

É interessante ainda este caso-de-uso já que a funcionalidade de escrever em um terminal com cores não é suportada em sistemas Windows. Portanto containerizar esta aplicação garantirá seu funcionamento em qualquer sistema operacional sem quaisquer modificações no código.

A aplicação em python é a seguinte:

~~~python
from time import sleep
from os import system,name,get_terminal_size
from random import randrange

verdes = ["1;32;40","2;32;40","3;32;40","3;36;40","1;37;102"]

def printVerde(txt,qual):
    verde = verdes[qual]
    return "\x1b[{}m{}\x1b[0m".format(verde,txt)

def limpar():
    print("\033[H")

print("\033[2J")
# Get the size
# of the terminal
size = get_terminal_size()
lines = size.lines
columns = size.columns

letters = [  {} for x in range(int(columns/4))]

for y in range(len(letters)):
    letters[y]["pos_x"] = randrange(0,columns-1)
    letters[y]["pos_y"] = randrange(0,lines-1)
    letters[y]["txt"] = ""

while True:
    limpar()
    entireTerminal = [[" " for y in range(lines-1)] for x in range(columns-1)]
    for column in letters:
        letra = chr(randrange(33, 127))

        if randrange(0,lines/2) != 0:
            column["txt"] = column["txt"]+letra
        else:
            column["pos_x"] = randrange(0,columns-1)
            column["pos_y"] = randrange(0,lines-1)
            column["txt"] = letra

        pos_x = column["pos_x"]
        pos_y = column["pos_y"]
        for i,c in enumerate(column["txt"]):
            if i == len(column["txt"]) -1:
                formatedChar = printVerde(c,4)
            else:
                formatedChar = printVerde(c,randrange(0,4))
            entireTerminal[pos_x][(pos_y+i)%(lines-2)] = formatedChar
    for x in range(lines-1):
        for y in range(columns-1):
            letra = entireTerminal[y][x]
            print(letra,end="")
        print()
    sleep(0.1)
~~~

Agora, o Dockerfile para a construção desta imagem deve utilizar como base uma imagem capaz de executar um programa python em linha de comando.

Veja como ficou o Dockerfile:

~~~dockerfile
FROM python:3
COPY . /
CMD [ "python", "./matrix.py" ]
~~~

Execução do build da imagem:

~~~bash
docker build -t erickweil/python-matrix .
~~~

Executando o container:

~~~bash
docker run -it --name matrix erickweil/python-matrix
~~~

> Essas imagens estão publicadas no DockerHub com esse nome, então você mesmo pode executar o comando docker run acima e irá funcionar! a imagem será baixada do DockerHub e executada em seu computador.

> ATENÇÃO: NÃO execute qualquer imagem que encontrar no DockerHub, apenas faça-o de fontes conhecidas e/ou que estiverem marcadas como imagens oficiais. É perfeitamente possível que uma imagem disponibilizada no DockerHub contenha malware.