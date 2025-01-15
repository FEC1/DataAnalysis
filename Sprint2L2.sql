/*L2E1*/

SELECT DATE(timestamp), SUM(amount) AS total_dia
FROM transaction
GROUP BY DATE(timestamp)
ORDER BY total_dia DESC
LIMIT 5;

/*L2E2*/
SELECT country, avg(amount) AS media_ventas
FROM company c
JOIN transaction t ON t.company_id=c.id
GROUP BY country
ORDER BY media_ventas DESC
;

/*L2E3*/
SELECT t.id, c.company_name
 FROM company c
 JOIN transaction t ON t.company_id=c.id
 WHERE c.country= 'United Kingdom'
 ; 
SELECT t.id, c.company_name
 FROM company c, transaction t
 WHERE c.country= 'United Kingdom' AND t.company_id=c.id
 ;