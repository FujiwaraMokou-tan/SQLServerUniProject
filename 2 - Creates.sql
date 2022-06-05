use PROJETO

--1 Row: (100*2) + 4 = 204BYTES
--Reserved-144	+	IndexSize-24  = 168KB 		
CREATE TABLE Questions(
Ques_questionKey int identity(1,1) PRIMARY KEY,
Ques_Question nvarchar(100) NOT NULL UNIQUE
)ON [FG_AccountManagement];

--1 Row: 4 + 4 + 4 + (35*2) = 82BYTES
--Reserved-264	 +	IndexSize-16  =	280KB	* STARTS WITH 0	
CREATE TABLE AccountRecoverySystem(
AccRS_accountRecoveryKey int identity(1,1) PRIMARY KEY,
AccRS_question int NOT NULL,
AccRS_answer nvarchar(35) NOT NULL,
AccRS_UserID int NOT NULL
)ON [FG_AccountManagement];

--1 Row: (50*2) + (50*2) = 200BYTES
--Reserved-144	+	IndexSize-24  = 168KB 		* STARTS WITH 0	
CREATE TABLE sentEmails(
senE_EmailsAdress nvarchar(50) PRIMARY KEY,
senE_Password nvarchar(50) not null
)ON [FG_AccountManagement];

--1 Row: 4 + (10*2) + (50*2) + (70*2) +1 = 265BYTES
--Reserved-72	+	IndexSize-8  = 80KB	  	
CREATE TABLE USERS(
U_userID int identity(1, 1) PRIMARY KEY,
U_PasswordSalt nvarchar(10) NOT NULL,
U_passwordHash nvarchar(255) NOT NULL,
U_emailAdress nvarchar(255) NOT NULL UNIQUE,
U_loggedOn bit NOT NULL
)ON [FG_AccountManagement];

--1 Row: (3*2) + (50*2) = 106BYTES
--Reserved-72	+	IndexSize-8  = 80KB		/After Migration/
CREATE TABLE CountryName(
CouN_countryRegionCode nvarchar(3) PRIMARY KEY,
CouN_countryRegionName nvarchar(50) NOT NULL,
)ON [FG_Customers];

--1 Row: 4 + (4*2) + (3*2) + (50*2) = 118BYTES
--Reserved-72	+	IndexSize-8  = 80KB		/After Migration/
CREATE TABLE StateLocation(
StaL_stateProvinceKey int identity(1,1) PRIMARY KEY,
StaL_stateProvinceCode nvarchar(4) NOT NULL,
StaL_countryRegionCode nvarchar(3) NOT NULL,
StaL_stateProvinceName nvarchar(50) NOT NULL,
)ON [FG_Customers];

--1 Row: 4 + 4 = 8
--Reserved-72	+	IndexSize-8  = 80KB		/After Migration/
CREATE TABLE State_City(
StaC_cityKey int NOT NULL,
StaC_stateProvinceKey int NOT NULL
)ON [FG_Customers];

--1 Row: 4 + (50*2) = 104
--Reserved-200	+	IndexSize-16  = 216KB		/After Migration/
CREATE TABLE CityLocation(
CitL_cityKey int IDENTITY(1,1) PRIMARY KEY,
CitL_CityName nvarchar(50) NOT NULL,
)ON [FG_Customers];

--1 Row: 4 + 4 + 4 = 12BYTES
--Reserved-72	+	IndexSize-8	 = 80KB			/After Migration/
CREATE TABLE CustomerPossessions(
CusP_possessionsKey int IDENTITY(1,1) PRIMARY KEY,
CusP_houseOwnerFlag int NOT NULL,
CusP_numberCarsOwned int NOT NULL
)ON [FG_Customers];

--1 Row: 4 + 1 + 4 + 4 = 13BYTES
--Reserved-72	+	IndexSize-8  = 80KB		/After Migration/
CREATE TABLE RelationshipInformation(
Rel_relationshipKey int IDENTITY(1,1) PRIMARY KEY,
Rel_maritalStatus char(1) NOT NULL,
Rel_totalChildren int NOT NULL,
Rel_numberChildrenAtHome int NOT NULL
)ON [FG_Customers];

