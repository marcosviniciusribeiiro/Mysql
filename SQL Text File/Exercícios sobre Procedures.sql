-- Lista de Exercícios sobre Procedures
DROP DATABASE IF EXISTS PlanoSaudeDB;
CREATE DATABASE PlanoSaudeDB;

USE PlanoSaudeDB;

CREATE TABLE Beneficiarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    data_nascimento DATE,
    sexo ENUM('M', 'F', 'Outro'),
    cpf CHAR(14) UNIQUE,
    status ENUM('Ativo', 'Inativo', 'Cancelado'),
    plano_id INT,
    data_adesao DATE
);

CREATE TABLE Planos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_plano VARCHAR(100),
    tipo ENUM('Individual', 'Familiar', 'Empresarial'),
    mensalidade DECIMAL(10,2),
    cobertura TEXT,
    coparticipacao BOOLEAN
);

CREATE TABLE Prestadores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    tipo ENUM('Hospital', 'Clínica', 'Profissional'),
    cnpj CHAR(18),
    especialidade VARCHAR(100),
    credenciado BOOLEAN
);

CREATE TABLE Procedimentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    codigo_tuss VARCHAR(10) UNIQUE,
    valor DECIMAL(10,2),
    exige_autorizacao BOOLEAN
);

CREATE TABLE Autorizacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    beneficiario_id INT,
    prestador_id INT,
    procedimento_id INT,
    data_solicitacao DATE,
    status ENUM('Pendente', 'Aprovado', 'Negado'),
    data_resposta DATE,
    justificativa TEXT,
    FOREIGN KEY (beneficiario_id) REFERENCES Beneficiarios(id),
    FOREIGN KEY (prestador_id) REFERENCES Prestadores(id),
    FOREIGN KEY (procedimento_id) REFERENCES Procedimentos(id)
);

CREATE TABLE Reembolsos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    beneficiario_id INT,
    procedimento_id INT,
    valor_solicitado DECIMAL(10,2),
    valor_aprovado DECIMAL(10,2),
    data_solicitacao DATE,
    status ENUM('Em análise', 'Aprovado', 'Negado'),
    FOREIGN KEY (beneficiario_id) REFERENCES Beneficiarios(id),
    FOREIGN KEY (procedimento_id) REFERENCES Procedimentos(id)
);

CREATE TABLE Consultas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    beneficiario_id INT,
    prestador_id INT,
    data_consulta DATE,
    procedimento_id INT,
    valor_cobrado DECIMAL(10,2),
    coparticipacao_pago DECIMAL(10,2),
    FOREIGN KEY (beneficiario_id) REFERENCES Beneficiarios(id),
    FOREIGN KEY (prestador_id) REFERENCES Prestadores(id),
    FOREIGN KEY (procedimento_id) REFERENCES Procedimentos(id)
);

CREATE TABLE AuditoriaProcedimentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    consulta_id INT,
    data_auditoria DATE,
    auditor_nome VARCHAR(100),
    resultado ENUM('Conforme', 'Não Conforme'),
    observacao TEXT,
    FOREIGN KEY (consulta_id) REFERENCES Consultas(id)
);

INSERT INTO Planos (id, nome_plano, tipo, mensalidade, cobertura, coparticipacao) VALUES 
(1, 'Vida Leve', 'Individual', 1223.47, 'acompanhamento pré-natal', 1),
(2, 'Vida Leve', 'Empresarial', 248.37, 'tratamentos fisioterapêuticos', 1),
(3, 'Saúde Total', 'Individual', 1342.46, 'internações e cirurgias', 0),
(4, 'Bem Viver', 'Familiar', 520.44, 'tratamentos odontológicos', 1),
(5, 'Vida Leve', 'Empresarial', 426.28, 'consultas com especialistas', 0),
(6, 'Vida Leve', 'Individual', 792.72, 'atendimento ambulatorial', 0),
(7, 'Vida Leve', 'Familiar', 536.47, 'atendimento de urgência e emergência', 0),
(8, 'Saúde Total', 'Familiar', 212.81, 'consultas e exames básicos', 0),
(9, 'Cuidar+', 'Empresarial', 1097.29, 'exames laboratoriais', 1),
(10, 'Saúde Total', 'Empresarial', 1306.98, 'cobertura nacional', 1);

