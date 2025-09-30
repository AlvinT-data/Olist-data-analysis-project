/*
========================================
Create Database 'Olive_DataWarehouse'
========================================
Script Purpose:
	To ceate a new database named 'DataWarehouse' after checking if it already exists.
	If the database exists, it is dropped and recreated. The script also sets up three schemas within the database: 'bronze', 'silver', and 'gold.'

WARNING:
	Running this script will wipe out the entire 'Olive_DataWarehouse' database if it exists
*/
USE master;
GO

-- Drop and recreate the 'Olive_DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Olive_DataWarehouse')
BEGIN
	ALTER DATABASE Olive_DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Olive_DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE Olive_DataWarehouse;
GO

USE Olive_DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
