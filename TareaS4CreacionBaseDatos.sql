-- CREACIÓN DE BASE DE DATOS
CREATE DATABASE VentasBD;

USE VentasBD; 
-- Creando una tabla con todos los ususarios para evitar problemas con la FK en la tabla Transactions
CREATE TABLE D_Users (
id INT NOT NULL,
name VARCHAR(100),
surname VARCHAR(100),
phone VARCHAR(150),
email VARCHAR(150),
birth_date VARCHAR(100),
country VARCHAR(100),
city VARCHAR(150),
postal_code VARCHAR(100),
address VARCHAR(255),
PRIMARY KEY (id)
);

USE VentasBD; 
-- creando tabla Companies
CREATE TABLE Companies (
company_id VARCHAR(15) NOT NULL,
company_name VARCHAR(255),
phone VARCHAR(15),
email VARCHAR(150),
country VARCHAR(100),
website VARCHAR(255),
PRIMARY KEY (company_id)
);

USE VentasBD; 
-- creando tabla Credit_card
CREATE TABLE Credit_cards (
id VARCHAR(15) NOT NULL,
user_id INT,
iban VARCHAR(50),
pan VARCHAR(19),
pin VARCHAR(4),
cvv VARCHAR(3),
track1 VARCHAR(100),
track2 VARCHAR(100),
expiring_date VARCHAR(10),
PRIMARY KEY (id)
);

USE  VentasBD; 
CREATE TABLE Transactions (
id VARCHAR(255) NOT NULL ,
card_id VARCHAR(15),
company_id VARCHAR(15),
timestamp timestamp,
amount DECIMAL(10,2),
declined BOOLEAN,
user_id INT,
lat FLOAT,
longitude FLOAT,
PRIMARY KEY (id),
CONSTRAINT fk_card_id FOREIGN KEY (card_id) REFERENCES Credit_cards (id),
CONSTRAINT fk_company_id FOREIGN KEY (company_id) REFERENCES Companies (company_id),
CONSTRAINT fk_D_users FOREIGN KEY (user_id ) REFERENCES D_users (id)
);

#Carga de datos

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\companies.csv' 
INTO TABLE companies
FIELDS TERMINATED BY ','  -- Aquí se pone el separador del docu
ENCLOSED BY '"'  -- Si usan comillas los campos
LINES TERMINATED BY '\n'  -- Salto de línea
IGNORE 1 LINES  -- Para omitir la primera línea con títulos de la cabecera
(company_id,company_name,phone,email,country,website);  -- Nombres de las columnas

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\credit_cards.csv' 
INTO TABLE credit_cards
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 LINES  
(id,user_id,iban,pan,pin,cvv,track1,track2,expiring_date);

#carga de ambos archivos en la misma tabla 
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\european_users.csv' 
INTO TABLE d_users
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 LINES 
(id, name, surname, phone, email, birth_date, country, city, postal_code, address);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\american_users.csv' 
INTO TABLE d_users
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES  
(id, name, surname, phone, email, birth_date, country, city, postal_code, address);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\transactions.csv' 
INTO TABLE Transactions
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, card_id, company_id, timestamp, amount, declined, @dummy, user_id, lat, longitude);

SELECT *
FROM companies;
SELECT *
FROM credit_cards;
SELECT *
FROM d_users;
SELECT *
FROM transactions;

#EJERCICIO 1
# Realiza una subconsulta que muestre a todos los usuarios con más de 80 transacciones utilizando al menos 2 tablas.

SELECT d_users.id, d_users.name as "Nombre", d_users.surname as "Apellido", COUNT(transactions.id) as CantidaddeTransacciones
FROM transactions
JOIN d_users
ON d_users.id = transactions.user_id
GROUP BY d_users.id, d_users.name, d_users.surname
HAVING CantidaddeTransacciones > 80;

#Ejercicio 2
#Muestra la media de amount por IBAN de las tarjetas de crédito en la compañía Donec Ltd., utiliza por lo menos 2 tablas.

SELECT iban, ROUND(AVG(amount), 2) as MediaMonto
FROM transactions
JOIN credit_cards
ON credit_cards.id = transactions.card_id
JOIN companies
ON companies.company_id = transactions.company_id
WHERE company_name = "Donec Ltd"
GROUP BY iban
ORDER BY MediaMonto DESC;
