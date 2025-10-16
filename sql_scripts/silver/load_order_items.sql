/*
====================================================================================
Script: Insert data into  silver.order_items table
====================================================================================
Script Purpose:
    Drop all rows in silver.order_items table. 
    Clean and insert data from bronze table into it.
    Performed data enrichment by adding the long state name to increase readability
====================================================================================
*/

TRUNCATE TABLE silver.order_items
INSERT INTO silver.order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)

SELECT
    TRIM('"' FROM order_id) AS order_id, -- Remove quotation marks from both end
    order_item_id,
    TRIM('"' FROM product_id) AS product_id,
    TRIM('"' FROM seller_id) AS seller_id,
    CAST(shipping_limit_date AS datetime) AS shipping_limit_date, -- cast data from string to datetime
    price,
    freight_value
FROM bronze.order_items

-- ------------------------
-- Checking data quality
-- ------------------------

--SELECT *
--FROM bronze.order_items

--SELECT 
--	order_id,
--    order_item_id,
--	COUNT(*)
--FROM bronze.order_items
--GROUP BY order_id, order_item_id
--HAVING COUNT(*) > 1 OR order_id IS NULL OR order_item_id IS NULL

--WITH cte AS (
--    SELECT
--        *,
--        COUNT(*) OVER(PARTITION BY order_id, order_item_id) AS cnt
--    FROM bronze.order_items
--)
--SELECT *
--FROM cte
--WHERE cnt > 1
--ORDER BY order_id, order_item_id

---- Check for unwanted Spaces (Strings)
---- Expectation: No Results
--SELECT shipping_limit_date
--FROM bronze.order_items
--WHERE seller_id != TRIM(seller_id)

--SELECT CAST(shipping_limit_date AS datetime) AS shipping_limit_date
--FROM bronze.order_items

--SELECT *
--FROM bronze.order_items
--WHERE seller_id NOT IN (SELECT seller_id FROM bronze.orders)

--SELECT MIN(CAST(shipping_limit_date AS datetime))
--FROM bronze.order_items
