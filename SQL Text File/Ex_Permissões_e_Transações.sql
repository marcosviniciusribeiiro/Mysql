-- Lista de Exercícios sobre Permissões e Transações
DROP DATABASE IF EXISTS VendaIngressosDB;

CREATE DATABASE IF NOT EXISTS VendaIngressosDB;
USE VendaIngressosDB;
CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    perfil ENUM('admin', 'financeiro', 'vendedor', 'cliente') NOT NULL
);

CREATE TABLE Eventos (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    nome_evento VARCHAR(150),
    artista VARCHAR(100),
    data_evento DATE,
    local VARCHAR(100)
);

CREATE TABLE Ingressos (
    id_ingresso INT AUTO_INCREMENT PRIMARY KEY,
    id_evento INT,
    tipo VARCHAR(50),
    preco DECIMAL(8,2),
    disponivel BOOLEAN,
    FOREIGN KEY (id_evento) REFERENCES Eventos(id_evento)
);

CREATE TABLE Vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    id_ingresso INT,
    data_venda DATETIME,
    quantidade INT,
    total DECIMAL(10,2),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_ingresso) REFERENCES Ingressos(id_ingresso)
);
-- Usuários
INSERT INTO Usuarios (nome, email, perfil) VALUES
('Ana Silva', 'ana.silva@email.com', 'admin'),
('Carlos Souza', 'c.souza@email.com', 'vendedor'),
('Juliana Ramos', 'juliana.r@email.com', 'financeiro'),
('Diego Martins', 'diego@email.com', 'cliente'),
('Fernanda Torres', 'fernanda@email.com', 'cliente'),
('Lucas Prado', 'lucas@email.com', 'cliente'),
('Mariana Lopes', 'mariana@email.com', 'vendedor'),
('Bruno Rocha', 'bruno@email.com', 'cliente'),
('Paula Mendes', 'paula@email.com', 'financeiro'),
('Ricardo Lima', 'ricardo@email.com', 'cliente');

-- Eventos
INSERT INTO Eventos (nome_evento, artista, data_evento, local) VALUES
('Turnê The Eras Tour', 'Taylor Swift', '2025-08-15', 'Allianz Parque - SP'),
('World Tour 2025', 'Coldplay', '2025-09-20', 'Estádio do Morumbi'),
('Ao Vivo no Brasil', 'Ed Sheeran', '2025-10-10', 'Arena BRB Mané Garrincha'),
('Reunião de Banda', 'RBD', '2025-07-25', 'Mineirão - BH'),
('Festival Rock in Rio', 'Foo Fighters', '2025-09-01', 'Parque Olímpico - RJ'),
('Baile da Favorita', 'Ludmilla', '2025-06-22', 'Fundição Progresso'),
('Pagode Retrô', 'Sorriso Maroto', '2025-11-05', 'Espaço das Américas'),
('Clássicos Sertanejos', 'Jorge & Mateus', '2025-12-12', 'Villa Mix - GO'),
('Show do Século', 'Beyoncé', '2025-10-28', 'Estádio Beira-Rio - POA'),
('Carnaval Fora de Época', 'Ivete Sangalo', '2025-11-15', 'Avenida Paulista - SP');

-- Ingressos
INSERT INTO Ingressos (id_evento, tipo, preco, disponivel) VALUES
(1, 'Pista Premium', 850.00, TRUE),
(1, 'Cadeira Inferior', 500.00, TRUE),
(2, 'Pista', 650.00, TRUE),
(3, 'VIP', 1200.00, TRUE),
(4, 'Arquibancada', 300.00, TRUE),
(5, 'Pista Comum', 400.00, TRUE),
(6, 'Área Open Bar', 900.00, TRUE),
(7, 'Mesa para 4', 1600.00, TRUE),
(8, 'Pista', 450.00, TRUE),
(9, 'Camarote', 2000.00, TRUE);

-- Vendas
INSERT INTO Vendas (id_usuario, id_ingresso, data_venda, quantidade, total) VALUES
(4, 1, '2025-04-01 14:30:00', 2, 1700.00),
(5, 3, '2025-04-02 10:00:00', 1, 650.00),
(6, 6, '2025-04-03 16:45:00', 2, 800.00),
(8, 9, '2025-04-04 18:20:00', 1, 2000.00),
(10, 2, '2025-04-05 12:10:00', 1, 500.00),
(4, 5, '2025-04-06 11:00:00', 3, 1200.00),
(7, 7, '2025-04-06 13:15:00', 1, 1600.00),
(6, 8, '2025-04-07 15:00:00', 2, 900.00),
(9, 4, '2025-04-07 17:50:00', 1, 1200.00),
(5, 10, '2025-04-08 09:45:00', 2, 4000.00);

