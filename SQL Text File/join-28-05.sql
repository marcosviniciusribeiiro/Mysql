CREATE DATABASE DB_JOIN;
USE DB_JOIN;

CREATE TABLE `tb_cargo` (
  id_cargo int NOT NULL,
  cargo varchar(50) NOT NULL,
  salario decimal(10,2) NOT NULL,
  PRIMARY KEY (id_cargo)
);

INSERT INTO tb_cargo
(id_cargo, cargo, salario)
VALUES (1,'Analista de Sistemas',5000.00),(2,'DBA',7500.00),(3,'Desenvolvedor',4000.00),(4,'Gerente de Projeto',8500.00),(5,'Estagiário',900.00);


CREATE TABLE tb_departamento (
  id_departamento int NOT NULL,
  departamento varchar(80) NOT NULL,
  PRIMARY KEY (id_departamento)
);

INSERT INTO tb_departamento (id_departamento, departamento)
VALUES
(100,'Admistrativo'),(200,'Jurídico'),(300,'Contábil'),(400,'Tecnologia da Informação'),(500,'Recursos Humanos'),(600,'Comercial'),(700,'Financeiro');



CREATE TABLE tb_empregado (
  matricula int NOT NULL,
  nome varchar(80) NOT NULL,
  sexo enum('M','F') NOT NULL,
  email varchar(80) NOT NULL,
  dt_nascimento date NOT NULL,
  dt_admissao date NOT NULL,
  fk_cargo int ,
  fk_departamento int,
  PRIMARY KEY (matricula),
  FOREIGN KEY (fk_cargo) REFERENCES tb_cargo (id_cargo),
  FOREIGN KEY (fk_departamento) REFERENCES tb_departamento (id_departamento)
);



INSERT INTO tb_empregado
(matricula, nome, sexo, email, dt_nascimento, dt_admissao, fk_cargo, fk_departamento) values
(102,'Pedro','M','pedro@gmail.com','2001-01-10','2021-07-23',5,NULL),
(123,'Maria','F','maria@gmail.com','1990-05-20','2019-11-15',1,300),
(147,'Carlos','M','carlos@gmail.com','1985-03-15','2019-08-10',1,100),
(150,'Natalia','F','nati@gmail.com','2001-01-15','2021-07-21',NULL,200),
(258,'André','M','andre@gmail.com','1998-03-10','2020-06-10',3,200),
(369,'Amanda','F','amanda@gmail.com','1995-03-25','2021-01-01',2,300),
(456,'João','M','joao@gmail.com','1985-01-02','2020-01-10',2,NULL),
(789,'Renata','F','renata@gmail.com','2000-01-25','2021-05-05',5,500);
select * from tb_empregado;




select nome,cargo,salario
from tb_empregado,tb_cargo where  id_cargo =fk_cargo;

select matricula,nome,departamento
 from tb_departamento,tb_empregado
 where  fk_departamento = id_departamento;
 
 -- selecione a matricula,nome,cargo,salario e departamento do emrpegado
 select matricula,nome, cargo,salario,departamento from tb_cargo,tb_departamento,tb_empregado
 where id_cargo=fk_cargo and id_departamento=fk_departamento;
 
 select matricula,nome, cargo,salario,departamento from tb_cargo,tb_departamento,tb_empregado
 where id_cargo=fk_cargo 
 and id_departamento=fk_departamento 
 and salario >5000;
 
 
 /*inner jion*/
 select nome,cargo,salario 
 from tb_empregado inner join tb_cargo 
 on id_cargo = fk_cargo;
 
 /*left join- neste caso vai selscionar todos empregados mesmo aqueles que tenham cargo null */
  select nome,cargo,salario 
 from tb_empregado left join tb_cargo 
 on id_cargo = fk_cargo;
 
 /*right join- neste caso vai selscionar todos cargos  mesmo aqueles que não tenha empregado associados */
 select nome,cargo,salario 
 from tb_empregado right join tb_cargo 
 on id_cargo = fk_cargo;
 
 select matricula,nome,departamento from tb_empregado 
 inner join tb_departamento on id_departamento = fk_departamento;
 
  select matricula,nome,departamento from tb_empregado 
 left join tb_departamento on id_departamento = fk_departamento;
 
  select matricula,nome,departamento from tb_empregado 
 right join tb_departamento on id_departamento = fk_departamento;
 
 select matricula,nome,departamento from tb_empregado 
 right join tb_departamento on id_departamento = fk_departamento
 where fk_departamento is null;
 
 select matricula,nome,cargo,salario from tb_empregado 
 left join tb_cargo on id_cargo = fk_cargo
 where fk_cargo is null;