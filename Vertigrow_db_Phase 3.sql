Use vertigrow_db;
-- =============================================================
-- Phase 3: Querying and Analytical Operations

-- Step 1: 	Perform joins to combine multiple tables.
-- =============================================================
-- (i) INNER JOIN
-- Display each section along with the farm it belongs to.
SELECT
    s.section_id,
    s.section_name,
    f.farm_name
FROM SECTION s
INNER JOIN FARM f
    ON s.farm_id = f.farm_id;

-- Display harvest records along with the corresponding crop name.
SELECT
    h.harvest_id,
    c.crop_name,
    h.harvest_date,
    h.quantity_kg
FROM HARVEST h
INNER JOIN CROP c
    ON h.crop_id = c.crop_id;

-- Display harvest details along with the section and farm where the harvest occurred.
SELECT
    h.harvest_id,
    f.farm_name,
    s.section_name,
    h.harvest_date,
    h.quantity_kg
FROM HARVEST h
INNER JOIN SECTION s
    ON h.section_id = s.section_id
INNER JOIN FARM f
    ON s.farm_id = f.farm_id;
    
-- Display customer details along with their orders.
SELECT
    c.customer_id,
    c.customer_name,
    c.contact,
    o.order_id,
    o.order_date,
    o.total_amount
FROM CUSTOMER c
INNER JOIN ORDERS o
    ON c.customer_id = o.customer_id;
    
-- ============================================================
-- (ii): LEFT JOINS
-- Display all farms and their sections, including farms that have no sections.
SELECT
    f.farm_id,
    f.farm_name,
    s.section_id,
    s.section_name
FROM FARM f
LEFT JOIN SECTION s
    ON f.farm_id = s.farm_id;
-- ============================================================
-- (iii): RIGHT JOINS
-- Display all sections and their corresponding farms, including sections even if a farm is missing.
SELECT
    s.section_id,
    s.section_name,
    f.farm_id,
    f.farm_name
FROM FARM f
RIGHT JOIN SECTION s
    ON f.farm_id = s.farm_id;
-- ===============================================================
-- (iv): GROUP BY with JOIN
-- Calculate the number of sections available in each farm.
SELECT
    f.farm_id,
    f.farm_name,
    COUNT(s.section_id) AS section_count
FROM FARM f
LEFT JOIN SECTION s
    ON f.farm_id = s.farm_id
GROUP BY
    f.farm_id,
    f.farm_name;
-- ====================================================================
-- (v): HAVING with GROUP BY
-- Display only farms that have more than 2 sections.
SELECT
    f.farm_id,
    f.farm_name,
    COUNT(s.section_id) AS section_count
FROM FARM f
LEFT JOIN SECTION s
    ON f.farm_id = s.farm_id
GROUP BY
    f.farm_id,
    f.farm_name
HAVING COUNT(s.section_id) > 2;

-- ===================================================================
-- Step 2: Write nested and subqueries
 -- Display harvest records whose quantity is greater than the overall average harvest quantity.

SELECT
    harvest_id,
    crop_id,
    section_id,
    harvest_date,
    quantity_kg
FROM HARVEST
WHERE quantity_kg > (
    SELECT AVG(quantity_kg)
    FROM HARVEST );

-- Display crops whose total harvested quantity is greater than the average total quantity across crops.
SELECT
    crop_id,
    SUM(quantity_kg) AS total_quantity_kg
FROM HARVEST
GROUP BY crop_id
HAVING SUM(quantity_kg) > (
    SELECT AVG(crop_total)
    FROM (
        SELECT SUM(quantity_kg) AS crop_total
        FROM HARVEST
        GROUP BY crop_id
    ) AS crop_summary );
    
-- Nested Subquery
-- Retrieve farms whose section count is above the average section count per farm.
SELECT
    f.farm_id,
    f.farm_name
FROM farm f
WHERE (
    SELECT COUNT(*)
    FROM section s
    WHERE s.farm_id = f.farm_id
) > (
    SELECT AVG(section_count)
    FROM (
        SELECT COUNT(*) AS section_count
        FROM section
        GROUP BY farm_id
    ) AS farm_section_counts
);

-- ===================================================================
-- Step 3: Create views for reusable queries

-- Create a reusable view showing harvest details with crop, section, and farm information.
CREATE VIEW Harvest_Summary AS
SELECT
    h.harvest_id,
    c.crop_name,
    s.section_name,
    f.farm_name
FROM HARVEST h
INNER JOIN CROP c
    ON h.crop_id = c.crop_id
INNER JOIN SECTION s
    ON h.section_id = s.section_id
INNER JOIN FARM f
    ON s.farm_id = f.farm_id;
        
-- Display the records stored through the Harvest_Summary view.
SELECT * FROM Harvest_Summary;

-- Update the quantity of a specific harvest record.
UPDATE HARVEST
SET quantity_kg = 900
WHERE harvest_id = 1;

-- Verify the updated harvest quantity.
SELECT
    harvest_id,
    quantity_kg
FROM HARVEST
WHERE harvest_id = 1;

-- Insert a new harvest record into the HARVEST table.
INSERT INTO HARVEST
    (crop_id, section_id, harvest_date, quantity_kg)
VALUES
    (1, 1, '2026-08-21', 600.00);

-- Verify that the new harvest record was inserted successfully.
SELECT *
FROM HARVEST
WHERE harvest_date = '2026-08-21'
  AND quantity_kg = 600.00;

DELETE FROM HARVEST
WHERE harvest_id = 21;

SELECT *
FROM HARVEST
WHERE harvest_id = 21;

-- Create a reusable procedure to display harvests above a specified quantity.
DELIMITER //
CREATE PROCEDURE GetHarvestAboveQuantity(IN min_quantity DECIMAL(10,2))
BEGIN
    SELECT
        harvest_id,
        crop_id,
        section_id,
        harvest_date,
        quantity_kg
    FROM HARVEST
    WHERE quantity_kg > min_quantity
    ORDER BY quantity_kg DESC;
END //

DELIMITER ;
-- Display harvest records having a quantity greater than 500 kg.
CALL GetHarvestAboveQuantity(700);

