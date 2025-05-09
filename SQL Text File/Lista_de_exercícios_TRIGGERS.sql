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
DROP TRIGGER IF EXISTS trg_after_insert_pedido;
DELIMITER //
CREATE TRIGGER trg_after_insert_pedido
 AFTER INSERT ON Pedidos
 FOR EACH ROW
 BEGIN
  INSERT INTO Log_Auditoria(tabela_afetada, acao, id_registro, data_hora, usuario)
  VALUES ('Pedidos','INSERT', new.id_pedido, now(), user());
 END
// DELIMITER ;

SELECT * FROM Pedidos;

INSERT INTO Pedidos (id_cliente, data_pedido, status_pedido)
 VALUES ('2', '2025-04-26', 'Finalizado');
 
SELECT * FROM Log_Auditoria;

/*2. Crie uma trigger que impeça a inserção de produtos com preço menor que 100 reais.*/
DROP TRIGGER IF EXISTS trg_before_insert_produto;
DELIMITER //
CREATE TRIGGER trg_before_insert_produto
 BEFORE INSERT ON Produtos
 FOR EACH ROW
 BEGIN
  IF NEW.preco < 100 THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Produto com preço menor que 100 R$';
  END IF;
 END
// DELIMITER ;

INSERT INTO Produtos(preco)
 VALUES (40.5);

SELECT * FROM Log_Auditoria;

/*3. Crie uma trigger que atualize automaticamente o estoque do produto ao inserir um novo item em `ItensPedido`.*/
DROP TRIGGER IF EXISTS trg_after_insert_itemPedido;
DELIMITER //
CREATE TRIGGER trg_after_insert_itemPedido
 AFTER INSERT ON ItensPedido
 FOR EACH ROW
 BEGIN
  UPDATE Produtos
   SET estoque = estoque - NEW.quantidade
   WHERE id_produto = NEW.id_produto;
 END
// DELIMITER ;

SELECT * FROM ItensPedido;

INSERT INTO ItensPedido (id_pedido, id_produto, quantidade, preco_unitario)
 VALUES (11, 9 , 3, 350.00);

SELECT * FROM Produtos;

/*4. Crie uma trigger que não permita excluir um `Cliente` que tenha pedidos.*/
DROP TRIGGER IF EXISTS trg_before_delete_cliente;
DELIMITER //
CREATE TRIGGER trg_before_delete_cliente
 BEFORE DELETE ON Clientes
 FOR EACH ROW
 BEGIN
  DECLARE cliente_tem_pedidos BOOLEAN;
  SET cliente_tem_pedidos = EXISTS(
   SELECT 1 FROM Pedidos WHERE id_cliente = OLD.id_cliente
  );
  IF cliente_tem_pedidos THEN 
  SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'Não é possivel apagar um cliente que já possui pedidos.';
  END IF;
 END
// DELIMITER ;

DELETE FROM Clientes 
 WHERE id_cliente = 3;

/*5. Crie uma trigger que registre no log qualquer atualização de status em `Pedidos`.*/
DROP TRIGGER IF EXISTS trg_after_update_status;
DELIMITER //
CREATE TRIGGER trg_after_update_status
 AFTER UPDATE ON Pedidos
 FOR EACH ROW
 BEGIN
  IF OLD.status_pedido <> NEW.status_pedido THEN
   INSERT INTO Log_Auditoria(tabela_afetada, acao, id_registro, data_hora, usuario)
    VALUES ('Pedidos', 'UPDATE', NEW.id_pedido, now(), user());
  END IF;
 END
// DELIMITER ;

UPDATE Pedidos
 SET status_pedido = 'Cancelado'
  WHERE id_pedido = 3;

SELECT * FROM Log_Auditoria;

/*6. Crie uma trigger que impeça de alterar o preço de um produto se ele já foi vendido em algum pedido.*/
DROP TRIGGER IF EXISTS trg_before_update_preco;
DELIMITER //
CREATE TRIGGER trg_before_update_preco
 BEFORE UPDATE ON Produtos
 FOR EACH ROW
 BEGIN
  DECLARE produto_vendido BOOLEAN;
   SET produto_vendido = EXISTS (
    SELECT 1 FROM ItensPedido WHERE id_produto = OLD.id_produto 
   );
   IF produto_vendido THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Não é possivel atualizar o preço de um produto que já foi vendido';
   END IF;
 END
// DELIMITER ;

UPDATE Produtos
 SET preco = '4000'
  WHERE id_produto = 1;

