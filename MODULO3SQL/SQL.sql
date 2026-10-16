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

-- TASK 3 POPOLA LE TABELLE.

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

-- TASK 4A.1 INTEGRITTA' . QUERY DI VERIFICA UNIVOCITA' DELLA CHIAVE PRIMARIA.

SELECT
COUNT(*) AS totale_righe, 
COUNT(DISTINCT product_id) AS id_distinti
FROM product;

-- in product risultano 10 righe con 10 id distinti tanti quanti i prodotti inseriti.

SELECT 
COUNT(*) AS totale_righe, 
COUNT(DISTINCT region_id) AS id_distinti
FROM region;

-- in region risultano 8 righe con 8 id distinti.

SELECT
COUNT(*) AS totale_righe, 
COUNT(DISTINCT sales_id) AS id_distinti
FROM sales;

--  totale_righe = id_distinti, nessun duplicato sulla chiave primaria sales_id

-- TASK 4A.2 JOIN. COSTUISCO L'ELENCO DELLE TRANSAZIONI CON INNER JOIN

select 
p.product_id, product_category, region_state, region_name, sales_date 
FROM sales s 
INNER JOIN product p ON s.product_id=p.product_id
INNER JOIN region r ON s.region_id=r.region_id;

-- 20 righe di risaltato, tante qualnte sono le righe di sales.

-- TASK 4A.3 AGGIUNGO UNA COLONNA BOOLEANA ALLA QUERY DI CUI SOPRA

SELECT p.product_id, product_category, region_state, region_name, sales_date,
CASE 
    WHEN DATEDIFF(CURDATE(), sales_date) > 180 THEN TRUE
    ELSE FALSE
END AS oltre_180_giorni
FROM sales s
INNER JOIN product p ON s.product_id = p.product_id
INNER JOIN region r ON s.region_id = r.region_id;

-- tutti i prodotti sono stati acquistati da piu di 180 giorni . 1= true.

-- TASK 4B.1 FATTURATO TOTALE PER PRODOTTO PER 1 ANNO.
-- fatturato totale per prodotto e per anno

SELECT 
product_id, YEAR(sales_date) AS anno,
SUM(sales_price * sales_quantity) AS fatturato_totale
FROM sales
GROUP BY product_id, YEAR(sales_date);

-- TASK 4B.2
-- Fatturato totale per stato e per anno, ordinato per data e per fatturato decrescente

SELECT r.region_state, YEAR(s.sales_date) AS anno, SUM(s.sales_price * s.sales_quantity) AS fatturato_totale
FROM sales s
INNER JOIN region r ON s.region_id = r.region_id
GROUP BY r.region_state, YEAR(s.sales_date)
ORDER BY anno, fatturato_totale DESC;

-- TASK 4B.3
-- Categoria di prodotto più richiesta, misurata come quantità totale venduta

SELECT p.product_category, SUM(s.sales_quantity) AS quantita_totale
FROM sales s
INNER JOIN product p ON s.product_id = p.product_id
GROUP BY p.product_category
ORDER BY quantita_totale DESC
LIMIT 1;
-- categoria piu richiesta e' costruzioni.

-- TASK 4C.1
-- CALCOLO CON UNA SUBQUERY LA QUANTITA MEDIA VENDUTA PER PRODOTTO NELL'ULTIMO ANNO.

SELECT AVG(tot_quantity) AS media_quantita
FROM (
    SELECT SUM(sales_quantity) AS tot_quantity
    FROM sales
    WHERE YEAR(sales_date) = (SELECT MAX(YEAR(sales_date)) FROM sales)
    GROUP BY product_id
) t; 

-- la media e di 50000

-- TASK 4C.2 
-- CALCOLO I PRODOTTO CHE, NELL'ULTIMO ANNO CENSITO, HANNO VENDUTO UNA QUANTITA SUPERIORE ALLA MEDIA DI VENDITA PER PRODOTTO, DI QUELL'ANNO.

SELECT product_id, SUM(sales_quantity) AS totale_venduto
FROM sales
WHERE YEAR(sales_date) = (SELECT MAX(YEAR(sales_date)) FROM sales)
GROUP BY product_id
HAVING SUM(sales_quantity) > (
    SELECT AVG(tot_quantity)
    FROM (
        SELECT SUM(sales_quantity) AS tot_quantity
        FROM sales
        WHERE YEAR(sales_date) = (SELECT MAX(YEAR(sales_date)) FROM sales)
        GROUP BY product_id
    ) t
);

