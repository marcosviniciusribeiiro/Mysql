CREATE DATABASE IF NOT EXISTS EscolaCursos;

USE EscolaCursos;

-- Tabela de Alunos
CREATE TABLE Alunos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    data_nascimento DATE,
    status VARCHAR(20)
);

-- Tabela de Cursos
CREATE TABLE Cursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    carga_horaria INT,
    nivel VARCHAR(20)
);

-- Tabela de Professores
CREATE TABLE Professores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    especialidade VARCHAR(50)
);

-- Tabela de Matrículas
CREATE TABLE Matriculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT,
    id_curso INT,
    data_matricula DATE,
    situacao VARCHAR(20),
    FOREIGN KEY (id_aluno) REFERENCES Alunos(id),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id)
);

-- Tabela Alunos
INSERT INTO Alunos (nome, data_nascimento, status) VALUES
('Alice Souza', '2004-05-12', 'Ativo'),
('Bruno Silva', '1990-11-20', 'Ativo'),
('Carlos Oliveira', '1980-02-28', 'Trancado'),
('Daniela Santos', '1995-03-15', 'Inativo'),
('Eduardo Ferreira', '2003-07-08', 'Ativo'),
('Fernanda Costa', '1975-09-10', 'Ativo'),
('Gabriela Lima', '1965-05-03', 'Inativo'),
('Henrique Rocha', '1989-06-21', 'Trancado'),
('Isabela Martins', '1998-12-25', 'Ativo'),
('João Pedro Alves', '2007-02-18', 'Ativo');

-- Tabela Cursos
INSERT INTO Cursos (nome, carga_horaria, nivel) VALUES
('Introdução ao Banco de Dados', 40, 'Básico'),
('Programação em Java', 80, 'Intermediário'),
('Algoritmos Avançados', 100, 'Avançado'),
('Desenvolvimento Web', 60, 'Intermediário'),
('Cálculo I', 40, 'Básico'),
('Estruturas de Dados', 70, 'Intermediário'),
('Matemática Discreta', 90, 'Avançado'),
('Inteligência Artificial', 120, 'Avançado'),
('Linguagens de Programação', 50, 'Básico'),
('Design de Interfaces', 60, 'Intermediário');

-- Tabela Professores
INSERT INTO Professores (nome, especialidade) VALUES
('Professor João', 'Banco de Dados'),
('Professor Carlos', 'Programação em Java'),
('Professor Fernanda', 'Algoritmos Avançados'),
('Professor Rafael', 'Desenvolvimento Web'),
('Professor Maria', 'Cálculo'),
('Professor Lucas', 'Estruturas de Dados'),
('Professor Alice', 'Matemática Discreta'),
('Professor Pedro', 'Inteligência Artificial'),
('Professor Marcos', 'Linguagens de Programação'),
('Professor Silvia', 'Design de Interfaces');

-- Tabela Matrículas
INSERT INTO Matriculas (id_aluno, id_curso, data_matricula, situacao) VALUES
(1, 1, '2022-01-15', 'Matriculado'),
(2, 2, '2023-02-20', 'Matriculado'),
(3, 3, '2021-03-25', 'Cancelado'),
(4, 4, '2023-01-30', 'Concluído'),
(5, 5, '2023-05-01', 'Matriculado'),
(6, 6, '2020-08-12', 'Concluído'),
(7, 7, '2019-11-19', 'Cancelado'),
(8, 8, '2022-07-14', 'Matriculado'),
(9, 9, '2021-12-03', 'Concluído'),
(10, 10, '2023-04-22', 'Matriculado');

-- EXERCÍCIOS PARA PRATICAR PROCEDURES COM CASE

