use limpieza;
select * from limpieza;

alter table limpieza change column `ï»¿Id?empleado` id_employee varchar(20);
alter table limpieza change column `Apellido` last_name varchar(50) null;
alter table limpieza change column `star_date` start_date varchar(50) null;
alter table limpieza change column `gÃ©nero` genre varchar(20);

alter table limpieza drop column promotion_date;
alter table limpieza drop column finish_date;

-- Eliminar duplicados

SELECT id_employee, COUNT(*) as Cantidad
FROM limpieza
GROUP BY id_employee
HAVING COUNT(*) > 1;

select count(*) as nro_duplicados from(
SELECT id_employee, COUNT(*) as Cantidad
FROM limpieza
GROUP BY id_employee
HAVING COUNT(*) > 1
) as subquery;

rename table limpieza to duplicados;

create temporary table temp_limp as 
select distinct * from duplicados;

select count(*) from duplicados;
select count(*) from temp_limp;

CREATE TABLE limpieza AS SELECT * FROM
    temp_limp;
drop table duplicados;
select * from limpieza;
describe limpieza;

-- Dar formato a las columnas
select last_name from limpieza 
where length(last_name)-length(trim(name))>0;

select last_name, trim(last_name) as last_name from limpieza 
where length(last_name)-length(trim(last_name))>0;

set sql_safe_updates=0;
update limpieza set last_name=trim(name)
where length(last_name)-length(trim(last_name))>0;

update limpieza set area=replace(area, '     ', ' ');

select area from limpieza
where area regexp '\\s{2,}';

select area, trim(regexp_replace(area, '\\s+', ' ')) as spaces from limpieza;
update limpieza set area=trim(regexp_replace(area, '\\s+', ' '));

describe limpieza;

select genre,
Case 
	when genre='hombre' then 'male' 	
    when genre='mujer' then 'female'	 
    else 'other' 
end as genre1 
from limpieza;

update limpieza set genre= Case 
	when genre='hombre' then 'male' 	
    when genre='mujer' then 'female'	 
    else 'other' 
end;

-- Formato de salario

SELECT 
    salary, CAST(REPLACE(REPLACE(salary, '$', ''), ',', '') AS UNSIGNED) AS salary_formatted
FROM 
    limpieza;
    
update limpieza set salary=CAST(REPLACE(REPLACE(salary, '$', ''), ',', '')AS UNSIGNED);

alter table limpieza 
modify column salary int unsigned; -- el unsigned es para que no hayan valores negativos 

-- Formato a las fechas 
BEGIN ;

UPDATE limpieza 
set birth_date = DATE_FORMAT(STR_TO_DATE(birth_date, '%m/%d/%Y'), '%Y/%m/%d');
COMMIT;

BEGIN ;
UPDATE limpieza 
set start_date = DATE_FORMAT(STR_TO_DATE(start_date, '%m/%d/%Y'), '%Y/%m/%d');
COMMIT;

-- Cambiar tipo de dato a date

alter table limpieza
modify column birth_date date;

alter table limpieza
modify column start_date date;
commit;
-- crear campo de email
select id_employee, name, genre, lower(CONCAT(name, '.', substring(last_name, 1,3) ,'@gmail.com')) as email from limpieza;

alter table limpieza
add column email varchar(50);

update limpieza
set email= lower(CONCAT(name, '.', substring(last_name, 1,3) ,'@gmail.com'));
-- crear columna de edad 

select name, birth_date, start_date, timestampdiff(year, birth_date, curdate()) as age from limpieza;

alter table limpieza
add column age int;

update limpieza
set age=timestampdiff(year, birth_date, curdate());