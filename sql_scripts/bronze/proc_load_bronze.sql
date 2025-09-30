/*
===========================================================================
Stored Procedure: Load Bronze Layer (Insert contents into created tables)
===========================================================================
Script Purpose:
	The stored procedure loads data from external CSV files.
	It performs the following actions:
	- Truncates the bronze tables before loading data.
	- Uses Bulk Insert to load data from csv files into bronze tables.

Parameters:
	None
*/

-- Usage Eample: A command used to run the stored procedure
-- EXEC bronze.load_bronze;

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY

		PRINT '=========================================='
		PRINT 'Loading Bronze Layer'
		PRINT '=========================================='

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.customers';
		TRUNCATE TABLE bronze.customers

		PRINT '>> Inserting Data Into: bronze.customers';
		BULK INSERT bronze.customers
		FROM 'C:\Users\alvin\Desktop\Brazilian E-Commerce Public Dataset\olist_customers_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',       -- comma-separated
			ROWTERMINATOR = '0x0a',      -- handles LF (Unix-style). If still failing, try '0x0d0a'
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec'
		PRINT '----------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.geolocation';
		TRUNCATE TABLE bronze.geolocation
		PRINT '>> Inserting Data Into: bronze.geolocation';
		BULK INSERT bronze.geolocation
		FROM 'C:\Users\alvin\Desktop\Brazilian E-Commerce Public Dataset\olist_geolocation_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',       -- comma-separated
			ROWTERMINATOR = '0x0a',      -- handles LF (Unix-style). If still failing, try '0x0d0a'
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec'
		PRINT '----------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.order_items';
		TRUNCATE TABLE bronze.order_items
		PRINT '>> Inserting Data Into: bronze.order_items';
		BULK INSERT bronze.order_items
		FROM 'C:\Users\alvin\Desktop\Brazilian E-Commerce Public Dataset\olist_order_items_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',', -- delimeter
			ROWTERMINATOR = '0x0a',  
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec'
		PRINT '----------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.order_payments';
		TRUNCATE TABLE bronze.order_payments
		PRINT '>> Inserting Data Into: bronze.order_payments';
		BULK INSERT bronze.order_payments
		FROM 'C:\Users\alvin\Desktop\Brazilian E-Commerce Public Dataset\olist_order_payments_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',', -- delimeter
			ROWTERMINATOR = '0x0a', 
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec'
		PRINT '----------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.order_reviews';
		TRUNCATE TABLE bronze.order_reviews
		PRINT '>> Inserting Data Into: bronze.order_reviews';
		BULK INSERT bronze.order_reviews
		FROM 'C:\Users\alvin\Desktop\Brazilian E-Commerce Public Dataset\olist_order_reviews_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',', -- delimeter
			ROWTERMINATOR = '0x0a', 
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec'
		PRINT '----------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.orders';
		TRUNCATE TABLE bronze.orders
		PRINT '>> Inserting Data Into: bronze.orders';
		BULK INSERT bronze.orders
		FROM 'C:\Users\alvin\Desktop\Brazilian E-Commerce Public Dataset\olist_orders_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',', -- delimeter
			ROWTERMINATOR = '0x0a', 
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec'
		PRINT '----------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.products';
		TRUNCATE TABLE bronze.products
		PRINT '>> Inserting Data Into: bronze.products';
		BULK INSERT bronze.products
		FROM 'C:\Users\alvin\Desktop\Brazilian E-Commerce Public Dataset\olist_products_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',', -- delimeter
			ROWTERMINATOR = '0x0a', 
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec'
		PRINT '----------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.sellers';
		TRUNCATE TABLE bronze.sellers
		PRINT '>> Inserting Data Into: bronze.sellers';
		BULK INSERT bronze.sellers
		FROM 'C:\Users\alvin\Desktop\Brazilian E-Commerce Public Dataset\olist_sellers_dataset.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',', -- delimeter
			ROWTERMINATOR = '0x0a', 
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec'
		PRINT '----------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.product_category_name_translation';
		TRUNCATE TABLE bronze.product_category_name_translation
		PRINT '>> Inserting Data Into: bronze.product_category_name_translation';
		BULK INSERT bronze.product_category_name_translation
		FROM 'C:\Users\alvin\Desktop\Brazilian E-Commerce Public Dataset\product_category_name_translation.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',', -- delimeter
			ROWTERMINATOR = '0x0a', 
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' sec'
		PRINT '----------------------'

	END TRY
	BEGIN CATCH
		PRINT '================================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '================================================='
	END CATCH
END
