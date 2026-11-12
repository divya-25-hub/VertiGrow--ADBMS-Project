-- Select the existing VERTIGROW database.
USE VERTIGROW_DB;

-- Display all tables and views in the database.
SHOW FULL TABLES;

-- Display column names and data types for all VERTIGROW tables.
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'VERTIGROW_DB'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- Create a separate account for the VERTIGROW frontend.
CREATE USER 'vertigrow_app'@'localhost'
IDENTIFIED BY 'ChooseYourNewPassword123!';

-- Grant database access to the VERTIGROW application account.
GRANT SELECT, INSERT, UPDATE, DELETE
ON VERTIGROW_DB.*
TO 'vertigrow_app'@'localhost';

-- Check whether the VERTIGROW application account exists.
SELECT user, host
FROM mysql.user
WHERE user = 'vertigrow_app';

-- Set a new password for the VERTIGROW application account.
ALTER USER 'vertigrow_app'@'localhost'
IDENTIFIED BY 'db123@SQL';

show databases;
SELECT DATABASE();