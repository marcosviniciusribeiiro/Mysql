CREATE DATABASE db_company;

use db_company;

/*criar a tabela tb_cargo*/
CREATE TABLE tb_cargo (
    id_cargo INT NOT NULL PRIMARY KEY,
    nm_cargo VARCHAR(60) NOT NULL,
    salario DECIMAL(9 , 2 ) NOT NULL
);
/*criar a tabela departamento*/ 
CREATE TABLE tb_departamento (
    id_departamento INT NOT NULL PRIMARY KEY,
    nm_departamento VARCHAR(40) NOT NULL
);
CREATE TABLE tb_empregado (
    matricula INT NOT NULL PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    dt_nascimento DATE NOT NULL,
    sexo ENUM('F', 'M') NOT NULL,
    dt_admissao DATE NOT NULL,
    fk_cargo INT NOT NULL,
    fk_departamento INT NOT NULL,
    FOREIGN KEY (fk_cargo)
        REFERENCES tb_cargo (id_cargo),
    FOREIGN KEY (fk_departamento)
        REFERENCES tb_departamento (id_departamento)
);
insert into tb_cargo 
(id_cargo, nm_cargo, salario) values
(1, 'Advogado', 9200.00),
(2 , 'Administrador', 6500.00),
(3, 'Contador', 5600.00),
(4, 'Estagiário', 980.00),
(5, 'Gerente de Projeto', 8300.00),
(6, 'Programador', 7500.00),
(7, 'Administrador de Banco de Dados', 5990.00),
(8, 'Cientista de Dados', 8700.00),
(9, 'Secretária', 2200.00);

INSERT INTO tb_departamento
(id_departamento, nm_departamento) VALUES
(100, 'Administrativo'),
(200, 'Jurídico'),
(300, 'Contábil'),
(400, 'Tecnologia da Informação'),
(500, 'Recursos Humanos'),
(600, 'Comercial'),
(700, 'Financeiro');

SELECT
    MAX(salario) AS maior_salario
FROM
    tb_cargo;

SELECT 
    MIN(salario) AS menor_salario
FROM
    tb_cargo;

SELECT 
    AVG(salario) AS media_salario
FROM
    tb_cargo;


SELECT 
    ROUND(AVG(salario), 2) AS media_salario
FROM
    tb_cargo;

INSERT INTO tb_empregado(matricula, nome, dt_nascimento, sexo,
dt_admissao, fk_cargo, fk_departamento) VALUES
(123, 'Vânia Alves', '1967-07-02', 'F', '2010-12-08', 2, 100),
(124, 'Florisbela Silva', '1999-10-02', 'F', '2019-10-01', 1, 200),
(125, 'Walter Amaral', '1998-02-02', 'M', '2018-05-25', 7, 400),
(126, 'Ana Cristina Peixoto', '1980-03-02', 'F', '2018-10-02', 4, 200),
(127, 'Clara Rodrigues', '1998-07-05', 'F', '2020-10-02', 4, 400),
(128, 'Flávio Luiz Silva', '1990-09-05', 'M', '2016-02-15', 6, 400),
(129, 'Roberto Oliveira', '1981-03-10', 'M', '2012-12-10', 8, 400),
(130, 'Cristina Moura', '1980-12-20', 'F', '2020-10-02', 9, 100),
(131, 'Gabriel Silva Costa', '1985-10-2', 'M', '2017-01-02', 3,300);
SELECT 
    *
FROM
    tb_empregado;


SELECT 
    COUNT(*) as total_empregados
FROM
    tb_empregado;


SELECT 
    SUM(matricula)
FROM
    tb_empregado;


SELECT 
    d.nm_departamento, COUNT(matricula) AS total_empregados
FROM
    tb_empregado e
        JOIN
    tb_departamento d ON fk_departamento = id_departamento
GROUP BY d.nm_departamento;


SELECT 
    d.nm_departamento, ROUND(AVG(c.salario), 2) AS salario_medio
FROM
    tb_departamento d
        JOIN
    tb_empregado e ON e.fk_departamento = d.id_departamento
        JOIN
    tb_cargo c ON e.fk_cargo = c.id_cargo