-- product id 7, 9, 10 hanno venduto pezzi in quantita superiore alla media rispettivamente di 10, 8, 7 pezzi.


-- TASK 4C.3 
-- RISCRIVO LA STESSA QUERY MA CON CTE PER ISOLARE LA MEDIA

WITH media_prodotto AS (
    SELECT AVG(tot_quantity) AS media
    FROM (
        SELECT SUM(sales_quantity) AS tot_quantity
        FROM sales
        WHERE YEAR(sales_date) = (SELECT MAX(YEAR(sales_date)) FROM sales)
        GROUP BY product_id
    ) t
)
SELECT product_id, SUM(sales_quantity) AS totale_venduto
FROM sales
WHERE YEAR(sales_date) = (SELECT MAX(YEAR(sales_date)) FROM sales)
GROUP BY product_id
HAVING SUM(sales_quantity) > (SELECT media FROM media_prodotto);

-- il risultato e uguale alla query di sopra. 

-- TASK 4D.1
-- ASSEGNO A OGNI PRODOTTO UNA POSIZIONE IN CLASSIFICA PER FATTURATO TOTALE,
-- ALL'INTERNO DELLA PROPRIA CATEGORIA (RANK CON PARTITION BY CATEGORY)
-- CTE CHE ISOLA IL CALCOLO DEL FATTURATO TOTALE PER PRODOTTO, PER EVITARE
-- DI ANNIDARE UNA WINDOW FUNCTION DENTRO UN'ALTRA (NON CONSENTITO IN MYSQL)
WITH fatturato_prodotto AS (
    SELECT product_id, SUM(sales_price * sales_quantity) AS fatturato_totale_prodotto
    FROM sales
    GROUP BY product_id
)
SELECT 
    s.sales_id, s.product_id, p.product_category, s.sales_date,
    (s.sales_price * s.sales_quantity) AS fatturato_transazione,
    fp.fatturato_totale_prodotto,
    RANK() OVER (
        PARTITION BY p.product_category 
        ORDER BY fp.fatturato_totale_prodotto DESC
    ) AS posizione_in_categoria
FROM sales s
INNER JOIN product p ON s.product_id = p.product_id
INNER JOIN fatturato_prodotto fp ON s.product_id = fp.product_id;

-- TASK 4D.2
-- CALCOLO, PER OGNI TRANSAZIONE, IL TOTALE PROGRESSIVO DEL FATTURATO
-- DELLA REGIONE FINO A QUELLA DATA (SUM CON PARTITION BY REGION, ORDER BY DATA)
SELECT 
    s.sales_id, r.region_name, s.sales_date,
    (s.sales_price * s.sales_quantity) AS fatturato_transazione,
    SUM(s.sales_price * s.sales_quantity) OVER (
        PARTITION BY r.region_id 
        ORDER BY s.sales_date
    ) AS totale_progressivo_regione
FROM sales s
INNER JOIN region r ON s.region_id = r.region_id;

-- TASK 4D.3
-- CONFRONTO IL FATTURATO DI OGNI TRANSAZIONE CON QUELLO DELLA TRANSAZIONE
-- PRECEDENTE DELLA STESSA REGIONE (LAG CON PARTITION BY REGION, ORDER BY DATA)
SELECT 
    s.sales_id, r.region_name, s.sales_date,
    (s.sales_price * s.sales_quantity) AS fatturato_transazione,
    LAG(s.sales_price * s.sales_quantity) OVER (
        PARTITION BY r.region_id 
        ORDER BY s.sales_date
    ) AS fatturato_transazione_precedente
FROM sales s
INNER JOIN region r ON s.region_id = r.region_id;


-- TASK 4E.1
-- INDIVIDUO I PRODOTTI INVENDUTI: TUTTI I PRODOTTI IN PRODUCT
-- CHE NON COMPAIONO TRA I PRODUCT_ID DISTINTI PRESENTI IN SALES
SELECT product_id, product_name, product_category
FROM product
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM sales);

