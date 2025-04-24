drop database olx_clone;
-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS olx_clone;
USE olx_clone;

-- Tabela de usuários
CREATE TABLE IF NOT EXISTS usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cidade VARCHAR(100)
);

-- Tabela de categorias
CREATE TABLE IF NOT EXISTS categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria_pai_id INT,
    FOREIGN KEY (categoria_pai_id) REFERENCES categorias(categoria_id)
);

-- Tabela de anúncios
CREATE TABLE IF NOT EXISTS anuncios (
    anuncio_id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    usuario_id INT NOT NULL,
    categoria_id INT NOT NULL,
    data_publicacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id)
);

-- Tabela de mensagens
drop table mensagens;
CREATE TABLE IF NOT EXISTS mensagens (
   mensagem_id INT AUTO_INCREMENT PRIMARY KEY,
    anuncio_id INT NOT NULL,
    remetente_id INT NOT NULL,
    destinatario_id INT NOT NULL,
    mensagem TEXT NOT NULL,
    data_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (anuncio_id) REFERENCES anuncios(anuncio_id),
    FOREIGN KEY (remetente_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (destinatario_id) REFERENCES usuarios(usuario_id)
);
-- Inserção de usuários
INSERT INTO usuarios (nome, email, telefone, cidade) VALUES
('João Silva', 'joao@email.com', '11999999999', 'São Paulo'),
('Maria Oliveira', 'maria@email.com', '21988888888', 'Rio de Janeiro'),
('Pedro Santos', 'pedro@email.com', '31977777777', 'Belo Horizonte'),
('Ana Souza', 'ana@email.com', '41966666666', 'Curitiba'),
('Lucas Pereira', 'lucas@email.com', '51955555555', 'Porto Alegre'),
('Carla Rodrigues', 'carla@email.com', '61944444444', 'Brasília'),
('Bruno Almeida', 'bruno@email.com', '71933333333', 'Salvador'),
('Fernanda Costa', 'fernanda@email.com', '81922222222', 'Recife'),
('Ricardo Gomes', 'ricardo@email.com', '91911111111', 'Manaus'),
('Juliana Lima', 'juliana@email.com', '27900000000', 'Vitória');
select * from usuarios;

-- Inserção de categorias
INSERT INTO categorias (nome, categoria_pai_id) VALUES
('Eletrônicos', NULL),
('Celulares', 1),
('Informática', 1),
('Veículos', NULL),
('Carros', 4),
('Motos', 4),
('Imóveis', NULL),
('Apartamentos', 7),
('Casas', 7),
('Roupas e Calçados', NULL);
select * from categorias;

-- Inserção de anúncios
INSERT INTO anuncios (titulo, descricao, preco, usuario_id, categoria_id) VALUES
('iPhone 12', 'Novo, 128GB', 3500.00, 1, 2),
('Notebook Dell Inspiron', 'Usado, Core i5, 8GB RAM', 2000.00, 2, 3),
('Fiat Uno', 'Ano 2010, bom estado', 15000.00, 3, 5),
('Honda CG 150', 'Ano 2015, baixa quilometragem', 8000.00, 4, 6),
('Apartamento 2 quartos', 'Centro, com garagem', 250000.00, 5, 8),
('Camiseta Polo', 'Tamanho M, nova', 50.00, 6, 10),
('Samsung Galaxy S21', 'Seminovo, 256GB', 3000.00, 7, 2),
('Desktop Gamer', 'Ryzen 5, GTX 1660', 4000.00, 8, 3),
('VW Gol', 'Ano 2012, completo', 18000.00, 9, 5),
('Jaqueta de Couro', 'Tamanho G, usada', 150.00, 10, 10);
select * from anuncios;

-- Inserção de mensagens
INSERT INTO mensagens (anuncio_id, remetente_id, destinatario_id, mensagem) VALUES
(1, 2, 1, 'Tenho interesse no iPhone, qual o menor preço?'),
(2, 3, 2, 'O notebook ainda está disponível?'),
(3, 4, 3, 'Aceita troca no Fiat Uno?'),
(4, 5, 4, 'Qual a quilometragem da Honda CG 150?'),
(5, 6, 5, 'O apartamento aceita financiamento?'),
(6, 7, 6, 'Qual o material da camiseta Polo?'),
(7, 8, 7, 'O Samsung Galaxy S21 tem garantia?'),
(8, 9, 8, 'Quais os jogos que o Desktop Gamer roda?'),
(9, 10, 9, 'O VW Gol tem ar condicionado?'),
(10, 1, 10, 'A jaqueta de couro tem algum defeito?'),
(1, 3, 1, 'Ainda está à venda?'),
(2, 4, 2, 'Qual o modelo exato do notebook?'),
(3, 5, 3, 'Aceita oferta?');
select * from mensagens;

-- Inserção de categorias com hierarquia
INSERT INTO categorias (nome, categoria_pai_id) VALUES
('Eletrônicos', NULL), -- Categoria raiz
('Celulares', 1), -- Subcategoria de Eletrônicos
('Smartphones', 2), -- Subcategoria de Celulares
('Tablets', 2), -- Subcategoria de Celulares
('Informática', 1), -- Subcategoria de Eletrônicos
('Notebooks', 5), -- Subcategoria de Informática
('Desktops', 5), -- Subcategoria de Informática
('Veículos', NULL), -- Categoria raiz
('Carros', 8), -- Subcategoria de Veículos
('Motos', 8); -- Subcategoria de Veículos
select * from categorias;

-- Exemplo Sem CTEs
select c.nome as categoria,
       sum(a.preco) as preco_total,
       (sum(a.preco) / (select sum(preco) from anuncios * 10 as percentual
from anuncios a
join
categorias c on a.categoria_id = c.categoria_id
group by c.nome;

-- CTE para encontrar anúncios com mais de uma mensagem
WITH CTE_AnunciosComMensagens AS (
    SELECT anuncio_id, COUNT(*) AS total_mensagens
    FROM mensagens
    GROUP BY anuncio_id
    HAVING COUNT(*) > 1
)
-- Consulta final para exibir os anúncios e seus títulos
select a.titulo, acm.total_mensagens from anuncios a
join CTE_AnunciosComMensagens acm on a.anuncio_id = acm.anuncio_id;

-- CTEs recursivas
WITH RECURSIVE Subcategorias AS (
    -- Consulta Âncora: Seleciona a categoria "Eletrônicos"
    SELECT categoria_id, nome, categoria_pai_id, 1 AS nivel
    FROM categorias
    WHERE nome = 'Eletrônicos'

    UNION ALL

    -- Consulta Recursiva: Seleciona as subcategorias
    SELECT c.categoria_id, c.nome, c.categoria_pai_id, s.nivel + 1 AS nivel
    FROM categorias c
    JOIN Subcategorias s ON c.categoria_pai_id = s.categoria_id
)
SELECT *
FROM Subcategorias;

/* CTE para calcular o total de preços de anuncio*/
With TotalPrecos as (
    select sum(preco) as total from anuncios
),
PrecosPorCategoria as (
    select
         c.nome as categoria,
         sum(a.preco) as total_preco
	from anuncios a
    join categorias c on a.categoria_id = c.categoria_id
    group by c.nome
)

select 
    pc.categoria,
    pc.total_preco,
    (pc.total_preco / tp.total) * 100 as percentual
from PrecosPorCategoria pc, TotalPrecos tp;

-- Usando o Union e Union All
Select mensagem from mensagens where remetente_id = 2
union
Select mensagem from mensagens where destinatario_id = 1;

Select mensagem from mensagens where remetente_id = 2
union all
Select mensagem from mensagens where destinatario_id = 1;

