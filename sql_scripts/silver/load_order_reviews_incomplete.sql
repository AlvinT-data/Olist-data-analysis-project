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

TRUNCATE TABLE silver.order_reviews
INSERT INTO silver.order_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)

SELECT 
   CASE TRIM(NCHAR(9)  +  -- tab
             NCHAR(10) +  -- LF
             NCHAR(13) +  -- CR
             NCHAR(32) +  -- normal space
             NCHAR(160)   -- NBSP
             FROM TRIM('"' FROM review_id))
        WHEN '    ' THEN 'N/A'
        ELSE TRIM(NCHAR(9)  +  -- tab
             NCHAR(10) +  -- LF
             NCHAR(13) +  -- CR
             NCHAR(32) +  -- normal space
             NCHAR(160)   -- NBSP
             FROM TRIM('"' FROM review_id))
    END AS review_id,
    TRIM('"' FROM order_id) AS order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM bronze.order_reviews

-- ------------------------
-- Checking data quality
-- ------------------------

SELECT DISTINCT seller_city
FROM bronze.sellers
ORDER BY seller_city


-- Check for unwanted Spaces (Strings)
-- Expectation: No Results
SELECT TRIM('"' FROM order_id)
FROM bronze.order_reviews
WHERE TRIM('"' FROM TRIM('"' FROM order_id)) != TRIM(TRIM('"' FROM TRIM('"' FROM order_id)))

SELECT 
	CASE TRIM(NCHAR(9)  +  -- tab
             NCHAR(10) +  -- LF
             NCHAR(13) +  -- CR
             NCHAR(32) +  -- normal space
             NCHAR(160)   -- NBSP
             FROM TRIM('"' FROM review_id))
        WHEN '    ' THEN 'N/A'
        ELSE TRIM(NCHAR(9)  +  -- tab
             NCHAR(10) +  -- LF
             NCHAR(13) +  -- CR
             NCHAR(32) +  -- normal space
             NCHAR(160)   -- NBSP
             FROM TRIM('"' FROM review_id))
    END AS review_id,
	COUNT(*)
FROM bronze.order_reviews
GROUP BY TRIM(NCHAR(9)  +  -- tab
             NCHAR(10) +  -- LF
             NCHAR(13) +  -- CR
             NCHAR(32) +  -- normal space
             NCHAR(160)   -- NBSP
             FROM TRIM('"' FROM review_id))
HAVING COUNT(*) > 1 OR TRIM(NCHAR(9)  +  -- tab
             NCHAR(10) +  -- LF
             NCHAR(13) +  -- CR
             NCHAR(32) +  -- normal space
             NCHAR(160)   -- NBSP
             FROM TRIM('"' FROM review_id)) IS NULL

WITH cte AS (
    SELECT
        *,
        COUNT(*) OVER(PARTITION BY seller_id) AS cnt
    FROM bronze.sellers
)
SELECT *
FROM cte
WHERE cnt > 1
ORDER BY seller_id

-- Check for unwanted Spaces (Strings)
-- Expectation: No Results
SELECT seller_state
FROM bronze.sellers
WHERE seller_state != TRIM(seller_state)

SELECT CAST(shipping_limit_date AS datetime) AS shipping_limit_date
FROM bronze.order_items

SELECT *
FROM bronze.order_reviews
WHERE TRIM('"' FROM order_id) NOT IN (SELECT TRIM('"' FROM order_id) FROM bronze.orders)

SELECT
    DISTINCT order_status
FROM bronze.orders

-- Check for Invalid Dates
SELECT
    order_id,
    CAST(order_delivered_carrier_date AS datetime),
    CAST(order_delivered_customer_date AS datetime)
FROM silver.orders
WHERE  CAST(order_delivered_carrier_date AS datetime) > CAST(order_delivered_customer_date AS datetime)
