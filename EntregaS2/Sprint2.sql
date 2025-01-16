/*En todos los ejercicios considere las transacciones declinadas como transacciones validas, ya que las considero ventas 
y pasan a ser un pasivo que tendra que ser liquidado en un futuro pero facturadas en ese momento*/ 

/*Nivel 1 ejercicio 2*/
/*2.1*/
SELECT country, COUNT(country) AS cuantos
FROM company c
JOIN transaction t on t.company_id=c.id
GROUP BY c.country
Order by cuantos;
/*2.2*/
SELECT COUNT(DISTINCT c.country) AS total_countries
FROM company c
JOIN transaction t ON t.company_id = c.id;
/*2.3*/
SELECT c.company_name, ROUND(AVG(t.amount),2) AS media_ventas
FROM company c
JOIN transaction t ON t.company_id=c.id
GROUP BY c.company_name
ORDER BY media_ventas DESC
Limit 1;

/*Nivel 1 ejercicio 3*/
/*3.1*/
SELECT t.id, t.timestamp, t.amount, c.country
FROM company c, transaction t
WHERE 	c.country = 'Germany' and c.id=t.company_id
; 
/*3.2*/
SELECT company_name 
FROM company
WHERE company.id IN (
		SELECT t.company_id 
    FROM transaction t
    WHERE t.amount > (
    SELECT AVG(amount) 
    FROM transaction 
    ) )
;

/*3.3*/
/* este codigo lo use para hacer la comprobacion de existencia o no de registros y el borrado de los mismos, agregando 2 companys falsas

INSERT INTO company (id, company_name, phone, email, country, website) VALUES (        'b-1238', 'inventada', '06 85 00 00 00', 'no.toy@yahoo.net', 'Soprania', 'https://nada/de/nada');

INSERT INTO company (id, company_name, phone, email, country, website) VALUES (        'b-9999', 'inventada2', '66 66 00 00 00', 'no.toy@yahoo.net', 'Soprania', 'https://nada/de/nada');
 */                       


SELECT company_name AS para_eliminar, id AS id_sint
FROM company c
WHERE c.id NOT IN (SELECT t.company_id
                     FROM transaction t
                   );
DELETE FROM company  -- aqui inclui la funcion para eliminar los registros en caso de que existan mas adelante
WHERE id NOT IN (
    SELECT t.company_id
    FROM transaction t                
                  ); 
                  
/*Nivel 2 ejercicio 1*/

SELECT DATE(timestamp), SUM(amount) AS total_dia
FROM transaction
GROUP BY DATE(timestamp)
ORDER BY total_dia DESC
LIMIT 5;

/*L2E2*/
SELECT country, ROUND(avg(amount), 2) AS media_ventas
FROM company c
JOIN transaction t ON t.company_id=c.id
GROUP BY country
ORDER BY media_ventas DESC
;

/*L2E3*/

/* codigo con el que consegui el country
SELECT country
FROM company
WHERE company_name = 'Non Institute';*/

SELECT t.id, c.company_name
 FROM company c
 JOIN transaction t ON t.company_id=c.id
 WHERE c.country= 'United Kingdom'
 ; 
SELECT t.id, c.company_name
 FROM company c, transaction t
 WHERE c.country= 'United Kingdom' AND t.company_id=c.id
 ;

/*Nivel 3 ejercicio 1*/

SELECT c.company_name, c.phone, c.country, DATE(t.timestamp) , t.amount
FROM company c
JOIN transaction t ON t.company_id=c.id
WHERE (t.amount BETWEEN 100 AND 200)
AND (DATE(t.timestamp) IN ('2021-04-29', '2021-07-20', '2022-03-13'))
ORDER BY DATE(T.TIMESTAMP)
;
/*Nivel 3 ejercicio 2*/

SELECT c.company_name, count(t.id) AS n_transacciones,
CASE 
        WHEN COUNT(t.id) >= 4 THEN 'sí' -- en este caso CASE funciona similar a un bucle if-else (for), solo que no se ejecuta para recorrer un array, si no que decide el valor de la columna en base a las condiciones
        ELSE 'no'
    END AS mas_de_4
FROM company c
JOIN transaction t ON t.company_id=c.id
GROUP BY c.company_name
ORDER BY n_transacciones DESC
;