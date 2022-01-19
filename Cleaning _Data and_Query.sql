Create Database Logistic_Project
-- import  Excel into database [Logistic_Project] and rename Table [Order_Details]
--Cleaning Data in SQL Queries
	Select * From Order_Details
	-- Remove Duplicate rows
	 With Duplicaterows as
	 (Select *, row_number() over (partition by No_Picking order by No_Order) as R_number
	 from Order_Details)
	 Delete from Duplicaterows
	 Where R_number>1
	-- Standardize Date Format
	ALTER TABLE Order_Details
	Add OrderDateConverted Date;

	Update Order_Details
	SET OrderDateConverted = CONVERT(Date,OrderDate)

	-- Fill NA Channel columns
	Select * From  Order_Details
	Where Channel is null

	Update Order_Details
	SET Channel = CASE When Channel is null THEN 'Mini Mart'					
						ELSE Channel
						END

	-- Cleaning rows Customer
	Select distinct Customer
	From Order_Details 
	Order by Customer

	Update Order_Details
	SET Customer = CASE When Customer = 'bigc' THEN 'Big C'
						When Customer = 'Coop Mart' THEN 'Coopmart'
						When Customer = 'Mega' THEN 'Mega Mart'
						When Customer = 'mini Stop' THEN 'ministop'
						When Customer = 'Satra foods' THEN 'Satrafoods'
						ELSE Customer
						END

	-- Cleaning rows Province
	Select distinct Province
	From Order_Details 
	Order by Province
	
	Update Order_Details
	SET Province = CASE When Province = '  HCM' THEN 'TP.HCM'
						When Province = 'HCM' THEN 'TP.HCM'
						When Province = ' Ho Chi Minh' THEN 'TP.HCM'
						When Province = 'Ho Chi Minh' THEN 'TP.HCM'
						When Province = 'Ho Chi Minh' THEN 'TP.HCM'
						When Province = 'TP HCM' THEN 'TP.HCM'
						When Province = 'TP. HCM' THEN 'TP.HCM'
						When Province = 'Ba Ria Vung Tau' THEN 'Ba Ria - Vung Tau'
						When Province = 'Binh DUONg' THEN 'Binh Duong'
						When Province = 'Bình Duong' THEN 'Binh Duong'
						When Province = ' Long An' THEN 'Long An'
						When Province = ' Dak Lak' THEN 'Dak Lak'
						ELSE Province
						END
	--Your management is thinking that customers's orders is small.This will increase costs and reduce profits.
	--Query to find Order's volume min (if Customer is Conveniece Store (CVS) Total_volume/ Orders <2 CMB,
	--if Customer is Mini Mart Total_volume/ Orders < 3.5 CMB,if Customer is Supermarket Total_volume/ Orders < 5 CMB)
	With CTE As
	(Select distinct Customer,OrderDateConverted,ShipID,Sum([Volume (cbm)]) Over(Partition by OrderDateConverted,ShipID,Customer) as Total_Volume,
	Sum([Total Amount ( VND)]) Over(Partition by OrderDateConverted,ShipID,Customer) as Total_Amount_by_Customer
	From Order_Details
	Where Channel= 'CVS')
	Select * From CTE
	Where Total_Volume <2

	With CTE As
	(Select distinct Customer,OrderDateConverted,ShipID,Sum([Volume (cbm)]) Over(Partition by OrderDateConverted,ShipID,Customer) as Total_Volume,
	Sum([Total Amount ( VND)]) Over(Partition by OrderDateConverted,ShipID,Customer) as Total_Amount_by_Customer
	From Order_Details
	Where Channel= 'Mini Mart')
	Select * From CTE
	Where Total_Volume <3.5

	With CTE As
	(Select distinct Customer,OrderDateConverted,ShipID,Sum([Volume (cbm)]) Over(Partition by OrderDateConverted,ShipID,Customer) as Total_Volume,
	Sum([Total Amount ( VND)]) Over(Partition by OrderDateConverted,ShipID,Customer) as Total_Amount_by_Customer
	From Order_Details
	Where Channel= 'Supermarket')
	Select * From CTE
	Where Total_Volume <5