--1 Row: 4 + (10*2) + (30*2) + (30*2) + (30*2) + (50*2) + (70*2) + (70*2) + (20*2) + 4 (5*2) + 3 + 1 + (25*2) + 8 + (30*2) + (30*2) + 3 + (30*2) + 4 + 4 = 917bytes
--Reserved-7312	 +	IndexSize-1336  = 8648KB		/After Migration/
CREATE TABLE Customer(
Cus_customerKey int IDENTITY(11000,1) PRIMARY KEY,
Cus_title nvarchar(10),
Cus_firstName nvarchar(30) NOT NULL,
Cus_middleName nvarchar(30),
Cus_lastName nvarchar(30) NOT NULL,
Cus_emailAdress nvarchar(50) NOT NULL UNIQUE,
Cus_adressLine1 nvarchar (70),
Cus_adressLine2 nvarchar (70),
Cus_postalCode nvarchar(20),
Cus_cityKey int,
Cus_nameStyle nvarchar(5),
Cus_birthdate date,
Cus_gender char(1),
Cus_phone nvarchar(25),
Cus_yearlyIncome money,
Cus_education nvarchar(30),
Cus_ocupation nvarchar(30),
Cus_dateFirstPurchase date,
Cus_comuteDistance nvarchar(30),
Cus_relationshipKey int,
Cus_possessionsKey int
)ON [FG_Customers];

--1 Row: 4 + (25*2) = 54bytes
--Reserved-144	+	IndexSize-24  = 168KB		/After Migration/
CREATE TABLE ProductColor(
ProC_colorKey int identity(1,1) PRIMARY KEY,
ProC_color varchar(25) NOT NULL UNIQUE
)ON [FG_Product];

--1 Row: 4 + (40*2) + (40*2) + (40*2) = 244BYTES
--Reserved-72	+	IndexSize-8  = 80KB		/After Migration/
CREATE TABLE ProductSubCategory(
ProSB_productSubCategorykey int identity (1,1) PRIMARY KEY,
ProSB_EnglishProductSubcategoryName nvarchar(40) not null,
ProSB_SpanishProductSubcategoryName nvarchar(40),
ProSB_FrenchProductSubcategoryName nvarchar(40),
)ON [FG_Product];

--1 Row: 4 + (40*2) + (40*2) + (40*2) + 4 = 248BYTES
--Reserved-72	+	IndexSize-8	 = 80KB		/After Migration/
CREATE TABLE ProductLanguageCategory(
ProLC_productLanguageKey int identity(1,1) PRIMARY KEY,
ProLC_EnglishProductCategoryName varchar(40) NOT NULL,
ProLC_frenchProductCategoryName varchar(40),
ProLC_SpanishProductCategoryName varchar(40),
ProLC_productSubCategorykey int NOT NULL
)ON [FG_Product];

--1 Row: 4 + (250*2) + (300*2) = 1104BYTES
--Reserved-392	+	IndexSize-16  = 408KB		/After Migration/
CREATE TABLE ProductDescription(
ProDe_productDescriptionKey int identity(210, 1) PRIMARY KEY,
ProDe_englishDescription nvarchar(250),
ProDe_frenchDescription nvarchar(300)
)ON [FG_Product];

--1 Row: 4 + 2 + 2 = 8 BYTES
--Reserved-72	+	IndexSize-8	 = 80KB		/After Migration/
CREATE TABLE MiscellaneousProductInfo(
Mis_productDescriptionKey int identity(1,1) PRIMARY KEY,
Mis_class nvarchar(1),
Mis_style nvarchar(1),
--Mis_status varchar(25)
)ON [FG_Product];

--1 Row: 4 + (50*2) + (50*2) + (50*2) + 4 + (5*2) + 4 + 8 + (5*2) + 8 + 8 + 3 + 3 + 8 + (8*2) + 4 + 4 + 4 + 4 + 4 + 4 + 4 = 414BYTES
--Reserved-264	+	IndexSize-16  = 280KB		/After Migration/
CREATE TABLE Product(
Pro_productKey int identity(210,1) PRIMARY KEY,
Pro_englishProductName nvarchar(50) NOT NULL,
Pro_frenchProductName nvarchar(50),
Pro_spanishProductName nvarchar(50),
Pro_daysToManufacture int,
Pro_productLine nvarchar(5),
Pro_safetyStockLevel int,
Pro_DealerPrice money,
Pro_finishedGoodsFlag nvarchar(5),
Pro_standardCost Money,
Pro_listPrice Money,
Pro_PromotionStart date,
Pro_PromotionEnd date,
Pro_PromotionPrice money,
--Pro_Promo bit,
Pro_Status nvarchar(8),
Pro_modelKey int,
Pro_colorKey int NOT NULL,
Pro_SizeDetailsKey int,
Pro_WeightDetailsKey int,
Pro_productLanguageCategoryKey int NOT NULL,
Pro_productDescriptionKey int,
Pro_MiscellaneousProductInfoKey int,
)ON [FG_Product];

