/*
=============================================================================
Create Dimension: gold.dim_sellers
Script Purpose:
    This script creates a view for the customers dimension in the Gold layer 
	in the data warehouse. 

The customers dimension includes information from the sellers, orders, order
items and geolocation tables, allow further analysis on sellers performance
with it
=============================================================================
*/
IF OBJECT_ID('gold.dim_sellers', 'V') IS NOT NULL
    DROP VIEW gold.dim_sellers;
GO

CREATE VIEW gold.dim_sellers AS
WITH seller_data AS
(
	SELECT 
		oi.seller_id,
		COUNT(*) AS items_sold,
		COUNT(DISTINCT o.order_id) AS orders_count,
		MIN(o.order_purchase_timestamp) AS first_sale_date,
		MAX(o.order_purchase_timestamp) AS last_sale_date,
		COUNT(DISTINCT CASE WHEN o.order_status = 'delivered' THEN o.order_id ELSE NULL END) AS delivered_orders
	FROM silver.orders o
	LEFT JOIN silver.order_items oi
		ON o.order_id = oi.order_id
	WHERE oi.seller_id IS NOT NULL
	GROUP BY oi.seller_id
)
SELECT 
	s.seller_id,
	sd.items_sold,
	sd.orders_count,
	sd.delivered_orders,
	sd.first_sale_date,
	sd.last_sale_date,
	s.seller_zip_code_prefix AS zip_code,
	s.seller_city,
	s.seller_state,
	geo.latitude,
	geo.longitude
	
FROM silver.sellers s
LEFT JOIN seller_data sd
	ON s.seller_id = sd.seller_id
LEFT JOIN silver.geolocation geo
	ON geo.zip_code_prefix = s.seller_zip_code_prefix

	SELECT *
	FROM gold.dim_sellers
