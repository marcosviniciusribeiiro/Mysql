CREATE DATABASE LojaVirtual;

USE LojaVirtual;

CREATE TABLE Clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);
select * from Clientes;

CREATE TABLE Produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    preco DECIMAL(10,2),
    estoque INT
);
select * from Produtos;

CREATE TABLE Pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);
select * from Pedidos;

CREATE TABLE ItensPedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT,
    produto_id INT,
    quantidade INT,
    preco_unitario DECIMAL(10,2),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);
select * from ItensPedido;

CREATE TABLE LogsPedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    data_pedido DATETIME
);

CREATE TABLE MovimentacoesEstoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT,
    quantidade INT,
    tipo VARCHAR(10), -- 'saida' ou 'entrada'
    data_movimentacao DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE HistoricoPrecos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT,
    preco_antigo DECIMAL(10,2),
    preco_novo DECIMAL(10,2),
    data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE BoasVindas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_cliente VARCHAR(100),
    data_bemvindo DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Clientes
INSERT INTO Clientes (nome, email) VALUES
('Ana Costa', 'ana@gmail.com'),
('Bruno Silva', 'bruno@gmail.com'),
('Carla Mendes', 'carla@gmail.com'),
('Diego Torres', 'diego@gmail.com'),
('Elisa Ramos', 'elisa@gmail.com');

-- Produtos
INSERT INTO Produtos (nome, preco, estoque) VALUES
('Notebook', 3500.00, 10),
('Mouse', 80.00, 50),
('Teclado', 120.00, 30),
('Monitor 24"', 950.00, 15),
('Webcam HD', 150.00, 20),
('Headset Gamer', 300.00, 25);

-- Pedidos
INSERT INTO Pedidos (cliente_id) VALUES (1), (2), (3);

-- Itens dos pedidos
INSERT INTO ItensPedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 1, 3500.00), -- Notebook
(1, 2, 2, 80.00),   -- 2 Mouses
(2, 3, 1, 120.00),   -- Teclado
(2, 4, 1, 950.00),   -- Monitor
(3, 5, 1, 150.00),   -- Webcam
(3, 6, 1, 300.00);   -- Headset

-- Lista de Exercícios com TRIGGERS

/*1. Crie uma trigger AFTER INSERT em ItensPedido que reduza o estoque do produto na tabela Produtos.*/
drop trigger if exists trg_after_insert_quantidade_item;
DELIMITER //
CREATE TRIGGER trg_after_insert_quantidade_item
after insert on ItensPedido
for each row
begin
 update produtos
  set estoque = estoque - new.quantidade
   where id = new.produto_id;
end
// DELIMITER ;

select * from ItensPedido;

insert into ItensPedido(produto_id, quantidade)
 values (6, 1);
 
select * from Produtos;

/*2. Crie uma trigger AFTER DELETE em ItensPedido que devolva ao estoque a quantidade do item deletado.*/
delimiter //
create trigger trg_after_delete_estoque_item
after delete on ItensPedido
for each row
begin
 update Produtos
  set estoque = estoque + old.quantidade
   where id = old.produto_id;
end
// delimiter ;

/*3. Crie uma trigger BEFORE INSERT em Clientes que bloqueie e exiba erro se o e-mail já estiver cadastrado.*/
drop trigger trg_before_insert_email_cliente;
delimiter //
create trigger trg_before_insert_email_cliente
before insert on Clientes
for each row
begin
 declare v_email_existente int;
 select count(*)
 into v_email_existente
 from clientes
 where email = new.email;
 
 if v_email_existente > 0 then
  signal sqlstate '45000'
  set message_text = 'ERRO: O email já foi cadastrado.';
 end if;
end
// delimiter ;

insert into clientes (email)
values ('ana@gmail.com');

/*4. Crie uma trigger AFTER INSERT em Pedidos que envie um log com a data e o ID do cliente para uma nova tabela LogsPedidos.*/
drop trigger trg_after_insert_pedido;
delimiter //
create trigger trg_after_insert_pedido
after insert on Pedidos
for each row
begin
 insert into logspedidos (cliente_id, data_pedido)
  values (new.cliente_id, now());
end
// delimiter ;

insert into Pedidos (cliente_id,data_pedido)
values (3, now());

/*5. Crie uma trigger BEFORE INSERT em ItensPedido que impeça adicionar quantidade maior do que o estoque disponível.*/
drop trigger trg_before_insert_quantidade_item;
delimiter //
create trigger trg_before_insert_quantidade_item
before insert on ItensPedido
for each row
begin
 declare v_estoque int;
 select estoque 
 into v_estoque
 from produtos
 where id = new.produto_id;
 if new.quantidade > v_estoque then
 signal sqlstate '45000'
 set message_text = 'Erro: a quantidade selecionada é maior que o estoque disponível.';
 end if;
end
// delimiter ;

insert into itenspedido (produto_id, quantidade)
values (1, 1000);

/*6. Altere a trigger de estoque criada no exercício 1 para registrar cada movimentação em uma nova tabela MovimentacoesEstoque.*/
drop trigger if exists trg_after_insert_quantidade_item;
DELIMITER //
CREATE TRIGGER trg_after_insert_quantidade_item
after insert on ItensPedido
for each row
begin
 insert into movimentacoesestoque(produto_id, quantidade, tipo, data_movimentacao)
  values (new.produto_id, new.quantidade, 'saida', now());
 update produtos
  set estoque = estoque - new.quantidade
   where id = new.produto_id;
end
// DELIMITER ;

/*7. Crie uma trigger AFTER UPDATE na tabela Produtos que registre as mudanças de preço em uma tabela HistoricoPrecos.*/
delimiter //
create trigger trg_after_update_preco_produto
after update on Produtos
for each row
begin
  insert into historicoprecos (produto_id, preco_antigo, preco_novo, data_alteracao)
   values (new.id, old.preco, new.preco, now());
end
// delimiter ;

update produtos
set preco = 100.00
where id = 2;

select * from historicoprecos;

/*8. Crie uma trigger BEFORE DELETE na tabela Clientes que bloqueie a exclusão se o cliente tiver pedidos registrados.*/
delimiter //
create trigger trg_before_delete_cliente
before delete on Clientes
for each row
begin
 declare cliente_com_pedido boolean;
 set cliente_com_pedido = exists (
    select 1 from pedidos where cliente_id = old.id
 );
 if cliente_com_pedido then
 signal sqlstate '45000'
 set message_text = 'ERRO: Não é possivel deletar um cliente que já possui pedidos.';
 end if;
end
// delimiter ;

/*9. Crie uma trigger AFTER INSERT em Clientes que registre a data e o nome do cliente em uma tabela BoasVindas.*/
delimiter //
create trigger trg_after_insert_cliente
after insert on Clientes
for each row
begin
 insert into BoasVindas (nome_cliente, data_bemvindo)
 values (new.nome, now());
end
// delimiter ;

insert into clientes(nome, email, data_cadastro)
values ('João', 'joaõ@hotmail.com', now());

select * from boasvindas;