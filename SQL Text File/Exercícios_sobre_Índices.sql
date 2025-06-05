/*use exemplo_index;

CREATE INDEX idx_cliente ON clientes(nome);

SET profiling = 1;
select * from vendas where cliente_id = 123456;
show profiles;

alter table vendas drop index idx_cliente;
alter table vendas drop index idx_data;


SELECT 
TABLE_NAME, 
INDEX_NAME, 
COLUMN_NAME, 
NON_UNIQUE, 
SEQ_IN_INDEX, 
INDEX_TYPE 
FROM information_schema.STATISTICS 
WHERE 
TABLE_SCHEMA = 'exemplo_index' 
ORDER BY 
TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;


ALTER TABLE vendas ADD COLUMN observacoes TEXT; 
ALTER TABLE vendas ADD FULLTEXT INDEX idx_observacoes (observacoes);

UPDATE vendas SET observacoes = 'Cliente reclamou do atraso na entrega' WHERE id = 123; 
UPDATE vendas SET 
observacoes = 'Venda realizada com desconto especial' WHERE id = 124;

select * from vendas where match(observacoes) against("desconto");*/



-- Lista de Exercícios sobre Índices
/*1. Importar dump
Carregue o arquivo Dump_ecommercedb_20250513_v3.rar no MySQL Workbench para restaurar a base de dados de teste.*/
use ecommercedb;

/*2. Verificar índices existentes
Liste todos os índices existentes no banco ecommercedb.*/
Select
table_name,
index_name,
column_name,
non_unique,
seq_in_index,
index_type
from information_schema.statistics
where table_schema = 'ecommercedb'
order by
table_name, index_name, seq_in_index;

/*3. Criar índice simples
Crie um índice para a coluna estado da tabela clientes. Depois, execute a consulta abaixo com e sem índice e compare usando EXPLAIN:
SELECT * FROM clientes WHERE estado = 'SP';*/

drop index idx_estado on clientes;

SET profiling = 1;
SELECT * FROM clientes WHERE estado = 'SP';
show profiles;
-- Houve uma diferença na execução da query sem index (0.27195450ms) para (0.23760690ms) com o index idx_estado

/*4. Criar índice composto
Crie um índice em clientes(estado, cidade) e verifique se ele é usado em:
SELECT * FROM clientes WHERE estado = 'SP' AND cidade = 'Campinas';*/
create index idx_estado_cidade on clientes(estado, cidade);

set profiling = 1;
SELECT * FROM clientes WHERE estado = 'SP' AND cidade = 'Campinas';
show profiles;

-- o index não foi usado pois não existem clientes registrados que são do estado de Sp e da cidade de Campinas

/*5. Usar EXPLAIN ANALYZE
Verifique o plano de execução detalhado:
EXPLAIN ANALYZE SELECT * FROM pedidos WHERE id_cliente = 123456 AND status = 'Pago';*/

EXPLAIN SELECT * FROM pedidos WHERE id_cliente = 123456 AND status = 'Pago';

/*6. Criar índice para otimizar join
Crie um índice em itenspedido(id_produto) e otimize a seguinte consulta:
SELECT p.nome, SUM(i.quantidade)
FROM produtos p
JOIN itenspedido i ON p.id_produto = i.id_produto
GROUP BY p.nome;*/


CREATE INDEX idx_itenspedido_id_produto ON itenspedido(id_produto);
create index idx_p_id_produto on produtos(id_produto);


set profiling = 1;
/*SELECT p.nome, SUM(i.quantidade)
FROM produtos p
JOIN itenspedido i ON p.id_produto = i.id_produto
GROUP BY p.nome;
show profiles;*/

EXPLAIN SELECT p.nome, SUM(i.quantidade)
FROM produtos p
JOIN itenspedido i ON p.id_produto = i.id_produto
GROUP BY p.nome;


/*7. FULLTEXT em comentários
Adicione um campo descricao_curta em produtos, crie um índice FULLTEXT e execute:
SELECT * FROM produtos WHERE MATCH(descricao_curta) AGAINST ('moderno');*/
alter table produtos add column descricao_curta text;
alter table produtos add fulltext index idx_descricao_curta(descricao_curta);

select * from produtos;
update produtos set descricao_curta = 'moderno' where id_produto = 1;
select * from produtos where match(descricao_curta) against ('moderno');

/*8. Comparar FULLTEXT vs LIKE
Compare com:
SELECT * FROM produtos WHERE descricao_curta LIKE '%moderno%';
Analise performance com EXPLAIN.*/

select * from produtos where match(descricao_curta) against ('moderno');
explain select * from produtos where match(descricao_curta) against ('moderno');

