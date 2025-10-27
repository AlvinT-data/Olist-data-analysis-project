/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		-- Loading silver.customers
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.customers';
		TRUNCATE TABLE silver.customers;
		PRINT '>> Inserting Data Into: silver.customers';
		INSERT INTO silver.customers (
			customer_id,
			customer_unique_id,
			customer_zip_code_prefix,
			customer_city,
			customer_abbrev_state,
			customer_state
		)
		SELECT 
			TRIM('"' FROM customer_id) AS customer_id,
			TRIM('"' FROM customer_unique_id) AS customer_unique_id,
			TRIM('"' FROM customer_zip_code_prefix) AS customer_zip_code_prefix,
			TRIM(customer_city) AS customer_city,
			UPPER(TRIM(customer_state)) AS customer_abbrev_state,
			CASE UPPER(TRIM(customer_state))
				WHEN 'AC' THEN N'Acre'
				WHEN 'AL' THEN N'Alagoas'
				WHEN 'AP' THEN N'Amapá'
				WHEN 'AM' THEN N'Amazonas'
				WHEN 'BA' THEN N'Bahia'
				WHEN 'CE' THEN N'Ceará'
				WHEN 'DF' THEN N'Distrito Federal'
				WHEN 'ES' THEN N'Espírito Santo'
				WHEN 'GO' THEN N'Goiás'
				WHEN 'MA' THEN N'Maranhão'
				WHEN 'MT' THEN N'Mato Grosso'
				WHEN 'MS' THEN N'Mato Grosso do Sul'
				WHEN 'MG' THEN N'Minas Gerais'
				WHEN 'PA' THEN N'Pará'
				WHEN 'PB' THEN N'Paraíba'
				WHEN 'PR' THEN N'Paraná'
				WHEN 'PE' THEN N'Pernambuco'
				WHEN 'PI' THEN N'Piauí'
				WHEN 'RJ' THEN N'Rio de Janeiro'
				WHEN 'RN' THEN N'Rio Grande do Norte'
				WHEN 'RS' THEN N'Rio Grande do Sul'
				WHEN 'RO' THEN N'Rondônia'
				WHEN 'RR' THEN N'Roraima'
				WHEN 'SC' THEN N'Santa Catarina'
				WHEN 'SP' THEN N'São Paulo'
				WHEN 'SE' THEN N'Sergipe'
				WHEN 'TO' THEN N'Tocantins'
				ELSE 'N/A'
			END AS customer_state
		FROM bronze.customers;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.geolocation
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.geolocation';
		TRUNCATE TABLE silver.geolocation;
		PRINT '>> Inserting Data Into: silver.geolocation';
		INSERT INTO silver.geolocation (
			zip_code_prefix,
			latitude,
			longitude,
			geolocation_state
		)
		SELECT 
			TRIM('"' FROM geolocation_zip_code_prefix) AS zip_code_prefix,
			ROUND(AVG(geolocation_lat), 3) AS latitude,
			ROUND(AVG(geolocation_lng), 3) AS longitude,
			MIN(geolocation_state) AS geolocation_state
		FROM bronze.geolocation
		GROUP BY TRIM('"' FROM geolocation_zip_code_prefix);
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading order_items
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.order_items';
		TRUNCATE TABLE silver.order_items;
		PRINT '>> Inserting Data Into: silver.order_items';
		INSERT INTO silver.order_items (
			order_id,
			order_item_id,
			product_id,
			seller_id,
			shipping_limit_date,
			price,
			freight_value
		)

		SELECT
			TRIM('"' FROM order_id) AS order_id, -- Remove quotation marks from both end
			order_item_id,
			TRIM('"' FROM product_id) AS product_id,
			TRIM('"' FROM seller_id) AS seller_id,
			CAST(shipping_limit_date AS datetime) AS shipping_limit_date, -- cast data from string to datetime
			price,
			freight_value
		FROM bronze.order_items;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading order_payments
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.order_payments';
		TRUNCATE TABLE silver.order_payments;
		PRINT '>> Inserting Data Into: silver.order_payments';
		INSERT INTO silver.order_payments (
			order_id,
			payment_type,
			avg_payment_installments,
			payment_value
		)

		SELECT 
			TRIM('"' FROM order_id) AS order_id, -- Remove quotation marks from both end
			CASE payment_type 
				WHEN 'credit_card' THEN 'credit card'
				WHEN 'not_defined' THEN 'N/A'
				WHEN 'debit_card' THEN 'debit card'
				ELSE payment_type
			END AS payment_type,
			FLOOR(AVG(payment_installments)) avg_payment_installments, -- take the average of payment installments to reduce unnecessary amount of records while keeping track of statistics
			SUM(payment_value) AS payment_value -- sum up the payment_value to reduce unnecessary amount of records
		FROM bronze.order_payments
		GROUP BY order_id, payment_type;
	    SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading order_reviews
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.order_reviews';
		TRUNCATE TABLE silver.order_reviews;
		PRINT '>> Inserting Data Into: silver.order_reviews';
		INSERT INTO silver.order_reviews (
			review_id,
			order_id,
			review_score,
			review_comment_title,
			review_comment_message,
			review_creation_date,
			review_answer_timestamp
		)

		SELECT 
			TRIM('"' FROM review_id) AS review_id,
			TRIM('"' FROM order_id) AS order_id,
			review_score,
			review_comment_title,
			review_comment_message,
			CAST(review_creation_date AS datetime) AS review_creation_date,
			CAST(TRIM(NCHAR(32) FROM review_creation_date) AS datetime) AS review_answer_timestamp
		FROM bronze.order_reviews;
	    SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		
		-- Loading orders
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.orders';
		TRUNCATE TABLE silver.orders;
		PRINT '>> Inserting Data Into: silver.orders';
		INSERT INTO silver.orders (
			order_id,
			customer_id,
			order_status,
			order_purchase_timestamp,
			order_approved_at,
			order_delivered_carrier_date,
			order_delivered_customer_date,
			order_estimated_delivery_date
		)

		SELECT 
			TRIM('"' FROM order_id) AS order_id, -- Remove quotation marks from both end
			TRIM('"' FROM customer_id) AS customer_id,
			order_status,
			CAST(order_purchase_timestamp AS datetime) AS order_purchase_timestamp,
			CAST(order_approved_at AS datetime) AS order_approved_at,
			CASE 
				WHEN CAST(order_delivered_carrier_date AS datetime) > CAST(order_delivered_customer_date AS datetime) THEN CAST(order_delivered_customer_date AS datetime)
				ELSE CAST(order_delivered_customer_date AS datetime)
			END AS order_delivered_carrier_date,
			CASE 
				WHEN CAST(order_delivered_carrier_date AS datetime) > CAST(order_delivered_customer_date AS datetime) THEN CAST(order_delivered_carrier_date AS datetime)
				ELSE CAST(order_delivered_customer_date AS datetime)
			END AS order_delivered_customer_date,
			CAST(order_estimated_delivery_date AS datetime) AS order_estimated_delivery_date
		FROM bronze.orders;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading products
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.products';
		TRUNCATE TABLE silver.products;
		PRINT '>> Inserting Data Into: silver.products';
		INSERT INTO silver.products (
			product_id,
			product_category_name,
			product_name_lenght,
			product_description_lenght,
			product_photos_qty,
			product_weight_g,
			product_length_cm,
			product_height_cm,
			product_width_cm
		)

		SELECT 
			TRIM('"' FROM product_id) AS product_id,
			REPLACE(product_category_name, '_', ' ') AS product_category_name,
			product_name_lenght,
			product_description_lenght,
			product_photos_qty,
			product_weight_g,
			product_length_cm,
			product_height_cm,
			product_width_cm
		FROM bronze.products;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading products
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.products';
		TRUNCATE TABLE silver.products;
		PRINT '>> Inserting Data Into: silver.products';
		INSERT INTO silver.sellers (
			seller_id,
			seller_zip_code_prefix,
			seller_city,
			seller_state
		)

		SELECT 
			TRIM('"' FROM seller_id) AS seller_id, -- take out the quotations marks in both end for some records
			TRIM('"' FROM seller_zip_code_prefix) AS seller_zip_code_prefix,
			TRIM('"' FROM seller_city) AS seller_city,
			CASE seller_state
				WHEN ' rio grande do sul, brasil",RS' THEN 'RS'
				WHEN ' rio de janeiro, brasil",RJ' THEN 'RJ'
				ELSE seller_state
			END AS seller_state
		FROM bronze.sellers;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