-- 4E.2
-- RISOLVO LA STESSA DOMANDA DEL PUNTO 1 CON UN SECONDO APPROCCIO:
-- LEFT JOIN TRA PRODUCT E SALES, TENENDO SOLO LE RIGHE SENZA CORRISPONDENZA (IS NULL)
SELECT p.product_id, p.product_name, p.product_category
FROM product p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.product_id IS NULL;

-- 4E.3
-- CREO UNA VISTA SUI PRODOTTI CHE ESPONE UNA VERSIONE DENORMALIZZATA
-- CON CODICE PRODOTTO, NOME PRODOTTO E NOME CATEGORIA
CREATE VIEW vw_prodotti AS
SELECT product_id, product_name, product_category
FROM product;

-- 4E.4
-- CREO UNA VISTA PER LE INFORMAZIONI GEOGRAFICHE, UTILE
-- A CHI ANALIZZA LE VENDITE PER AREA (REGIONE E STATO/MACRO-AREA)
CREATE VIEW vw_regioni AS
SELECT region_id, region_name, region_state
FROM region;

-- TEST
SELECT * FROM vw_prodotti;
SELECT * FROM vw_regioni;




-- GOVERNANCE E PRIVACY APPLICATA
-- NOTA: SCHEMA IPOTETICO (product/sales generico con purchase_cost, sales_amount, 
-- margin) DIVERSO DA TOYSGROUP. SEZIONE DA LEGGERE/VALUTARE, NON DA ESEGUIRE.
/*
-- Caso 1 — Vista pubblica
CREATE VIEW vw_prodotti_rivenditori AS
SELECT product_id, product_name, category, purchase_cost FROM product;

-- Causa: è una vista pubblica (destinata a rivenditori esterni) che espone purchase_cost
-- il costo di acquisto interno, un dato commercialmente sensibile che un soggetto esterno
-- non dovrebbe vedere. Viola il principio di minimizzazione dei dati (esporre solo ciò che è strettamente necessario allo scopo).

-- Versione corretta:
CREATE VIEW vw_prodotti_rivenditori AS
SELECT product_id, product_name, category FROM product;

-- Caso 2 — Scheda fornitori
CREATE TABLE supplier_contact (supplier_id INT, phone VARCHAR(20));
-- condivisa col reparto marketing

-- Causa: i contatti dei fornitori vengono condivisi con un reparto (marketing)
-- che non ha un bisogno legittimo (need-to-know) di quei dati — la gestione fornitori
-- è tipicamente competenza di acquisti/procurement, non marketing. Viola il principio di limitazione
-- della finalità e di accesso per ruolo.

-- Versione corretta: restringere l'accesso alla tabella solo al reparto competente, ad esempio tramite
-- permessi/ruolo dedicato invece di condivisione libera:
GRANT SELECT ON supplier_contact TO ruolo_acquisti;
-- nessun accesso concesso a marketing

-- Caso 3 — Vista commerciale
CREATE VIEW vw_sales_margine AS
SELECT sales_id, sales_amount, purchase_cost, margin FROM sales;

-- Causa: una vista ad uso commerciale (venditori/agenti) che espone purchase_cost e margin — dati che
-- rivelano la marginalità aziendale, informazione sensibile che dovrebbe restare riservata a management/finance,
-- non al reparto vendite operativo. Viola ancora minimizzazione dei dati e segregazione per ruolo.

-- Versione corretta:
CREATE VIEW vw_sales_margine AS
SELECT sales_id, sales_amount FROM sales;

-- Caso 4 — Log di reporting
CREATE TABLE report_access_log (
  user_id INT, query_text VARCHAR(250), access_date DATETIME
); -- nessuna scadenza

-- Causa: il log conserva query_text (che potrebbe contenere dati sensibili nelle query stesse)
-- senza alcuna politica di scadenza/retention. Viola il principio di limitazione della conservazione
-- (i dati vanno tenuti solo per il tempo necessario, non indefinitamente).

-- Versione corretta: aggiungere una policy di retention esplicita, ad esempio con un campo di scadenza o un processo di pulizia periodica:
CREATE TABLE report_access_log (
  user_id INT,
  query_text VARCHAR(250),
  access_date DATETIME,
  expiry_date DATETIME  -- es. access_date + 90 giorni, con job di pulizia automatica
);
*/