GROUP BY nm_departamento;


SELECT 
    d.nm_departamento AS departamento,
    ROUND(AVG(salario), 2) AS salario_medio
FROM
   tb_departamento d
	 JOIN
   tb_empregado e ON e.fk_departamento = d.id_departamento
	 JOIN
   tb_cargo c ON e.fk_cargo = c.id_cargo
GROUP BY d.nm_departamento
 HAVING AVG(c.salario) > 5000;


SELECT 
    d.nm_departamento, 
    ROUND(AVG(salario), 2) AS media_salario
FROM
   tb_departamento d
	 JOIN
   tb_empregado e ON e.fk_departamento = d.id_departamento
	 JOIN
   tb_cargo c ON e.fk_cargo = c.id_cargo
WHERE
    c.salario > 5000
GROUP BY d.nm_departamento;


select
	 matricula, 
     nome, 
     nm_departamento 
from 
   tb_empregado, tb_departamento
where 
    fk_departamento = id_departamento
order by nome;


select 
     e.nome, 
     c.salario, 
     d.nm_departamento as departamento, 
     e.dt_admissao 
from 
   tb_empregado e
     join 
   tb_cargo c on e.fk_cargo = c.id_cargo
     join 
  
  tb_departamento d  on d.id_departamento = e.fk_departamento
having c.salario >3000
  order by d.nm_departamento;

SELECT 
    matricula, nome, nm_cargo as cargo, salario
FROM
    tb_empregado,
    tb_cargo
WHERE
    fk_cargo = id_cargo
    order by nome;

SELECT 
    e.matricula, e.nome, c.nm_cargo as cargo, c.salario
FROM
    tb_empregado e
        join
    tb_cargo c ON c.id_cargo = e.fk_cargo
ORDER BY e.nome;

select 
  e.nome as empregados,
  c.nm_cargo as cargo_empregado, 
  d.nm_departamento as departamento 
from tb_empregado e
 inner join tb_departamento d on e.fk_departamento = d.id_departamento
 inner join tb_cargo c on e.fk_cargo = c.id_cargo
  order by e.nome;
  

select 
     d.nm_departamento as departamento,
	 e.nome as empregados
from 
 tb_empregado e
  right join 
 tb_departamento d
  on e.fk_departamento = d.id_departamento
  where e.fk_departamento is null;
  
  
select 
	 d.nm_departamento, 
	 count(e.matricula) as total_empregados 
from 
    tb_departamento d
      left join
    tb_empregado e on d.id_departamento = e.fk_departamento
 group by d.nm_departamento; /*agrupar valores iguais numa tabela*/


select 
     d.nm_departamento as departamentos, 
     count(e.matricula) as total_empregados 
from 
   tb_departamento d
     left join 
   tb_empregado e on d.id_departamento = e.fk_departamento
 group by d.nm_departamento
  having count(e.matricula)> 1; /* uma condição de busca que envolve uma função agregadora. */


select curdate() as 'data'; /* retorna a data do sistema operacional */

select curtime() as 'hora'; /* retorna a hora do sistema operacional */

select now() as 'data-hora'; /* data e a hora do sistema operacional */

select
     nome,
     date_format(dt_nascimento, '%d/%M/%Y') as nascimento /* formata uma data para dia-mês-ano */
from
   tb_empregado;
   
select nome, 
       year(dt_nascimento) as ano_nascimento, 
       month(dt_nascimento) as mes_nascimento
from 
   tb_empregado; /* retorna somente o ano e mês de nascimento */

select nome,
       timestampdiff(year, dt_nascimento, curdate()) as idade /* calcula uma diferença entre duas datas */
from 
   tb_empregado
order by nome;

select year(curdate()); /* seleciona o ano atual */


/*Lista de exercícios sobre group by e having:*/

/* 1. Total de empregados por departamento */
select d.nm_departamento as departamentos, count(e.matricula) from tb_departamento d
left join
tb_empregado e on d.id_departamento = e.fk_departamento
group by d.nm_departamento;

