/*
=============================================================================
Create Dimension: gold.fact_orders
Script Purpose:
    This script creates a view for the order fact table in the 
	Gold layer of the data warehouse. 

The order fact table includes information of each order and customer keys, 
allow further analysis on the orders and delivery logistic workflow

Fields:
o.order_id — unique ID for the order.

o.order_status — final order status (e.g., delivered, shipped, canceled).

o.order_purchase_timestamp — when the customer placed the order.

o.order_approved_at — when payment was approved.

o.order_delivered_carrier_date — when the package was handed to the carrier (shipped).

o.order_delivered_customer_date — when the customer received the order.

order_estimated_delivery_date — promised/estimated delivery date at purchase.

oi.total_price — sum of item prices (excludes freight) for the order.

oi.total_delivery_cost — sum of freight/shipping charges for the order.

oi.order_value — total charged (items + freight) for the order.

To use the view:
SELECT *
FROM gold.fact_orders
=============================================================================
*/
IF OBJECT_ID('gold.fact_orders', 'V') IS NOT NULL
    DROP VIEW gold.fact_orders;
GO

CREATE VIEW gold.fact_orders AS
SELECT
  o.order_id,
  o.order_status,
  o.order_purchase_timestamp,
  o.order_approved_at,
  o.order_delivered_carrier_date,
  o.order_delivered_customer_date,
  order_estimated_delivery_date,
  oi.total_price,
  oi.total_delivery_cost,
  oi.order_value
FROM silver.orders o
LEFT JOIN silver.customers c
  ON c.customer_id = o.customer_id
LEFT JOIN (
	SELECT
		order_id,
		SUM(price) total_price,
		SUM(freight_value) total_delivery_cost,
		SUM(price + freight_value) order_value
	FROM silver.order_items
	GROUP BY order_id
	) oi
	ON oi.order_id = o.order_id
