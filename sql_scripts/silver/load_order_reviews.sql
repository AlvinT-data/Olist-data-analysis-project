/*
====================================================================================
Script: Insert data into  silver.order_reviews table
====================================================================================
Script Purpose:
    Drop all rows in silver.order_reviews table. 
    Clean and insert data from bronze table into it.
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
    TRIM('"' FROM review_id) AS review_id,
    TRIM('"' FROM order_id) AS order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    CAST(review_creation_date AS datetime) AS review_creation_date,
    CAST(TRIM(NCHAR(32) FROM review_creation_date) AS datetime) AS review_answer_timestamp
FROM bronze.order_reviews
