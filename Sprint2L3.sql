/*L3E1*/
SELECT c.company_name, c.phone, c.country, DATE(t.timestamp) , t.amount
FROM company c
JOIN transaction t ON t.company_id=c.id
WHERE (t.amount BETWEEN 100 AND 200)
AND (DATE(t.timestamp) IN ('2021-04-29', '2021-07-20', '2022-03-13'))
ORDER BY DATE(T.TIMESTAMP)
;
/*L3E2*/

SELECT c.company_name, count(t.id) AS n_transacciones,
CASE 
        WHEN COUNT(t.id) >= 4 THEN 'sí' -- en este caso CASE funciona similar a un bucle if-else, solo que no se ejecuta para recorrer un array, si no que decide el valor de la columna en base a las condiciones
        ELSE 'no'
    END AS mas_de_4
FROM company c
JOIN transaction t ON t.company_id=c.id
GROUP BY c.company_name
ORDER BY n_transacciones DESC
;
