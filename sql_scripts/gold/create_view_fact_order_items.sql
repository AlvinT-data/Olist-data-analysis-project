/*
=============================================================================
Create Dimension: gold.fact_order_items
Script Purpose:
    This script creates a view for the order fact table in the 
	Gold layer of the data warehouse. 

The order fact table includes information of each order and customer keys, 
allow further analysis on the orders and delivery logistic workflow

To use the view:
SELECT *
FROM gold.fact_order_items
=============================================================================
*/
IF OBJECT_ID('gold.fact_order_items', 'V') IS NOT NULL
    DROP VIEW gold.fact_order_items;
GO

CREATE VIEW gold.fact_order_items AS
WITH grouped_order_items AS (
    SELECT
        order_id,
        product_id,
        seller_id,
        COUNT(*) product_quantity,
        SUM
        MIN(shipping_limit_date) shipping_limit_date
    FROM silver.order_items
    GROUP BY order_id, product_id, seller_id
)
SELECT
 

SELECT *
FROM silver.order_items
