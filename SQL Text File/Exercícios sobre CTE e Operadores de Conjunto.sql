CREATE DATABASE imobiliaria;
USE imobiliaria;

-- Tabela de propriedades
CREATE TABLE propriedades (
    id INT NOT NULL PRIMARY KEY,
    tipo VARCHAR(255),
    cidade VARCHAR(100),
    estado VARCHAR(2),
    data_inicio DATE,
    data_fim DATE,
    valor DECIMAL(10, 2)
);
-- Tabela de clientes
CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    telefone VARCHAR(50),
    email VARCHAR(255)
);

-- Tabela de corretores
CREATE TABLE corretores (
    corretor_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    telefone VARCHAR(50),
    email VARCHAR(255)
);

-- Tabela de contratos
CREATE TABLE contratos (
    contrato_id INT AUTO_INCREMENT PRIMARY KEY,
    propriedade_id INT,
    cliente_id INT,
    corretor_id INT,
    tipo_contrato VARCHAR(50),
    data_inicio DATE,
    data_fim DATE,
    valor DECIMAL(10,2),
    propostas_recusadas BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (propriedade_id) REFERENCES propriedades(id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (corretor_id) REFERENCES corretores(corretor_id)
);

CREATE TABLE variacao_precos (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_propriedade INT,
    data_alteracao DATE,
    preco DECIMAL(10, 2),
    FOREIGN KEY (id_propriedade) REFERENCES propriedades(id)
);

-- Inserir registros na tabela propriedades
insert into propriedades (id, tipo, cidade, estado, data_inicio, data_fim, valor) values
(1, 'Apartamento', 'Porto Velho', 'RO', '2023-01-01', '2023-03-01', 250000.00),
(2, 'Casa', 'Rio Branco', 'AC', '2023-02-01', '2023-04-01', 300000.00),
(3, 'Cobertura', 'Manaus', 'AM', '2023-03-01', '2023-05-01', 500000.00),
(4, 'Sítio', 'Boa Vista', 'RR', '2023-04-01', '2023-06-01', 350000.00),
(5, 'Chácara', 'Belém', 'PA', '2023-05-01', '2023-07-01', 450000.00),
(6, 'Apartamento', 'Teresina', 'PI', '2023-06-01', '2023-08-01', 220000.00),
(7, 'Casa', 'Fortaleza', 'CE', '2023-07-01', '2023-09-01', 380000.00),
(8, 'Apartamento', 'Recife', 'PE', '2023-08-01', '2023-10-01', 400000.00),
(9, 'Casa', 'Curitiba', 'PR', '2023-09-01', '2023-11-01', 600000.00),
(10, 'Apartamento', 'São Paulo', 'SP', '2023-10-01', '2023-12-01', 750000.00);

-- Inserir registros na tabela clientes
INSERT INTO clientes (nome, telefone, email) VALUES
('Beatriz Lima', '(61) 98765-4321', 'beatriz.lima@example.com'),
('Carlos Souza', '(11) 99876-5432', 'carlos.souza@example.com'),
('Fernanda Moraes', '(21) 95678-1234', 'fernanda.moraes@example.com'),
('José Pereira', '(81) 91234-5678', 'jose.pereira@example.com'),
('Ana Claudia', '(31) 92345-6789', 'ana.claudia@example.com'),
('Luiz Henrique', '(71) 93456-7890', 'luiz.henrique@example.com'),
('Sabrina Vieira', '(51) 94567-8901', 'sabrina.vieira@example.com'),
('Roberto Silva', '(19) 95678-9012', 'roberto.silva@example.com'),
('Camila Torres', '(41) 96789-0123', 'camila.torres@example.com'),
('Pedro Oliveira', '(27) 97890-1234', 'pedro.oliveira@example.com');

-- Inserir registros na tabela corretores
INSERT INTO corretores (nome, telefone, email) VALUES
('Marcelo Batista', '(61) 91234-1234', 'marcelo.batista@example.com'),
('Juliana Mendes', '(11) 93456-2345', 'juliana.mendes@example.com'),
('Henrique Duarte', '(21) 94567-3456', 'henrique.duarte@example.com'),
('Paula Nascimento', '(81) 95678-4567', 'paula.nascimento@example.com'),
('Eduardo Farias', '(31) 96789-5678', 'eduardo.farias@example.com'),
('Renata Alves', '(71) 97890-6789', 'renata.alves@example.com'),
('Tiago Martins', '(51) 98901-7890', 'tiago.martins@example.com'),
('Bianca Ferreira', '(19) 99012-8901', 'bianca.ferreira@example.com'),
('Rafael Borges', '(41) 91123-9012', 'rafael.borges@example.com'),
('Vanessa Costa', '(27) 92234-0123', 'vanessa.costa@example.com');

-- Inserir registros na tabela contratos
INSERT INTO contratos (propriedade_id, cliente_id, corretor_id, tipo_contrato, data_inicio, data_fim, valor, propostas_recusadas) VALUES
(5, 7, 3, 'Venda', '2025-01-15', '2025-01-15', 490000.90, TRUE),
(1, 10, 8, 'Aluguel', '2025-02-01', '2025-12-31', 45000.00, FALSE),
(8, 4, 5, 'Venda', '2025-03-20', '2025-03-20', 570000.70, FALSE),
(3, 6, 9, 'Venda', '2025-04-05', '2025-04-05', 780000.40, TRUE),
(2, 9, 1, 'Aluguel', '2025-05-10', '2025-12-31', 55000.60, FALSE),
(10, 2, 4, 'Venda', '2025-06-18', '2025-06-18', 410000.80, TRUE),
(7, 8, 7, 'Aluguel', '2025-07-22', '2025-12-31', 30000.50, FALSE),
(4, 3, 10, 'Venda', '2025-08-14', '2025-08-14', 320000.10, FALSE),
(6, 5, 2, 'Venda', '2025-09-03', '2025-09-03', 640000.20, TRUE),
(9, 1, 6, 'Venda', '2025-10-29', '2025-10-29', 860000.00, FALSE);

insert into variacao_precos (id_propriedade, data_alteracao, preco) values
(1, '2023-02-01', 260000.00),
(1, '2023-03-01', 270000.00),
(2, '2023-03-15', 310000.00),
(2, '2023-05-01', 320000.00),
(3, '2023-04-10', 510000.00),
(3, '2023-06-01', 530000.00),
(4, '2023-05-01', 360000.00),
(4, '2023-06-15', 370000.00),
(5, '2023-06-01', 460000.00),
(5, '2023-07-01', 480000.00),
(6, '2023-07-01', 230000.00),
(6, '2023-08-15', 240000.00),
(7, '2023-08-01', 390000.00),
(7, '2023-09-01', 400000.00),
(8, '2023-09-01', 420000.00);


-- Exercícios sobre CTE
/*1.	Identificar os tipos de imóveis mais caros com base na média de preços*/

-- •	Passo 1: Calcule a média geral de preços dos imóveis.
With cte_MediaPrecos as (
Select avg(valor) as media_geral from propriedades
),

-- •	Passo 2: Calcule a média de preços por tipo de imóvel.
cte_MediaPorTipo as (
select 
tipo,
avg(valor) media_tipo from propriedades
group by tipo)

-- •	Passo 3: Liste os tipos de imóveis com média acima da geral.
select
     tipo,
     media_tipo from cte_MediaPorTipo, cte_MediaPrecos
     where media_tipo > media_geral;

/*2.	Corretores que venderam mais de 5 imóveis nos últimos 12 meses
•	Passo 1: Filtre as vendas ocorridas nos últimos 12 meses.
•	Passo 2: Conte o total de vendas realizadas por cada corretor.
•	Passo 3: Liste os corretores com mais de 5 vendas.*/

/*3.	Cálculo do tempo médio para vender um imóvel
•	Passo 1: Calcule o tempo entre a data de início e a data de fim das vendas.
•	Passo 2: Calcule a média desse intervalo para todos os imóveis vendidos.*/

/*4.	Imóveis com maior variação de preço (histórico de alterações)
•	Passo 1: Analise o histórico de preços de cada imóvel.
•	Passo 2: Calcule a diferença entre o maior e o menor preço registrado.
•	Passo 3: Liste os imóveis com as maiores variações.*/

/*5.	Valor total de imóveis vendidos por cidade*/
-- •	Passo 1: Identifique a cidade no endereço de cada imóvel vendido.
With cte_cidade_endereco as(
  select cidade from Propriedades
),

-- •	Passo 2: Some o valor total de vendas por cidade.
cte_cidade_valor_total as (
select p.cidade as localidade, sum(c.valor) as valor_total_vendas from contratos c
join
propriedades p on p.id = c.propriedade_id
group by localidade)
select * from cte_cidade_valor_total;

-- •	Passo 3: Ordene as cidades pelo valor total em vendas.
select localidade, valor_total_vendas 
from cte_cidade_valor_total, cte_cidade_endereco
order by valor_total_vendas desc;

/*6.	Porcentagem de imóveis vendidos por tipo
•	Passo 1: Calcule o total de imóveis vendidos por tipo.
•	Passo 2: Calcule o total geral de vendas.
•	Passo 3: Determine a porcentagem de cada tipo em relação ao total geral.*/

/*7.	Imóveis que ficaram mais de 180 dias à venda
•	Passo 1: Calcule o tempo em dias entre o início e o fim de cada venda.
•	Passo 2: Filtre os imóveis com mais de 180 dias entre essas datas.*/

/*8.	Clientes com mais de uma compra
•	Passo 1: Conte o número de compras realizadas por cada cliente.
•	Passo 2: Filtre os clientes que realizaram mais de uma compra.*/

/*9.	Hierarquia de categorias de imóveis (CTE Recursiva)
•	Passo 1: Construa uma hierarquia de categorias (exemplo: Comercial > Loja > Shopping).
•	Passo 2: Monte uma estrutura recursiva para exibir a hierarquia completa.*/

/*
10.	Top 5 corretores com maior comissão acumulada
•	Passo 1: Calcule o total de comissão acumulada por corretor.
•	Passo 2: Ordene os corretores pelo total acumulado.
•	Passo 3: Liste os 5 melhores.
*/


-- Exercícios sobre Operadores de Conjunto

/*✅ 1. Clientes que são também corretores (mesmo nome e CPF)
Objetivo: Descobrir pessoas cadastradas tanto como cliente quanto como corretor.
Operador: INTERSECT
Justificativa: Interseção entre conjuntos com mesma estrutura evita múltiplos JOINs e WHEREs.*/

/*✅ 2. Imóveis ainda não vendidos ou com propostas recusadas
Objetivo: Listar imóveis que ou nunca foram vendidos ou tiveram vendas recusadas.
Operador: UNION
Justificativa: Combina dois conjuntos distintos com filtros diferentes.*/

/*✅ 3. Todos os contatos da imobiliária (clientes e corretores)
Objetivo: Unificar uma lista com todos os nomes e e-mails de clientes e corretores.
Operador: UNION
Justificativa: Ideal para consolidar contatos sem duplicação.*/

/*✅ 4. Imóveis que foram cadastrados por corretores, mas ainda não foram vendidos
Objetivo: Localizar imóveis ativos, prontos para venda.
Operador: EXCEPT
Justificativa: Excluir imóveis que já constam na tabela de vendas.*/

/*✅ 5. Clientes que compraram e também venderam imóveis (pessoa física ou jurídica)
Objetivo: Identificar quem atua dos dois lados da negociação.
Operador: INTERSECT
Justificativa: Conjunto de clientes que aparecem nos dois papéis.*/

/*✅ 6. Corretores que nunca venderam nenhum imóvel
Objetivo: Encontrar corretores inativos em vendas.
Operador: EXCEPT
Justificativa: Remove do total de corretores os que aparecem na tabela de vendas.*/

/*✅ 7. Todos os imóveis anunciados ou vendidos em 2024
Objetivo: Consolidar a base de imóveis movimentados em 2024.
Operador: UNION ALL
Justificativa: Traz todos os imóveis sem eliminar duplicatas (para análise de volume real).*/

/*✅ 8. Corretores que atuaram em 2023 mas não em 2024
Objetivo: Detectar corretores que estão inativos neste ano.
Operador: EXCEPT
Justificativa: Remove os corretores ativos em 2024 do conjunto de 2023.*/

/*✅ 9. Imóveis anunciados em cidades distintas de onde foram vendidos
Objetivo: Encontrar imóveis com cidade de cadastro diferente da cidade de venda.
Operador: EXCEPT ou INTERSECT (dependendo da estrutura dos conjuntos comparados).
Justificativa: Permite comparar dois conjuntos com base em cidade de origem vs cidade de venda.*/

/*✅ 10. Clientes e corretores com e-mails duplicados (possível erro de cadastro)
Objetivo: Validar integridade dos dados.
Operador: INTERSECT
Justificativa: Ideal para detectar sobreposição de informações de contato.*/