/*7. Crie uma trigger que registre no log quando um produto for excluído.*/
DROP TRIGGER IF EXISTS trg_after_delete_ItensPedido;
DELIMITER //
CREATE TRIGGER trg_after_delete_ItensPedido
 AFTER DELETE ON ItensPedido
 FOR EACH ROW
 BEGIN
  INSERT INTO Log_Auditoria (tabela_afetada, acao, id_registro, data_hora, usuario)
   VALUES ('ItensPedido', 'DELETE', old.id_pedido, now(), user());
 END
// DELIMITER ;

SELECT * FROM ItensPedido;

DELETE FROM ItensPedido
 WHERE id_item = 10;

SELECT * FROM Log_Auditoria;

/*8. Crie uma trigger que aumente automaticamente o estoque em 1 unidade quando um pedido é cancelado.*/
DROP TRIGGER IF EXISTS trg_after_update_pedido;
DELIMITER //
CREATE TRIGGER trg_after_update_pedido
 AFTER UPDATE ON Pedidos
 FOR EACH ROW
 BEGIN
  IF OLD.status_pedido != 'Cancelado' AND NEW.status_pedido = 'Cancelado' THEN
   UPDATE Produtos p
    JOIN ItensPedido i ON p.id_produto = i.id_produto
     SET estoque = estoque + i.quantidade
     WHERE i.id_pedido = NEW.id_pedido;
  END IF;
 END
// DELIMITER ;
 
/*9. Crie uma trigger que impeça a alteração da cidade do cliente para nulo.*/
DROP TRIGGER IF EXISTS trg_before_update_cliente_cidade;
DELIMITER //
CREATE TRIGGER trg_before_update_cliente_cidade
 BEFORE UPDATE ON Clientes
 FOR EACH ROW
 BEGIN
  IF TRIM(NEW.cidade) = '' THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Não é possivel alterar a cidade para um valor nulo.';
  END IF;
 END
// DELIMITER ;

UPDATE Clientes
 SET cidade = 'São Paulo'
  WHERE id_cliente = 1;
 
/*10. Crie uma trigger que registre alterações no email dos clientes.*/
DROP TRIGGER IF EXISTS trg_after_update_email_cliente;
DELIMITER //
CREATE TRIGGER trg_after_update_email_cliente
 AFTER UPDATE ON Clientes
 FOR EACH ROW
 BEGIN
  IF OLD.email <> NEW.email THEN
   INSERT INTO Log_Auditoria (tabela_afetada, acao, id_registro, data_hora, usuario)
    VALUES ('Clientes', 'UPDATE', NEW.id_cliente, NOW(), USER());
  END IF;
 END
// DELIMITER ;

UPDATE Clientes
 SET email = 'juliana@hotmail.com'
  WHERE id_cliente = 10;
  
SELECT * FROM Log_Auditoria;

/*11. Crie uma trigger que registre o usuário MySQL que excluiu um item do pedido.*/
DROP TRIGGER IF EXISTS trg_after_delete_itempedido;
DELIMITER //
CREATE TRIGGER trg_after_delete_itempedido
 AFTER DELETE ON ItensPedido
 FOR EACH ROW
 BEGIN
  INSERT INTO Log_Auditoria (tabela_afetada, acao, id_registro, data_hora, usuario)
   VALUES ('ItensPedido', 'DELETE', OLD.id_item, NOW(), USER());
 END
// DELIMITER ;

DELETE FROM ItensPedido
 WHERE id_item = 12;

SELECT * FROM Log_Auditoria;

/*12. Crie uma trigger que impeça um pedido de ser marcado como "Finalizado" se não houver itens no pedido.*/
DROP TRIGGER IF EXISTS trg_before_update_finalizar_pedido;
DELIMITER //
CREATE TRIGGER trg_before_update_finalizar_pedido
 BEFORE UPDATE ON Pedidos
 FOR EACH ROW
 BEGIN
  IF NEW.status_pedido = 'Finalizado' AND (SELECT COUNT(*) FROM itenspedido WHERE id_pedido = NEW.id_pedido) = 0 THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Um Pedido sem itens não pode ser finalizado.';
  END IF;
 END
// DELIMITER ;

/*13. Crie uma trigger que lance um erro se tentar comprar mais produtos do que o estoque disponível.*/
DROP TRIGGER IF EXISTS trg_before_insert_itempedido_estoque;
DELIMITER //
CREATE TRIGGER trg_before_insert_itempedido_estoque
 BEFORE INSERT ON ItensPedido
 FOR EACH ROW
 BEGIN
  DECLARE v_qt_disponivel INT;
   SELECT estoque 
   INTO v_qt_disponivel
   FROM Produtos 
   WHERE id_produto = NEW.id_produto;
  IF NEW.quantidade > v_qt_disponivel THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Não é possivel solicitar mais produtos do que o estoque disponível.';
  END IF;
 END
