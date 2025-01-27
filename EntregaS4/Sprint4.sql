CREATE DATABASE IF NOT EXISTS sprint4;
USE sprint4; -- crear la base de datos
/*crear las tablas*/

CREATE TABLE IF NOT EXISTS transactions (
        id VARCHAR(255) PRIMARY KEY,
        card_id VARCHAR(15),
        buisness_id VARCHAR(15),
        timestamp timestamp,
        amount DECIMAL(10, 2),
        declined BOOLEAN,
        product_ids VARCHAR(100),
        user_id VARCHAR(15),
        lat FLOAT,
        longitude FLOAT
    );
    CREATE TABLE IF NOT EXISTS companies (
        company_id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(15),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );
    
	CREATE TABLE IF NOT EXISTS credit_cards (
        id VARCHAR(15) PRIMARY KEY,
        user_id INT,
        iban VARCHAR(100),
        pan VARCHAR(20),
        pin CHAR(4),
        ccv CHAR(4),
        track1 VARCHAR(100),
        track2 VARCHAR(100),
        expiring_date VARCHAR(20) -- formato MM/DD/AA
        
    );
    
    CREATE TABLE IF NOT EXISTS products (
        id VARCHAR(15) PRIMARY KEY,
        product_name VARCHAR(100),
        price VARCHAR(25), -- viene con el signo $ incluido por lo que habra que quitarlo, me gustaria cambiarlo a DECIMAL(5,2)
        colour VARCHAR(10),
        weight DECIMAL(2, 1),
        warehouse_id VARCHAR(10) -- hay algunos errores con los guiones ( WH-2 y WH--2)
	);
    
    CREATE TABLE IF NOT EXISTS users (
		id VARCHAR(15) PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(15),
        email VARCHAR(100),
        birth_date VARCHAR(20), -- formato "Mes DD, YYYY"
        country VARCHAR(25),
        city VARCHAR(25),
       postal_code VARCHAR(10), -- viene en un formato extraño con letras
       address VARCHAR(255)
	);
    /*en esta parte declaro todas las FK*/
    ALTER TABLE transactions
ADD constraint Fk_transactions_users foreign key (user_id) REFERENCES users (id),
ADD constraint Fk_transactions_companies foreign key (buisness_id) REFERENCES companies (company_id),
ADD constraint Fk_transactions_credit_cards foreign key (card_id) REFERENCES credit_cards (id);
/*ADD constraint Fk_transaction_products foreign key (product_ids) REFERENCES products (id); omitire esta ya que cada transaccion puede tener mas de un producto*/

/*cargar los datos del csv*/
/*Solo los cargue con codigo para la tabla transactions, para los otros use el wizard*/
SHOW VARIABLES LIKE 'secure_file_priv'; -- este codigo es para verificar cual es el directorio seguro
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv' -- Los slash van asi "/" y no  asi "\" porque? no se cosas del diablo
INTO TABLE  transactions
FIELDS TERMINATED BY ';'
LINES TERMINATED BY  '\n'
IGNORE 1 ROWS;

/*Nivel 1 Ejercicio 1*/

SELECT user_id, 
       (SELECT name FROM users WHERE id = t.user_id) AS name, 
       COUNT(t.user_id) AS num_trans
FROM transactions t
GROUP BY user_id
HAVING num_trans >= 30;

/*Nivel 1 Ejercicio 2*/

SELECT  c.iban, cm.company_name, avg(t.amount) 
FROM transactions t
JOIN credit_cards c ON t.card_id=c.id
JOIN companies cm ON t.buisness_id=cm.company_id
GROUP BY c.iban, cm.company_name
HAVING cm.company_name = 'Donec Ltd'
;
   
   /*Nivel 2 previo*/
   
  CREATE TABLE card_status AS 
WITH ultimas AS (
    SELECT t.card_id, t.declined,
        ROW_NUMBER() OVER (PARTITION BY t.card_id ORDER BY t.timestamp DESC) AS rn -- crea una columna en la que asigna un numero a cada card_id que esta ordenaco por time stamp
    FROM transactions t
)

SELECT card_id, COUNT(declined) AS declinaciones,
    CASE 
        WHEN COUNT(declined) >= 3 THEN 'inactiva'
        ELSE 'activa'
    END AS status
FROM ultimas
WHERE rn <= 3 -- en esta parte e donde limitamos para que tome solo los primeros 3 de cada rn  Como un ranking 
GROUP BY card_id
ORDER BY declinaciones DESC;
ALTER TABLE card_status
ADD PRIMARY KEY (card_id);
ALTER TABLE transactions
ADD constraint Fk_transactions_card_status foreign key (card_id) REFERENCES card_status (card_id);
 
/*Nivel 2 Ejercicio 1*/

SELECT COUNT(status) as active_cards
FROM card_status
WHERE status = 'activa';

/*Nivel 3 Previo*/

CREATE TABLE transaction_products (
    transaction_id VARCHAR(255) NOT NULL,
    product_id VARCHAR(15) NOT NULL,
    PRIMARY KEY (transaction_id, product_id),
    FOREIGN KEY (transaction_id) REFERENCES transactions (id) ON DELETE CASCADE, -- agrego el delete cascade para eliminar las relaciones cuando se elimine una transaccion o un producto
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE -- tal vez debi haber agregado tambien un update cascade
    );

-- poblar la tabla anterior

INSERT INTO transaction_products (transaction_id, product_id)
SELECT 
    t.id AS transaction_id,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(t.product_ids, ',', contador.n), ',', -1)) AS product_id -- aqui primero conseguimos los primeros "n" elementos de la lista y posteriormente seleccionamos el ultimo elemento de esalista y por ultimo quitamos espacios en blanco
FROM 
    transactions t
JOIN 
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL 
     SELECT 5 ) contador ON CHAR_LENGTH(t.product_ids) -- cuenta los caracteres
     -CHAR_LENGTH(REPLACE(t.product_ids, ',', '')) >= contador.n - 1 -- quita las "," y vuelve a contar los caracteres, luego se los resta a los caracteres originales 
WHERE 
    t.product_ids IS NOT NULL;

    /* al final me parece que encontre una manera mejor de poblar la tabla pero me dio muchas complicaciones y al final no comprobe
    si realmente funncionaba pero igual dejo el codigo pues me parece que la logica es correcta
    INSERT INTO transaction_products (transaction_id, product_id)
WITH RECURSIVE NumberSequence AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM NumberSequence
    WHERE n < 100
),
MaxOccurrences AS (  
    SELECT 
        id AS transaction_id,
        product_ids,
        LENGTH(product_ids) - LENGTH(REPLACE(product_ids, ',', '')) + 1 AS comas
    FROM 
        transactions
    WHERE 
        product_ids IS NOT NULL
)
SELECT 
    mo.transaction_id,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(mo.product_ids, ',', ns.n), ',', -1)) AS product_id
FROM 
    MaxOccurrences mo
JOIN 
    NumberSequence ns ON ns.n <= mo.comas;*/
    -- tambien creo que se podria usar la funcion find_in_set
    
    /*Nivel 3 Ejercicio 1*/
    
SELECT tp.product_id AS producto, p.product_name AS nombre, count(tp.transaction_id) AS vendidos
FROM transaction_products tp
JOIN products p ON tp.product_id=p.id
GROUP BY producto
ORDER BY vendidos DESC ;

        
