--  CREA IL DATABASE
CREATE DATABASE toysgroup;
USE toysgroup;

-- TASK 2 CREAZIONE DELLE TABELLE
-- Creo le tabelle per il database specificando per ogni entita la tipologia di carattere e criteri specifici.

CREATE TABLE product (
    product_id    INT PRIMARY KEY AUTO_INCREMENT,
    product_name  VARCHAR(100) NOT NULL,
    product_category VARCHAR(50) NOT NULL
);

CREATE TABLE region (
    region_id     INT PRIMARY KEY AUTO_INCREMENT,
    region_name   VARCHAR(50) NOT NULL,
    region_state  VARCHAR(50) NOT NULL
);

CREATE TABLE sales (
    sales_id      INT PRIMARY KEY AUTO_INCREMENT,
    product_id    INT NOT NULL,
    region_id     INT NOT NULL,
    sales_price   DECIMAL(10,2) NOT NULL,
    sales_date    DATE NOT NULL,
    sales_quantity INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (region_id)  REFERENCES region(region_id)
);

-- TASK 3 POPOLA LE TABELLE

-- Product
INSERT INTO product (product_name, product_category) VALUES
('Lego Star Wars', 'Costruzioni'),
('Barbie Dreamhouse', 'Bambolotti'),
('Play-Doh Starter Set', 'Plastiche'),
('Hot Wheels Track Set', 'Veicoli'),
('LEGO City Police Station', 'Costruzioni'),
('Mega Bloks Castle', 'Costruzioni'),
('Nerf N-Strike Blaster', 'Pistole'),
('Fisher-Price Piano', 'Musica'),
('Hot Wheels Monster Truck', 'Veicoli'),
('Barbie Fashion Pack', 'Bambolotti');

-- Region
INSERT INTO region (region_name, region_state) VALUES
('Lombardia', 'Nord'),
('Lazio', 'Centro'),
('Campania', 'Sud'),
('Veneto', 'Nord'),
('Toscana', 'Centro'),
('Sicilia', 'Sud'),
('Piemonte', 'Nord'),
('Emilia-Romagna', 'Centro');

-- Sales
INSERT INTO sales (product_id, region_id, sales_price, sales_date, sales_quantity) VALUES
(1, 1, 59.99, '2025-01-15', 3),
(2, 4, 89.99, '2024-02-10', 2),
(3, 3, 12.99, '2025-02-03', 5),
(4, 4, 44.99, '2025-02-10', 2),
(5, 6, 79.99, '2024-05-22', 3),
(6, 5, 34.99, '2025-03-01', 4),
(7, 6, 24.99, '2025-03-05', 6),
(8, 1, 19.99, '2024-08-14', 5),
(9, 8, 14.99, '2025-03-20', 8),
(10, 2, 29.99, '2025-04-01', 3),
(1, 3, 59.99, '2025-04-10', 2),
(4, 5, 44.99, '2025-04-15', 1),
(7, 1, 24.99, '2025-05-01', 4),
(3, 7, 12.99, '2024-11-03', 4),
(5, 4, 79.99, '2025-05-20', 1),
(9, 3, 14.99, '2023-03-18', 6),
(2, 8, 89.99, '2025-06-15', 2),
(6, 8, 34.99, '2023-10-25', 3),
(10, 5, 29.99, '2025-07-01', 4),
(1, 5, 59.99, '2023-07-09', 2);   

-- TASK 4A.1 QUERY DI VERIFICA UNIVOCITA' DELLA CHIAVE PRIMARIA

SELECT
COUNT(*) AS totale_righe, 
COUNT(DISTINCT product_id) AS id_distinti
FROM product;

-- risultano 10 righe con 10 id distinti tanti quanti i prodotti inseriti.

SELECT 
COUNT(*) AS totale_righe, 
COUNT(DISTINCT region_id) AS id_distinti
FROM region;

-- risultano 8 righe con 8 id distinti