INSERT INTO Beneficiarios (nome, data_nascimento, sexo, cpf, status, plano_id, data_adesao) VALUES
 ('Anthony Oliveira', '2013-07-27', 'M', '920.654.781-01', 'Cancelado', 5, '2021-01-31'),
 ('Stephany Vieira', '1974-03-13', 'F', '106.438.295-98', 'Cancelado', 10, '2020-10-03'),
 ('Alexia Nunes', '2004-11-22', 'F', '524.196.807-58', 'Inativo', 10, '2023-03-08'),
 ('Luiz Felipe Nogueira', '2002-05-01', 'Outro', '615.479.802-49', 'Ativo', 1, '2023-04-04'),
 ('Leandro Rodrigues', '1958-04-29', 'F', '658.247.930-00', 'Ativo', 8, '2023-07-22'),
 ('Diego da Rocha', '1957-07-31', 'F', '831.967.452-28', 'Inativo', 2, '2021-05-18'),
 ('Sr. Samuel Nunes', '1990-09-09', 'M', '875.960.124-85', 'Cancelado', 4, '2020-04-17'),
 ('Luiz Otávio Jesus', '1945-07-30', 'M', '031.682.594-89', 'Ativo', 10, '2024-07-27'),
 ('Matheus Souza', '1971-05-12', 'M', '327.964.108-03', 'Ativo', 1, '2024-05-03'),
 ('Valentina Moura', '1977-03-04', 'M', '384.972.065-92', 'Ativo', 6, '2021-12-02');

INSERT INTO Prestadores (nome, tipo, cnpj, especialidade, credenciado) VALUES 
('Peixoto Ltda.', 'Hospital', '07.186.492/0001-09', 'Clínica Geral', 0),
('Ribeiro Fernandes S.A.', 'Profissional', '87.256.034/0001-20', 'Clínica Geral', 1),
('Novaes', 'Profissional', '73.458.612/0001-04', 'Cardiologia', 0),
('Martins', 'Hospital', '96.184.035/0001-05', 'Pediatria', 1),
('Pereira S/A', 'Clínica', '31.605.874/0001-04', 'Dermatologia', 1),
('Costela S/A', 'Clínica', '63.849.107/0001-29', 'Ortopedia', 0),
('Teixeira', 'Clínica', '87.235.610/0001-52', 'Cardiologia', 0),
('Jesus', 'Clínica', '53.781.962/0001-91', 'Ortopedia', 1),
('Lopes', 'Profissional', '41.056.783/0001-02', 'Ortopedia', 0),
('Lima Gomes e Filhos', 'Profissional', '73.165.482/0001-03', 'Cardiologia', 0);

INSERT INTO Procedimentos (nome, codigo_tuss, valor, exige_autorizacao) VALUES 
('Ressonância', '724952', 1529.44, 1),
('Consulta Médica', '934043', 1568.92, 1),
('Exame de Sangue', '620419', 413.78, 1),
('Cirurgia Simples', '367034', 1087.4, 0),
('Ressonância', '881455', 841.29, 0),
('Exame de Sangue', '174006', 514.22, 0),
('Consulta Médica', '262966', 1392.0, 0),
('Vacinação', '446853', 1475.43, 0),
('Consulta Médica', '368009', 51.66, 0),
('Consulta Médica', '79515', 476.33, 1);

INSERT INTO Autorizacoes (beneficiario_id, prestador_id, procedimento_id, data_solicitacao, status, data_resposta, justificativa) VALUES 
(5, 10, 5, '2024-06-05', 'Pendente', '2025-03-21', 'Procedimento necessário.'),
(10, 6, 7, '2024-10-24', 'Aprovado', '2025-03-31', 'Solicitação urgente.'),
(7, 5, 6, '2024-07-11', 'Negado', '2025-04-03', 'Paciente com dor.'),
(5, 5, 9, '2025-01-07', 'Negado', '2025-03-28', 'Exame de rotina.'),
(7, 7, 5, '2024-08-05', 'Pendente', '2025-03-24', 'Recomendação médica.'),
(5, 8, 3, '2025-03-16', 'Negado', '2025-03-28', 'Solicitado em consulta.'),
(1, 1, 7, '2024-04-08', 'Pendente', '2025-03-21', 'Tratamento contínuo.'),
(2, 1, 8, '2024-09-30', 'Pendente', '2025-03-29', 'Queixa recorrente.'),
(8, 4, 6, '2024-09-23', 'Pendente', '2025-03-30', 'Prescrição recente.'),
(1, 2, 3, '2024-10-03', 'Pendente', '2025-03-31', 'Acompanhamento exigido.');