-- Exercícios
-- 🔐 Permissões e Gerenciamento de Usuários (GRANT, REVOKE, CREATE USER)
/*1.	Crie um usuário vendedor1 que possa visualizar eventos e registrar vendas, mas não possa acessar dados de usuários ou alterar qualquer estrutura do banco.*/
create user vendedor1@'127.0.0.1' identified by 'senha1369';

grant select on vendaingressosdb.eventos  to vendedor1@'127.0.0.1';
grant insert on vendaingressosdb.vendas to vendedor1@'127.0.0.1';
        
/*2.	Revogue a permissão de INSERT do usuário vendedor1 no banco VendaIngressosDB.*/
revoke insert on vendaingressosdb.vendas from vendedor1@'127.0.0.1';  

/*3.	Conceda permissão total sobre o banco VendaIngressosDB ao usuário admin_eventos e permita que ele também possa conceder essas permissões a outros usuários.*/
create user admin_eventos@'127.0.0.1' identified by 'senha54321';

grant all privileges on vendaingressosdb.* to admin_eventos@'127.0.0.1' with grant option;

/*4.	Crie dois usuários, caixa_manha e caixa_tarde, com acesso somente à tabela Vendas, permitindo apenas SELECT e INSERT.*/
create user caixa_manha@'127.0.0.1' identified by 'senha9876';
create user caixa_tarde@'127.0.0.1' identified by 'senha6443';

grant select, insert on vendaingressosdb.vendas to caixa_manha@'127.0.0.1';
grant select, insert on vendaingressosdb.vendas to caixa_tarde@'127.0.0.1';

/*5.	Utilize o comando SHOW GRANTS para listar as permissões do usuário caixa_tarde e comente os resultados.*/
show grants for caixa_tarde@'127.0.0.1';

-- o usuario caixa_tarde possui permissoes para realizar select e insert somente na tabela vendas do banco de dados vendaingressosDB

/*6.	Crie um usuário auditor que tenha apenas permissão de leitura (SELECT) em todas as tabelas do banco VendaIngressosDB.*/
create user auditor@'127.0.0.1' identified by 'senha96533';

grant select on vendaingressosdb.* to auditor@'127.0.0.1';

show grants for auditor@'127.0.0.1';

/*7.	Renomeie o usuário caixa_manha para caixa_turno1 sem alterar o host.*/
rename user caixa_manha@'127.0.0.1' to caixa_turno1@'127.0.0.1';
rename user caixa_tarde@'127.0.0.1' to caixa_turno2@'127.0.0.1';

/*8.	Remova o usuário auditor do sistema de forma segura.*/
drop user if exists auditor@'127.0.0.1';

-- 🔄 Transações (START TRANSACTION, COMMIT, ROLLBACK, SAVEPOINT)
/*9.	Implemente uma transação que registre a venda de um ingresso, atualize o status do ingresso para indisponível e registre o pagamento.
 Em caso de erro na atualização, use ROLLBACK.*/
start transaction;

 insert into Vendas (id_usuario, id_ingresso, data_venda, quantidade, total)
 values (8, 5, now(), 1, 300.00);

savepoint depois_da_venda;

 update Ingressos
  set disponivel = false 
  where id_ingresso = 5;

rollback to depois_da_venda;

commit;


/*10.	Crie um cenário em que uma transação realiza a venda de dois ingressos, define um SAVEPOINT após a primeira venda e, em caso de falha na segunda, faz ROLLBACK parcial.*/
start transaction;
 
 insert into vendas (id_usuario, id_ingresso, data_venda, quantidade, total)
 values (4, 1, now(), 1, 850.00);

 update ingressos
  set disponivel = false
  where id_ingresso = 1;

savepoint depois_da_venda;

 insert into vendas (id_usuario, id_ingresso, data_venda, quantidade, total)
 values (8, 7, now(), 1, 900.00);

 update ingressos
  set disponivel = false
  where id_ingresso = 7;

rollback to depois_da_venda;

commit;

/*11.	Escreva uma transação que insere uma venda e depois, por engano, remove todos os ingressos. Use ROLLBACK para reverter a operação.*/
start transaction;
 
 insert into Vendas (id_usuario, id_ingresso, data_venda, quantidade, total)
 values(10, 2, now(), 1, 500.00);
 
 delete from Ingressos;

rollback;