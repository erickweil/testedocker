# Mysql Shared

A ideia é prover um ambiente mysql com PHPMyAdmin de forma que usuários possam criar databases e tabelas nessas databases, sem um usuário ser capaz de acessar/deletar a database um do outro

- https://kinsta.com/blog/mariadb-vs-mysql/

Rodar este projeto:

```bash
$ docker network create alunos
$ docker compose up -d
```