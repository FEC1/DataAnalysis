/*Nivel 1 ejercicio 1*/
/*En esta parte esta el codigo con el que se creo la tabla credit_card omiti la parte de introducir todos los registros pues es muy larga*/
CREATE INDEX idx_credit_card_id ON transaction(credit_card_id);
CREATE TABLE IF NOT EXISTS credit_card (
        id VARCHAR(15) PRIMARY KEY,
        iban VARCHAR(100),
        pan VARCHAR(20),
        pin INT,
        ccv INT,
        birth_date VARCHAR(100),
        expiring_date VARCHAR(20),
        FOREIGN KEY(id) REFERENCES transaction(credit_card_id)
    );
/*Nivel 1 ejercicio 2*/
SELECT id, iban    -- secomprueba el registro erroneo
FROM credit_card
WHERE  id = 'CcU-2938'
; 
-- Se actualiza el registro
UPDATE credit_card SET iban='R323456312213576817699999' WHERE id='CcU-2938'
;
-- Se comprueba el registro
SELECT id, iban 
FROM credit_card
WHERE  id = 'CcU-2938'
;
/*Nivel 1 ejercicio 3*/
INSERT INTO company (id) VALUES ('b-9999'); -- se inserta primero el id en company ya que este es FK de company y requiere existir primero este registro
INSERT INTO transaction 
(id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined)
 VALUES 
 (        '108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', NOW(),         '111.11', '0')
 ; -- use un NOW() para timestampa para guardar el momento del registro
 -- claro esto dejara un registro en company sin datos (null)
 
 /*Nivel 1 ejercicio 4*/
 
 ALTER TABLE credit_card DROP COLUMN pan;
 DESCRIBE credit_card; -- comprobar el cambio
 
 /*Nivel 2 ejercicio 1*/
 
 SET FOREIGN_KEY_CHECKS = 0; -- desabilito las FK para poder borrar
 DELETE FROM transaction
 WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';
 
 /*Nivel 2 ejercicio 2*/
 
 CREATE VIEW VistaMarketing AS
SELECT company_name,phone,country, ROUND(avg(t.amount), 2) AS promedio_ventas
FROM company c
JOIN transaction t ON t.company_id=c.id
GROUP BY company_name,phone,country;

SELECT *
from vistamarketing
ORDER BY promedio_ventas DESC;

/*Nivel 2 ejercicio 3*/

SELECT * 
FROM vistamarketing vm
WHERE vm.country = 'Germany';

/*Nivel 3 ejercicio 1*/
-- cambio 1
RENAME TABLE user TO user_data;
-- Cambio 2
ALTER TABLE user_data 
CHANGE email personal_email varchar(150);
-- cambio 3
ALTER TABLE credit_card DROP birth_date;
-- cambio 4
ALTER TABLE credit_card ADD fecha_actual DATE;
UPDATE credit_card SET fecha_actual = CURDATE(); -- le dara la fecha actual a todos los registros
-- cambio 5
ALTER TABLE credit_card MODIFY pin VARCHAR(4);
-- cambio 6
ALTER TABLE company DROP website;
-- cambio 7
/*desactivo momentaneamente la restriccion de FK para poder agregar este nuevo 
FK pues en un ejercicio anterior introduje un dato que no tiene correspondencia */
SET FOREIGN_KEY_CHECKS = 0;  
ALTER TABLE transaction
ADD constraint Fk_transaction_user_data foreign key (user_id) REFERENCES user_data (id);
SET FOREIGN_KEY_CHECKS = 1; -- vuelvo a activar la restriccion
-- cambio 8
-- lo mismo que en el anterior
SET FOREIGN_KEY_CHECKS = 0;
ALTER TABLE transaction
ADD constraint Fk_transaction_credit_card foreign key (credit_card_id) REFERENCES credit_card (id);
SET FOREIGN_KEY_CHECKS = 1;
-- ultimo cambio, quitar las restricciones que estaban antes para evitar problemas de integridad
ALTER TABLE user_data DROP FOREIGN KEY user_data_ibfk_1;
ALTER TABLE credit_card DROP FOREIGN KEY FK_credit_card_transaction;

/*Nivel 3 Ejercicio 2*/ 

CREATE VIEW InformeTecnico AS
SELECT 
    t.id AS ID_transaccion, u.name AS Nombre, u.surname AS Apellido, c.iban AS IBAN, co.company_name AS Compañia, 
    t.amount AS Monto, co.country AS Pais
FROM 
    transaction t
	JOIN user_data u ON t.user_id = u.id
	JOIN credit_card c ON t.credit_card_id = c.id
    JOIN company co ON t.company_id = co.id;

SELECT *
FROM informetecnico
ORDER BY ID_transaccion DESC;







