FROM node:alpine

WORKDIR /node-app

ARG PORT=3000
ENV PORT=${PORT}
EXPOSE ${PORT}

# Primeiro instala as dependências
COPY package.json package-lock.json ./

# Utilizar 'npm ci' em vez de 'npm install'
# https://stackoverflow.com/questions/52499617/what-is-the-difference-between-npm-install-and-npm-ci
RUN npm ci

# Depois copia o projeto (Isto torna mais rápido o build devido ao cache)
COPY . .

# Ponto de partida
ENTRYPOINT ["npm","start"]
