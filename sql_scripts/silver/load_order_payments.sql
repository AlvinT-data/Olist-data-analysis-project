/*
====================================================================================
Script: Insert data into  silver.order_payments table
====================================================================================
Script Purpose:
    Drop all rows in silver.order_payments table. 
    Clean and insert data from bronze table into it.
    Performed data enrichment by adding the long state name to increase readability
====================================================================================
*/

TRUNCATE TABLE silver.order_payments
INSERT INTO silver.order_payments (
    order_id,
    payment_type,
    avg_payment_installments,
    payment_value
)

SELECT 
    TRIM('"' FROM order_id) AS order_id, -- Remove quotation marks from both end
    CASE payment_type 
        WHEN 'credit_card' THEN 'credit card'
        WHEN 'not_defined' THEN 'N/A'
        WHEN 'debit_card' THEN 'debit card'
        ELSE payment_type
    END AS payment_type,
    FLOOR(AVG(payment_installments)) avg_payment_installments, -- take the average of payment installments to reduce unnecessary amount of records while keeping track of statistics
    SUM(payment_value) AS payment_value -- sum up the payment_value to reduce unnecessary amount of records
FROM bronze.order_payments
GROUP BY order_id, payment_type

