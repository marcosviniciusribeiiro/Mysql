DROP DATABASE IF EXISTS ClinicaVida;

CREATE DATABASE IF NOT EXISTS ClinicaVida;

USE ClinicaVida;

-- Tabela Pacientes
CREATE TABLE IF NOT EXISTS Pacientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    data_nascimento DATE,
    sexo CHAR(1),
    ativo BOOLEAN
);

-- Tabela Medicos
CREATE TABLE IF NOT EXISTS Medicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    especialidade VARCHAR(50)
);

-- Tabela Consultas
CREATE TABLE IF NOT EXISTS Consultas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    id_medico INT,
    data_consulta DATE,
    status VARCHAR(20), -- Agendada, Realizada, Cancelada
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id),
    FOREIGN KEY (id_medico) REFERENCES Medicos(id)
);

-- Tabela Exames
CREATE TABLE IF NOT EXISTS Exames (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    categoria VARCHAR(50), -- Laboratorial, Imagem, Cardiológico
    preco DECIMAL(10,2)
);

-- Tabela Exames_Pacientes
CREATE TABLE IF NOT EXISTS Exames_Pacientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    id_exame INT,
    data_exame DATE,
    resultado VARCHAR(100),
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id),
    FOREIGN KEY (id_exame) REFERENCES Exames(id)
);

-- Inserts Pacientes
INSERT INTO Pacientes (nome, data_nascimento, sexo, ativo) VALUES
('Ana Lima', '1985-06-12', 'F', TRUE),
('Bruno Costa', '1990-01-22', 'M', TRUE),
('Carla Souza', '1975-09-30', 'F', FALSE),
('Diego Martins', '2000-03-15', 'M', TRUE),
('Elaine Rocha', '1965-11-18', 'F', TRUE),
('Fabio Gomes', '1982-12-05', 'M', TRUE),
('Gisele Torres', '1999-04-09', 'F', TRUE),
('Henrique Alves', '1978-08-27', 'M', FALSE),
('Isabela Mendes', '1988-02-11', 'F', TRUE),
('João Silva', '1995-07-19', 'M', TRUE);

-- Inserts Medicos
INSERT INTO Medicos (nome, especialidade) VALUES
('Dr. André Reis', 'Cardiologia'),
('Dra. Beatriz Pinto', 'Pediatria'),
('Dr. Carlos Dias', 'Clínico Geral'),
('Dra. Daniela Cruz', 'Ginecologia'),
('Dr. Eduardo Melo', 'Ortopedia'),
('Dra. Fernanda Lira', 'Dermatologia'),
('Dr. Gustavo Freitas', 'Neurologia'),
('Dra. Helena Barreto', 'Psiquiatria'),
('Dr. Ivan Leite', 'Endocrinologia'),
('Dra. Juliana Prado', 'Oftalmologia');

-- Inserts Consultas
INSERT INTO Consultas (id_paciente, id_medico, data_consulta, status) VALUES
(1, 1, '2024-04-01', 'Realizada'),
(2, 2, '2024-04-02', 'Agendada'),
(3, 3, '2024-03-30', 'Cancelada'),
(4, 4, '2024-04-03', 'Realizada'),
(5, 5, '2024-04-05', 'Agendada'),
(6, 6, '2024-04-06', 'Realizada'),
(7, 7, '2024-04-07', 'Agendada'),
(8, 8, '2024-03-29', 'Cancelada'),
(9, 9, '2024-04-08', 'Realizada'),
(10, 10, '2024-04-10', 'Agendada');

-- Inserts Exames
INSERT INTO Exames (nome, categoria, preco) VALUES
('Hemograma', 'Laboratorial', 50.00),
('Raio-X Tórax', 'Imagem', 120.00),
('Eletrocardiograma', 'Cardiológico', 150.00),
('Ultrassom Abdominal', 'Imagem', 200.00),
('Glicemia', 'Laboratorial', 30.00),
('Ressonância Magnética', 'Imagem', 800.00),
('Ecocardiograma', 'Cardiológico', 300.00),
('Colesterol Total', 'Laboratorial', 40.00),
('Tomografia Computadorizada', 'Imagem', 600.00),
('Mapa 24h', 'Cardiológico', 250.00);

-- Inserts Exames_Pacientes
INSERT INTO Exames_Pacientes (id_paciente, id_exame, data_exame, resultado) VALUES
(1, 1, '2024-04-01', 'Normal'),
(2, 2, '2024-04-02', 'Alteração leve'),
(3, 3, '2024-03-30', 'Normal'),
(4, 4, '2024-04-03', 'Normal'),
(5, 5, '2024-04-04', 'Acima do normal'),
(6, 6, '2024-04-05', 'Normal'),
(7, 7, '2024-04-06', 'Anormal'),
(8, 8, '2024-04-07', 'Normal'),
(9, 9, '2024-04-08', 'Alteração moderada'),
(10, 10, '2024-04-09', 'Normal');

-- Procedures com IF
/*1.Verificar Ativação de Paciente
Crie uma procedure que receba o nome do paciente e 
retorne uma mensagem indicando se ele está 
ativo ou inativo.*/
delimiter //
create procedure paciente_ativo(
in nome_paciente varchar(100),
out msg_atividade varchar (20)
)
begin
declare v_paciente_ativo boolean;
select ativo 
into v_paciente_ativo
from Pacientes
where nome = nome_paciente;
if v_paciente_ativo = TRUE then
  set msg_atividade = 'Ativo';
