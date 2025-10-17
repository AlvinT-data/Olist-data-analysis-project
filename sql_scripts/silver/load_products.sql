/*
====================================================================================
Script: Insert data into  silver.products table
====================================================================================
Script Purpose:
    Drop all rows in silver.products table. 
    Clean and insert data from bronze table into it.
    Performed data enrichment by adding the long state name to increase readability
====================================================================================
*/

TRUNCATE TABLE silver.products
INSERT INTO silver.products (
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)

SELECT 
    TRIM('"' FROM product_id) AS product_id,
    REPLACE(product_category_name, '_', ' ') AS product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM bronze.products