// DELIMITER ;

/*14. Crie uma trigger que atualize o preço_unitario de ItensPedido se o preço do produto mudar.*/
DROP TRIGGER IF EXISTS trg_after_update_preco_produto;
DELIMITER //
CREATE TRIGGER trg_after_update_preco_produto
 AFTER UPDATE ON Produtos
 FOR EACH ROW
 BEGIN
  IF OLD.preco <> NEW.preco THEN 
   UPDATE ItensPedido
    SET preco_unitario = NEW.preco
     WHERE id_produto = NEW.id_produto;
  END IF;
 END
// DELIMITER ;

/*15. Crie uma trigger que logue toda inclusão de um novo cliente.*/
DROP TRIGGER IF EXISTS trg_after_insert_cliente;
DELIMITER //
CREATE TRIGGER trg_after_insert_cliente
 AFTER INSERT ON Clientes
 FOR EACH ROW
 BEGIN
  INSERT INTO Log_Auditoria (tabela_afetada, acao, id_registro, data_hora, usuario)
   VALUES ('Clientes', 'INSERT', NEW.id_cliente, NOW(), USER());
 END
// DELIMITER ;

SELECT * FROM Clientes;

INSERT INTO Clientes (nome, email, cidade, estado)
 VALUES ('João Pedro', 'joão@hotmail.com', 'Sobradinho', 'DF');

SELECT * FROM Log_Auditoria;

/*16. Crie uma trigger que bloqueie alterações de status de pedido para "Cancelado" se o pedido estiver "Finalizado".*/
DROP TRIGGER IF EXISTS trg_before_update_status_cancelar;
DELIMITER //
CREATE TRIGGER trg_before_update_status_cancelar
 BEFORE UPDATE ON Pedidos
 FOR EACH ROW
 BEGIN
  IF OLD.status_pedido = 'Finalizado' AND NEW.status_pedido = 'Cancelado' THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Não é possivel alterar o status de um pedido Finalizado.';
  END IF;
 END
// DELIMITER ;

UPDATE Pedidos
 SET status_pedido = 'Cancelado'
  WHERE id_pedido = 1;

/*17. Crie uma trigger que reduza o estoque do produto quando um item é inserido no pedido.*/

-- Já foi resolvido no exercício 3 (trigger: trg_after_insert_itenspedido)

/*18. Crie uma trigger que registre quando a quantidade de um item de pedido é alterada.*/
DROP TRIGGER IF EXISTS trg_after_update_quantidade_pedido;
DELIMITER //
CREATE TRIGGER trg_after_update_quantidade_pedido
 AFTER UPDATE ON ItensPedido
 FOR EACH ROW
 BEGIN
  IF OLD.quantidade <> NEW.quantidade THEN
   INSERT INTO Log_Auditoria (tabela_afetada, acao, id_registro, data_hora, usuario)
    VALUES ('ItensPedido', 'UPDATE', NEW.id_item, NOW(), USER());
  END IF;
 END
// DELIMITER ;

SELECT * FROM ItensPedido;

UPDATE ItensPedido
 SET quantidade = 4
  WHERE id_pedido = 4;

SELECT * FROM Log_Auditoria;

/*19. Crie uma trigger que bloqueie a exclusão de produtos com estoque maior que zero.*/
DROP TRIGGER IF EXISTS trg_before_delete_produto;
DELIMITER //
CREATE TRIGGER trg_before_delete_produto
 BEFORE DELETE ON Produtos
 FOR EACH ROW
 BEGIN
  IF OLD.estoque > 0 THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'O produto ainda possui estoque para a venda! Não foi possivel exclui-lo.';
  END IF;
 END
// DELIMITER ;

DELETE FROM Produtos
 WHERE id_produto = 1;

/*20. Crie uma trigger que lance um erro se o nome de um cliente for alterado para vazio.*/
DROP TRIGGER IF EXISTS trg_before_update_nome_cliente;
DELIMITER //
CREATE TRIGGER trg_before_update_nome_cliente
 BEFORE UPDATE ON Clientes
 FOR EACH ROW
 BEGIN
  IF TRIM(NEW.nome) = '' THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Um nome não pode ser vazio.';
  END IF;
 END
// DELIMITER ;