drop database if exists ReservaLeitosHospital;
-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS ReservaLeitosHospital;
USE ReservaLeitosHospital;

-- Tabela de Pacientes
CREATE TABLE Pacientes (
    id_paciente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    email VARCHAR(100) 
);

-- Tabela de Leitos
CREATE TABLE Leitos (
    id_leito INT PRIMARY KEY AUTO_INCREMENT,
    numero_quarto INT NOT NULL,
    tipo VARCHAR(50) -- Ex: UTI, Enfermaria, etc.
);

-- Tabela de Reservas
CREATE TABLE Reservas (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT,
    id_leito INT,
    data_reserva DATE,
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (id_leito) REFERENCES Leitos(id_leito)
);


-- Inserção de dados de exemplo
INSERT INTO Pacientes (nome, data_nascimento, email) VALUES
    ('Ana Silva', '1990-05-15', 'ana.silva@email.com'),
    ('Bruno Pereira', '1985-10-23', 'bruno.pereira@email.com'),
    ('Carla Rodrigues', '2000-02-01', 'carla.rodrigues@email.com'),
    ('Mariana Souza', '1988-07-21', 'mariana.souza@email.com'), 
    ('Rafael Almeida', '1995-03-10', 'rafael.almeida@email.com'), 
    ('Juliana Castro', '1982-11-05', 'juliana.castro@email.com'), 
    ('Gustavo Lima', '2001-09-18', 'gustavo.lima@email.com'), 
    ('Beatriz Nunes', '1979-06-30', 'beatriz.nunes@email.com');

INSERT INTO Pacientes (nome, data_nascimento) VALUES
    ('Fulano de Tal', '1975-09-18'), 
    ('Beltrano de Tal', '1982-06-30');

INSERT INTO Leitos (numero_quarto, tipo) VALUES
    (101, 'Enfermaria'),
    (102, 'UTI'),
    (201, 'Enfermaria'),
    (202, 'UTI'), 
    (301, 'Enfermaria'), 
    (302, 'UTI'), 
    (401, 'Pediátrico'), 
    (402, 'Pediátrico');

INSERT INTO Reservas (id_paciente, id_leito, data_reserva) VALUES
    (1, 7, '2023-11-01'),
    (2, 2, '2023-11-05'),
    (3, 2, '2023-11-10'),
    (4, 2, '2023-11-15'), 
    (1, 5, '2023-11-20'), 
    (6, 7, '2023-11-25'), 
    (3, 7, '2023-11-30'), 
    (4, 8, '2023-12-01');
select * from reservas;
-- Exercícios sobre Views

/*1. View de pacientes maiores de idade
Crie uma view chamada vw_pacientes_maiores_idade que liste o nome e a data de nascimento dos pacientes que já completaram 18 anos.*/
create or replace view vw_pacientes_maiores_idade as
select 
	 nome,
	 data_nascimento
from 
   pacientes
where 
    timestampdiff(year, data_nascimento, curdate()) > 18;

select * from vw_pacientes_maiores_idade;

/*2. View de pacientes com reservas feitas em novembro
Crie uma view vw_reservas_novembro que exiba o nome do paciente e a data da reserva, 
somente para reservas realizadas no mês de novembro de qualquer ano.*/
create or replace view vw_reservas_novembro as
select 
	 p.nome, 
     r.data_reserva 
from 
   reservas r
  join 
   pacientes p on p.id_paciente = r.id_paciente
where 
    data_reserva like '%11%';

select * from vw_reservas_novembro;

/*3. View de quartos UTI ocupados
Crie uma view vw_utis_ocupadas que exiba o número do quarto e a data da reserva para todos os leitos do tipo "UTI" que foram reservados.*/
create or replace view vw_utis_ocupadas as
select 
	 l.numero_quarto, 
     r.data_reserva 
from 
   reservas r
  join 
   leitos l on l.id_leito = r.id_leito 
order by 
    numero_quarto;

select * from vw_utis_ocupadas;

/*4. View de pacientes ordenados por idade
Crie uma view vw_pacientes_idade que mostre o nome do paciente e sua idade
(calculada a partir da data de nascimento), ordenados do mais velho para o mais novo.*/
create or replace view vw_pacientes_idade as
select 
     nome, 
     timestampdiff(year, data_nascimento, curdate()) as idade
from 
   pacientes
order by 
    data_nascimento;

select * from vw_pacientes_idade;

