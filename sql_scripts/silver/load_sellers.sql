/*
====================================================================================
Script: Insert data into  silver.sellers table
====================================================================================
Script Purpose:
    Drop all rows in silver.sellers table. 
    Clean and insert data from bronze table into it.
    Performed data enrichment by adding the long state name to increase readability
====================================================================================
*/

TRUNCATE TABLE silver.sellers
INSERT INTO silver.sellers (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)

SELECT 
    TRIM('"' FROM seller_id) AS seller_id, -- take out the quotations marks in both end for some records
    TRIM('"' FROM seller_zip_code_prefix) AS seller_zip_code_prefix,
    TRIM('"' FROM seller_city) AS seller_city,
    CASE seller_state
        WHEN ' rio grande do sul, brasil",RS' THEN 'RS'
        WHEN ' rio de janeiro, brasil",RJ' THEN 'RJ'
        ELSE seller_state
    END AS seller_state
FROM bronze.sellers