SELECT * FROM produtos WHERE descricao_curta LIKE '%moderno%';
explain SELECT * FROM produtos WHERE descricao_curta LIKE '%moderno%';

-- por causa do index, a query utilizando o fulltext é bem mais rapida, afetando somente as linhas que possuem descricao_curta like '%moderno%', do que utilizando o like, que faz query entre todos os  494902 linhas de registros para retornar os registros que possuem a descricao_curta like '%moderno%'

/*9. Desempenho com LIKE sem índice
Execute:
SELECT * FROM produtos WHERE nome LIKE '%fone%';
Crie um índice em nome e repita a consulta. O índice foi usado?*/
select * from produtos where nome like '%Voluptates%';

create index idx_nome on produtos(nome);
explain select * from produtos where nome like '%Voluptates%';

-- o indice não foi usado pois a query utiliza o like para filtrar os registros

/*10. Criar índice com baixa seletividade
Crie um índice em clientes(sexo) e teste:
SELECT * FROM clientes WHERE sexo = 'F';
O índice foi ignorado?*/

desc clientes;

create index idx_sexo on clientes(sexo);
explain select * from clientes where sexo = 'F';

-- o index foi utilizado, deu para verificar utilizando o expain select * from clientes where sexo = 'F';

/*11. Índice em tabela pequena
Crie um índice em categorias(nome) e execute:
SELECT * FROM categorias WHERE nome = 'Eletrônicos';
Analise com EXPLAIN.*/

desc categorias;
create index idx_categoria_nome on categorias(nome);

explain select * from categorias where nome = 'Laborum';

-- o explain nos mostra que o index foi utilizado 'Using index condition' 

/*12. Indexar campo de data
Crie um índice em pedidos(data_pedido) e verifique:
SELECT * FROM pedidos WHERE data_pedido BETWEEN '2024-01-01' AND '2024-12-31';*/
set profiling = 1;
create index idx_pedido_data_pedido on pedidos(data_pedido);
SELECT * FROM pedidos WHERE data_pedido BETWEEN '2025-05-13' AND '2025-05-30';
show profiles;

/*13. Indexar histórico por cliente e data
Crie um índice composto em historicovisualizacoes(id_cliente, data_visualizacao) e use-o:
SELECT * FROM historicovisualizacoes WHERE id_cliente = 123456 AND data_visualizacao > '2024-01-01';*/
create index idx_cliente_data on historicovisualizacoes(id_cliente, data_visualizacao);

explain SELECT * FROM historicovisualizacoes WHERE id_cliente = 123456 AND data_visualizacao > '2024-01-01';

-- o index está sendo utilizado para procurar e retornar os selects que atendam o id_cliente = 123456 and data_visualizacao > '2024-01-01', retornando 4 registros;

/*14. Medir tempo com profiling
Ative profiling, execute uma consulta e veja o tempo:
SET profiling = 1;
SELECT * FROM pedidos WHERE status = 'Pago';
SHOW PROFILES;*/
set profiling = 1;
select * from pedidos where status = 'Pago';
show profiles;

-- foi possivel indentificar que a query levou cerca de 0.05442650ms para ser executada mesmo possuindo 500000 registros na tabela de pedidos

/*15. Verificar uso de índice com ORDER BY
Crie índice:
CREATE INDEX idx_preco ON produtos(preco);
Execute:
SELECT * FROM produtos ORDER BY preco DESC LIMIT 10;*/

/*16. Verificar queries mais lentas (Performance Schema)
Execute:
SELECT * FROM performance_schema.events_statements_summary_by_digest
ORDER BY AVG_TIMER_WAIT DESC
LIMIT 5;*/

/*17. Criar índice em avaliações
Crie índice composto em avaliacoes(id_produto, nota) e execute:
SELECT AVG(nota) FROM avaliacoes WHERE id_produto = 10001;*/

/*18. Testar índice ignorado pela ordem dos filtros
Crie:
CREATE INDEX idx_estado_nome ON clientes(estado, nome);
Execute:
SELECT * FROM clientes WHERE nome = 'João';
O índice foi usado?*/

/*19. Consultar cliente mais ativo
Use historicovisualizacoes para listar o cliente com mais visualizações:
SELECT id_cliente, COUNT(*) AS total
FROM historicovisualizacoes
GROUP BY id_cliente
ORDER BY total DESC
LIMIT 1;
Otimize com índice adequado.*/

/*20. Índices que prejudicam INSERT
Crie índices em todas as colunas de pedidos. Meça o tempo de inserção de 10 mil pedidos. Remova os índices e compare.*/


