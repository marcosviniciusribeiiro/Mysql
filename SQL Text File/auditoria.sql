create database auditoria; 

use auditoria;

CREATE TABLE log_consultas (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT NOT NULL,
    acao VARCHAR(200),
    data_log DATETIME,
    usuario VARCHAR(200)
);

CREATE TABLE Consultas (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    data_consulta DATE,
    descricao VARCHAR(255)
);

-- Trigger depois do insert
DELIMITER // 
CREATE TRIGGER trg_depois_insert_consulta 
AFTER INSERT ON Consultas 
FOR EACH ROW 
BEGIN 
INSERT INTO 
Log_Consultas (id_consulta, acao, data_log, usuario) 
VALUES (NEW.id_consulta, 'INSERT', NOW(), USER()); 
END; 
// DELIMITER ;

SELECT 
    *
FROM
    consultas; 
insert into consultas(data_consulta,descricao) values('2025-8-27','2° teste de inserção'); 
SELECT 
    *
FROM
    log_consultas
    
-- Trigger antes do insert    
delimiter //
create trigger trg_antes_insert_consulta
before insert on consultas
for each row
begin
  if new.data_consulta > curdate() + interval 1 year then
    signal sqlstate '45000'
    set message_text = 'Data da consulta muito distante';
  end if;
end
// delimiter ;

select * from consultas; 

insert into consultas(data_consulta,descricao) 
values('2028-10-25','teste de inserção');

select * from log_consultas;

-- Trigger depois do update
delimiter //
create trigger trg_after_update_consulta
after update on consultas
for each row
begin
  insert into log_consultas(id_consulta, acao, data_log, usuario)
  values (new.id_consulta, 'UPDATE', now(), user());
end
// delimiter ;

select * from consultas; 

UPDATE Consultas 
SET descricao = 'Descrição alterada' 
WHERE id_consulta = 1; 

select * from Log_Consultas;

alter table consultas
  drop column descricao,
  add column status varchar(20),
  add column autorizada boolean;

-- Trigger antes do update
delimiter //
create trigger trg_before_update_consulta
 before update on consultas
 for each row
 begin
  -- Verifica se a consulta já estava autorizada ANTES do update
  if OLD.autorizada = true then
    signal sqlstate '45000'
    set message_text = 'Consulta já autorizada pela operadora.';
  end if;
 end
// delimiter ;

INSERT INTO 
Consultas (id_consulta, data_consulta, status, autorizada) 
VALUES (default, '2025-04-25', 'Agendada', FALSE);

UPDATE Consultas 
SET autorizada = TRUE 
WHERE id_consulta = 3;

UPDATE Consultas 
SET status = 'Concluída' 
WHERE id_consulta = 3;

UPDATE Consultas 
SET autorizada = FALSE 
WHERE id_consulta = 3;

-- Triggers depois do delete
delimiter //
CREATE TRIGGER trg_after_delete_consulta
after delete on consultas
for each row
begin
  INSERT INTO Log_Consultas(id_consulta, acao, data_log, usuario)
  values (old.id_consulta, 'DELETE', now(), user());
end
// delimiter ;

INSERT INTO 
Consultas (id_consulta, data_consulta, status, autorizada) 
VALUES (default, '2025-04-25', 'Agendada', FALSE);

delete from consultas where id_consulta = 4;

select * from log_consultas;