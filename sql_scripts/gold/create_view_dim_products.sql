/*
=============================================================================
Create Dimension: gold.dim_products
Script Purpose:
    This script creates a view for the products dimension in the Gold layer 
	in the data warehouse. 

The products dimension includes information of each product's gmv, 
shipping cost, units sold, allow further analysis on products

To use the view:
SELECT *
FROM gold.dim_products
=============================================================================
*/
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT 
	product_id,
	COUNT(*) units_sold,
	MIN(price) lowest_price,
	MAX(price) highest_price,
	ROUND(AVG(price),2) avg_price,
	SUM(price) gross_merchandise_value,
	ROUND(AVG(freight_value),2) avg_shipping_cost,
	SUM(freight_value) total_shipping_cost
FROM silver.order_items
GROUP BY product_id


