/*
===============================================================================
Script: Insert data into  silver.geolocation table
===============================================================================
Script Purpose:
    Drop all rows in silver.customers table. 
    Clean and insert data from bronze table into it.
    Cleaned duplicated zip codes to avoid duplicate records when connecting
    with other tables.
===============================================================================
*/

TRUNCATE TABLE silver.geolocation
INSERT INTO silver.geolocation (
	zip_code_prefix,
	latitude,
	longitude,
	geolocation_state
)
SELECT 
	TRIM(geolocation_zip_code_prefix) AS zip_code_prefix,
	ROUND(AVG(geolocation_lat), 3) AS latitude,
	ROUND(AVG(geolocation_lng), 3) AS longitude,
	MIN(geolocation_state) AS geolocation_state
FROM bronze.geolocation
GROUP BY TRIM(geolocation_zip_code_prefix)
