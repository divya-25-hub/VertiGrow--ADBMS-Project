USE VERTIGROW_DB;

-- =================================================
-- PHASE 2- Database Creation and Data Preparation
-- ==================================================

-- =================================================
-- Shows all 8 tables and,
-- approximately how many records each contains.
-- =================================================
SELECT 
    TABLE_NAME,
    TABLE_ROWS
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'VERTIGROW_DB'
ORDER BY TABLE_NAME;

-- ====================================================
-- Step 1: DDL / Verify the structure of all 8 tables
-- ====================================================
DESCRIBE FARM;
DESCRIBE SECTION;
DESCRIBE CROP;
DESCRIBE EMPLOYEE;
DESCRIBE EQUIPMENT;
DESCRIBE HARVEST;
DESCRIBE CUSTOMER;
DESCRIBE ORDERS;

-- ===================================================
-- DML / Record Verification
-- ===================================================
SELECT * FROM FARM;
SELECT * FROM SECTION;
SELECT * FROM CROP;
SELECT * FROM EMPLOYEE;
SELECT * FROM EQUIPMENT;
SELECT * FROM HARVEST;
SELECT * FROM CUSTOMER;
SELECT * FROM ORDERS;

USE VERTIGROW_DB;

-- =================================================
-- Step 2: Data Cleaning — NULL Handling
-- =================================================
SELECT
    'FARM' AS TABLE_NAME,
    SUM(farm_id IS NULL) AS NULL_FARM_ID,
    SUM(farm_name IS NULL) AS NULL_FARM_NAME,
    SUM(location IS NULL) AS NULL_LOCATION,
    SUM(total_area IS NULL) AS NULL_TOTAL_AREA
FROM FARM;

-- ================================================
-- Check NULLs in all 8 tables
-- ================================================
SELECT 'FARM' AS TABLE_NAME,
       SUM(farm_id IS NULL) AS NULL_FARM_ID,
       SUM(farm_name IS NULL) AS NULL_FARM_NAME,
       SUM(location IS NULL) AS NULL_LOCATION,
       SUM(total_area IS NULL) AS NULL_TOTAL_AREA
FROM FARM

UNION ALL

SELECT 'SECTION',
       SUM(section_id IS NULL),
       SUM(section_name IS NULL),
       SUM(floor_level IS NULL),
       SUM(farm_id IS NULL)
FROM SECTION

UNION ALL

SELECT 'CROP',
       SUM(crop_id IS NULL),
       SUM(crop_name IS NULL),
       SUM(growth_cycle_days IS NULL),
       SUM(optimal_temp IS NULL)
FROM CROP

UNION ALL

SELECT 'EMPLOYEE',
       SUM(employee_id IS NULL),
       SUM(name IS NULL),
       SUM(role IS NULL),
       SUM(contact IS NULL)
FROM EMPLOYEE

UNION ALL

SELECT 'EQUIPMENT',
       SUM(equipment_id IS NULL),
       SUM(equipment_name IS NULL),
       SUM(section_id IS NULL),
       SUM(status IS NULL)
FROM EQUIPMENT

UNION ALL

SELECT 'HARVEST',
       SUM(harvest_id IS NULL),
       SUM(section_id IS NULL),
       SUM(crop_id IS NULL),
       SUM(harvest_date IS NULL)
FROM HARVEST

UNION ALL

SELECT 'CUSTOMER',
       SUM(customer_id IS NULL),
       SUM(customer_name IS NULL),
       SUM(contact IS NULL),
       SUM(email IS NULL)
FROM CUSTOMER

UNION ALL

SELECT 'ORDERS',
       SUM(order_id IS NULL),
       SUM(customer_id IS NULL),
       SUM(order_date IS NULL),
       SUM(total_amount IS NULL)
FROM ORDERS;

-- ====================================================
-- Step 3: Basic SQL Queries

-- Basic SELECT commands
-- ====================================================
SELECT * FROM FARM;

SELECT farm_name, location, total_area
FROM FARM;

-- =====================================================
-- Using WHERE commands
-- Display farms that are located in Bengaluru.
-- =====================================================
SELECT *
FROM FARM
WHERE location = 'Bengaluru';

-- Display farms whose total area is greater than 25 acres.
SELECT *
FROM FARM
WHERE total_area > 25;

-- =====================================================
-- Basic ORDER BY commands.
-- Display all farms sorted by total area from smallest to largest.
-- ======================================================
SELECT *
FROM FARM
ORDER BY total_area ASC; 

-- =================================================================================
--  Step 4- Aggregate functions
-- Count ()- Count the total number of harvest records stored in the HARVEST table.
SELECT COUNT(*) AS total_harvest_records
FROM HARVEST;

-- Avg()- Calculate the average quantity harvested across all harvest records.
SELECT AVG(quantity_kg) AS average_harvest_quantity
FROM HARVEST;

-- Sum()- Calculate the total quantity harvested across all harvest records.
SELECT SUM(quantity_kg) AS total_harvest_quantity
FROM HARVEST;

-- Count the number of harvest records for each crop.
SELECT
    crop_id,
    COUNT(*) AS harvest_count
FROM HARVEST
GROUP BY crop_id;

-- Calculate the total quantity harvested for each crop.
SELECT
    crop_id,
    SUM(quantity_kg) AS total_quantity_kg
FROM HARVEST
GROUP BY crop_id;

-- Calculate the average quantity harvested for each crop.
SELECT
    crop_id,
    AVG(quantity_kg) AS average_quantity_kg
FROM HARVEST
GROUP BY crop_id;

-- Display crops whose total harvested quantity exceeds 1000 kg.
SELECT
    crop_id,
    SUM(quantity_kg) AS total_quantity_kg
FROM HARVEST
GROUP BY crop_id
HAVING SUM(quantity_kg) > 1000;

-- ===============================================================
-- Check for NULL values in the main HARVEST table fields.
SELECT
    SUM(harvest_id IS NULL) AS null_harvest_id,
    SUM(crop_id IS NULL) AS null_crop_id,
    SUM(section_id IS NULL) AS null_section_id,
    SUM(quantity_kg IS NULL) AS null_quantity_kg
FROM HARVEST;

-- ================================================================
-- Phase 2 Completed
-- ================================================================


