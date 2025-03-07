-- Criando o banco de dados
CREATE DATABASE IF NOT EXISTS db_SistemaAcademico;

USE db_SistemaAcademico;

-- Criando a tabela de Estudantes
CREATE TABLE tb_Estudantes (
    id_estudante INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Criando a tabela de Professores
CREATE TABLE tb_Professores (
    id_professor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Criando a tabela de Disciplinas
CREATE TABLE tb_Disciplinas (
    id_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    id_professor INT NOT NULL,
    FOREIGN KEY (id_professor) REFERENCES tb_Professores(id_professor)
);

-- Criando a tabela de Matrículas
CREATE TABLE tb_Matriculas (
    id_estudante INT NOT NULL,
    id_disciplina INT NOT NULL,
    semestre VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_estudante, id_disciplina, semestre),
    FOREIGN KEY (id_estudante) REFERENCES tb_Estudantes(id_estudante),
    FOREIGN KEY (id_disciplina) REFERENCES tb_Disciplinas(id_disciplina)
);

-- Inserindo Dados 

-- Inserindo Estudantes
INSERT INTO tb_Estudantes (nome, email) VALUES
('Alice Souza', 'alice@email.com'),
('Bruno Lima', 'bruno@email.com'),
('Carlos Mendes', 'carlos@email.com');

-- Inserindo Professores
INSERT INTO tb_Professores (nome) VALUES
('Dr. Ricardo Silva'),
('Profa. Juliana Costa'),
('Dr. Marcos Ribeiro');

-- Inserindo Disciplinas
INSERT INTO tb_Disciplinas (nome, id_professor) VALUES
('Banco de Dados', 1),
('Estruturas de Dados', 2),
('Algoritmos', 3);

-- Inserindo Matrículas
INSERT INTO tb_Matriculas (id_estudante, id_disciplina, semestre) VALUES
(1, 1, '2024.1'),
(1, 2, '2024.1'),
(2, 1, '2024.1'),
(3, 3, '2024.1'),
(2, 3, '2024.1');

-- Consultas

-- 1. Listar os estudantes matriculados, mostrando também as disciplinas e os professores responsáveis.
SELECT 
    e.nome AS Nome_Estudante, 
    d.nome AS Nome_Disciplina, 
    p.nome AS Nome_Professor 
FROM 
    tb_Estudantes e
INNER JOIN 
    tb_Matriculas m ON e.id_estudante = m.id_estudante
INNER JOIN 
    tb_Disciplinas d ON m.id_disciplina = d.id_disciplina
INNER JOIN
    tb_Professores p ON p.id_professor = d.id_professor
ORDER BY e.nome;

-- 2. Exibir o nome do estudante, a disciplina e o semestre apenas para os alunos que estão cursando 'Banco de Dados'.
SELECT 
    e.nome AS Nome_Estudante, 
    d.nome AS Nome_Disciplina, 
    m.semestre AS Semestre 
FROM 
    tb_Matriculas m
INNER JOIN
    tb_Estudantes e ON e.id_estudante = m.id_estudante
INNER JOIN
    tb_Disciplinas d ON d.id_disciplina = m.id_disciplina
WHERE d.nome = 'Banco de Dados';

-- 3. Mostrar quais professores estão lecionando disciplinas para determinados alunos.
SELECT 
    p.nome AS Nome_Professor, 
    d.nome AS Nome_Disciplina, 
    e.nome AS Nome_Estudante 
FROM 
    tb_Disciplinas d
INNER JOIN
    tb_Matriculas m ON m.id_disciplina = d.id_disciplina
INNER JOIN
    tb_Estudantes e ON e.id_estudante = m.id_estudante
INNER JOIN
    tb_Professores p ON p.id_professor = d.id_professor
WHERE e.nome = 'Bruno Lima';

-- 4. Listar os estudantes e os semestres em que estão matriculados, incluindo os nomes das disciplinas e os professores responsáveis.
SELECT 
    e.nome AS Nome_Estudante, 
    m.semestre AS Semestre, 
    d.nome AS Nome_Disciplina, 
    p.nome AS Nome_Professor 
FROM 
    tb_Matriculas m
INNER JOIN
    tb_Estudantes e ON e.id_estudante = m.id_estudante
INNER JOIN 
    tb_Disciplinas d ON d.id_disciplina = m.id_disciplina
INNER JOIN 
    tb_Professores p ON p.id_professor = d.id_professor
ORDER BY m.semestre;

-- 5. Exibir o nome do professor e os alunos que estão cursando as disciplinas ministradas por ele.
SELECT 
    p.nome AS Nome_Professor, 
    e.nome AS Nome_Estudante 
FROM 
    tb_Professores p
INNER JOIN
    tb_Disciplinas d ON p.id_professor = d.id_professor
INNER JOIN
    tb_Matriculas m ON m.id_disciplina = d.id_disciplina
INNER JOIN 
    tb_Estudantes e ON e.id_estudante = m.id_estudante
ORDER BY p.nome;