/*5. View de total de reservas por paciente
Crie uma view vw_reservas_por_paciente que exiba o nome do paciente e a quantidade total de reservas feitas por ele(a).*/
create or replace view vw_reservas_por_paciente as
select 
     p.nome, 
     count(r.id_paciente) as reservas 
from 
   reservas r
  join 
   pacientes p on p.id_paciente = r.id_paciente
group by 
    r.id_paciente;

select * from vw_reservas_por_paciente;

/*6. View de pacientes com múltiplas reservas
Crie uma view vw_pacientes_multiplas_reservas que mostre o nome e o e-mail dos pacientes que possuem mais de uma reserva registrada.*/
create or replace view vw_pacientes_multiplas_reservas as
select 
	 p.nome,
     p.email
from 
   pacientes p
  join
   reservas r on p.id_paciente = r.id_paciente
group by 
    p.id_paciente, p.nome, p.email
having 
     count(r.id_reserva) > 1;

select * from vw_pacientes_multiplas_reservas;

/*7. View de ocupação detalhada por tipo de leito
Crie uma view vw_ocupacao_por_tipo que exiba o tipo do leito, 
a quantidade total de leitos desse tipo existentes no hospital, e quantos foram reservados.*/
create or replace view vw_ocupacao_por_tipo as
select 
     l.tipo, 
     count(*) as total_leitos, 
     count(r.id_reserva) as reservados 
from 
   leitos l
  join 
   reservas r on l.id_leito = r.id_leito
group by 
    l.tipo;

select * from vw_ocupacao_por_tipo;

/*8. View de uso percentual dos leitos
Crie uma view vw_percentual_ocupacao que mostre para cada tipo de leito: 
a quantidade total de leitos, o total de reservas e o percentual de ocupação (reservas ÷ total × 100).*/
create or replace view vw_percentual_ocupacao as
select 
     l.tipo,
     count(distinct l.id_leito) as qt_total_leitos,
     count(r.id_reserva) as total_reservas,
     round(
	    cast(count(r.id_reserva) as decimal(10,2)) / count(distinct l.id_leito) * 100, 2
     ) as percentual_ocupacao
from 
   leitos l
  left join
   reservas r on l.id_leito = r.id_leito
group by 
    l.tipo;

select * from vw_percentual_ocupacao;

/*9. View de reservas nos últimos 30 dias
Crie uma view vw_reservas_recentes que exiba o nome do paciente, 
o número do quarto e a data da reserva somente para as reservas feitas nos últimos 30 dias a partir da data atual.*/
create or replace view vw_reservas_recentes as
select 
     p.nome, 
     l.numero_quarto, 
     r.data_reserva 
from 
   reservas r
  join 
   pacientes p on r.id_paciente = p.id_paciente
  join 
   leitos l on l.id_leito = r.id_leito
where 
    timestampdiff(day, data_reserva, curdate()) <= 30;

select * from vw_reservas_recentes;

/*10.	View de pacientes sem e-mail
Crie uma view vw_pacientes_sem_email que mostre os pacientes cujo campo de e-mail está vazio ou nulo.*/
create or replace view vw_pacientes_sem_email as 
select 
     nome, 
     data_nascimento 
from 
   pacientes
where 
    email is null;

select * from vw_pacientes_sem_email;


/*11.	View de reservas completas
Crie uma view vw_reservas_completas que exiba o nome do paciente, a data de nascimento do paciente, 
o número do quarto, o tipo do leito e a data da reserva.*/
create or replace view vw_reservas_completas as
select 
     p.nome, 
     p.data_nascimento, 
     l.numero_quarto, 
     l.tipo as tipo_leito, 
     r.data_reserva 
from 
   reservas r
  join 
   pacientes p on p.id_paciente = r.id_paciente
  join 
   leitos l on l.id_leito = r.id_leito;

select * from vw_reservas_completas;

/*12.	View de pacientes pediátricos
Crie uma view vw_pacientes_pediatricos que mostre o nome, o número do quarto pediátrico reservado, 
e a data da reserva dos pacientes que utilizaram leitos do tipo “Pediátrico”.*/
create or replace view vw_pacientes_pediatricos as
select 
     p.nome, 
     l.numero_quarto, 
     r.data_reserva 
from 
   reservas r
  join 
   pacientes p on p.id_paciente = r.id_paciente 
  join 
   leitos l on l.id_leito = r.id_leito
where 
    l.tipo = 'Pediátrico';

select * from vw_pacientes_pediatricos;