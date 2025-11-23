/*
=====================================================================================
Create Dimension: gold.dim_products
Script Purpose:
    This script creates a view for the products dimension in the Gold layer 
	in the data warehouse. 

The products dimension includes information of each product's gmv, shipping cost, 
units sold, and review score, allow further analysis on products

Fields:
product_id — unique identifier of the product (dimension grain).

units_sold — total item occurrences sold (count of order-item rows).

lowest_price — minimum unit price observed for this product.

highest_price — maximum unit price observed for this product.

avg_price — average unit price across all sales.

gross_merchandise_value — total item revenue (Σ unit price, excludes shipping).

avg_shipping_cost — average freight (shipping) charged per item.

total_shipping_cost — total freight charged across all sales of this product.

avg_review_score — average review score of orders containing this product

To use the view:
SELECT *
FROM gold.dim_products
=====================================================================================
*/
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
WITH orders_with_reviews AS (
	SELECT 
		o.order_id,
		ore.review_score  
	FROM silver.orders o
	LEFT JOIN (
		SELECT order_id, AVG(CAST(review_score AS INT)) review_score
		FROM silver.order_reviews
		GROUP BY order_id
	) ore
		ON o.order_id = ore.order_id
)
SELECT 
	oi.product_id,
	COUNT(*) units_sold,
	MIN(oi.price) lowest_price,
	MAX(oi.price) highest_price,
	ROUND(AVG(oi.price),2) avg_price,
	SUM(oi.price) gross_merchandise_value,
	ROUND(AVG(oi.freight_value),2) avg_shipping_cost,
	SUM(oi.freight_value) total_shipping_cost,
	ROUND(AVG(owr.review_score), 1) avg_review_score
FROM silver.order_items oi
LEFT JOIN orders_with_reviews owr
	ON oi.order_id = owr.order_id
GROUP BY product_id


