/*
=============================================================================
Create Dimension: gold.dim_sellers
Script Purpose:
    This script creates a view for the sellers dimension in the Gold layer 
	in the data warehouse. 

The sellers dimension includes information from the sellers, orders, order
items, geolocation and reviews tables. It provides the data like number of 
items sold and late delivery rate which allow further analysis on sellers 
performance with it.

To use the view:
SELECT *
FROM gold.dim_sellers
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
		SUM(oi.price) AS revenue,
		MIN(o.order_purchase_timestamp) AS first_sale_date,
		MAX(o.order_purchase_timestamp) AS last_sale_date,
		CAST(ROUND(1.0 *
		COUNT(DISTINCT CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN o.order_id END)
		/ NULLIF(COUNT(DISTINCT CASE WHEN o.order_delivered_customer_date IS NOT NULL AND o.order_estimated_delivery_date IS NOT NULL THEN o.order_id END), 0)
		, 2) AS DECIMAL(10,2)) AS late_delivery_rate,
		COUNT(DISTINCT CASE WHEN o.order_status = 'delivered' THEN o.order_id ELSE NULL END) AS delivered_orders,
		ROUND(AVG(ore.review_score), 1) AS avg_review_score
	FROM silver.orders o
	LEFT JOIN silver.order_items oi
		ON o.order_id = oi.order_id
	LEFT JOIN (
		SELECT order_id, AVG(CAST(review_score AS INT)) review_score
		FROM silver.order_reviews
		GROUP BY order_id
	) ore
		ON o.order_id = ore.order_id
	WHERE oi.seller_id IS NOT NULL
	GROUP BY oi.seller_id
)
SELECT 
	s.seller_id,
	sd.items_sold,
	sd.orders_count,
	sd.delivered_orders,
	ROUND(sd.revenue, 2) revenue,
	sd.late_delivery_rate,
	sd.first_sale_date,
	sd.last_sale_date,
	sd.avg_review_score,
	s.seller_city,
	s.seller_state,
	geo.latitude,
	geo.longitude
	
FROM silver.sellers s
LEFT JOIN seller_data sd
	ON s.seller_id = sd.seller_id
LEFT JOIN silver.geolocation geo
	ON geo.zip_code_prefix = s.seller_zip_code_prefix
