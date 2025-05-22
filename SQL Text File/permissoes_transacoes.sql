create user fulano_de_tal@'127.0.0.1' identified by 'senha23456'; -- cria um novo usuario
create user beltrano_de_tal@'127.0.0.1' identified by 'senha1234';

select user from mysql.user; -- apresenta todos os usuarios
select user(); -- apresenta o usuario ativo

RENAME USER 'fulano_de_tal'@'127.0.0.1' TO 'fulano'@'127.0.0.1'; -- renomeia o nome de um usuario

grant all privileges on *.* to ciclano@'127.0.0.1';  -- concede o privilegio de acessar todos os banco de dados e todas as tabelas

grant select on db_company.* to 'beltrano_de_tal'@'127.0.0.1'; -- concede privilegio para visualizar o banco de dados db_company

grant select,delete on db_company.* to 'beltrano_de_tal'@'127.0.0.1'; -- concede privilegio para deletar dados do banco de dados db_company

show grants for beltrano_de_tal@'127.0.0.1';  -- mostra todas as permissões de um usuario

revoke ALL privileges, grant option from 'ciclano'@'127.0.0.1'; -- revoga os privilegios de um usuario

create user 'ana_maria'@'127.0.0.1' IDENTIFIED BY 'senha123'; 
create user 'antonio_carlos'@'127.0.0.1' IDENTIFIED BY 'senha456'; 

GRANT ALL PRIVILEGES ON *.* TO 'ana_maria'@'127.0.0.1'; 
GRANT ALL PRIVILEGES ON *.* TO 'antonio_carlos'@'127.0.0.1';
