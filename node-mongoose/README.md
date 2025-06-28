# Node + Mongoose

Exemplo projeto com nodejs e mongoose ORM para conectar com MongoDB.

## Executando com docker

```bash
docker compose up -d --build --force-recreate
```

## Executando localmente o projeto:

```bash
npm i
cp .env.example .env # Configure o .env com uma url do banco mongodb válidas
node src/seeds/usuarioSeed.js
npm start
```