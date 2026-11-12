CREATE DATABASE VERTIGROW_DB;

USE VERTIGROW_DB;
SHOW DATABASES;
-- 1. FARM
CREATE TABLE FARM (
    farm_id INT PRIMARY KEY AUTO_INCREMENT,
    farm_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    total_area DECIMAL(10,2) NOT NULL,
    CHECK (total_area > 0)
);


-- 2. SECTION
CREATE TABLE SECTION (
    section_id INT PRIMARY KEY AUTO_INCREMENT,
    section_name VARCHAR(100) NOT NULL,
    floor_level INT NOT NULL,
    farm_id INT NOT NULL,

    CONSTRAINT fk_section_farm
        FOREIGN KEY (farm_id)
        REFERENCES FARM(farm_id),

    CHECK (floor_level > 0)
);


-- 3. CROP
CREATE TABLE CROP (
    crop_id INT PRIMARY KEY AUTO_INCREMENT,
    crop_name VARCHAR(50) NOT NULL,
    growth_cycle_days INT NOT NULL,
    optimal_temp DECIMAL(5,2) NOT NULL,

    CHECK (growth_cycle_days > 0)
);


-- 4. EMPLOYEE
CREATE TABLE EMPLOYEE (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    contact VARCHAR(15) NOT NULL UNIQUE
);


-- 5. EQUIPMENT
CREATE TABLE EQUIPMENT (
    equipment_id INT PRIMARY KEY AUTO_INCREMENT,
    equipment_name VARCHAR(100) NOT NULL,
    section_id INT NOT NULL,
    status VARCHAR(20) NOT NULL,

    CONSTRAINT fk_equipment_section
        FOREIGN KEY (section_id)
        REFERENCES SECTION(section_id),

    CHECK (status IN ('Active', 'Maintenance', 'Inactive'))
);


-- 6. HARVEST
CREATE TABLE HARVEST (
    harvest_id INT PRIMARY KEY AUTO_INCREMENT,
    section_id INT NOT NULL,
    crop_id INT NOT NULL,
    harvest_date DATE NOT NULL,
    quantity_kg DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_harvest_section
        FOREIGN KEY (section_id)
        REFERENCES SECTION(section_id),

    CONSTRAINT fk_harvest_crop
        FOREIGN KEY (crop_id)
        REFERENCES CROP(crop_id),

    CHECK (quantity_kg > 0)
);


-- 7. CUSTOMER
CREATE TABLE CUSTOMER (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    contact VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE
);


-- 8. ORDERS
CREATE TABLE ORDERS (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES CUSTOMER(customer_id),

    CHECK (total_amount > 0)
);
show tables;


USE VERTIGROW_DB;
-- =========================================
-- INSERTION OF VALUES
-- =========================================

-- =========================================
-- 1. FARM
-- =========================================

INSERT INTO FARM (farm_id, farm_name, location, total_area) VALUES
(1, 'Green Valley Farms', 'Bengaluru', 25.50),
(2, 'Sunrise Agro Farm', 'Mysuru', 18.75),
(3, 'EcoHarvest Farm', 'Tumakuru', 32.00),
(4, 'FreshFields Farm', 'Mandya', 21.25),
(5, 'NatureNest Farms', 'Hassan', 27.80);


-- =========================================
-- 2. SECTION
-- =========================================

INSERT INTO SECTION (section_id, section_name, floor_level, farm_id) VALUES
(1, 'North Field', 1, 1),
(2, 'South Field', 1, 1),
(3, 'Greenhouse A', 2, 1),
(4, 'Greenhouse B', 2, 1),
(5, 'East Field', 1, 2),
(6, 'West Field', 1, 2),
(7, 'Organic Zone', 1, 2),
(8, 'Hydroponic Unit', 2, 3),
(9, 'Open Field A', 1, 3),
(10, 'Open Field B', 1, 3),
(11, 'Greenhouse C', 2, 3),
(12, 'Central Field', 1, 4),
(13, 'Vegetable Zone', 1, 4),
(14, 'Fruit Zone', 1, 4),
(15, 'Nursery Section', 2, 5),
(16, 'Herbal Zone', 1, 5),
(17, 'Root Crop Zone', 1, 5);


-- =========================================
-- 3. CROP
-- =========================================

