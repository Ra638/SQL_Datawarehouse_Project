/*
=============================================================================================
DDL Script : Create Bronze Tables
=============================================================================================
Script Purpose :
   This Script creates tables in the 'bronze' schema , dropping existing tables 
   if they already exist.
   Run this Script to re-define the DDL Structure of 'bronze' Tables
  ============================================================================================
  */

IF OBJECT_ID('bronze.crm_cust_info' ,'U') is not null 
    drop table bronze.crm_cust_info;
Create Table  bronze.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date 
);

IF OBJECT_ID('bronze.crm_prd_info' ,'U') is not null 
    drop table bronze.crm_prd_info;
Create Table bronze.crm_prd_info(
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost nvarchar(50),
	prd_line nvarchar(50),
	prd_start_dt date ,
	prd_end_dt date 
);

IF OBJECT_ID('bronze.crm_sales_details' ,'U') is not null 
    drop table bronze.crm_sales_details;
Create Table bronze.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int ,
	sls_order_dt int ,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int ,
	sls_price int 
);

IF OBJECT_ID('bronze.erp_CUST_AZ12' ,'U') is not null 
    drop table bronze.erp_cust_az12;
	create table bronze.erp_cust_az12(
		CID nvarchar(50),
		BDATE date ,
		GEN nvarchar(50)
);
IF OBJECT_ID('bronze.erp_LOC_A101' ,'U') is not null 
    drop table bronze.erp_loc_a101;
	Create Table bronze.erp_loc_a101(
		CID nvarchar(50),
		CNTRY nvarchar(50)
);

IF OBJECT_ID('bronze.erp_PX_CAT_G1V2' ,'U') is not null 
 drop table bronze.erp_px_cat_g1v2;
 Create Table bronze.erp_px_cat_g1v2(
	id nvarchar(50),
	cat nvarchar(50),
	subcat nvarchar(50),
	maintenance nvarchar(50)
);

GO--
-- Creating a stored procedure 
EXEC bronze.load_bronze
Go--
CREATE or ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
DECLARE @start_time DATETIME , @end_time DATETIME ,@batch_start_time DATETIME,@batch_end_time DATETIME;
BEGIN TRY 
	PRINT'========================================================';
	PRINT' Loading Bronze layer :|';
	PRINT'========================================================';

	PRINT '-------------------------------------------------------';
	PRINT 'Loading CRM Files';
	PRINT'--------------------------------------------------------';
	SET @batch_start_time = GETDATE();
	SET @start_time = GETDATE();
	PRINT'>>Truncating and Inserting into : bronze.crm_cust_info Table ';
	Truncate table bronze.crm_cust_info;
	BULK INSERT bronze.crm_cust_info
	from 'C:\Users\Rayan\OneDrive\Documents\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	with (
	   firstrow = 2 ,
	   FIELDTERMINATOR = ',',
	   Tablock
	);
	SET @end_time = GETDATE();
	PRINT '>>LOAD DUARTION :'  +cast( DATEDIFF(second , @start_time ,@end_time) as nvarchar) +'Seconds';
	PRINT'----------------------'

	SET @start_time = GETDATE();
	PRINT'>>Truncating and Inserting into : bronze.crm_prd_info Table ';
	Truncate table bronze.crm_prd_info;
	BULK INSERT bronze.crm_prd_info
	from 'C:\Users\Rayan\OneDrive\Documents\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	with (
	   firstrow = 2 ,
	   FIELDTERMINATOR = ',',
	   Tablock
	);
	SET @end_time = GETDATE();
	PRINT '>>LOAD DUARTION :' +cast( DATEDIFF(second , @start_time ,@end_time) as nvarchar) +'Seconds';
	PRINT'----------------------'

	SET @start_time = GETDATE();
	PRINT'>>Truncating and Inserting into : bronze.crm_sales_details Table ';
	Truncate table bronze.crm_sales_details;
	BULK INSERT bronze.crm_sales_details
	from 'C:\Users\Rayan\OneDrive\Documents\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	with (
	   firstrow = 2 ,
	   FIELDTERMINATOR = ',',
	   Tablock
	);
	SET @end_time = GETDATE();
	PRINT '>>LOAD DUARTION :' +cast( DATEDIFF(second , @start_time ,@end_time) as nvarchar) +'Seconds';
	PRINT'----------------------'

	PRINT '------------------------------------------------------'
	PRINT 'Loading ERP Files'
	PRINT'-------------------------------------------------------'

	SET @start_time = GETDATE();
	PRINT'>>Truncating and Inserting into : bronze.erp_cust_az12 Table ';
	Truncate table bronze.erp_cust_az12;
	BULK INSERT bronze.erp_cust_az12
	from 'C:\Users\Rayan\OneDrive\Documents\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	with (
	   firstrow = 2 ,
	   FIELDTERMINATOR = ',',
	   Tablock
	);
	SET @end_time = GETDATE();
	PRINT '>>LOAD DUARTION :' +cast( DATEDIFF(second , @start_time ,@end_time) as nvarchar) +'Seconds';
	PRINT'----------------------'

	SET @start_time = GETDATE();
	PRINT'>>Truncating and Inserting into : bronze.erp_loc_a101 Table ';
	Truncate table bronze.erp_loc_a101;
	BULK INSERT bronze.erp_loc_a101
	from 'C:\Users\Rayan\OneDrive\Documents\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	with (
	   firstrow = 2 ,
	   FIELDTERMINATOR = ',',
	   Tablock
	);
	SET @end_time = GETDATE();
	PRINT '>>LOAD DUARTION :' +cast( DATEDIFF(second , @start_time ,@end_time) as nvarchar) +'Seconds';
	PRINT'----------------------'

	SET @start_time = GETDATE();
	PRINT'>>Truncating and Inserting into : bronze.erp_px_cat_g1v2 Table ';
	Truncate table bronze.erp_px_cat_g1v2;
	BULK INSERT bronze.erp_px_cat_g1v2
	from 'C:\Users\Rayan\OneDrive\Documents\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	with (
	   firstrow = 2 ,
	   FIELDTERMINATOR = ',',
	   Tablock
);
SET @end_time = GETDATE();
	PRINT '>>LOAD DUARTION :' +cast( DATEDIFF(second , @start_time ,@end_time) as nvarchar) +'Seconds';
	PRINT'----------------------'
SET @batch_end_time = GETDATE();
    PRINT'=================================================================';
	PRINT' LOADING OF BRONZE LAYER COMPLETED :)';
	PRINT'=================================================================';
    PRINT '>> BATCH LOAD DUARATION :'+ CAST(DATEDIFF(second , @batch_start_time ,@batch_end_time) as nvarchar) + ' Seconds';
	PRINT 'DONE AND DUSTED';
END TRY 
BEGIN CATCH 
 PRINT '===============================================================';
 PRINT 'ERROR OCCCURED DRUING LOADING BRONZE LAYER :(';
 PRINT 'ERROR Message' +Error_message();
 PRINT 'ERROR Message' + cast(Error_number() as nvarchar);
 PRINT 'ERROR Message' + cast(Error_state () as nvarchar);
 PRINT '===============================================================';
END CATCH 
END 
