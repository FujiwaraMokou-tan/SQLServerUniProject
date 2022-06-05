	use PROJETO
	----------------------------  Store Procedure para Currency--------------------------------
	go

	--create or alter procedure sp_importCurrency2
	--as
	
	insert into PROJETO.dbo.Currency(
		Cur_CurrencyKey,
		Cur_CurrencyAlternateKey,
		Cur_CurrencyName
	)
	select distinct
		CurrencyKey,
		CurrencyAlternateKey,
		CurrencyName

	from AdventureOldData.dbo.Currency

	----------------------------  Stored Procedure para CountryName--------------------------------
	go

	--create or alter procedure sp_importCountryName2
	--as
	
	insert into PROJETO.dbo.countryName(
		CouN_countryRegionCode,
		CouN_countryRegionName
	)
	select distinct
		CountryRegionCode,
		CountryRegionName
	from AdventureOldData.dbo.Customer

	----------------------------  Stored Procedure para StateLocation--------------------------------
	go

	--create or alter procedure sp_importStateLocation2
	--as
	
	insert into PROJETO.dbo.StateLocation(
		StaL_stateProvinceCode,
		StaL_countryRegionCode,
		StaL_stateProvinceName
	)
	select distinct

		StateProvinceCode,
		CountryRegionCode,
		StateProvinceName

	from adventureOldData.dbo.Customer

	----------------------------  Stored Procedure para CityLocation Attempt2--------------------------------
	go

	--create or alter procedure sp_importCityLocation2
	--as
	
	insert into PROJETO.dbo.CityLocation(
		CitL_CityName
	)
	select distinct
		old.City

		from AdventureOldData.dbo.Customer as old 

	----------------------------  Stored Procedure para State_City Attempt2--------------------------------
	go

	--create or alter procedure sp_importState_City2
	--as
	
	insert into PROJETO.dbo.State_City(
		StaC_cityKey,
		StaC_stateProvinceKey
	)
	select distinct
		CitL_cityKey,
		StaL_stateProvinceKey

		from AdventureOldData.dbo.Customer as old 
		left join PROJETO.dbo.CityLocation as cl on cl.CitL_CityName like old.City
		left join PROJETO.dbo.StateLocation as sl on sl.StaL_stateProvinceName like old.StateProvinceName

	----------------------------  Store Procedure para RelationshipInformation---------------------------------
	go

	--create or alter procedure sp_importRelationshipInformation3
	--as 
	
	insert into PROJETO.dbo.RelationshipInformation(
		Rel_maritalStatus,
		Rel_totalChildren,
		Rel_numberChildrenAtHome
	)
	select distinct
		MaritalStatus,
		TotalChildren,
		NumberChildrenAtHome
		from AdventureOldData.dbo.Customer

	----------------------------  Store Procedure para CustomerPossessions---------------------------------
	go

	--create or alter procedure sp_importCustomerPossessions3
	--as
	
	insert into PROJETO.dbo.CustomerPossessions(
		CusP_houseOwnerFlag,
		CusP_numberCarsOwned
	)
	select distinct
		HouseOwnerFlag,
		NumberCarsOwned
		from AdventureOldData.dbo.Customer


	----------------------------  Store Procedure para Customer--------------------------------
	go

	--create or alter procedure sp_importCustomer5
	--as
	
	SET IDENTITY_INSERT PROJETO.dbo.Customer ON
	insert into PROJETO.dbo.Customer(
		Cus_customerKey,
		Cus_title,
		Cus_firstName,
		Cus_middleName,
		Cus_lastName,
		Cus_emailAdress,
		Cus_adressLine1,
		Cus_adressLine2,
		Cus_postalCode,
		Cus_cityKey,
		Cus_nameStyle,
		Cus_birthdate,
		Cus_gender,
		Cus_phone,
		Cus_yearlyIncome,
		Cus_education,
		Cus_ocupation,
		Cus_dateFirstPurchase,
		Cus_comuteDistance,
		Cus_relationshipKey,
		Cus_possessionsKey

	)
	select 
		max(old.CustomerKey),
		max(old.Title),
		max(old.FirstName),
		max(old.MiddleName),
		max(old.LastName),
		max(old.EmailAddress),
		max(old.AddressLine1),
		max(old.AddressLine2),
		max(old.PostalCode),
		max(cdl.CitL_cityKey),
		max(old.NameStyle),
		max(old.birthdate),
		max(old.gender),
		max(old.phone),
		max(old.yearlyIncome),
		max(old.education),
		max(old.Occupation),
		max(old.dateFirstPurchase),
		max(old.CommuteDistance),
		max(ri.Rel_relationshipKey),
		max(cus.CusP_possessionsKey)

		 from AdventureOldData.dbo.Customer as old 
		 left join PROJETO.dbo.CityLocation as cdl on cdl.CitL_CityName like old.City
		 join PROJETO.dbo.RelationshipInformation as ri on ri.Rel_maritalStatus COLLATE DATABASE_DEFAULT like old.MaritalStatus COLLATE DATABASE_DEFAULT
		 join PROJETO.dbo.CustomerPossessions as cus on cus.CusP_numberCarsOwned like old.NumberCarsOwned 
		 WHERE ri.Rel_maritalStatus = old.MaritalStatus and ri.Rel_numberChildrenAtHome = old.NumberChildrenAtHome and ri.Rel_totalChildren = old.TotalChildren
		 and cus.CusP_houseOwnerFlag = old.HouseOwnerFlag and cus.CusP_numberCarsOwned = old.NumberCarsOwned
		 group by CustomerKey
		 SET IDENTITY_INSERT PROJETO.dbo.Customer OFF

	----------------------------  Stored Procedure para ProductSubCategory--------------------------------
	go

	--create or alter procedure sp_importProductSubCategory3
	--as
	
	SET IDENTITY_INSERT PROJETO.dbo.ProductSubCategory ON
	insert into PROJETO.dbo.ProductSubCategory(
		ProSB_productSubCategorykey,
		ProSB_EnglishProductSubcategoryName,
		ProSB_SpanishProductSubcategoryName,
		ProSB_FrenchProductSubcategoryName

	)
	select distinct
		ProductSubcategoryKey,
		EnglishProductSubcategoryName,
		SpanishProductSubcategoryName,
		FrenchProductSubcategoryName

	from AdventureOldData.dbo.ProductSubCategory
	SET IDENTITY_INSERT PROJETO.dbo.ProductSubCategory OFF

	----------------------------  Stored Procedure para ProductLanguageCategory---------------------------------
	go

	--create or alter procedure sp_importProductLanguageCategory3
	--as
	
	insert into PROJETO.dbo.ProductLanguageCategory(
		ProLC_EnglishProductCategoryName,
		ProLC_frenchProductCategoryName,
		ProLC_SpanishProductCategoryName,
		ProLC_productSubCategorykey
	)
	select distinct
		EnglishProductCategoryName,
		FrenchProductCategoryName,
		SpanishProductCategoryName,
		ProductSubcategoryKey
	
	from AdventureOldData.dbo.Products

	----------------------------  Store Procedure para ProductModelName--------------------------------
	go

	--create or alter procedure sp_importProductModelName2
	--as
	
	insert into PROJETO.dbo.ProductModelName(
		ProDN_ModelName

	)
	select distinct
		ModelName
	
	from AdventureOldData.dbo.Products

	----------------------------  Store Procedure para ProductDescription---------------------------------
	go

	--create or alter procedure sp_importProductDescription2
	--as
	
	SET IDENTITY_INSERT PROJETO.dbo.ProductDescription ON
	insert into PROJETO.dbo.ProductDescription(
		ProDe_productDescriptionKey,
		ProDe_englishDescription,
		ProDe_frenchDescription
	)
	select distinct
		a.ProductKey,
		a.EnglishDescription,
		a.FrenchDescription
		from AdventureOldData.dbo.Products as a left join PROJETO.dbo.ProductModelName as n on n.ProDN_ModelName like a.ModelName 
	SET IDENTITY_INSERT PROJETO.dbo.ProductDescription OFF

	----------------------------  Store Procedure para ProductColor---------------------------------
	go

	--create or alter procedure sp_importProductColor3
	--as
	
	insert into PROJETO.dbo.ProductColor(
		ProC_color
	)
	select distinct
		Color
		from AdventureOldData.dbo.Products

	----------------------------  Store Procedure para SizeDetails---------------------------------
	go

	--create or alter procedure sp_importSizeDetails3
	--as
	
	insert into PROJETO.dbo.SizeDetails(
		SizD_sizeUnitmeasureCode,
		SizD_size,
		SizD_sizeRange
	)
	select distinct
		SizeUnitMeasureCode,
		Size,
		SizeRange
		from AdventureOldData.dbo.Products

	----------------------------  Store Procedure para WeightDetails---------------------------------
	go

	--create or alter procedure sp_importWeightDetails3
	--as
	
	insert into PROJETO.dbo.WeightDetails(
		WeiD_weightUnitmeasureCode,
		WeiD_weight
	)
	select distinct
		WeightUnitMeasureCode,
		Weight
		from AdventureOldData.dbo.Products

	----------------------------  Store Procedure para MiscellaneousProductInfo---------------------------------
	go

	--create or alter procedure sp_importMiscellaneousProductInfo
	--as
	
	insert into PROJETO.dbo.MiscellaneousProductInfo(
		Mis_class,
		Mis_style
	)
	select distinct
		Class,
		Style
		from AdventureOldData.dbo.Products

	----------------------------  Store Procedure para Product--------------------------------
	go

	--create or alter procedure sp_importProduct2
	--as
	
	SET IDENTITY_INSERT PROJETO.dbo.Product ON
	insert into PROJETO.dbo.Product(
		Pro_productKey,
		Pro_englishProductName,
		Pro_frenchProductName,
		Pro_spanishProductName,
		Pro_daysToManufacture,
		Pro_productLine,
		Pro_safetyStockLevel,
		Pro_DealerPrice,
		Pro_finishedGoodsFlag,
		Pro_standardCost,
		Pro_listPrice,
		Pro_PromotionStart,
		Pro_PromotionEnd,
		Pro_PromotionPrice,
		Pro_Status,
		Pro_modelKey,
		Pro_colorKey,
		Pro_SizeDetailsKey,
		Pro_WeightDetailsKey,
		Pro_productLanguageCategoryKey,
		Pro_productDescriptionKey,
		Pro_MiscellaneousProductInfoKey
	)
	select 
		max(old.ProductKey),
		max(old.EnglishProductName),
		max(old.FrenchProductName),
		max(old.SpanishProductName),
		max(old.daysToManufacture),
		max(old.productLine),
		max(old.safetyStockLevel),
		max(old.DealerPrice),
		max(old.finishedGoodsFlag),
		max(old.StandardCost),
		max(old.ListPrice),
		null,
		null,
		null,
		max(old.Status),
		max(pmn.ProDN_ModelKey),
		max(pc.ProC_colorKey),
		max(sawd.SizD_SizeDetailsKey),
		max(wd.WeiD_WeightDetailsKey),
		max(plc.ProLC_productLanguageKey),
		max(old.ProductKey),
		max(mis.Mis_productDescriptionKey)

		 from AdventureOldData.dbo.Products as old 
		 left join PROJETO.dbo.ProductColor as pc on pc.ProC_color COLLATE DATABASE_DEFAULT like old.Color COLLATE DATABASE_DEFAULT 
		 left join PROJETO.dbo.ProductLanguageCategory as plc on plc.ProLC_productSubCategorykey = old.ProductSubcategoryKey 
		 left join PROJETO.dbo.SizeDetails as sawd on sawd.SizD_sizeRange COLLATE DATABASE_DEFAULT like old.SizeRange COLLATE DATABASE_DEFAULT
		 left join PROJETO.dbo.WeightDetails as wd on wd.WeiD_weight like old.Weight
		 left join PROJETO.dbo.ProductModelName as pmn on pmn.ProDN_ModelName like old.ModelName
		 left join PROJETO.dbo.MiscellaneousProductInfo as mis on mis.Mis_style COLLATE DATABASE_DEFAULT = old.Style COLLATE DATABASE_DEFAULT 
		 --where  sawd.SizD_sizeRange = old.SizeRange and sawd.SizD_size = old.Size and sawd.SizD_sizeUnitmeasureCode = old.SizeUnitMeasureCode
		 group by old.ProductKey
		 SET IDENTITY_INSERT PROJETO.dbo.Product OFF

		 

	----------------------------  Store Procedure para Company--------------------------------
	go

	--create or alter procedure sp_importCompany2
	--as
	
	insert into PROJETO.dbo.Company(Com_companyKey, Com_companyName) values(1 , 'AdventureWorks');
	insert into PROJETO.dbo.Company(Com_companyKey, Com_companyName) values(2 , 'AdventureService');

	----------------------------  Store Procedure para SalesTerritory--------------------------------
	go

	--create or alter procedure sp_importSalesTerritory2
	--as
	
	insert into PROJETO.dbo.SalesTerritory(
		salT_SalesTerritoryKey,
		salT_SalesTerritoryRegion,
		salT_SalesTerritoryCountry,
		salT_SalesTerritoryGroup
	)
	select distinct
		SalesTerritoryKey,
		SalesTerritoryRegion,
		SalesTerritoryCountry,
		SalesTerritoryGroup

	from AdventureOldData.dbo.SalesTerritory

	----------------------------  Store Procedure para SalesOrder--------------------------------
	go

	--create or alter procedure sp_importSalesOrder
	--as
	
	insert into PROJETO.dbo.SalesOrder(
		--SalO_productKey,
		SalO_customerKey,
		SalO_currencyKey,
		SalO_salesTerritoryKey,
		SalO_salesOrderNumber,
		Sal_salesOrderLineNumber,
		SalO_OrderDate,
		SalO_dueDate,
		SalO_shipDate,
		SalO_companyKey

	)
	select
		--old.ProductKey,
		old.CustomerKey,
		old.CurrencyKey,
		st.SalT_SalesTerritoryKey,
		old.SalesOrderNumber,
		old.SalesOrderLineNumber,
		old.OrderDate,
		old.DueDatE,
		old.ShipDate,
		1

		 from AdventureOldData.dbo.Sales as old 
		 left join PROJETO.dbo.SalesTerritory as st on st.SalT_SalesTerritoryRegion like old.SalesTerritoryRegion

	----------------------------  Store Procedure para Sales--------------------------------
	go

	--create or alter procedure sp_SalesDetails
	--as
	
	insert into PROJETO.dbo.SalesOrderDetails(
		SalOD_SalesOrderKey,
		SalOD_productKey,
		SalOD_orderQuantity,
		SalOD_unitPrice,
		SalOD_saleAmount,
		SalOD_Promo

	)
	select 
		so.SalO_SalesOrderkey,
		max(old.ProductKey),
		max(old.OrderQuantity),
		max(old.UnitPrice),
		max(old.SalesAmount),
		0


		from AdventureOldData.dbo.Sales as old join PROJETO.dbo.SalesOrder as so on old.CustomerKey = so.SalO_customerKey
		where old.SalesOrderLineNumber = so.Sal_salesOrderLineNumber and old.SalesOrderNumber = so.SalO_salesOrderNumber
		group by so.SalO_SalesOrderkey
		
		