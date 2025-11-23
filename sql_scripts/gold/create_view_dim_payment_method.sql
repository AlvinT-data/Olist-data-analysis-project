/*
=============================================================================
Create Dimension: gold.dim_payment_method
Script Purpose:
    This script creates a view for the payment method dimension in the 
	Gold layer of the data warehouse. 

The products dimension includes information of each order's payment method, 
allow further analysis on customer behavior

Fields:
payment_method_key: unique identifier for each order id and payment type pair

order_id: order id of each record

payment_type: payment method for the order, each order can have more than one payment method

payment_value: amount paid by the corresponding payment method for the order

To use the view:
SELECT *
FROM gold.dim_payment_method
=============================================================================
*/
IF OBJECT_ID('gold.dim_payment_method', 'V') IS NOT NULL
    DROP VIEW gold.dim_payment_method;
GO

CREATE VIEW gold.dim_payment_method AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY order_id, payment_type) payment_method_key,
	order_id,
	payment_type,
	payment_value
FROM silver.order_payments

