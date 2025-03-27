create database esocial;
use esocial;
create table tb_empregadores(
    id_empregador INT PRIMARY KEY,
    nome_empregador VARCHAR(100),
    cnpj_empregador VARCHAR(14),
    endereco VARCHAR(200),
    telefone VARCHAR(20)
);
create table tb_empregados(
    id_empregado INT PRIMARY KEY,
    nome_empregado VARCHAR(100),
    cpf_empregado VARCHAR(11),
    data_admissao DATE,
    id_empregador INT,
    foreign key (id_empregador) references tb_empregadores(id_empregador)
);
create table tb_folhaPagamentos(
    id_folha INT PRIMARY KEY,
    id_empregado INT,
    mes_referencia DATE,
    valor_salario DECIMAL(10, 2),
    valor_inss DECIMAL(10, 2),
    valor_fgts DECIMAL(10, 2),
    foreign key(id_empregado) references tb_empregados(id_empregado)
);
CREATE TABLE tb_afastamentos (
    id_afastamento INT PRIMARY KEY,
    id_empregado INT,
    data_inicio DATE,
    data_fim DATE,
    motivo VARCHAR(200),
    FOREIGN KEY (id_empregado) REFERENCES tb_empregados(id_empregado)
);
create table tb_cat(
    id_cat INT PRIMARY KEY,
    id_empregado INT,
    data_acidente DATE,
    tipo_acidente VARCHAR(100),   
    descricao VARCHAR(200),
    FOREIGN KEY (id_empregado) REFERENCES tb_empregados(id_empregado)
);
CREATE TABLE tb_avisoPrevio (
    id_aviso_previo INT PRIMARY KEY,
    id_empregado INT,
    data_aviso DATE,
    FOREIGN KEY (id_empregado) REFERENCES tb_empregados(id_empregado)
);
CREATE TABLE tb_demissao (
    id_demissao INT PRIMARY KEY,
    id_empregado INT,
    data_demissao DATE,
    FOREIGN KEY (id_empregado) REFERENCES tb_empregados(id_empregado)
);
INSERT INTO tb_empregadores (id_empregador, nome_empregador, cnpj_empregador, endereco, telefone) VALUES
(1, 'Empresa A', '12345678901234', 'Rua A, 123', '11111111'),
(2, 'Empresa B', '23456789012345', 'Rua B, 456', '22222222'),
(3, 'Empresa C', '34567890123456', 'Rua C, 789', '33333333'),
(4, 'Empresa D', '45678901234567', 'Rua D, 987', '44444444'),
(5, 'Empresa E', '56789012345678', 'Rua E, 654', '55555555');
select tb_empregadores;

INSERT INTO tb_empregados (id_empregado, nome_empregado, cpf_empregado, data_admissao, id_empregador) VALUES
(1, 'João', '12345678901', '2022-01-01', 1),
(2, 'Maria', '23456789012', '2022-02-01', 1),
(3, 'Pedro', '34567890123', '2022-03-01', 2),
(4, 'Ana', '45678901234', '2022-04-01', 2),
(5, 'Carlos', '56789012345', '2022-05-01', 3);
select * from tb_empregados;

INSERT INTO tb_folhaPagamentos (id_folha, id_empregado, mes_referencia, valor_salario, valor_inss, valor_fgts) VALUES
(1, 1, '2022-01-01', 3000.00, 300.00, 270.00),
(2, 2, '2022-01-01', 2500.00, 250.00, 225.00),
(3, 3, '2022-01-01', 3500.00, 350.00, 315.00),
(4, 4, '2022-01-01', 2800.00, 280.00, 252.00),
(5, 5, '2022-01-01', 3200.00, 320.00, 288.00);
select * from tb_folhaPagamentos;

INSERT INTO tb_afastamentos (id_afastamento, id_empregado, data_inicio, data_fim, motivo) VALUES
(1, 1, '2022-02-01', '2022-02-05', 'Licença médica'),
(2, 2, '2022-03-01', '2022-03-05', 'Licença maternidade'),
(3, 3, '2022-04-01', '2022-04-05', 'Licença médica'),
(4, 4, '2022-05-01', '2022-05-05', 'Licença maternidade'),
(5, 5, '2022-06-01', '2022-06-05', 'Licença médica');
select * from tb_afastamentos;

INSERT INTO tb_cat (id_cat, id_empregado, data_acidente, tipo_acidente, descricao) VALUES
(1, 1, '2022-03-15', 'Acidente de trabalho', 'Fratura no braço'),
(2, 2, '2022-04-15', 'Acidente de trabalho', 'Torção no tornozelo'),
(3, 3, '2022-05-15', 'Acidente de trabalho', 'Corte no dedo'),
(4, 4, '2022-06-15', 'Acidente de trabalho', 'Queimadura na mão'),
(5, 5, '2022-07-15', 'Acidente de trabalho', 'Lesão nas costas');
select * from tb_cat;

