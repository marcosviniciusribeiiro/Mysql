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

select * from tb_cargo;

INSERT INTO tb_departamento
(id_departamento, nm_departamento) VALUES
(100, 'Administrativo'),
(200, 'Jurídico'),
(300, 'Contábil'),
(400, 'Tecnologia da Informação'),
(500, 'Recursos Humanos'),
(600, 'Comercial'),
(700, 'Financeiro');
select * from tb_departamento;

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
    COUNT(*)
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
    d.nm_departamento, ROUND(AVG(salario), 2) AS media_salario
FROM
    tb_departamento d
        JOIN
    tb_empregado e ON e.fk_departamento = d.id_departamento
        JOIN
    tb_cargo c ON e.fk_cargo = c.id_cargo
WHERE
    c.salario > 5000
GROUP BY nm_departamento;


SELECT 
    matricula, nome, nm_departamento
FROM
    tb_empregado,
    tb_departamento
WHERE
    fk_departamento = id_departamento
ORDER BY nome;

    
SELECT 
    nome, salario, nm_departamento AS departamento, dt_admissao
FROM
    tb_empregado e
        JOIN
    tb_cargo c ON e.fk_cargo = c.id_cargo
        JOIN
    tb_departamento d ON d.id_departamento = e.fk_departamento
HAVING salario > 3000
ORDER BY nm_departamento;

SELECT 
    matricula, nome, nm_cargo AS cargo, salario
FROM
    tb_empregado,
    tb_cargo
WHERE
    fk_cargo = id_cargo
ORDER BY nome;

SELECT 
    matricula, nome, nm_cargo AS cargo, salario
FROM
    tb_empregado e
        JOIN
    tb_cargo c ON c.id_cargo = e.fk_cargo
ORDER BY nome;

SELECT 
    e.nome AS empregados,
    c.nm_cargo AS cargo_empregado,
    d.nm_departamento AS departamento
FROM
    tb_empregado e
        INNER JOIN
    tb_departamento d ON e.fk_departamento = d.id_departamento
        INNER JOIN
    tb_cargo c ON e.fk_cargo = c.id_cargo
ORDER BY e.nome;
  

SELECT 
    d.nm_departamento AS departamento, e.nome AS empregados
FROM
    tb_empregado e
        RIGHT JOIN
    tb_departamento d ON e.fk_departamento = d.id_departamento
WHERE
    e.fk_departamento IS NULL;