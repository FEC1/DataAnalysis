/*N1E2*/

SELECT country, COUNT(country) AS cuantos
FROM company c
JOIN transaction t on t.company_id=c.id
GROUP BY c.country
Order by cuantos;

SELECT COUNT(DISTINCT c.country) AS total_countries
FROM company c
JOIN transaction t ON t.company_id = c.id;

SELECT c.company_name, AVG(t.amount) AS media_ventas
FROM company c
JOIN transaction t ON t.company_id=c.id
GROUP BY c.company_name
ORDER BY media_ventas DESC
Limit 1;

/*N1E3*/

SELECT t.id, t.timestamp, t.amount, c.country
FROM company c, transaction t
WHERE 	c.country = 'Germany' and c.id=t.company_id
; 

SELECT company_name 
FROM company
WHERE (
		SELECT AVG(t.amount) 
    FROM transaction t
    WHERE t.company_id = company.id
)  > (
    SELECT AVG(amount) 
    FROM transaction 
    ) 
;

/*nivel 1 ejercicio 3.3*/

SELECT company_name AS para_eliminar, id AS id_sint
FROM company c
WHERE c.id NOT IN (SELECT t.company_id
                     FROM transaction t
                   );
DELETE FROM company c
WHERE c.id NOT IN (
    SELECT t.company_id
    FROM transaction t                
                  ); 