INSERT INTO Reembolsos (beneficiario_id, procedimento_id, valor_solicitado, valor_aprovado, data_solicitacao, status) VALUES
 (4, 8, 279.46, 154.1, '2024-10-20', 'Aprovado'),
 (3, 7, 362.09, 270.6, '2024-10-24', 'Em análise'),
 (9, 7, 1361.12, 559.31, '2025-03-19', 'Em análise'),
 (10, 2, 1257.77, 493.07, '2025-03-09', 'Negado'),
 (7, 9, 477.65, 31.71, '2025-03-10', 'Aprovado'),
 (8, 6, 183.44, 65.51, '2025-03-13', 'Negado'),
 (3, 6, 1110.0, 793.99, '2024-12-13', 'Aprovado'),
 (2, 8, 1886.36, 286.33, '2024-10-14', 'Aprovado'),
 (8, 10, 1965.8, 545.22, '2025-01-04', 'Em análise'),
 (6, 10, 180.11, 168.87, '2025-03-06', 'Negado');

INSERT INTO Consultas (beneficiario_id, prestador_id, data_consulta, procedimento_id, valor_cobrado, coparticipacao_pago) VALUES
 (4, 1, '2025-03-19', 7, 981.59, 209.24),
 (7, 6, '2025-03-08', 3, 959.63, 437.77),
 (1, 4, '2025-01-22', 4, 382.1, 99.29),
 (7, 5, '2025-03-11', 8, 517.94, 187.52),
 (10, 4, '2025-03-23', 6, 870.43, 138.71),
 (5, 5, '2025-01-13', 5, 133.25, 18.24),
 (5, 3, '2025-03-07', 9, 526.13, 143.23),
 (1, 10, '2025-01-15', 6, 352.18, 132.71),
 (8, 10, '2025-02-18', 2, 124.16, 29.27),
 (3, 2, '2025-02-26', 8, 475.21, 215.24);

INSERT INTO AuditoriaProcedimentos (consulta_id, data_auditoria, auditor_nome, resultado, observacao) VALUES
 (1, '2025-03-27', 'Valentina Cardoso', 'Não Conforme', 'Procedimento fora do padrão.'),
 (2, '2025-03-01', 'Cauê Correia', 'Não Conforme', 'Inconsistência nos registros.'),
 (3, '2025-03-19', 'Letícia Silva', 'Não Conforme', 'Falha na documentação.'),
 (4, '2025-03-02', 'Sr. Diogo Freitas', 'Conforme', 'Tudo de acordo.'),
 (5, '2025-03-02', 'João Lucas Gomes', 'Conforme', 'Conforme protocolo.'),
 (6, '2025-03-18', 'Nicole Mendes', 'Conforme', 'Nada a declarar.'),
 (7, '2025-03-20', 'Eduarda Ferreira', 'Não Conforme', 'Informação incompleta.'),
 (8, '2025-02-26', 'Eduardo da Costa', 'Conforme', 'Atendimento adequado.'),
 (9, '2025-03-11', 'Dra. Maria Alice Vieira', 'Conforme', 'Sem irregularidades.'),
 (10, '2025-03-09', 'Melissa Santos', 'Não Conforme', 'Divergência nos valores.');
 
/*Exercício 1: 	Criar uma procedure que exibe todos os planos cadastrados
Passos:
1.	Use DELIMITER para permitir blocos de código.
2.	Crie a procedure com CREATE PROCEDURE.
3.	Use um simples SELECT * FROM Planos*/
drop procedure if exists planos_cadastrados;
delimiter //
create procedure planos_cadastrados()
begin
Select * from Planos;
end
// delimiter ;

call planos_cadastrados;

/*Exercício 2: 	Criar uma procedure que exibe os beneficiários ativos
Passos:
1.	Crie uma procedure sem parâmetros.
2.	Dentro dela, faça SELECT * FROM Beneficiarios WHERE status = 'Ativo';*/
drop procedure if exists beneficiarios_ativos;
delimiter //
create procedure beneficiarios_ativos()
begin
Select * from Beneficiarios 
where status = 'Ativo';
end
// delimiter ;