INSERT INTO CROP (crop_id, crop_name, growth_cycle_days, optimal_temp) VALUES
(1, 'Tomato', 90, 24.50),
(2, 'Spinach', 45, 20.00),
(3, 'Carrot', 75, 18.50),
(4, 'Potato', 100, 19.00),
(5, 'Capsicum', 110, 25.00),
(6, 'Cucumber', 60, 26.00),
(7, 'Lettuce', 40, 18.00),
(8, 'Strawberry', 120, 22.00),
(9, 'Onion', 100, 20.50),
(10, 'Beans', 65, 23.00);


-- =========================================
-- 4. EMPLOYEE
-- =========================================

INSERT INTO EMPLOYEE (employee_id, name, role, contact) VALUES
(1, 'Arjun Kumar', 'Farm Manager', '9876501001'),
(2, 'Priya Sharma', 'Agricultural Officer', '9876501002'),
(3, 'Rahul Nair', 'Field Supervisor', '9876501003'),
(4, 'Sneha Rao', 'Crop Specialist', '9876501004'),
(5, 'Kiran Reddy', 'Equipment Operator', '9876501005'),
(6, 'Ananya Das', 'Farm Assistant', '9876501006'),
(7, 'Vivek Shetty', 'Field Supervisor', '9876501007'),
(8, 'Megha Joshi', 'Agricultural Officer', '9876501008'),
(9, 'Rohit Verma', 'Equipment Operator', '9876501009'),
(10, 'Divya Menon', 'Farm Assistant', '9876501010'),
(11, 'Sanjay Rao', 'Crop Specialist', '9876501011'),
(12, 'Pooja Iyer', 'Farm Assistant', '9876501012');


-- =========================================
-- 5. EQUIPMENT
-- =========================================

INSERT INTO EQUIPMENT (equipment_id, equipment_name, section_id, status) VALUES
(1, 'Automated Irrigation System', 1, 'Active'),
(2, 'Soil Moisture Sensor', 2, 'Active'),
(3, 'Temperature Controller', 3, 'Active'),
(4, 'Automated Sprayer', 4, 'Maintenance'),
(5, 'Water Pump', 5, 'Active'),
(6, 'Tractor', 6, 'Active'),
(7, 'Seed Planter', 7, 'Active'),
(8, 'Hydroponic Controller', 8, 'Active'),
(9, 'Harvesting Machine', 9, 'Active'),
(10, 'Fertilizer Spreader', 10, 'Maintenance'),
(11, 'Climate Controller', 11, 'Active'),
(12, 'Drip Irrigation Unit', 12, 'Active'),
(13, 'Crop Monitoring Camera', 13, 'Active'),
(14, 'Fruit Sorting Machine', 14, 'Active'),
(15, 'Seedling Transplanter', 15, 'Active'),
(16, 'Herb Processing Unit', 16, 'Inactive'),
(17, 'Root Crop Harvester', 17, 'Active');


-- =========================================
-- 6. HARVEST
-- =========================================

INSERT INTO HARVEST
(harvest_id, section_id, crop_id, harvest_date, quantity_kg) VALUES
(1, 1, 1, '2026-01-15', 850.50),
(2, 2, 2, '2026-01-20', 420.00),
(3, 3, 5, '2026-02-05', 675.25),
(4, 4, 6, '2026-02-12', 510.75),
(5, 5, 3, '2026-02-18', 390.00),
(6, 6, 4, '2026-02-25', 920.50),
(7, 7, 10, '2026-03-02', 480.25),
(8, 8, 7, '2026-03-08', 350.00),
(9, 9, 1, '2026-03-15', 780.00),
(10, 10, 9, '2026-03-20', 650.75),
(11, 11, 8, '2026-03-28', 290.50),
(12, 12, 2, '2026-04-05', 440.00),
(13, 13, 5, '2026-04-12', 720.25),
(14, 14, 8, '2026-04-20', 315.00),
(15, 15, 7, '2026-04-28', 280.75),
(16, 16, 10, '2026-05-05', 465.50),
(17, 17, 4, '2026-05-12', 875.00),
(18, 1, 6, '2026-05-20', 530.25),
(19, 3, 1, '2026-05-28', 810.50),
(20, 5, 3, '2026-06-05', 405.00);


-- =========================================
-- 7. CUSTOMER
-- =========================================

