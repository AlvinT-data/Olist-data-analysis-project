/*
====================================================================================
Script: Insert data into  silver.customers table
====================================================================================
Script Purpose:
    Drop all rows in silver.customers table. 
    Clean and insert data from bronze table into it.
    Performed data enrichment by adding the long state name to increase readability
====================================================================================
*/

TRUNCATE TABLE silver.customers
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
FROM bronze.customers
