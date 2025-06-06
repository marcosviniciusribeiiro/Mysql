-- LISTA DE EXERCÍCIOS - CONSTRAINTS NO MySQL
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
 (1, '2025-03-27', 'Valentina Cardoso', 'Não Conforme', 'Quae maxime deleniti quia.'),
 (2, '2025-03-01', 'Cauê Correia', 'Não Conforme', 'Asperiores dolorem repellendus magni omnis repudiandae.'),
 (3, '2025-03-19', 'Letícia Silva', 'Não Conforme', 'Cumque laudantium totam corporis repellat porro.'),
 (4, '2025-03-02', 'Sr. Diogo Freitas', 'Conforme', 'Veritatis ipsum temporibus illo pariatur.'),
 (5, '2025-03-02', 'João Lucas Gomes', 'Conforme', 'Esse eius repudiandae ducimus expedita.'),
 (6, '2025-03-18', 'Nicole Mendes', 'Conforme', 'Voluptatibus ullam non nesciunt dicta ad aliquam.'),
 (7, '2025-03-20', 'Eduarda Ferreira', 'Não Conforme', 'Nisi delectus dolore molestias quia labore expedita ex.'),
 (8, '2025-02-26', 'Eduardo da Costa', 'Conforme', 'Suscipit quia corrupti tempore.'),
 (9, '2025-03-11', 'Dra. Maria Alice Vieira', 'Conforme', 'Magnam velit animi itaque quaerat necessitatibus maiores dolores.'),
 (10, '2025-03-09', 'Melissa Santos', 'Não Conforme', 'Enim tempore tenetur debitis repudiandae molestiae.');

/*Exercício 01 — NOT NULL básico
Enunciado: Adicione NOT NULL aos campos nome e data_nascimento da tabela Beneficiários.
Validação: Tente inserir um beneficiário sem nome e observe o erro.
Passos:
•	Use ALTER TABLE para adicionar NOT NULL
•	Teste com INSERT sem nome*/
desc beneficiarios;

alter table beneficiarios modify column nome varchar(100) not null;
alter table beneficiarios modify column data_nascimento date not null;

insert into beneficiarios (id)
values(11);

-- Não foi possível realizar os inserts sem colocar o nome, data_nascimento do beneficiario

-- Error Code: 1364. Field 'nome' doesn't have a default value
-- Error Code: 1364. Field 'data_nascimento' doesn't have a default value

/*Exercício 02 — ENUM simples
Enunciado: Altere o campo sexo da tabela Beneficiarios para aceitar apenas 'M', 'F' ou 'Outro'.
Validação: Tente inserir 'Masculino' e verifique o erro.
Passos:
•	Use MODIFY COLUMN com ENUM
•	Tente um INSERT inválido*/
insert into beneficiarios(id, nome, data_nascimento, sexo)
values(11, 'Fernando Gabriel', '2002-08-22', 'Masculino');

-- Não é possivel tentar inserir um beneficiario com o sexo diferente de 'M', 'F' ou 'Outros'
-- Error Code: 1265. Data truncated for column 'sexo' at row 1	0.000 sec

/*Exercício 03 — CHECK de data
Enunciado: Garanta que a data_nascimento dos Beneficiarios seja menor ou igual à data atual.
Validação: Tente cadastrar alguém nascido no futuro.
Passos:
•	Use CHECK (data_nascimento <= CURDATE())
•	Teste com INSERT de 2100*/
Delimiter //
create trigger trg_check_data_nascimento_insert
before insert on Beneficiarios
for each row
begin
  if new.data_nascimento > curdate() then
    signal sqlstate '45000'
    set message_text = 'Erro: data_nascimento não pode estar no futuro.';
  end if;
end
// Delimiter ;

insert into beneficiarios (id, nome, data_nascimento)
values(11, 'Marcos', '2100-12-12');
-- Error Code: 1644. Erro: data_nascimento não pode estar no futuro.

/*Exercício 04 — UNIQUE de CPF
Enunciado: Verifique que o CPF é único em Beneficiarios.
Validação: Tente repetir um CPF existente.
Passos:
•	Use UNIQUE (já existe, mas teste)
•	Faça INSERT duplicado*/
select * from beneficiarios;