-- 1. Verificar status do aluno
-- Crie uma procedure que recebe o nome de um aluno e retorna:
-- "Aluno ativo", "Aluno inativo" ou "Aluno com matrícula trancada".
drop procedure status_aluno;
delimiter //
create procedure status_aluno(
in nomeAluno varchar(50),
out msg_status varchar(50)
)
begin
declare v_status_aluno varchar(50);
select status 
into v_status_aluno
from Alunos
where nome = nomeAluno;
case v_status_aluno
   when 'Ativo' then 
     set msg_status = 'Aluno ativo';
   when 'Inativo' then
     set msg_status = 'Aluno inativo';
   when 'Trancado' then
     set msg_status = 'Aluno com matrícula trancada';
   else 
     set msg_status = 'Aluno não encontrado';
end case;
end
// delimiter ;
call status_aluno('Gabriela Lima', @mensagem);

select @mensagem;

-- 2. Classificar o nível do curso
-- Procedure que recebe o nome do curso e retorna:
-- "Curso introdutório" (se nível for Básico),
-- "Curso médio" (Intermediário),
-- "Curso avançado" (Avançado).
drop procedure nivel_curso;
delimiter //
create procedure nivel_curso(
in nome_curso varchar(50),
out msg_nivel_curso varchar(50)
)
begin
declare v_nivel varchar(50);
select nivel 
into v_nivel
from  Cursos
where nome = nome_curso;

case v_nivel
  when 'Básico' then
    set msg_nivel_curso = 'Curso introdutório';
  when 'Intermediário' then
    set msg_nivel_curso = 'Curso médio';
  when 'Avançado' then
    set msg_nivel_curso = 'Curso avançado';
  else
    set msg_nivel_curso = 'Curso inválido';
end case;
end
// delimiter ;

call nivel_curso('Introdução ao Banco de Dados', @mensagem);

select @mensagem;

-- 3. Retornar situação da matrícula
-- Procedure que recebe um id_aluno e retorna:
-- "Em curso", "Finalizado" ou "Cancelado".
drop procedure situacao_matricula;
delimiter //
create procedure situacao_matricula(
in aluno_id int,
out msg_situacao varchar(50)
)
begin
declare v_situacao varchar(50);
select situacao 
into v_situacao
from matriculas
where id_aluno = aluno_id;
case v_situacao
     when 'Matriculado' then
       set msg_situacao = 'Em curso';
	 when 'Concluído' then
       set msg_situacao = 'Finalizado';
	 when 'Cancelado' then
       set msg_situacao = 'Cancelado';
	 else
       set msg_situacao = 'Curso não encontrado';
end case;
end
// delimiter ;

call situacao_matricula(5, @mensagem);

select @mensagem;

-- 4. Mensagens conforme carga horária do curso
-- Recebe o nome do curso, e conforme a carga horária retorna:
-- < 40h → "Curso curto"
-- entre 40h e 80h → "Curso regular"
-- > 80h → "Curso intensivo"
drop procedure if exists carga_curso;
delimiter //
create procedure carga_curso(
in nome_curso varchar(50),
out msg_carga varchar(50))
begin
declare v_carga int;
select carga_horaria
into v_carga 
from cursos
where nome = nome_curso;
case
  when v_carga < 40 then
    set msg_carga = 'Curso curto';
  when v_carga between 40 and 80 then
    set msg_carga = 'Curso regular';
  when v_carga > 80 then
    set msg_carga = 'Curso intensivo';
  else
    set msg_carga = 'Curso inválido';
end case;
end
// delimiter ;

call carga_curso('Cálculo I', @mensagem);

select @mensagem;

-- 5. Classificação de idade dos alunos
-- Recebe nome do aluno e retorna:
-- "< 18 anos": "Menor de idade"
-- "18-60": "Adulto"
-- "> 60": "Idoso"
delimiter //
create procedure idade_aluno(
in nome_aluno varchar(50),
out msg_idade varchar(50))
begin
declare v_idade int;
select timestampdiff(year, data_nascimento, curdate())
into v_idade
from alunos
where nome = nome_aluno;
case
  when v_idade < 18 then
    set msg_idade = 'Menor de idade';
  when v_idade between 18 and 60 then
    set msg_idade = 'Adulto';
  when v_idade > 60 then
    set msg_idade = 'idoso';
end case;
end
// delimiter ;

call idade_aluno('João Pedro Alves', @mensagem);

select @mensagem;