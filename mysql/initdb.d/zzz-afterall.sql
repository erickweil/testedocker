-- Criando usuário e dando permissões
-- https://stackoverflow.com/questions/5988842/can-i-grant-access-to-databases-with-prefix-then-wild-card
-- CREATE USER 'aluno1'@'%' IDENTIFIED BY '12345678';
-- GRANT ALL PRIVILEGES ON `aluno1\_%`.* TO 'aluno1'@'%';

FLUSH PRIVILEGES;

-- Iniciando o banco