call beneficiarios_ativos;

/*Exercício 3: 	Criar uma procedure que exibe os procedimentos que exigem autorização
Passos:
1.	Crie uma procedure sem parâmetros.
2.	Use SELECT nome, valor FROM Procedimentos WHERE exige_autorizacao = TRUE;*/
drop procedure if exists procedimentos_autorizados;
delimiter //
create procedure procedimentos_autorizados()
begin
Select nome, valor from Procedimentos
where exige_autorizacao = TRUE;
end
// delimiter ;

call procedimentos_autorizados;

/*Exercício 4: 	Criar uma procedure que recebe um nome de plano e exibe sua mensalidade
Passos:
1.	Crie uma procedure com parâmetro de entrada nomePlano VARCHAR(100).
2.	Faça SELECT mensalidade FROM Planos WHERE nome_plano = nomePlano;*/
drop procedure if exists plano_mensalidade;
delimiter //
create procedure plano_mensalidade(
in nomePlano varchar(100)
)
begin
Select mensalidade from Planos
where nome_plano = nomePlano;
end
// delimiter ;

call plano_mensalidade('Cuidar+');

/*Exercício 5: 	Criar uma procedure que lista os reembolsos com status 'Aprovado'
Passos:
1.	Procedure simples com SELECT * FROM Reembolsos WHERE status = 'Aprovado';*/
drop procedure if exists lista_de_reembolsos;
delimiter //
create procedure lista_de_reembolsos()
begin
Select * from Reembolsos
where status = 'Aprovado';
end
// delimiter ;

call lista_de_reembolsos;

/*Exercício 6: 	Criar uma procedure que recebe o nome de um beneficiário e retorna seu plano
Passos:
1.	Use um parâmetro de entrada nomeBen VARCHAR(100).
2.	Faça SELECT P.nome_plano FROM Beneficiarios B JOIN Planos P ON B.plano_id = P.id WHERE B.nome = nomeBen;*/
drop procedure if exists beneficiario_plano;
delimiter //
create procedure beneficiario_plano(
in nomeBen varchar(100)
)
begin
Select p.nome_plano as plano
from Beneficiarios b 
join Planos p on b.plano_id = p.id
where b.nome = nomeBen;
end
// delimiter ;

call beneficiario_plano('Anthony Oliveira');

/*Exercício 7: 	Criar uma procedure que exibe as consultas com coparticipação maior que 100
Passos:
1.	Procedure sem parâmetros.
2.	SELECT * FROM Consultas WHERE coparticipacao_pago > 100;*/
delimiter //
create procedure coparticipacao_maior_que_100()
begin
select * from Consultas where coparticipacao_pago > 100;
end
// delimiter ;

call coparticipacao_maior_que_100;

/*Exercício 8: 	Criar uma procedure que retorna todos os prestadores credenciados
Passos:
1.	Procedure simples.
2.	SELECT * FROM Prestadores WHERE credenciado = TRUE;*/
delimiter //
create procedure prestadores_credenciados()
begin
select * from Prestadores
where credenciado = TRUE;
end 
// delimiter ;

call prestadores_credenciados;

/*Exercício 9: 	Criar uma procedure que retorna as autorizações com status 'Pendente'
Passos:
1.	Procedure simples com SELECT * FROM Autorizacoes WHERE status = 'Pendente';*/
delimiter //
create procedure autorizacoes_pendentes()
begin
select * from Autorizacoes
where status = 'Pendente';
end
// delimiter ;

call autorizacoes_pendentes;

/*Exercício 10: 	Criar uma procedure que mostra o valor total cobrado nas consultas
Passos:
1.	Procedure com SELECT SUM(valor_cobrado) AS total FROM Consultas;*/
delimiter //
 Create procedure valor_total_consultas()
begin
select sum(valor_cobrado) as total from Consultas;
end
// delimiter ;

call valor_total_consultas;

