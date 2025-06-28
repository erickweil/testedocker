# Docker Compose

Você já imaginou como seria ótimo poder gerenciar todos os serviços e dependências de um aplicativo complexo, com vários contêineres Docker, de forma fácil e rápida? Isso é exatamente o que o Docker Compose permite fazer! Com essa ferramenta incrível, você pode definir as configurações dos seus contêineres em um arquivo YAML (.yml) simples e intuitivo. 

Você define todas as configurações e dependências do seu aplicativo em um único arquivo YAML. Em vez de digitar uma série de comandos complicados, basta executar `docker compose up` para iniciar e `docker compose down` para parar todos os containers. Isso simplifica bastante o processo e torna a utilização do Docker mais amigável, especialmente para aplicações que exigem vários contêineres interconectados.

## Entendendo o Docker Compose

Bom, pode até parecer complexo ficar escrevendo arquivos .yml ao invés de comandos, mas a ideia é que tudo fique mais fácil, e não mais difícil...

A ideia do docker compose é **substituir os comandos docker**. Uma vez construído o arquivo **docker-compose.yml** Diga adeus aos comandos docker build, docker network create, docker volume create, docker run, etc... 

Primeiro, vamos ao exemplo mais simples possível, executar um container de um site simples expondo a porta 3000 para acessá-lo, (veja o diretório [./nginx-simples/](./nginx-simples/))
```bash
cd nginx-simples
docker build -t nginx-simples .
docker run -d -p 3000:80 --name nginxhtml nginx-simples
```

Veja como fica no Docker Compose:

[./nginx-simples/docker-compose.yml](./nginx-simples/docker-compose.yml)
```yml
services:
  nginxhtml:
    build: .
    ports:
      - 3000:80
```

Agora, com o terminal no mesmo diretório deste arquivo basta executar o comando:
```bash
docker-compose up -d
```

Vamos lá então entender cada linha deste arquivo:
- version: (Nao usado mais: https://docs.docker.com/reference/compose-file/version-and-name/) indicava a versão da sintaxe utilizada no arquivo. O Docker Compose possuia diferentes versões, sendo que cada versão pode ter recursos e funcionalidades específicas.
- services: define que containers deseja executar, cada entrada define um container diferente que será criado e executado.
- nginxhtml: É a definição de um container
- build: especifica que irá realizar o build da imagem a partir do Dockerfile que encontra-se no diretório especificado. No caso foi especificado o diretório atual '.' (ponto) 
- ports: É usado para mapear as portas entre o host e o container. Isto permite que a porta 3000 do host seja mapeada para a porta 80 do container. É possível ter várias portas mapeadas

> Neste exemplo, Ao invés do `build: .` poderia ser especificado `image: erickweil/nginx-simples` e dispensaria realizar o build da imagem antes de executar o container pois iria baixar do Docker Hub.

## Vários Containers

A grande vantagem de se utilizar o docker-compose se torna clara quando se utiliza vários containers.

### Exemplo: Site NodeJS conectado com banco de dados MongoDB

> Para os arquivos do projeto abra o diretório [node-aula](./node-aula/)

Vamos ver um exemplo de como é antes e depois de se utilizar o Docker Compose.

O objetivo é executar o projeto no diretório node-aula. porém o mesmo utiliza um banco de dados MongoDB, portanto é necessário primeiro subir um container com um banco de dados e então a aplicação.

### Como é sem usar o docker-compose
Criando o container do banco de dados
```bash
docker network create net-banco
docker volume create vol-banco

docker run -d \
--name meu-banco \
--network net-banco \
-v vol-banco:/data/db \
mongo:4.4.6
```
Veja que foi especificado que o banco de dados necessita do volume `vol-banco` mapeado em /data/db e faz parte da rede `net-banco`. 

Outra coisa importante é que o nome do container é `meu-banco`, containers na mesma rede podem acessálo por este nome ao invés do IP.

Realizando build da imagem e criando container da api
```bash
cd node-aula
docker build -t node-aula .

docker run -d \
-p 3000:3000 \
-e MONGODB_URL='mongodb://meu-banco:27017' \
-e TITULO='Teste usando só o Docker' \
--network net-banco \
node-aula
```
Várias opções foram necessárias e o comando ficou bastante complicado. Imagina ter que fazer isso várias e várias vezes conforme é necessário executar o projeto, dá muito trabalho!

### Como é usando o docker-compose
Usando o Docker Compose, podemos simplificar e automatizar todo esse processo. Basta criar um arquivo chamado docker-compose.yml e definir todos os serviços e suas configurações nele. Veja como ficaria o arquivo para o exemplo anterior:

[./node-aula/docker-compose.yml](./node-aula/docker-compose.yml)
```yml
services:
  meu-banco:
    image: mongo:4.4.6
    volumes:
      - vol-banco:/data/db
  node-aula:
    build: .
    ports:
      - 3000:3000
    environment:
      - MONGODB_URL=mongodb://meu-banco:27017
      - TITULO=Teste Docker Compose
volumes:
  vol-banco:
```

Agora, para iniciar todos os serviços, basta entrar na pasta onde está o arquivo docker-compose.yml (./node-aula) e então executar o comando:
```bash
 docker compose up -d 
``` 

O Docker Compose cuidará de criar a rede, os volumes e os containers conforme as configurações especificadas. Não é incrível como isso simplifica tudo?

> Se quiser parar os containers, basta executar: `docker compose down`

### Entendendo este exemplo, detalhe por detalhe

`muita palavra ruim pouca palavra bom entender melhor`

Vamos lá, a ideia é que tudo o que é feito no **docker run** precisa também ser feito no docker-compose.yml. Por isso ficou um pouco mais elaborado.

- Variáveis de Ambiente: É possível passar variáveis de ambiente para um container, neste exemplo foi utilizado uma variável de ambiente MONGODB_URL para configurar a url de conexão do banco de dados, e a variável TITULO para exibir este título na página.
```yaml
services:
...
  node-aula:
    ...
	environment:
    	- MONGODB_URL=mongodb://meu-banco:27017
    	- TITULO=Teste Docker Compose
...
```

- Volumes: Para que um container possua persistência de dados, é necessário que o diretório dentro do container que deseja manter arquivos salvos seja mapeado em um volume. Isto foi feito no banco de dados, para que não se perca todos os registros a cada reinício do container.
```yml
services:
  meu-banco:
    ...
    volumes:
      - vol-banco:/data/db
...
volumes:
  vol-banco:
```

- build: Quando a imagem do container deve ser construída a partir de um Dockerfile, deve ser especificado pela chave **build** e seu valor deve ser '.' (ponto) quando o Dockerfile está no mesmo diretório ou o caminho para o diretório com o Dockerfile. É como se estivesse executando o comando `docker build -t node-aula .` para criar a imagem
```yml
services:
  ...
  node-aula:
    build: .
...
```

- image: Já se a imagem deve ser baixada do Registry do Docker Hub, se especifica isso pela chave **image** e o nome e tag da imagem assim como estiver descrito no Docker Hub.
```yml
services:
  meu-banco:
    image: mongo:4.4.6
...
```

## Exemplos

> No diretório [docker-compose](./docker-compose/) Há vários exemplos de arquivos docker-compose standalone, isto é, que são auto-contidos, basta executá-los e uma aplicação estará funcionando sem mais problemas. Utilize destes exemplos quando precisar verificar diferentes formas de integrar e gerenciar vários containers

> Para mais exemplos (Em inglês) veja: [https://github.com/docker/awesome-compose](https://github.com/docker/awesome-compose)

