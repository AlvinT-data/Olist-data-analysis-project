/*
===========================================================================================================
Create Dimension: gold.fact_order_items
Script Purpose:
    This script creates a view for the order fact table in the 
	Gold layer of the data warehouse. 

The order item fact table is aggregated by unique order and product id pair, 
it

Fields:
order_id: order id of each record
customer_id: customer id of each record
product_id: product id of each record
seller_id: seller id of each record
product_qty: quantity of a product bought in one order
per_item_price: price of one quantity of the product
per_item_shipment_fee: shipment fee of one quantity of the product
shipping_limit_date: the seller shipping limit date for handling the order over to the logistic partner

To use the view:
SELECT *
FROM gold.fact_order_items
===========================================================================================================
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
        COUNT(*) product_qty,
        AVG(price) per_item_price,
        AVG(freight_value) per_item_shipment_fee,
        MIN(shipping_limit_date) shipping_limit_date
    FROM silver.order_items
    GROUP BY order_id, product_id, seller_id
)
SELECT 
    oi.order_id,
    o.customer_id,
    oi.product_id,
    oi.seller_id,
    oi.product_qty,
    oi.per_item_price,
    oi.per_item_shipment_fee,
    oi.shipping_limit_date
FROM grouped_order_items oi
LEFT JOIN silver.orders o
    ON oi.order_id = o.order_id