/*Exercício 11: 	Criar uma procedure que lista beneficiários acima de 60 anos com status ativo
Passos mínimos:
1.	Calcule a idade usando TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()).
2.	Combine com WHERE status = 'Ativo'.
3.	Faça SELECT nome, data_nascimento, plano_id.*/
drop procedure if exists beneficiarios_idosos;
delimiter //
create procedure beneficiarios_idosos()
begin
select nome, data_nascimento, plano_id from Beneficiarios
where timestampdiff(year, data_nascimento, curdate()) > 60 and status = 'Ativo';
end
// delimiter ;

call beneficiarios_idosos;

/*Exercício 12: 	Criar uma procedure que conta quantos procedimentos exigem autorização e quantos não exigem
Passos mínimos:
1.	Use SELECT COUNT(*) com WHERE exige_autorizacao = TRUE e FALSE.
2.	Retorne os dois totais.
3.	Use SELECT com alias AS para nomear as colunas.*/

drop procedure if exists autorizacao_procedimentos;
delimiter //
create procedure autorizacao_procedimentos()
begin
select 
count(case 
       when exige_autorizacao = true then 1 end) as autorizados,
count(case
	   when exige_autorizacao = false then 1 end) as ñ_autorizados 
from Procedimentos;
end
// delimiter ;

call autorizacao_procedimentos();

/*Exercício 13: 	Criar uma procedure que recebe o nome de um plano e informa se ele possui coparticipação
Passos mínimos:
1.	Parâmetro de entrada: nomePlano VARCHAR(100).
2.	Busque com SELECT coparticipacao FROM Planos WHERE nome_plano = nomePlano LIMIT 1;.
3.	Use IF ou CASE para retornar mensagem como: "Plano com coparticipação" ou "Sem coparticipação".*/
drop procedure coparticipacao_plano;
delimiter //
create procedure coparticipacao_plano(
in nomePlano varchar(100),
out mensagemPlano varchar(100)
)
begin
declare p_coparticipacao boolean;
select coparticipacao 
into p_coparticipacao
from Planos 
where nome_plano = nomePlano
limit 1;

if p_coparticipacao = TRUE then 
  set mensagemPlano = 'Plano com coparticipação';
elseif p_coparticipacao = FALSE then 
  set mensagemPlano = 'Sem coparticipação';
else
  set mensagemPlano = 'Plano não encontrado ou valor inválido';
end if;
end
// delimiter ;

call coparticipacao_plano('Saúde Total', @mensagem);

select @mensagem;

/*Exercício 14: 	Criar uma procedure que recebe o nome de um prestador e informa se ele está credenciado
Passos mínimos:
1.	Use SELECT credenciado com WHERE nome = ?.
2.	Use IF ou CASE para mostrar mensagem como "Credenciado" ou "Não credenciado".*/
drop procedure prestador_credenciado;
delimiter //
create procedure prestador_credenciado
(
in nomePrestador varchar(100),
out c_mensagem varchar(100)
)
begin
declare p_credenciado boolean;
select credenciado
into p_credenciado
from Prestadores
where nome = nomePrestador;

if p_credenciado = TRUE then
  set c_mensagem = 'Credenciado';
elseif p_credenciado = FALSE then
  set c_mensagem = 'Não Credenciado';
else
  set c_mensagem = 'Prestador não encontrado!';
  end if;
end
// delimiter ;

call prestador_credenciado('Ribeiro Fernandes S.A.', @mensagem);

select @mensagem;

 select * from Prestadores;


/*Exercício 15: 	Verificar se um beneficiário pode pedir reembolso
Enunciado: Crie uma procedure que recebe o id de um beneficiário e verifica se ele tem status 'Ativo'. Se sim, exiba "Pode solicitar reembolso". Caso contrário, exiba "Não pode solicitar reembolso".
Passos mínimos:
1.	Receber um INT como parâmetro.
2.	Buscar o status do beneficiário.
3.	Usar IF para decidir a mensagem.*/
drop procedure if exists beneficiario_pede_reembolso;
delimiter //
create procedure beneficiario_pede_reembolso(
in id_ben int,
out mensagem_reembolso varchar(100)
)
begin
declare b_status varchar(100);
select status 
into b_status
from Beneficiarios
where id = id_ben
limit 1;

if b_status = 'Ativo' then
  set mensagem_reembolso = 'Pode solicitar reembolso';
else
  set mensagem_reembolso = 'Não pode solicitar reembolso';
end if;
end
// delimiter ;

call beneficiario_pede_reembolso(7, @mensagem);

