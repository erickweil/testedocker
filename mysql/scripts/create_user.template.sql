CREATE USER '${USUARIO}'@'%' IDENTIFIED BY '${SENHA}';
-- https://stackoverflow.com/questions/5988842/can-i-grant-access-to-databases-with-prefix-then-wild-card
GRANT ALL PRIVILEGES ON `${USUARIO}\_%`.* TO '${USUARIO}'@'%';

CREATE DATABASE IF NOT EXISTS ${USUARIO}_banco;
USE ${USUARIO}_banco;

CREATE TABLE exemplo (id INT, name VARCHAR(20), email VARCHAR(20));
INSERT INTO exemplo (id,name,email) VALUES(1,"${USUARIO}","${USUARIO}@abc.com");
INSERT INTO exemplo (id,name,email) VALUES(2,"Exemplo 2","exemplo2@gmail.com");
INSERT INTO exemplo (id,name,email) VALUES(3,"Exemplo 3","exemplo3@yahoo.com");