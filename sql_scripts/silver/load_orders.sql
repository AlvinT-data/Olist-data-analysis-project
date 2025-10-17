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

TRUNCATE TABLE silver.orders
INSERT INTO silver.orders (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)

SELECT 
    TRIM('"' FROM order_id) AS order_id, -- Remove quotation marks from both end
    TRIM('"' FROM customer_id) AS customer_id,
    order_status,
    CAST(order_purchase_timestamp AS datetime) AS order_purchase_timestamp,
    CAST(order_approved_at AS datetime) AS order_approved_at,
    CASE 
        WHEN CAST(order_delivered_carrier_date AS datetime) > CAST(order_delivered_customer_date AS datetime) THEN CAST(order_delivered_customer_date AS datetime)
        ELSE CAST(order_delivered_customer_date AS datetime)
    END AS order_delivered_carrier_date,
    CASE 
        WHEN CAST(order_delivered_carrier_date AS datetime) > CAST(order_delivered_customer_date AS datetime) THEN CAST(order_delivered_carrier_date AS datetime)
        ELSE CAST(order_delivered_customer_date AS datetime)
    END AS order_delivered_customer_date,
    CAST(order_estimated_delivery_date AS datetime) AS order_estimated_delivery_date
FROM bronze.orders