select @mensagem;

/*Exercício 16: 	Verificar faixa etária do beneficiário
Enunciado: Crie uma procedure que recebe o nome de um beneficiário e verifica sua faixa etária:
•	Se menor de 18 anos: exibir "Menor de idade".
•	Se entre 18 e 59 anos: exibir "Adulto".
•	Se 60 anos ou mais: exibir "Idoso".
Passos mínimos:
1.	Receber um VARCHAR(100) como parâmetro.
2.	Calcular idade com TIMESTAMPDIFF.
3.	Usar IF e ELSEIF para determinar a faixa.*/
drop procedure verificar_faixa_etaria;

delimiter //
create procedure verificar_faixa_etaria(
in nome_ben varchar(100),
out faixa_etaria varchar(100)
)
begin
declare fx_beneficiario int;
select timestampdiff(year, data_nascimento, curdate())
into fx_beneficiario 
from beneficiarios
where nome = nome_ben;

if fx_beneficiario is null then
  set faixa_etaria = 'Beneficiario não encontrado!';
elseif fx_beneficiario < 18 then
  set faixa_etaria = 'Menor de idade';
elseif fx_beneficiario between 18 and 59 then
  set faixa_etaria = 'Adulto';
else 
  set faixa_etaria = 'Idoso';
end if;
end
// delimiter ;

call verificar_faixa_etaria('Stephany Vieira', @mensagem);

select @mensagem;

select nome, timestampdiff(year, data_nascimento, curdate()) from beneficiarios;

/*Exercício 17: 	Verificar se o prestador é hospital e credenciado
Enunciado: Crie uma procedure que recebe o nome de um prestador. Verifique:
•	Se for do tipo 'Hospital' e for credenciado: exibir "Hospital credenciado".
•	Se for do tipo 'Hospital' e não credenciado: exibir "Hospital não credenciado".
•	Caso contrário: exibir "Não é hospital".
Passos mínimos:
1.	Receber um VARCHAR(100) como parâmetro.
2.	Buscar tipo e credenciado da tabela Prestadores.
3.	Usar IF aninhado.*/
drop procedure if exists hospital_credenciado;
delimiter //
create procedure hospital_credenciado(
in p_nome varchar(50),
out c_mensagem varchar (50)
)
begin
declare v_tipo varchar(50);
declare v_credenciado boolean;
select tipo, credenciado 
into v_tipo, v_credenciado
from Prestadores
where nome = p_nome;

if v_tipo = 'Hospital' and v_credenciado = true then
  set c_mensagem = 'Hospital Credenciado';
elseif v_tipo = 'Hospital' and v_credenciado = false then
  set c_mensagem = 'Hospital Não Credenciado';
else
  set c_mensagem = 'Não é um Hospital';
end if;
end 
// delimiter ;

call hospital_credenciado('Peixoto Ltda.', @mensagem);
select @mensagem;

/*Exercício 18: 	Comparar valor solicitado e aprovado de um reembolso
Enunciado: Crie uma procedure que recebe o id de um reembolso. Compare o valor aprovado com o solicitado:
•	Se forem iguais: "Valor aprovado integralmente".
•	Se o valor aprovado for menor: "Valor aprovado parcialmente".
•	Se for maior (raro): "Valor acima do solicitado".
Passos mínimos:
1.	Receber um INT como parâmetro.
2.	Buscar valor_solicitado e valor_aprovado.
3.	Usar IF, ELSEIF e ELSE para comparar.*/

delimiter //
create procedure valor_solicitado_aprovado(
in id_reembolso int,
out msg_reembolso varchar(50)
)
begin
declare v_valor_solicitado decimal(7,2);
declare v_valor_aprovado decimal(7,2);

select valor_solicitado, valor_aprovado 
into v_valor_solicitado, v_valor_aprovado
from reembolsos
where id = id_reembolso;

if v_valor_solicitado = v_valor_aprovado then
  set msg_reembolso = 'Valor aprovado integralmente';
elseif v_valor_solicitado > v_valor_aprovado then
  set msg_reembolso = 'Valor aprovado parcialmente';
else
  set msg_reembolso = 'Valor acima do solicitado';
end if;
end
// delimiter ;

call valor_solicitado_aprovado(6,@mensagem);
select @mensagem;
