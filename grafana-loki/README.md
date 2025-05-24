# Grafana & Loki

A ideia é prover um ambiente de monitoramento e log com Grafana e Loki, utilizando o Docker Compose para facilitar a configuração e o gerenciamento dos serviços.

Containers:
- **Grafana:** Plataforma de visualização e análise de dados.
- **Loki:** Sistema de agregação de logs, projetado para trabalhar em conjunto com o Grafana.
- **Node:** Aplicativo de exemplo para gerar logs.

Como executar:
1. copie o arquivos `.env.example` para `.env` e ajuste as variáveis de ambiente do usuário e senha do loki
2. copie `./grafana/datasources/ds.yaml.example` para `./grafana/datasources/ds.yaml` e ajuste as variáveis do usuário e senha do loki
3. execute `docker-compose up -d --build --force-recreate` para iniciar os serviços
4. acesse o Grafana em `http://localhost:3101` com o usuário e senha padrão admin admin
5. Crie um novo daashboard com o Loki como fonte de dados, e veja os logs da aplicação exemplo Node.js a cada segundo