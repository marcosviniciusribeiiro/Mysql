CREATE DATABASE db_pedidos;

USE db_pedidos;

-- Tabela de Clientes
CREATE TABLE tb_Clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100)
);

-- Tabela de Pedidos
CREATE TABLE tb_Pedidos (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    data_pedido DATE,
    FOREIGN KEY (id_cliente) REFERENCES tb_Clientes(id_cliente)
);

-- Tabela de Produtos
CREATE TABLE tb_Produtos (
    id_produto INT PRIMARY KEY,
    nome_produto VARCHAR(100),
    preco DECIMAL(10,2)
);

-- Tabela de Produtos_Pedidos
CREATE TABLE tb_Produtos_Pedidos (
    id_pedido INT,
    id_produto INT,
    quantidade INT,
    FOREIGN KEY (id_pedido) REFERENCES tb_Pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES tb_Produtos(id_produto) -- Adicionada a conexão com Produtos
);

-- Dados da tabela Clientes
INSERT INTO tb_Clientes (id_cliente, nome, email) VALUES
    (1, 'João Silva', 'joao.silva@email.com'),
    (2, 'Maria Oliveira', 'maria.oliveira@email.com'),
    (3, 'Carlos Santos', 'carlos.santos@email.com');

-- Dados da tabela Pedidos
INSERT INTO tb_Pedidos (id_pedido, id_cliente, data_pedido) VALUES
    (101, 1, '2025-01-15'),
    (102, 2, '2025-01-16'),
    (103, 1, '2025-01-17');

-- Dados da tabela Produtos
INSERT INTO tb_Produtos (id_produto, nome_produto, preco) VALUES
    (1001, 'Notebook', 3500.00),
    (1002, 'Smartphone', 2000.00),
    (1003, 'Mouse', 150.00);

-- Dados da tabela Produtos_Pedidos
INSERT INTO tb_Produtos_Pedidos (id_pedido, id_produto, quantidade) VALUES
    (101, 1001, 1),
    (101, 1003, 2),
    (102, 1002, 1),
    (103, 1003, 1);
/*SELECT 
    pd.id_pedido,
    c.nome AS Nome_Cliente,
    c.email AS email_Cliente,
    p.nome_produto AS Produto_Comprado,
    pp.quantidade AS Quantidade,
    (p.preco * pp.quantidade) AS Valor_Total
FROM 
    tb_Clientes c
 INNER JOIN 
    tb_Pedidos pd ON c.id_cliente = pd.id_cliente
 INNER JOIN 
    tb_Produtos_Pedidos pp ON pd.id_pedido = pp.id_pedido
 INNER JOIN 
    tb_Produtos p ON pp.id_produto = p.id_produto;*/

/*1. Exibir os pedidos feitos por cada cliente, incluindo os produtos adquiridos e suas quantidades.
Tabelas envolvidas: Clientes, Pedidos, Produtos_Pedidos, Produtos*/

SELECT 
    c.id_cliente, 
    p.nome_produto AS nome_produto, 
    pp.quantidade AS quantidade_produto
FROM 
    tb_Clientes c
    INNER JOIN tb_Pedidos pd ON c.id_cliente = pd.id_cliente
    INNER JOIN tb_Produtos_Pedidos pp ON pd.id_pedido = pp.id_pedido
    INNER JOIN tb_Produtos p ON p.id_produto = pp.id_produto
ORDER BY c.id_cliente;

/*2. Listar os clientes que compraram um produto específico (ex: 'Notebook').
Tabelas envolvidas: Clientes, Pedidos, Produtos_Pedidos, Produtos*/

SELECT 
    c.nome AS nome_cliente,
    p.nome_produto AS produto_comprado
FROM 
    tb_Clientes c
    INNER JOIN tb_Pedidos pd ON c.id_cliente = pd.id_cliente
    INNER JOIN tb_Produtos_Pedidos pp ON pd.id_pedido = pp.id_pedido
    INNER JOIN tb_Produtos p ON pp.id_produto = p.id_produto
WHERE p.nome_produto = 'Notebook';

/*3. Mostrar quais produtos foram comprados em um determinado pedido, junto com a data e o cliente que fez a compra.
Tabelas envolvidas: Clientes, Pedidos, Produtos_Pedidos, Produtos*/

SELECT 
    pd.id_pedido, 
    p.nome_produto, 
    pd.data_pedido, 
    c.nome AS cliente 
FROM 
    tb_Pedidos pd
    INNER JOIN tb_Produtos_Pedidos pp ON pd.id_pedido = pp.id_pedido
    INNER JOIN tb_Produtos p ON p.id_produto = pp.id_produto
    INNER JOIN tb_Clientes c ON c.id_cliente = pd.id_cliente;

/*4. Listar os clientes que já fizeram pedidos em mais de uma data, exibindo os nomes dos clientes e as datas dos pedidos.
Tabelas envolvidas: Clientes, Pedidos, Produtos_Pedidos, Produtos*/

SELECT 
    c.nome AS nome_cliente, 
    pd.data_pedido 
FROM 
    tb_Clientes c
    INNER JOIN tb_Pedidos pd ON c.id_cliente = pd.id_cliente
    INNER JOIN tb_Produtos_Pedidos pp ON pd.id_pedido = pp.id_pedido
    INNER JOIN tb_Produtos p ON p.id_produto = pp.id_produto
HAVING COUNT(DISTINCT data_pedido) > 1
ORDER BY c.nome, pd.data_pedido;

/*5. Exibir o nome dos clientes que já compraram um produto específico e em qual data eles fizeram isso.
Tabelas envolvidas: Clientes, Pedidos, Produtos_Pedidos, Produtos*/

SELECT DISTINCT 
    c.nome AS nome_cliente, 
    p.nome_produto, 
    pd.data_pedido 
FROM 
    tb_Clientes c
    INNER JOIN tb_Pedidos pd ON c.id_cliente = pd.id_cliente
    INNER JOIN tb_Produtos_Pedidos pp ON pd.id_pedido = pp.id_pedido
    INNER JOIN tb_Produtos p ON p.id_produto = pp.id_produto
WHERE p.nome_produto = 'Mouse'
ORDER BY pd.data_pedido;