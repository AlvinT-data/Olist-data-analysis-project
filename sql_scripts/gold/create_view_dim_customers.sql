/*
=============================================================================
Create Dimension: gold.dim_customers
Script Purpose:
    This script creates a view for the customers dimension in the Gold layer 
	in the data warehouse. 

The customers dimension includes information from the customers, orders, and
geolocation tables, allow further analysis on customer behavior with it

To use the view:
SELECT *
FROM gold.dim_customers
=============================================================================
*/
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY c.customer_id) AS customer_key, -- Surrogate key
	c.customer_id,
	c.customer_unique_id,
	o.order_status,
	o.order_purchase_timestamp AS purchase_date,
	o.order_delivered_customer_date AS delivered_date,
	oi.customer_item_revenue_total,
	c.customer_zip_code_prefix,
	c.customer_city,
	c.customer_state,
	geo.latitude,
	geo.longitude
		
FROM silver.customers c
LEFT JOIN silver.orders o
	ON o.customer_id = c.customer_id
LEFT JOIN silver.geolocation geo
	ON geo.zip_code_prefix = c.customer_zip_code_prefix
LEFT JOIN (
	SELECT order_id, SUM(price) customer_item_revenue_total
	FROM silver.order_items
	GROUP BY order_id
) oi
	ON o.order_id = oi.order_id