insert into beneficiarios(id, nome, data_nascimento, cpf)
values(12, 'Ana', '1997-03-11', '920.654.781-01');

-- Error Code: 1062. Duplicate entry '920.654.781-01' for key 'beneficiarios.cpf'

/*Exercício 05 — DEFAULT de status
Enunciado: Defina o valor padrão do campo status como 'Ativo'.
Validação: Insira sem status e veja se assume 'Aprovado'.
Passos:
•	Use ALTER TABLE com SET DEFAULT
•	Faça um INSERT sem status*/
alter table Autorizacoes modify column status enum('Pendente', 'Aprovado', 'Negado') default 'Aprovado';

insert into Autorizacoes (id)
values (12);

select * from autorizacoes;

/*Exercício 06 — CHECK para valores negativos
Enunciado: Adicione uma restrição CHECK na tabela Reembolsos para que valor_aprovado não seja negativo.
Validação: Tente aprovar valor -100.
Passos:
•	ALTER TABLE com ADD CHECK
•	Testar com valor negativo*/
alter table reembolsos add check (valor_aprovado >= 0);

/*Exercício 07 — FOREIGN KEY básica
Enunciado: Crie uma nova tabela Dependentes relacionada a Beneficiarios.
Validação: Tente inserir com beneficiario_id inexistente.
Passos:
•	Criar tabela com FK
•	Testar violação da FK*/
CREATE TABLE Dependentes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    beneficiario_id INT,
    foreign key(beneficiario_id) references beneficiarios(id)
);
    
/*Exercício 08 — ON DELETE CASCADE
Enunciado: Altere a FK beneficiario_id da tabela Consultas para ON DELETE CASCADE.
Validação: Apague um beneficiário e veja se as consultas somem.
Passos:
•	Dropar FK
•	Criar novamente com ON DELETE CASCADE*/
alter table Consultas drop foreign key Consultas_ibfk_1;

alter table Consultas add constraint fk_consultas_beneficiario
foreign key (beneficiario_id) references beneficiarios(id)
on delete cascade;

/*Exercício 09 — CHECK faixa de coparticipação
Enunciado: Na tabela Consultas, adicione CHECK para garantir que coparticipacao_pago <= valor_cobrado.
Validação: Testar INSERT que viole a regra.
Passos:
•	ALTER TABLE com ADD CHECK
•	Testar valor incoerente*/
alter table consultas add check (coparticipacao_pago <= valor_cobrado);


/*Exercício 10 — FOREIGN KEY entre consultas e procedimentos
Enunciado: Confirme que não é possível inserir uma consulta com procedimento_id inválido.
Validação: Tente um INSERT com procedimento inexistente.
Passos:
•	Validar FK já criada
•	Testar violação*/

/*Exercício 11 — CASCADE UPDATE
Enunciado: Altere a FK de beneficiario_id em Autorizacoes para ON UPDATE CASCADE.
Validação: Atualize o ID do beneficiário e veja o reflexo.
Passos:
•	Dropar FK
•	Recriar com ON UPDATE CASCADE
•	Atualizar PK e observar*/
Select 
   Constraint_Name, Table_Name, Column_Name, Referenced_Table_Name, Referenced_Column_Name
  from Information_Schema.Key_Column_Usage
  where 
    Constraint_Schema = 'planosaudedb'
     and 
	Referenced_Table_Name is not null;


alter table autorizacoes drop foreign key autorizacoes_ibfk_1;

alter table autorizacoes add constraint fk_autorizacoes_beneficiario
foreign key (beneficiario_id) references beneficiarios(id)
on update cascade;

/*Exercício 12 — UNIQUE + NOT NULL combinados
Enunciado: Em Prestadores, garanta que o cnpj seja NOT NULL e UNIQUE.
Validação: Tente inserir dois com mesmo CNPJ.
Passos:
•	ALTER TABLE para MODIFY com ambas as constraints
•	Testar duplicação*/
alter table prestadores modify column cnpj char(18) unique not null;

/*Exercício 13 — DEFAULT BOOLEAN
Enunciado: Em Planos, defina o campo coparticipacao como DEFAULT 1.
Validação: Insira plano sem esse campo e veja se assume 1.
Passos:
•	ALTER TABLE
•	Teste INSERT sem esse valor*/
alter table planos modify column coparticipacao boolean default '1';

