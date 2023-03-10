-- Code developed on MySQL 8.0.31.
-- If using the provided mysql docker compose, you can use root/root on localhost:3306

-- Setup
CREATE DATABASE IF NOT EXISTS ARTICLE;
USE ARTICLE;
DROP TABLE IF EXISTS FACT_SALES_NO_SK;

CREATE TABLE IF NOT EXISTS FACT_SALES_NO_SK(
PRODUCT_SK INT,
CLIENT_SK INT,
QUANTITY INT,
AMOUNT FLOAT,
TOTAL_AMOUNT FLOAT,
SALES_DATETIME DATETIME
);

INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (1,1,1,2.99,2.99,'2023-01-15 10:10:11');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (1,1,1,2.99,2.99,'2023-01-15 10:10:11');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (1,1,1,2.99,2.99,'2023-01-15 10:10:11');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (1,1,1,2.99,2.99,'2023-01-15 10:10:11');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (1,1,1,2.99,2.99,'2023-01-15 10:10:11');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (1,1,1,2.99,2.99,'2023-01-15 10:10:11');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (2,2,3,5.79,5.79*3,'2023-01-16 18:56:02');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (2,2,3,5.79,5.79*3,'2023-01-16 18:56:02');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (2,2,3,5.79,5.79*3,'2023-01-16 18:56:02');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (2,2,3,5.79,5.79*3,'2023-01-16 18:56:02');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (2,2,3,5.79,5.79*3,'2023-01-16 18:56:02');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (2,2,3,5.79,5.79*3,'2023-01-16 18:56:02');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (2,2,3,5.79,5.79*3,'2023-01-16 18:56:02');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (2,3,7,11.99,11.99*7,'2023-01-16 18:56:02');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (2,3,7,11.99,11.99*7,'2023-01-16 18:56:02');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (2,3,7,11.99,11.99*7,'2023-01-16 18:56:02');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (2,3,7,11.99,11.99*7,'2023-01-16 18:56:02');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (2,3,7,11.99,11.99*7,'2023-01-16 18:56:02');
INSERT INTO FACT_SALES_NO_SK (PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME) VALUES (2,3,7,11.99,11.99*7,'2023-01-16 18:56:02');

SELECT * FROM FACT_SALES_NO_SK;

-- The sequence of commands below is idempotent
-- Select records that are duplicated and insert in a separate table
DROP TABLE IF EXISTS FACT_SALES_NO_SK_DUPLICATES;

CREATE TABLE FACT_SALES_NO_SK_DUPLICATES AS 
SELECT COUNT(PRODUCT_SK) ROW_COUNT, PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME 
FROM FACT_SALES_NO_SK 
GROUP BY PRODUCT_SK ,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME 
HAVING COUNT(PRODUCT_SK) > 1;

SELECT * FROM FACT_SALES_NO_SK_DUPLICATES;

-- Delete the duplicates from fact 
DELETE FSNOSK FROM FACT_SALES_NO_SK FSNOSK INNER JOIN FACT_SALES_NO_SK_DUPLICATES FSNOSKDUPS
ON FSNOSK.PRODUCT_SK = FSNOSKDUPS.PRODUCT_SK 
AND FSNOSK.CLIENT_SK = FSNOSKDUPS.CLIENT_SK 
AND FSNOSK.QUANTITY = FSNOSKDUPS.QUANTITY 
AND FSNOSK.AMOUNT = FSNOSKDUPS.AMOUNT 
AND FSNOSK.TOTAL_AMOUNT = FSNOSKDUPS.TOTAL_AMOUNT;

SELECT * FROM FACT_SALES_NO_SK;

-- Insert deduplicated data to the fact table
INSERT INTO FACT_SALES_NO_SK SELECT PRODUCT_SK,CLIENT_SK,QUANTITY,AMOUNT,TOTAL_AMOUNT,SALES_DATETIME FROM FACT_SALES_NO_SK_DUPLICATES;

DROP TABLE FACT_SALES_NO_SK_DUPLICATES;

SELECT * FROM FACT_SALES_NO_SK;
