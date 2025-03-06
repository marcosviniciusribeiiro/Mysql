create database pedidos;

use pedidos;

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE Pedidos (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    data_pedido DATE,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Produtos (
    id_produto INT PRIMARY KEY,
    nome_produto VARCHAR(100),
    preco DECIMAL(10,2)
);

CREATE TABLE Produtos_Pedidos (
    id_pedido INT,
    id_produto INT,
    quantidade INT,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto) -- Adicionada a conexão com Produtos
);

-- Dados da tabela Clientes
INSERT INTO Clientes (id_cliente, nome, email) VALUES
(1, 'João Silva', 'joao.silva@email.com'),
(2, 'Maria Oliveira', 'maria.oliveira@email.com'),
(3, 'Carlos Santos', 'carlos.santos@email.com');

-- Dados da tabela Pedidos
INSERT INTO Pedidos (id_pedido, id_cliente, data_pedido) VALUES
(101, 1, '2025-01-15'),
(102, 2, '2025-01-16'),
(103, 1, '2025-01-17');

-- Dados da tabela Produtos
INSERT INTO Produtos (id_produto, nome_produto, preco) VALUES
(1001, 'Notebook', 3500.00),
(1002, 'Smartphone', 2000.00),
(1003, 'Mouse', 150.00);

-- Dados da tabela Produtos_Pedidos
INSERT INTO Produtos_Pedidos (id_pedido, id_produto, quantidade) VALUES
(101, 1001, 1),
(101, 1003, 2),
(102, 1002, 1),
(103, 1003, 1);

SELECT 
    c.nome AS Nome_Cliente,
    c.email AS email_Cliente,
    p.nome_produto AS Produto_Comprado,
    pp.quantidade AS Quantidade,
    (p.preco * pp.quantidade) AS Valor_Total
FROM 
    Clientes c
INNER JOIN 
    Pedidos pd ON c.id_cliente = pd.id_cliente
INNER JOIN 
    Produtos_Pedidos pp ON pd.id_pedido = pp.id_pedido
INNER JOIN 
    Produtos p ON pp.id_produto = p.id_produto;
    
/*1. Exibir os pedidos feitos por cada cliente, incluindo os produtos adquiridos e suas quantidades.
Tabelas envolvidas: Clientes, Pedidos, Produtos_Pedidos, Produtos*/
select c.id_cliente, p.nome_produto as Produto, pp.quantidade from Clientes c
join 
Pedidos pd on c.id_cliente = pd.id_cliente
join 
Produtos_Pedidos pp on pd.id_pedido = pp.id_pedido
join
Produtos p on p.id_produto = pp.id_produto
order by c.id_cliente;

/*2. Listar os clientes que compraram um produto específico (ex: 'Notebook').
Tabelas envolvidas: Clientes, Pedidos, Produtos_Pedidos, Produtos*/
select c.nome as Cliente, p.nome_produto as Produto_Comprado
from Clientes c
join
Pedidos pd on c.id_cliente = pd.id_cliente
join
Produtos_Pedidos pp on pd.id_pedido = pp.id_pedido
join
Produtos p on pp.id_produto = p.id_produto
where nome_produto like 'Notebook';

/*3. Mostrar quais produtos foram comprados em um determinado pedido, junto com a data e o cliente que fez a compra.
Tabelas envolvidas: Clientes, Pedidos, Produtos_Pedidos, Produtos*/

/*4. Listar os clientes que já fizeram pedidos em mais de uma data, exibindo os nomes dos clientes e as datas dos pedidos.
Tabelas envolvidas: Clientes, Pedidos, Produtos_Pedidos, Produtos*/

/*5. Exibir o nome dos clientes que já compraram um produto específico e em qual data eles fizeram isso.
Tabelas envolvidas: Clientes, Pedidos, Produtos_Pedidos, Produtos*/