/*2. Salário médio por cargo*/
select c.nm_cargo as cargo, 
       avg(c.salario) as media_salario 
from tb_cargo c
group by c.nm_cargo;

/*3. Número de empregados por sexo em cada departamento*/
select 
     d.nm_departamento as departamento, 
	 e.sexo,
	 count(e.matricula) as matriculas
from 
   tb_empregado e   
	 inner join
   tb_departamento d on d.id_departamento = e.fk_departamento
group by d.nm_departamento,e.sexo;

/*4. Salário total por departamento*/
select 
     d.nm_departamento as departamento, 
     sum(c.salario) as salario_total
from 
   tb_cargo c
     inner join 
   tb_empregado e on c.id_cargo = e.fk_cargo
     inner join 
   tb_departamento d on d.id_departamento = e.fk_departamento
group by departamento;

/*5. Média de idade dos empregados por cargo*/
select nm_cargo,
       avg(timestampdiff(year, dt_nascimento, curdate())) as idade from tb_cargo 
    inner join
      tb_empregado on id_cargo = fk_cargo
      group by nm_cargo;
      
/*6. Número de empregados admitidos em cada ano*/
select year(dt_admissao), count(matricula) from tb_empregado
group by year(dt_admissao);

/*7. Departamentos com mais de 10 empregados*/
select 
     nm_departamento, 
     count(matricula) 
from 
   tb_departamento
     inner join tb_empregado on id_departamento = fk_departamento
group by nm_departamento
having count(matricula)>10;

/*8. Cargos com salário médio acima de 5000*/
 select * from tb_cargo;
 select nm_cargo as cargos, avg(salario) as salario_medio from tb_cargo
 group by nm_cargo
 having avg(salario)>5000;
 
/*9. Número de empregados por departamento e cargo*/
select 
     nm_departamento as departamentos, 
	 nm_cargo as cargos, 
	 count(matricula) as matricula 
from 
   tb_empregado e
      inner join 
   tb_departamento d on d.id_departamento = e.fk_departamento
      inner join 
   tb_cargo c on c.id_cargo = e.fk_cargo
group by nm_departamento, nm_cargo;

/*10. Departamentos com salário total acima de 100000*/
select 
     nm_departamento as Departamentos,
     sum(salario) as salario_total 
from 
   tb_departamento
     inner join
   tb_empregado on id_departamento = fk_departamento 
     inner join
   tb_cargo on id_cargo = fk_cargo
group by nm_departamento
having sum(salario)>100000;

/*11. Média de anos de empresa por cargo*/
select nm_cargo as cargos,
       avg(timestampdiff(year, dt_admissao, curdate())) as media_anos from tb_cargo
       inner join tb_empregado on id_cargo = fk_cargo
       group by nm_cargo;
/*12. Departamentos com mais de 5 empregados do sexo feminino*/
select 
     d.nm_departamento,
     e.sexo,
     count(e.matricula) from tb_departamento d
     inner join
     tb_empregado e on d.id_departamento = e.fk_departamento
     where sexo like 'f'
group by nm_departamento, sexo;

/*13. Número de empregados por cargo com mais de 10 anos na empresa*/
select c.nm_cargo as cargo,
       count(e.matricula) as matriculas,
       timestampdiff(year, e.dt_admissao, curdate()) as anos
       from tb_empregado e
       inner join
       tb_cargo c on c.id_cargo = e.fk_cargo
       group by cargo
       having anos > 10;

/*14. Cargos com menos de 2 empregados*/
select 
     nm_cargo,
     count(matricula) 
from 
   tb_empregado
     inner join 
   tb_cargo on id_cargo = fk_cargo
group by nm_cargo
 having count(matricula)<2;

/*15. Salário médio por departamento com mais de 2 empregados*/
select nm_departamento, avg(salario), count(matricula) as matricula from tb_empregado
inner join tb_cargo on id_cargo = fk_cargo
inner join tb_departamento on id_departamento = fk_departamento
group by nm_departamento
having matricula >2;