INSERT INTO tb_avisoPrevio (id_aviso_previo, id_empregado, data_aviso) VALUES
(1, 1, '2022-02-15'),
(2, 2, '2022-03-15'),
(3, 3, '2022-04-15'),
(4, 4, '2022-05-15'),
(5, 5, '2022-06-15');
select * from tb_avisoPrevio;

INSERT INTO tb_demissao (id_demissao, id_empregado, data_demissao) VALUES
(1, 1, '2022-02-28'),
(2, 2, '2022-03-31'),
(3, 3, '2022-04-30'),
(4, 4, '2022-05-31'),
(5, 5, '2022-06-30');

/*1. Liste o nome do empregador e o nome do empregado que possuem o mesmo id_empregador.*/

select 
	  nome_empregador, 
	  nome_empregado 
 from 
	tb_empregadores emp
      inner join
	tb_empregados e 
       on 
        emp.id_empregador = e.id_empregador;

/*2. Exiba o nome do empregador, o nome do empregado e a data de admissão do empregado para todos os registros da tabela Empregados,
	                mesmo que não haja correspondência com a tabela Empregadores.*/

select 
      nome_empregador,
	  nome_empregado,
	  data_admissao 
 from
	tb_empregados e
      right join
	tb_empregadores emp 
       on 
        e.id_empregador = emp.id_empregador;

/*3. Liste o nome do empregador e o nome do empregado apenas para os registros em que o empregado possui uma folha de pagamento.*/

select 
      nome_empregador,
	  nome_empregado, 
	  valor_salario
 from 
	tb_empregados e
       join 
	tb_empregadores emp 
        on
         e.id_empregador = emp.id_empregador
       inner join
	tb_folhaPagamentos fp 
        on
         fp.id_empregado = e.id_empregado;

/*4. Exiba o nome do empregador e o nome do empregado para todos os registros da tabela Empregadores, mesmo que não haja correspondência com a tabela Empregados.*/

select 
      nome_empregador,
      nome_empregado 
 from 
	tb_empregadores emp
       left join 
	tb_empregados e 
        on
         emp.id_empregador = e.id_empregador;

/*5. Liste o nome do empregador, o nome do empregado e o mês de referência da folha de pagamento para todos os registros da tabela FolhaPagamentos.*/

select 
      nome_empregador,
      nome_empregado,
      mes_referencia 
 from 
	tb_folhaPagamentos fp
       left join 
	tb_empregados e 
        on 
         fp.id_empregado = e.id_empregado
       left join 
	tb_empregadores emp 
        on 
         e.id_empregador = emp.id_empregador;

/*6. Exiba o nome do empregador, o nome do  empregado, o cpf do empregado e o motivo de afastamento do empregado apenas para os registros em que o empregado possui um afastamento.*/

select 
      nome_empregador,
      nome_empregado,
      cpf_empregado,
      motivo
 from
	tb_empregados e
	   right join
	tb_afastamentos af 
        on 
         e.id_empregado = af.id_empregado
       left join
	tb_empregadores emp 
        on 
         e.id_empregador = emp.id_empregador;

/*7. Liste o nome do empregador e o tipo de acidente do empregado apenas para os registros em que o empregado possui uma Comunicação de Acidente de Trabalho (CAT).*/

select 
      nome_empregador,
      tipo_acidente 
 from 
	tb_empregados e
      inner join 
	tb_cat c 
       on 
        c.id_empregado = e.id_empregado
	  join 
	tb_empregadores emp 
       on 
        e.id_empregador = emp.id_empregador;
  
/*8. Exiba o nome do empregador e a data de aviso do empregado apenas para os registros em que o empregado possui um aviso prévio.*/

select
      nome_empregador,
      nome_empregado,
      data_aviso
 from
	tb_empregados e 
      inner join
    tb_avisoPrevio a 
       on 
        a.id_empregado = e.id_empregado
      left join
    tb_empregadores emp 
       on 
        emp.id_empregador = e.id_empregador;

/*9. Liste o nome do empregador e a data de demissão do empregado apenas para os registros em que o empregado possui uma demissão registrada.*/

select 
      nome_empregador,
      nome_empregado,
      data_demissao 
 from 
	tb_empregados e
      inner join 
	tb_empregadores emp 
       on 
	    e.id_empregador = emp.id_empregador
	  inner join 
	tb_demissao d 
       on d.id_empregado = e.id_empregado;