-- Cria o banco de dados
CREATE DATABASE SalesDB;
USE SalesDB;

-- Tabela de Clientes
CREATE TABLE Clientes (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  email VARCHAR(100),
  cidade VARCHAR(50),
  estado VARCHAR(2)
);

-- Tabela de Produtos
CREATE TABLE Produtos (
  id_produto INT AUTO_INCREMENT PRIMARY KEY,
  nome_produto VARCHAR(100),
  preco DECIMAL(10,2),
  estoque INT
);

-- Tabela de Pedidos
CREATE TABLE Pedidos (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  data_pedido DATE,
  status_pedido VARCHAR(20),
  FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

-- Tabela de Itens do Pedido
CREATE TABLE ItensPedido (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT,
  id_produto INT,
  quantidade INT,
  preco_unitario DECIMAL(10,2),
  FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
  FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

-- Tabela de Logs de Auditoria
CREATE TABLE Log_Auditoria (
  id_log INT AUTO_INCREMENT PRIMARY KEY,
  tabela_afetada VARCHAR(50),
  acao VARCHAR(10),
  id_registro INT,
  data_hora DATETIME,
  usuario VARCHAR(100)
);

-- Inserções em Clientes
INSERT INTO Clientes (nome, email, cidade, estado) VALUES
('Alice Martins', 'alice@gmail.com', 'São Paulo', 'SP'),
('Bruno Oliveira', 'bruno@hotmail.com', 'Campinas', 'SP'),
('Carla Souza', 'carla@yahoo.com', 'Belo Horizonte', 'MG'),
('Daniel Santos', 'daniel@gmail.com', 'Curitiba', 'PR'),
('Eduarda Lima', 'eduarda@hotmail.com', 'Rio de Janeiro', 'RJ'),
('Felipe Mendes', 'felipe@yahoo.com', 'Florianópolis', 'SC'),
('Gustavo Rocha', 'gustavo@gmail.com', 'Recife', 'PE'),
('Helena Almeida', 'helena@hotmail.com', 'Fortaleza', 'CE'),
('Igor Costa', 'igor@yahoo.com', 'Porto Alegre', 'RS'),
('Juliana Dias', 'juliana@gmail.com', 'Salvador', 'BA');

-- Inserções em Produtos
INSERT INTO Produtos (nome_produto, preco, estoque) VALUES
('Notebook Dell', 4500.00, 20),
('Smartphone Samsung', 2500.00, 50),
('Tablet Lenovo', 1200.00, 30),
('Headphone Sony', 600.00, 100),
('Monitor LG 24"', 900.00, 15),
('Teclado Mecânico', 400.00, 70),
('Mouse Logitech', 150.00, 80),
('Impressora HP', 700.00, 25),
('Webcam Logitech', 350.00, 40),
('Cadeira Gamer', 1300.00, 10);

-- Inserções em Pedidos
INSERT INTO Pedidos (id_cliente, data_pedido, status_pedido) VALUES
(3, '2025-01-15', 'Finalizado'),
(7, '2025-02-20', 'Pendente'),
(2, '2025-03-01', 'Finalizado'),
(9, '2025-03-15', 'Cancelado'),
(1, '2025-03-22', 'Finalizado'),
(5, '2025-04-01', 'Pendente'),
(6, '2025-04-05', 'Finalizado'),
(8, '2025-04-10', 'Pendente'),
(4, '2025-04-15', 'Finalizado'),
(10, '2025-04-18', 'Pendente');

-- Inserções em ItensPedido
INSERT INTO ItensPedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 2, 1, 2500.00),
(2, 4, 2, 600.00),
(3, 1, 1, 4500.00),
(4, 3, 1, 1200.00),
(5, 5, 1, 900.00),
(6, 6, 3, 400.00),
(7, 7, 2, 150.00),
(8, 8, 1, 700.00),
(9, 9, 1, 350.00),
(10, 10, 1, 1300.00);

-- Exercícios sobre triggers

/*1. Crie uma trigger que registre qualquer inserção na tabela `Pedidos` na tabela `Log_Auditoria`.*/
delimiter //
create trigger trg_after_insert_pedido
after insert on pedidos
for each row
begin
  insert into log_auditoria(id_log, acao, data_hora, usuario)
   values (new.id_log, 'INSERT', now(), user());
end
// delimiter ;

select * from pedidos;
desc log_auditoria;
 insert into pedidos (id_pedido, id_cliente, data_pedido, status_pedido)
 values (default, '2', '2025-04-26', 'Finalizado');
 
select * from log_auditoria;

/*2. Crie uma trigger que impeça a inserção de produtos com preço menor que 100 reais.*/
delimiter //
create trigger trg_before_insert_produto
before insert on produtos
for each row
begin
  if new.preco < 100 then
  signal sqlstate '45000'
  set message_text = 'Produto com preço menor que 100 R$';
  end if;
end
// delimiter ;

select * from produtos;
desc produtos;

insert into produtos(id_produto, preco)
values (default, 40.5);

select * from log_auditoria;

/*3. Crie uma trigger que atualize automaticamente o estoque do produto ao inserir um novo item em `ItensPedido`.*/
drop trigger trg_after_insert_itemPedido;
delimiter //
create trigger trg_after_insert_itemPedido
after insert on ItensPedido
for each row
begin
 update produtos
  set estoque = estoque - new.quantidade
  where id_produto = new.id_produto;
end
// delimiter ;

select * from ItensPedido;
desc ItensPedido;

insert into ItensPedido (id_item, id_pedido, id_produto, quantidade, preco_unitario)
values (default, 6, 1 , 1, 4500.00);

select * from produtos;

/*4. Crie uma trigger que não permita excluir um `Cliente` que tenha pedidos.*/
drop trigger trg_before_delete_cliente;

delimiter //
create trigger trg_before_delete_cliente
before delete on clientes
for each row
begin
 if old.id_cliente in(select id_cliente from pedidos) then
 signal sqlstate '45000'
 set message_text = 'Não foi possivel apagar o cliente que possui pedidos';
 end if;
end
// delimiter ;

delete from clientes 
where id_cliente = 3;

/*5. Crie uma trigger que registre no log qualquer atualização de status em `Pedidos`.*/
drop trigger trg_after_update_status;
delimiter //
create trigger trg_after_update_status
after update on Pedidos
for each row
begin
if old.status_pedido <> new.status_pedido then
  insert into log_auditoria(id_log, acao, data_hora, usuario)
  values (default, 'UPDATE', now(), user());
end if;
end
// delimiter ;
Update pedidos
 set status_pedido = 'Cancelado'
 where id_pedido = 3;
 
select * from pedidos;

select * from log_auditoria;

/*6. Crie uma trigger que impeça de alterar o preço de um produto se ele já foi vendido em algum pedido.*/
delimiter //
create trigger trg_before_update_preco
before update on produtos
for each row
begin
  if old.id_produto in (select id_produto from ItensPedido) then
  signal sqlstate '45000'
  set message_text = 'Não é possivel atualizar o preço de um produto em venda';
  end if;
end
// delimiter ;

update produtos
  set preco = '4000'
  where id_produto = 1;

/*7. Crie uma trigger que registre no log quando um produto for excluído.*/

/*8. Crie uma trigger que aumente automaticamente o estoque em 1 unidade quando um pedido é cancelado.*/

/*9. Crie uma trigger que impeça a alteração da cidade do cliente para nulo.*/

/*10. Crie uma trigger que registre alterações no email dos clientes.*/

/*11. Crie uma trigger que registre o usuário MySQL que excluiu um item do pedido.*/

/*12. Crie uma trigger que impeça um pedido de ser marcado como "Finalizado" se não houver itens no pedido.*/

/*13. Crie uma trigger que lance um erro se tentar comprar mais produtos do que o estoque disponível.*/

/*14. Crie uma trigger que atualize o preço_unitario de ItensPedido se o preço do produto mudar.*/

/*15. Crie uma trigger que logue toda inclusão de um novo cliente.*/

/*16. Crie uma trigger que bloqueie alterações de status de pedido para "Cancelado" se o pedido estiver "Finalizado".*/

/*17. Crie uma trigger que reduza o estoque do produto quando um item é inserido no pedido.*/

/*18. Crie uma trigger que registre quando a quantidade de um item de pedido é alterada.*/

/*19. Crie uma trigger que bloqueie a exclusão de produtos com estoque maior que zero.*/

/*20. Crie uma trigger que lance um erro se o nome de um cliente for alterado para vazio.*/