elseif v_paciente_ativo = FALSE then
  set msg_atividade = 'Inativo';
else
  set msg_atividade = 'Paciente inválido';
 end if;
end
// delimiter ;

call paciente_ativo('Bruno Costa', @mensagem);

select @mensagem;

/*2.Classificação de Exame por Preço
Crie uma procedure que receba o nome de um exame e 
retorne se ele é 
"Baixo custo" (até R$100), 
"Médio custo" (entre R$101 e R$500) 
ou "Alto custo" (acima de R$500).*/
drop procedure if exists exame_por_preco;
delimiter //
create procedure exame_por_preco(
in nome_exame VARCHAR(100),
out msg_custo varchar(20))
begin
declare v_preco decimal(6,2);
select preco 
into v_preco
from exames
where nome = nome_exame;
if v_preco <= 100 then
  set msg_custo = 'Baixo custo';
elseif v_preco between 101 and 500 then
  set msg_custo = 'Médio custo';
elseif v_preco > 500 then
  set msg_custo = 'Alto custo';
else
  set msg_custo = 'Exame inválido';
end if;
end
// delimiter ;

call exame_por_preco('Tomografia Computadorizada', @mensagem);

select @mensagem;

/*3.Verificar Consulta Agendada
Crie uma procedure que receba o ID de um paciente 
e informe se ele possui consultas agendadas.*/
drop procedure verificar_consulta_agendada;
delimiter //
create procedure verificar_consulta_agendada(
in id_paciente int,
out msg_consulta varchar(20))
begin
declare v_status varchar(20);
select status 
into v_status
from consultas
where id = id_paciente;

if v_status = 'Agendada' then
  set msg_consulta = 'Consulta agendada';
elseif v_status = 'Realizada' then
  set msg_consulta = 'Consulta realizada';
elseif v_status = 'Cancelada' then
  set msg_consulta = 'Consulta cancelada';
else
  set msg_consulta = 'Sem consultas';
end if;
end
// delimiter ;

call verificar_consulta_agendada(7, @mensagem);

select @mensagem;

/*4.Determinar Faixa Etária de Paciente
Crie uma procedure que receba o nome do paciente e 
informe se ele é "Criança" (menor que 12), "Adolescente" (12–17), "Adulto" (18–59) ou "Idoso" (60+).*/
delimiter //
create procedure faixa_etaria_paciente(
in nome_paciente varchar(100),
out fx_msg varchar(20))
begin
declare v_idade int;
select timestampdiff(year, data_nascimento, curdate())
into v_idade
from pacientes
where nome = nome_paciente;
if v_idade is null then
  set fx_msg = 'Idade não foi registrada';
elseif v_idade < 12 then
  set fx_msg = 'Criança';
elseif v_idade between 12 and 17 then
  set fx_msg = 'Adolescente';
elseif v_idade between 18 and 59 then
  set fx_msg = 'Adulto';
else
  set fx_msg = 'Idoso';
end if;
end
// delimiter ;

call faixa_etaria_paciente('Ana Lima', @mensagem);

select @mensagem;

/*5.Verificar se o exame realizado teve resultado normal
Crie uma procedure que receba o ID do exame_paciente 
e informe se o resultado foi “Normal” ou “Necessita Acompanhamento”.*/
drop procedure resultado_exame;
delimiter //
create procedure resultado_exame(
in exame_id int,
out msg_resultado varchar(30)
)
begin
declare v_resultado varchar(100);
select resultado
into v_resultado
from exames_pacientes
where id_exame = exame_id;
if v_resultado is null then
  set msg_resultado = 'Sem exames';
elseif v_resultado = 'Normal' then
  set msg_resultado = 'Normal';
elseif v_resultado != 'Normal' then
  set msg_resultado = 'Necessita Acompanhamento';
end if;
end
// delimiter ;

call resultado_exame(5, @mensagem);

select @mensagem;

-- Procedures com CASE (5 questões)
/*6.Mensagem conforme Status da Consulta
Crie uma procedure que receba o ID da consulta 
e retorne: "Consulta realizada", "Consulta agendada" ou "Consulta cancelada".*/

/*7.Classificar Especialidade do Médico
Crie uma procedure que receba o nome do médico 
e retorne uma mensagem personalizada conforme a especialidade (ex: "Especialista em coração" para Cardiologia, etc.).*/

/*8.Categoria do Exame em linguagem leiga
Crie uma procedure que receba o nome do exame 
e retorne: "Exame de sangue", "Exame por imagem" ou "Exame do coração", conforme a categoria.*/

/*9.Classificação do Resultado do Exame
Crie uma procedure que receba o resultado 
e retorne: "Resultado normal", "Resultado alterado" ou "Resultado não reconhecido".*/

/*10.Mensagem conforme Sexo do Paciente
Crie uma procedure que receba o nome do paciente 
e retorne: "Paciente do sexo masculino", "Paciente do sexo feminino" ou "Sexo não identificado".*/

