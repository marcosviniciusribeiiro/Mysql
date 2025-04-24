create database if not exists exemplo_intersect;
use exemplo_intersect;

create table alunos_aprovados(
  id int primary key,
  nome varchar(255)
);

create table alunos_participantes(
  id int primary key,
  nome varchar(255)
);

insert into alunos_aprovados(id, nome) values
(1, 'Alice'),
(2, 'Bob'),
(3, 'Carol'),
(4, 'David');

insert into alunos_participantes(id, nome) values
(2, 'Bob'),
(3, 'Carol'),
(5, 'Eve');

select nome from alunos_aprovados
  intersect
select nome from alunos_participantes;