/*Exercício 14 — ENUM com DEFAULT
Enunciado: Altere o campo status em Autorizacoes para ter DEFAULT 'Pendente'.
Validação: Inserir nova autorização sem status.
Passos:
•	MODIFY COLUMN com ENUM + DEFAULT*/
alter table Autorizacoes
modify column status enum('Pendente', 'Aprovado', 'Negado') default 'Pendente';

/*Exercício 15 — CHECK em porcentagem
Enunciado: Adicione campo percentual_reembolso (0–100) em Reembolsos com CHECK.
Validação: Tente inserir valor 110.
Passos:
•	ALTER TABLE ADD COLUMN
•	Com CHECK (valor BETWEEN 0 AND 100)*/
alter table Reembolsos add column percentual_reembolso decimal (5, 2),
add check (percentual_reembolso between 0 and 100);

/*Exercício 16 — Tabela com todas as constraints
Enunciado: Crie a tabela HistoricoPagamentos com PK, FK, NOT NULL, CHECK e DEFAULT.
Validação: Tente inserir dados inválidos.
Passos:
•	Criar a tabela com tudo
•	Tentar INSERT que viole regra*/
CREATE TABLE HistoricoPagamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    beneficiario_id INT NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL CHECK (valor_pago >= 0),
    data_pagamento DATE NOT NULL,
    status_pagamento ENUM('Pendente', 'Confirmado', 'Cancelado') DEFAULT 'Pendente',
    FOREIGN KEY (beneficiario_id) REFERENCES Beneficiarios(id)
);

/*Exercício 17 — FOREIGN KEY entre Reembolsos e Beneficiarios
Enunciado: Teste a integridade referencial entre Reembolsos e Beneficiarios.
Validação: Tente inserir com beneficiário inexistente.
Passos:
•	Validar FK existente
•	Testar inserção*/
insert into reembolsos (beneficiario_id)
values(1344);

-- Erro ao tentar inserir um beneficiario que não existe no banco de dados: 
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`planosaudedb`.`reembolsos`, CONSTRAINT `reembolsos_ibfk_1` FOREIGN KEY (`beneficiario_id`) REFERENCES `beneficiarios` (`id`))


/*Exercício 18 — CHECK em data futura de solicitação
Enunciado: Em Autorizacoes, adicione CHECK para data_solicitacao <= CURDATE().
Validação: Inserir data futura e validar erro.
Passos:
•	ALTER TABLE com ADD CHECK*/
desc autorizacoes;
delimiter //
create trigger trg_check_data_solicitacao_insert
before insert on autorizacoes
for each row
begin
  if new.data_solicitacao > curdate() then
  signal sqlstate '45000'
  set message_text = 'Erro: a data de solicitação não pode ser uma data futura';
  end if;
end
// delimiter ;

insert into autorizacoes(data_solicitacao)
values('2200-10-10');

-- Error Code: 1644. Erro: a data de solicitação não pode ser uma data futura


/*Exercício 19 — UNIQUE com combinação de campos
Enunciado: Em Autorizacoes, garanta que um beneficiário só possa ter uma solicitação por procedimento por data.
Validação: Inserir duplicado e validar erro.
Passos:
•	ALTER TABLE ADD CONSTRAINT UNIQUE(beneficiario_id, procedimento_id, data_solicitacao)*/
alter table autorizacoes
add constraint uc_beneficiario_proc_data unique(beneficiario_id, procedimento_id, data_solicitacao);

/*Exercício 20 — Checagem completa de integridade
Enunciado: Revise as constraints aplicadas nas 8 tabelas.
Validação: Documente cada constraint com SHOW CREATE TABLE.
Passos:
•	Rodar SHOW CREATE TABLE nome_tabela
•	Verificar se todas estão ativas*/
SHOW CREATE TABLE Beneficiarios;

SHOW CREATE TABLE Dependentes;

SHOW CREATE TABLE Consultas;

SHOW CREATE TABLE Autorizacoes;

SHOW CREATE TABLE Auditoriaprocedimentos;

SHOW CREATE TABLE Planos;

SHOW CREATE TABLE Prestadores;

SHOW CREATE TABLE Procedimentos;

SHOW CREATE TABLE Reembolsos;


