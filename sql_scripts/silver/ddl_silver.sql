/*
============================================
DDL Script: Create silver Tables
============================================
Script Purpose:
	To ceate new tables in the 'silver' schema, after checking if it already exists.
	If the table exists, it is dropped and recreated. 

WARNING:
	Running this script will wipe out all the records of the tables in 'Olive_DataWarehouse' database if it exists
*/

IF OBJECT_ID ('silver.customers', 'U') IS NOT NULL
	DROP TABLE silver.customers;
CREATE TABLE silver.customers (
	customer_id NVARCHAR(50),
	customer_unique_id NVARCHAR(50),
	customer_zip_code_prefix NVARCHAR(50),
	customer_city NVARCHAR(50),
	customer_abbrev_state NVARCHAR(50),
	customer_state NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.geolocation', 'U') IS NOT NULL
	DROP TABLE silver.geolocation;
CREATE TABLE silver.geolocation (
	zip_code_prefix NVARCHAR(50),
	latitude FLOAT,
	longitude FLOAT,
	geolocation_state NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.order_items', 'U') IS NOT NULL
	DROP TABLE silver.order_items;
CREATE TABLE silver.order_items (
	order_id NVARCHAR(50),
	order_item_id INT,
	product_id NVARCHAR(50),
	seller_id NVARCHAR(50),
	shipping_limit_date NVARCHAR(50),
	price FLOAT,
	freight_value FLOAT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.orders', 'U') IS NOT NULL
	DROP TABLE silver.orders;
CREATE TABLE silver.orders (
	order_id NVARCHAR(50),
	customer_id NVARCHAR(50),
	order_status NVARCHAR(50),
	order_purchase_timestamp NVARCHAR(50),
	order_approved_at NVARCHAR(50),
	order_delivered_carrier_date NVARCHAR(50),
	order_delivered_customer_date NVARCHAR(50),
	order_estimated_delivery_date NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.products', 'U') IS NOT NULL
	DROP TABLE silver.products;
CREATE TABLE silver.products (
	product_id NVARCHAR(50),
	product_category_name NVARCHAR(50),
	product_name_lenght INT,
	product_description_lenght INT,
	product_photos_qty INT,
	product_weight_g INT,
	product_length_cm INT,
	product_height_cm INT,
	product_width_cm INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.sellers', 'U') IS NOT NULL
	DROP TABLE silver.sellers;
CREATE TABLE silver.sellers (
	seller_id NVARCHAR(50),
	seller_zip_code_prefix NVARCHAR(50),
	seller_city NVARCHAR(50),
	seller_state NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.product_category_name_translation', 'U') IS NOT NULL
	DROP TABLE silver.product_category_name_translation;
CREATE TABLE silver.product_category_name_translation (
	product_category_name NVARCHAR(50),
	product_category_name_english NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.order_payments', 'U') IS NOT NULL
	DROP TABLE silver.order_payments;
CREATE TABLE silver.order_payments (
	order_id NVARCHAR(50),
	payment_sequential INT,
	payment_type NVARCHAR(50),
	payment_installments INT,
	payment_value FLOAT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.order_reviews', 'U') IS NOT NULL
	DROP TABLE silver.order_reviews;
CREATE TABLE silver.order_reviews (
	review_id NVARCHAR(1000),
	order_id NVARCHAR(1000),
	review_score NVARCHAR(200),
	review_comment_title NVARCHAR(1000),
	review_comment_message NVARCHAR(1000),
	review_creation_date NVARCHAR(1000),
	review_answer_timestamp NVARCHAR(1000),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
