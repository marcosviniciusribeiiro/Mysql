-- Criando o banco de dados
CREATE DATABASE IF NOT EXISTS SistemaAcademico;

USE SistemaAcademico;

-- Criando a tabela de Estudantes
CREATE TABLE Estudantes (
    id_estudante INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Criando a tabela de Professores
CREATE TABLE Professores (
    id_professor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Criando a tabela de Disciplinas
CREATE TABLE Disciplinas (
    id_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    id_professor INT NOT NULL,
    FOREIGN KEY (id_professor) REFERENCES Professores(id_professor)
);

-- Criando a tabela de Matrículas
CREATE TABLE Matriculas (
    id_estudante INT NOT NULL,
    id_disciplina INT NOT NULL,
    semestre VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_estudante, id_disciplina, semestre),
    FOREIGN KEY (id_estudante) REFERENCES Estudantes(id_estudante),
    FOREIGN KEY (id_disciplina) REFERENCES Disciplinas(id_disciplina)
);

-- Inserindo dados fictícios

-- Inserindo Estudantes
INSERT INTO Estudantes (nome, email) VALUES
('Alice Souza', 'alice@email.com'),
('Bruno Lima', 'bruno@email.com'),
('Carlos Mendes', 'carlos@email.com');

-- Inserindo Professores
INSERT INTO Professores (nome) VALUES
('Dr. Ricardo Silva'),
('Profa. Juliana Costa'),
('Dr. Marcos Ribeiro');

-- Inserindo Disciplinas
INSERT INTO Disciplinas (nome, id_professor) VALUES
('Banco de Dados', 1),
('Estruturas de Dados', 2),
('Algoritmos', 3);

-- Inserindo Matrículas
INSERT INTO Matriculas (id_estudante, id_disciplina, semestre) VALUES
(1, 1, '2024.1'),
(1, 2, '2024.1'),
(2, 1, '2024.1'),
(3, 3, '2024.1'),
(2, 3, '2024.1');

-- Quais disciplinas a Alice Souza está cursando e quem são os professores?
select 
    e.nome as Nome_Aluno, 
    d.nome as Nome_Disciplinas,
    p.nome as Nome_Professores
from 
   Estudantes e
 inner join
   Matriculas m on e.id_estudante = m.id_estudante
 inner join
   Disciplinas d on m.id_disciplina = d.id_disciplina
 inner join
   Professores p on p.id_professor = d.id_professor
where e.nome = 'Alice Souza';
  
 -- Quais alunos estão cursando Algoritmos e em qual semestre?
select
    e.nome as Alunos, 
    d.nome as Disciplina, 
    m.semestre As Semestre
from 
   Matriculas m
 inner join 
   Estudantes e on m.id_estudante = e.id_estudante
 inner join 
   Disciplinas d on d.id_disciplina = m.id_disciplina
where d.nome like 'Algoritmos';

-- Quantos alunos estão matriculados em cada disciplina e quem é o professor responsável?
select 
   d.nome as Disciplina, 
   p.nome as Professor, 
   count(e.nome) as Total_Estudantes 
 from Matriculas m
  inner join 
 Estudantes e on e.id_estudante = m.id_estudante
  inner join 
 Disciplinas d on d.id_disciplina = m.id_disciplina
  inner join
 Professores p on p.id_professor = d.id_professor
 group by d.nome; 

/*1. Listar os estudantes matriculados, mostrando também as disciplinas e os professores responsáveis.
Tabelas envolvidas: Estudantes, Matrículas, Disciplinas, Professores*/
select 
  e.nome as nome_estudante, 
  d.nome as nome_disciplina, 
  p.nome as nome_professor
from 
  Matriculas m
    inner join
  Estudantes e on m.id_estudante = e.id_estudante
    inner join 
  Disciplinas d on d.id_disciplina = m.id_disciplina
    inner join
  Professores p on p.id_professor = d.id_professor
order by e.nome;

/*2. Exibir o nome do estudante, a disciplina e o semestre apenas para os alunos que estão cursando uma disciplina específica (ex: 'Banco de Dados').
Tabelas envolvidas: Estudantes, Matrículas, Disciplinas*/
select 
    e.nome as nome_estudante, 
    d.nome as nome_disciplina, 
    m.semestre as semestre 
from 
  Matriculas m
      inner join
  Estudantes e on e.id_estudante = m.id_estudante
      inner join
  Disciplinas d on d.id_disciplina = m.id_disciplina
where d.nome = 'Banco de Dados';

/*3. Mostrar quais professores estão lecionando disciplinas para determinados alunos.
Tabelas envolvidas: Professores, Disciplinas, Matrículas, Estudantes*/

select 
    p.nome as Professor, 
    d.nome as Disciplina, 
    e.nome as Estudante from Disciplinas d
      inner join
  Matriculas m on m.id_disciplina = d.id_disciplina
      inner join
  Estudantes e on e.id_estudante = m.id_estudante
      inner join
  Professores p on p.id_professor = d.id_professor
where e.nome like 'Bruno%';

/*4. Listar os estudantes e os semestres em que estão matriculados, incluindo os nomes das disciplinas e os professores responsáveis por cada disciplina. 
Organize o resultado por semestre.
Tabelas envolvidas: Estudantes, Matrículas, Disciplinas, Professores*/

select 
    e.nome as Nome_Estudante, 
    m.semestre as Semestre, 
    d.nome as Nome_Disciplina, 
    p.nome as Nome_Professor from Matriculas m
      inner join
  Estudantes e on e.id_estudante = m.id_estudante
      inner join 
  Disciplinas d on d.id_disciplina = m.id_disciplina
      inner join 
  Professores p on p.id_professor = d.id_professor
order by m.semestre;

/*5. Exibir o nome do professor e os alunos que estão cursando as disciplinas ministradas por ele.
Tabelas envolvidas: Professores, Disciplinas, Matrículas, Estudantes*/
select 
    p.nome as Nome_Professor, 
    e.nome as Nome_Estudante from Professores p
      inner join
  Disciplinas d on p.id_professor = d.id_professor
      inner join
  Matriculas m on m.id_disciplina = d.id_disciplina
      inner join Estudantes e on e.id_estudante = m.id_estudante
order by p.nome;