--1 Row: 4 + (50*2) = 104BYTES
--Reserved-72	+	IndexSize-8	 = 80KB	/After Migration/
CREATE TABLE ProductModelName(
ProDN_ModelKey int IDENTITY(1,1) PRIMARY KEY,
ProDN_ModelName nvarchar(50) NOT NULL
)ON [FG_Product];

--1 Row: 4 + (20*2) + 8 = 52BYTES
--Reserved-72	+	IndexSize-8	 = 80KB	/After Migration/
CREATE TABLE WeightDetails(
WeiD_WeightDetailsKey int identity(1,1) PRIMARY KEY,
WeiD_weightUnitmeasureCode nvarchar(20),
WeiD_weight float,
)ON [FG_Product];

--1 Row: 4 + (20*2) + (10*2) + (15*2) = 94BYTES 
--Reserved-72	+	IndexSize-8	 = 80KB	/After Migration/
CREATE TABLE SizeDetails(
SizD_SizeDetailsKey int identity(1,1) PRIMARY KEY,
SizD_sizeUnitmeasureCode nvarchar(20),
SizD_size nvarchar(10),
SizD_sizeRange nvarchar(15),
)ON [FG_Product];

--1 Row: 3 + (2*35) = 73BYTES
--Reserved-72	+	IndexSize-8	 = 80KB	/After Migration/
CREATE TABLE Currency(
Cur_CurrencyKey int PRIMARY KEY,
Cur_CurrencyAlternateKey char(3) NOT NULL,
Cur_CurrencyName nvarchar(35) NOT NULL,
)ON [FG_Sales];

--1 Row: (25*2) + (25*2) + (25*2) = 150bytes 
--Reserved-72	+	IndexSize-8  = 80KB		/After Migration/
CREATE TABLE SalesTerritory(
SalT_SalesTerritoryKey int PRIMARY KEY,
SalT_SalesTerritoryRegion nvarchar(25) NOT NULL,
SalT_SalesTerritoryCountry nvarchar(25) NOT NULL,
SalT_SalesTerritoryGroup nvarchar(25) NOT NULL,
)ON [FG_Sales];

--1 Row: 4 + (35*2) = 74BYTES
--Reserved-72	+	IndexSize-8	 = 80KB	/After Migration/
CREATE TABLE Company(
Com_companyKey int PRIMARY KEY,
Com_companyName varchar(30) NOT NULL
)ON [FG_Sales];

--1 Row: 4 + 4 + 4 + 4 + (2*10) + 4 + 4 + 4 + 4 + 4 = 56 bytes
--Reserved-4744	 +	IndexSize-16  = 4760KB		/After Migration/
CREATE TABLE SalesOrder(
SalO_SalesOrderkey int identity(1,1) NOT NULL PRIMARY KEY,
SalO_customerKey int NOT NULL,
SalO_currencyKey int NOT NULL,
SalO_salesTerritoryKey int NOT NULL,
SalO_salesOrderNumber nvarchar(10) NOT NULL,
Sal_salesOrderLineNumber int NOT NULL,
SalO_OrderDate datetime2 NOT NULL,
SalO_dueDate datetime2 NOT NULL,
SalO_shipDate datetime2 NOT NULL,
SalO_companyKey int NOT NULL
)ON [FG_Sales];

--1 Row: 8 + 8 + 4 + 4 + 4 = 28 bytes
--Reserved-2248	 +	IndexSize-8	 = 2256KB			/After Migration/
CREATE TABLE SalesOrderDetails(
--SalOD_salesKey int identity(1, 1) PRIMARY KEY,
SalOD_productKey int NOT NULL,
SalOD_SalesOrderKey int NOT NULL,
SalOD_orderQuantity int NOT NULL,
SalOD_unitPrice  money NOT NULL,
SalOD_saleAmount money NOT NULL,
SalOD_Promo bit NOT NULL,
)ON [FG_Sales];

--1 Row: (150*2) + 4 = 304 bytes
--Reserved-72	+	IndexSize-8	 = 80KB		/After Migration/
CREATE TABLE ERROR(
ER_ErrorID int primary Key,
ER_Message nvarchar(150)
)ON [FG_AccountManagement];

--1 Row: 4 + 4 + 4 + 4 = 16 bytes
--Reserved-72	+	IndexSize-8	 = 80KB		/After Migration/
CREATE TABLE ERRORLOG(
ERL_ErrorLogID int identity(1,1) primary Key,
ERL_UserID int,
ERL_ErrorID int NOT NULL,
ERL_TimeStamp DateTime
)ON [FG_AccountManagement];

--exec SP_SPACEUSED
