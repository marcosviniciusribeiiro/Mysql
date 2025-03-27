create database Escola;

use Escola;

CREATE TABLE Alunos (
    id_aluno INT PRIMARY KEY AUTO_INCREMENT,
    nome_aluno VARCHAR(100) NOT NULL
);

alter table Alunos add column email_aluno varchar(200);

desc Alunos;

insert into Alunos(nome_aluno) value ('Rodrigo');
insert into Alunos(nome_aluno) value ('Tiago');
insert into Alunos(nome_aluno) value ('Ana Paula');
insert into Alunos(nome_aluno) value ('Geovana');
insert into Alunos(nome_aluno) value ('Leandro');

SELECT 
    *
FROM
    Alunos;

create database LojaOnline;

use LojaOnline;

CREATE TABLE Produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(80) NOT NULL,
    preco_produto DECIMAL(7 , 2 ) NOT NULL,
    qt_estoque INT NOT NULL
);


alter table Produtos
modify column preco_produto decimal(6,2);

desc Produtos;

insert into Produtos(nome_produto, preco_produto, qt_estoque) values ('Banana' , 4.99, 159);
insert into Produtos(nome_produto, preco_produto, qt_estoque) values ('Doce de Leite' , 12.50, 37);
insert into Produtos(nome_produto, preco_produto, qt_estoque) values ('Maçã' , 2.99, 204);

SELECT 
    *
FROM
    Produtos;

create database Biblioteca;

use Biblioteca;

CREATE TABLE Professores (
    id_professor INT PRIMARY KEY AUTO_INCREMENT,
    nome_professor VARCHAR(120) NOT NULL,
    salario_professor DECIMAL(6 , 2 ) NOT NULL,
    disciplina VARCHAR(100) NOT NULL
);

alter table Professores add column idade_professor int not null;

desc Professores;
insert into Professores(nome_professor, salario_professor, disciplina, idade_professor) values ('Carlos', 3299, 'Matemática', 34);
insert into Professores(nome_professor, salario_professor, disciplina, idade_professor) values ('Fernanda', 2999, 'Geografia', 27);
insert into Professores(nome_professor, salario_professor, disciplina, idade_professor) values ('Davi', 2895, 'Filosofia', 30);
select * from Professores;

create database HotelReservas;

use HotelReservas;

CREATE TABLE Pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    dt_pedido varchar(11) NOT NULL
);

desc Pedidos;

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome_cliente VARCHAR(120) NOT NULL,
    email_cliente VARCHAR(200)
);

alter table Clientes add column dt_nascimento date not null;

desc Clientes;

insert into Pedidos(dt_pedido) value ('13/02/2025');
insert into Pedidos(dt_pedido) value ('21/11/2024');
insert into Pedidos(dt_pedido) value ('02/09/2024');

select * from Pedidos;

use Escola;
select * from Alunos;

use LojaOnline;

select nome_produto from Produtos
where preco_produto = (select max(preco_produto) from Produtos);

use Biblioteca;

select * from Professores
where disciplina = 'Matemática';

use LojaOnline;
select sum(qt_estoque) as qt_total from Produtos;

use Escola;

select * from Alunos
order by nome_aluno;

use Biblioteca;

select nome_professor from Professores
where salario_professor > 3000;

use LojaOnline;

select nome_produto, preco_produto from Produtos 
where qt_estoque < 100;

use Escola;

select count(nome_aluno) as Alunos_Turma from Alunos;

use HotelReservas;
drop table Pedidos;

drop table Clientes;
