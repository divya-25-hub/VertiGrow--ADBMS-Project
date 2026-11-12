-- ---------------------------------------------------
-- PHASE 4 Data Integrity and Transaction Handling --

Use Vertigrow_db;
-- ---------------------------------------------
-- Step 1: Transaction Commands--
-- Check the current quantity of harvest record 1.
SELECT harvest_id, quantity_kg
FROM HARVEST
WHERE harvest_id = 1;

-- Temporarily change harvest record 1 from 750 kg to 600 kg.
UPDATE HARVEST
SET quantity_kg = 600
WHERE harvest_id = 1;

SELECT harvest_id, quantity_kg
FROM HARVEST
WHERE harvest_id = 1;

rollback;

-- Confirm that the harvest quantity has returned to 800 kg.
SELECT harvest_id, quantity_kg
FROM HARVEST
WHERE harvest_id = 1;

-- --------------------------------------------------------------------
-- Start a new transaction to practise using a savepoint.
START TRANSACTION;

-- Change harvest record 1 from 750 kg to 800 kg within the transaction.
UPDATE HARVEST
SET quantity_kg = 800
WHERE harvest_id = 1;

-- Create a savepoint after the first update so we can return to this stage.
SAVEPOINT first_update;

-- Change harvest record 1 from 800 kg to 650 kg after the savepoint.
UPDATE HARVEST
SET quantity_kg = 650
WHERE harvest_id = 1;

-- Undo changes made after the savepoint while keeping earlier changes in the transaction.
ROLLBACK TO SAVEPOINT first_update;

-- Verify that the quantity returned to 800 kg after rolling back to the savepoint.
SELECT harvest_id, quantity_kg
FROM HARVEST
WHERE harvest_id = 1;

COMMIT;

-- Check the current quantities of harvest records 1 and 2 before testing atomicity.
SELECT harvest_id, quantity_kg
FROM HARVEST
WHERE harvest_id IN (1, 2)
ORDER BY harvest_id;

-- ----------------------------------------------------------------------------------
-- Start an explicit transaction for the atomicity demonstration.
START TRANSACTION;

-- Temporarily change harvest record 1.
UPDATE HARVEST SET quantity_kg = 800 WHERE harvest_id = 1;

-- Temporarily change harvest record 2.
UPDATE HARVEST SET quantity_kg = 420 WHERE harvest_id = 2;

-- Permanently save the restored quantities of both harvest records.
COMMIT;

-- Verify that both original quantities have been restored.
SELECT harvest_id, quantity_kg
FROM HARVEST
WHERE harvest_id IN (1, 2)
ORDER BY harvest_id;

-- Display the HARVEST table definition and its existing integrity constraints.
SHOW CREATE TABLE HARVEST;

-- -----------------------------------------------------------------------
-- Validate harvest records and identify any missing or invalid values.
SELECT
    COUNT(*) AS total_records,
    SUM(quantity_kg IS NULL) AS null_quantities,
    SUM(quantity_kg <= 0) AS invalid_quantities,
    MIN(quantity_kg) AS minimum_quantity,
    MAX(quantity_kg) AS maximum_quantity
FROM HARVEST;

-- -------------------------------------------------------------
-- List columns, data types, nullability, and key information for all VERTIGROW tables.
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'vertigrow_db'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- --------------------------------------------------------------------------
-- Validate the record counts across the main VERTIGROW database tables.
SELECT 'FARM' AS table_name, COUNT(*) AS total_records FROM FARM
UNION ALL
SELECT 'SECTION', COUNT(*) FROM SECTION
UNION ALL
SELECT 'CROP', COUNT(*) FROM CROP
UNION ALL
SELECT 'HARVEST', COUNT(*) FROM HARVEST
UNION ALL
SELECT 'EQUIPMENT', COUNT(*) FROM EQUIPMENT
UNION ALL
SELECT 'EMPLOYEE', COUNT(*) FROM EMPLOYEE
UNION ALL
SELECT 'CUSTOMER', COUNT(*) FROM CUSTOMER
UNION ALL
SELECT 'ORDERS', COUNT(*) FROM ORDERS;

-- ------------------------------------------------------------
START TRANSACTION;

UPDATE HARVEST
SET quantity_kg = 600
WHERE harvest_id = 1;

SELECT harvest_id, quantity_kg
FROM HARVEST
WHERE harvest_id = 1;

ROLLBACK;

SELECT harvest_id, quantity_kg
FROM HARVEST
WHERE harvest_id = 1;

-- Retrieve harvest records along with their associated crop and section.
SELECT h.harvest_id,
       c.crop_name,
       s.section_name,
       h.harvest_date,
       h.quantity_kg
FROM harvest h
JOIN crop c ON h.crop_id = c.crop_id
JOIN section s ON h.section_id = s.section_id;