INSERT INTO CUSTOMER
(customer_id, customer_name, contact, email) VALUES
(1, 'FreshMart Retail', '9000010001', 'freshmart@gmail.com'),
(2, 'GreenBasket Stores', '9000010002', 'greenbasket@gmail.com'),
(3, 'NatureFoods Pvt Ltd', '9000010003', 'naturefoods@gmail.com'),
(4, 'OrganicHub Bengaluru', '9000010004', 'organichub@gmail.com'),
(5, 'DailyFresh Supermarket', '9000010005', 'dailyfresh@gmail.com'),
(6, 'Farm2Home', '9000010006', 'farm2home@gmail.com'),
(7, 'HealthyHarvest Foods', '9000010007', 'healthyharvest@gmail.com'),
(8, 'UrbanVeg Mart', '9000010008', 'urbanveg@gmail.com'),
(9, 'GreenBasket Mysuru', '9000010009', 'greenbasketmysuru@gmail.com'),
(10, 'Natural Choice Foods', '9000010010', 'naturalchoice@gmail.com');


-- =========================================
-- 8. ORDERS
-- =========================================

INSERT INTO ORDERS
(order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2026-02-01', 18500.00),
(2, 2, '2026-02-08', 12350.00),
(3, 3, '2026-02-15', 25600.00),
(4, 4, '2026-02-22', 17850.00),
(5, 5, '2026-03-01', 31400.00),
(6, 6, '2026-03-10', 14250.00),
(7, 7, '2026-03-18', 28900.00),
(8, 8, '2026-03-25', 16750.00),
(9, 9, '2026-04-02', 22100.00),
(10, 10, '2026-04-10', 19500.00),
(11, 1, '2026-04-18', 27350.00),
(12, 2, '2026-04-25', 15400.00),
(13, 3, '2026-05-03', 32900.00),
(14, 4, '2026-05-10', 18750.00),
(15, 5, '2026-05-18', 24600.00),
(16, 6, '2026-05-25', 13850.00),
(17, 7, '2026-06-02', 30200.00),
(18, 8, '2026-06-10', 17500.00),
(19, 9, '2026-06-18', 21850.00),
(20, 10, '2026-06-25', 26400.00);

-- =================================
-- 1NF EXECUTION
-- =================================
SELECT * FROM FARM;
SELECT * FROM SECTION;
SELECT * FROM CROP;
SELECT * FROM EMPLOYEE;
SELECT * FROM EQUIPMENT;
SELECT * FROM HARVEST;
SELECT * FROM CUSTOMER;
SELECT * FROM ORDERS;

-- ============================================
-- check for multi-valued/comma-separated data
-- =============================================
SELECT *
FROM FARM
WHERE farm_name LIKE '%,%'
   OR location LIKE '%,%';
   
SELECT *
FROM CROP
WHERE crop_name LIKE '%,%';

-- =============================================
-- Check whether every table has a primary key
-- =============================================
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'VERTIGROW_DB'
  AND CONSTRAINT_NAME = 'PRIMARY';

USE VERTIGROW_DB;

-- ================================================
-- 2NF Execution
-- ================================================
-- ================================================
-- Checking / Verifying foreign-key relationships
-- ================================================
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'VERTIGROW_DB'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
  
  -- ===========================================
  -- Check if every table has 1 primary-key column
  -- ===========================================
  SELECT
    TABLE_NAME,
    COUNT(*) AS PRIMARY_KEY_COLUMNS
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'VERTIGROW_DB'
  AND CONSTRAINT_NAME = 'PRIMARY'
GROUP BY TABLE_NAME;

-- =========================================
-- SQL QUERIES
-- =========================================
USE VERTIGROW_DB;

-- =========================================
-- Basic retrieval + filtering queries
-- Find farms in a particular location
-- =========================================
SELECT farm_name, location, total_area
FROM FARM
WHERE location = 'Bengaluru';

-- ===========================================
-- Complete actual structure of the 8 tables.
-- ===========================================
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'VERTIGROW_DB'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- ==============================================
-- 3NF Verified
-- ==============================================

-- ================================================
-- Check all UNIQUE constraints
-- BCNF Verfication
-- ================================================
SELECT
    tc.TABLE_NAME,
    kcu.COLUMN_NAME,
    tc.CONSTRAINT_NAME,
    tc.CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
    AND tc.TABLE_SCHEMA = kcu.TABLE_SCHEMA
    AND tc.TABLE_NAME = kcu.TABLE_NAME
WHERE tc.TABLE_SCHEMA = 'VERTIGROW_DB'
  AND tc.CONSTRAINT_TYPE IN ('PRIMARY KEY', 'UNIQUE')
ORDER BY tc.TABLE_NAME, tc.CONSTRAINT_TYPE, kcu.COLUMN_NAME;

-- ============================================================
-- Phase 1 Completed
-- ============================================================