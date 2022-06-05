use PROJETO

-----------------------------------------------CREATE PRODUCT--------------------------------------
go
create or alter procedure sp_CreatingProduct (@englishProductName nvarchar(50), @Color nvarchar(20), @EnglishProductCategoryName nvarchar(50), @EnglishProductSubcategoryName nvarchar(50), @userID int)
as
begin

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

if @englishProductName is null and @Color is null and @EnglishProductCategoryName is null and @EnglishProductSubcategoryName is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, @userID, GETDATE ())
return 1
end


declare @verifyColor as nvarchar(20)
select @verifyColor = ProC_color from ProductColor where ProC_color = @Color
declare @colorID as int

if @verifyColor = @color
begin
select @colorID = ProC_colorKey from ProductColor where ProC_color = @Color
end
else
begin
	insert into ProductColor(ProC_color) values (@color)
	select @colorID = ProC_colorKey from ProductColor where ProC_color = @Color
end

declare @VerifysubCategoryName as nvarchar(50)
select @VerifysubCategoryName = ProSB_EnglishProductSubcategoryName from ProductSubCategory where ProSB_EnglishProductSubcategoryName = @EnglishProductSubcategoryName
declare @subCategoryNameID as int

if @VerifysubCategoryName = @EnglishProductSubcategoryName
begin
select @subCategoryNameID = ProSB_productSubCategorykey from ProductSubCategory where ProSB_EnglishProductSubcategoryName = @EnglishProductSubcategoryName
end
else
begin
	insert into ProductSubCategory(ProSB_EnglishProductSubcategoryName) values (@EnglishProductSubcategoryName)
	select @subCategoryNameID = ProSB_productSubCategorykey from ProductSubCategory where ProSB_EnglishProductSubcategoryName = @EnglishProductSubcategoryName
end


declare @VerifyProductCategoryName as nvarchar(50)
select @VerifyProductCategoryName = ProLC_EnglishProductCategoryName from ProductLanguageCategory where ProLC_EnglishProductCategoryName =  @EnglishProductCategoryName
declare @ProductCategoryNameID as int

if @VerifyProductCategoryName = @EnglishProductCategoryName
begin
	insert into ProductLanguageCategory(ProLC_EnglishProductCategoryName, ProLC_productSubCategorykey) values (@EnglishProductCategoryName, @subCategoryNameID)
	select @ProductCategoryNameID = ProLC_productLanguageKey from ProductLanguageCategory where ProLC_EnglishProductCategoryName =  @EnglishProductCategoryName and ProLC_productSubCategorykey = @subCategoryNameID 
end
else
begin
	insert into ProductLanguageCategory(ProLC_EnglishProductCategoryName, ProLC_productSubCategorykey) values (@EnglishProductCategoryName, @subCategoryNameID)
	select @ProductCategoryNameID = ProLC_productLanguageKey from ProductLanguageCategory where ProLC_EnglishProductCategoryName =  @EnglishProductCategoryName
end

INSERT INTO Product (Pro_englishProductName, Pro_colorKey, Pro_productLanguageCategoryKey) values (@englishProductName, @colorID, @ProductCategoryNameID)
end

exec sp_CreatingProduct 'Touhou Plushie', 'Rainbow', 'Accessories', 'doll', 1
exec sp_CreatingProduct 'HL Bottom Bracket', 'Yellow', 'Accessories', 'Mountain Bikes', 1


-----------------------------------------------Delete PRODUCT--------------------------------------
go
create or alter procedure sp_DeleteProduct(@ProductKey int, @userID as int)
as
begin
EXEC sp_MSForEachTable "ALTER TABLE Product NOCHECK CONSTRAINT all"

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

if @ProductKey is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, @userID, GETDATE ())
return 1
end


declare @verifyProductID as int
select @verifyProductID = 0
select @verifyProductID = Pro_productKey from Product where Pro_productKey = @ProductKey

if @verifyProductID = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 4
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (4, @userID, GETDATE ())
return 1
end

declare @getCategory as int
select @getCategory = Pro_productLanguageCategoryKey from product where @ProductKey = Pro_productKey

declare @getSubcategory as int
select @getSubcategory = ProLC_productSubCategorykey from ProductLanguageCategory where @getCategory = ProLC_productLanguageKey

declare @getProdWithSameCat as int
select @getProdWithSameCat = count(Pro_productLanguageCategoryKey) from product where @ProductKey = Pro_productKey
 
declare @getCatWithSameSub as int
select @getCatWithSameSub = count(ProLC_productSubCategorykey) from ProductLanguageCategory where @getCategory = ProLC_productLanguageKey


if @getProdWithSameCat = 1 and @getCatWithSameSub = 1
Begin
EXEC sp_MSForEachTable "ALTER TABLE ? NOCHECK CONSTRAINT all"
DELETE FROM ProductSubCategory Where @getSubcategory = ProSB_productSubCategorykey
DELETE FROM ProductLanguageCategory Where @getCategory = ProLC_productLanguageKey
--DELETE FROM Product Where @ProductKey = Pro_productKey
exec sp_MSForEachTable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
return 1
end

if @getProdWithSameCat = 1
		begin
		EXEC sp_MSForEachTable "ALTER TABLE ? NOCHECK CONSTRAINT all"
		DELETE FROM ProductLanguageCategory Where @getCategory = ProLC_productLanguageKey
		DELETE FROM Product Where @ProductKey = Pro_productKey
		exec sp_MSForEachTable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
		return 1
		end

if @getCatWithSameSub = 1
		begin
		EXEC sp_MSForEachTable "ALTER TABLE ? NOCHECK CONSTRAINT all"
		DELETE FROM ProductSubCategory Where @getSubcategory = ProSB_productSubCategorykey
		DELETE FROM Product Where @ProductKey = Pro_productKey
		exec sp_MSForEachTable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
		return 1
		end

DELETE FROM Product Where @ProductKey = Pro_productKey
exec sp_MSForEachTable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
end

exec sp_DeleteProduct 590, 1

/*select *
from Product*/

-----------------------------------------------Associate PRODUCT--------------------------------------
go
create or alter procedure sp_AssociateProduct2(@ProductKey int, @EnglishProductCategoryID int, @EnglishProductSubcategoryID int, @userID int)
as
begin
EXEC sp_MSForEachTable "ALTER TABLE ? NOCHECK CONSTRAINT all"

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

if @ProductKey is null and @EnglishProductCategoryID is null and @EnglishProductSubcategoryID is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, @userID, GETDATE ())
return 1
end


declare @verifyID as int
select @verifyID = 0
select @verifyID = ProLC_productLanguageKey from ProductLanguageCategory where ProLC_productLanguageKey =  @EnglishProductCategoryID AND ProLC_productSubCategorykey = @EnglishProductSubcategoryID
select @verifyID

if @verifyID = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 8
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (8, @userID, GETDATE ())
return 1
end

Else
Begin
UPDATE Product
set Pro_productLanguageCategoryKey = @verifyID
where @ProductKey = Pro_productKey
exec sp_MSForEachTable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
end
end

exec sp_AssociateProduct2 211, 2, 27, 1
exec sp_AssociateProduct2 211, 2, 3, 1

/*select *
from Product

select *
from ProductLanguageCategory*/
----------------------------------------------Edit Subcategory--------------------------------------------
go
create or alter procedure sp_EditSubCat(@EnglishProductSubcategoryID int, @englishSubName nvarchar(50), @SpanishSubName nvarchar(50), @FrenchSubName nvarchar(50), @userID int)
as
begin

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

if @EnglishProductSubcategoryID is null or @englishSubName is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, @userID, GETDATE ())
return 1
end


declare @verifyProductSubcategoryID as int
select @verifyProductSubcategoryID = 0
select @verifyProductSubcategoryID  = ProSB_productSubCategorykey from ProductSubCategory where ProSB_productSubCategorykey = @EnglishProductSubcategoryID

if 0 = @verifyProductSubcategoryID
begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (1, @userID, GETDATE ())
return 1
end

Update ProductSubCategory
set ProSB_EnglishProductSubcategoryName = @englishSubName, ProSB_SpanishProductSubcategoryName = @SpanishSubName, ProSB_FrenchProductSubcategoryName = @FrenchSubName
where ProSB_productSubCategorykey = @EnglishProductSubcategoryID
end

exec sp_EditSubCat 3, 'aaa', 'dddd', 'uuuu', 1
exec sp_EditSubCat 90, 'aaa', 'dddd', 'uuuu', 1

----------------------------------------------Edit Category--------------------------------------------
go
create or alter procedure sp_EditCat(@EnglishProductcategoryID nvarchar(50), @englishName nvarchar(50), @SpanishName nvarchar(50), @FrenchName nvarchar(50), @subCategoryKey int, @userID int)
as
begin

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

if @EnglishProductcategoryID is null and @englishName is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, @userID, GETDATE ())
return 1
end

declare @verifyProductcategoryID as int
select @verifyProductcategoryID = 0
select @verifyProductcategoryID  = ProLC_productLanguageKey from ProductLanguageCategory where ProLC_productLanguageKey = @EnglishProductcategoryID

declare @verifyProductSubcategoryID as int
select @verifyProductSubcategoryID = 0
select @verifyProductSubcategoryID  = ProSB_productSubCategorykey from ProductSubCategory where ProSB_productSubCategorykey = @subCategoryKey

if @verifyProductcategoryID = 0 or 0 = @verifyProductSubcategoryID
begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (1, @userID, GETDATE ())
return 1
end

Update ProductLanguageCategory
set ProLC_EnglishProductCategoryName = @englishName, ProLC_SpanishProductCategoryName = @SpanishName, ProLC_frenchProductCategoryName = @FrenchName, ProLC_productSubCategorykey = @subCategoryKey
where ProLC_productLanguageKey = @EnglishProductcategoryID
end

exec sp_EditCat 6, 'aaaaa', 'bbbbb', 'ccccc', 8, 1
exec sp_EditCat 90, 'aaaaa', 'bbbbb', 'ccccc', 8, 1

----------------------------------------------Create Subcategory--------------------------------------------
go
create or alter procedure sp_CreateSubCat2( @englishSubName nvarchar(50), @SpanishSubName nvarchar(50), @FrenchSubName nvarchar(50), @userID int)
as
begin

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

insert into ProductSubCategory (ProSB_EnglishProductSubcategoryName, ProSB_SpanishProductSubcategoryName, ProSB_FrenchProductSubcategoryName)
values (@englishSubName, @SpanishSubName, @FrenchSubName)
end

exec sp_CreateSubCat2 'asaaa', 'ddddfd', 'uuguu', 1

select * from ProductSubCategory
----------------------------------------------Alter Status--------------------------------------------
/*go
create or alter procedure sp_alterStat(@ProductKey int, @newStatus nvarchar(20), @userID int)
as
begin

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

if @ProductKey is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, @userID, GETDATE ())
return 1
end

declare @verifyProductID as int
select @verifyProductID = 0
select @verifyProductID = Pro_productKey from Product where Pro_productKey = @ProductKey
if @verifyProductID = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (1, @userID, GETDATE ())
return 1
end

if @newStatus <> 'Current' and @newStatus <> null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (1 , @userID, GETDATE ())
return 1
end

Update Product
set Pro_Status = @newStatus
where Pro_productKey = @ProductKey
end*/

exec sp_alterStat 212, 'Current', 1
----------------------------------------------Edit/Create Promotion--------------------------------------------
go
create or alter procedure sp_EditPromo(@ProductKey int, @promotionStart date, @promotionEnd date, @Pro_PromotionPrice money, @userID int)
as
begin

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

if @ProductKey is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, @userID, GETDATE ())
return 1
end

declare @verifyProductID as int
select @verifyProductID = 0
select @verifyProductID = Pro_productKey from Product where Pro_productKey = @ProductKey

if @verifyProductID = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (1,  @userID, GETDATE ())
return 1
end

declare @getListPrize as money
select @getListPrize = Pro_listPrice From Product where Pro_productKey = @ProductKey

if @Pro_PromotionPrice is not null and @Pro_PromotionPrice > @getListPrize
Begin
Select ER_Message From ERROR Where ER_ErrorID = 9
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (9, @userID, GETDATE ())
return 1
end

if @promotionStart > @promotionEnd
begin
Select ER_Message From ERROR Where ER_ErrorID = 3
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (3, @userID, GETDATE ())
return 1
end

Update Product
set Pro_PromotionStart = @promotionStart, Pro_PromotionEnd = @promotionEnd, Pro_PromotionPrice = @Pro_PromotionPrice
where Pro_productKey = @ProductKey

if @Pro_PromotionPrice is null or @Pro_PromotionPrice = 0
begin
Update Product
set Pro_PromotionStart = null, Pro_PromotionEnd = null, Pro_PromotionPrice = null
where Pro_productKey = @ProductKey
end
end

exec sp_EditPromo 598, '2019-11-01', '2019-12-01', 600, 1
exec sp_EditPromo 598, '2019-12-01', '2019-11-01', null, 1
exec sp_EditPromo 598, '2019-11-01', '2019-12-01', null, 1
exec sp_EditPromo 598, '2019-11-01', '2019-12-01', 400, 1

----------------------------------------------Criação de Encomenda--------------------------------------------
go
create or alter procedure sp_CreateDelivery(@CustomerKey int, @CurrencyKey int, @salesTerritoryKey int, @CompanyKey int, @salesOrderNumber nvarchar(10), --@OrderLineNumber as int,
										@OrderDate datetime2, @dueDate datetime2, @shipDate datetime2, @userID int)
as
begin

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

if @CustomerKey is null or @CurrencyKey is null or @salesTerritoryKey is null or @CompanyKey is null or @salesOrderNumber is null or
@OrderDate is null or @dueDate is null or @shipDate is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, @userID, GETDATE ())
return 1
end



declare @currentTime as datetime2
select @currentTime = SYSDATETIME()

if @OrderDate > @dueDate or @OrderDate > @shipDate or @shipDate > @dueDate --and @currentTime > @shipDate
Begin
Select ER_Message From ERROR Where ER_ErrorID = 3
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (3, @userID, GETDATE ())
return 1
end


declare @verifySalesOrderNumber as nvarchar(10)
select @verifySalesOrderNumber = @salesOrderNumber
select @verifySalesOrderNumber = SUBSTRING(@verifySalesOrderNumber, 1, 2);


if @verifySalesOrderNumber <> 'SO'
Begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (1, @userID, GETDATE ())
return 1
end


declare @verifyCustomer as int
SELECT @verifyCustomer = 0
SELECT @verifyCustomer = Cus_customerKey From Customer where @CustomerKey = Cus_customerKey

if @verifyCustomer = 0 or @verifyCustomer is null
begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (1, @userID, GETDATE ())
return 1
end

declare @verifyCurrency as int
SELECT @verifyCurrency = 0
SELECT @verifyCurrency = Cur_CurrencyKey From Currency where @CurrencyKey = Cur_CurrencyKey

if @verifyCurrency = 0 or @verifyCurrency is null
begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (1, @userID, GETDATE ())
return 1
end

declare @verify@salesTerritoryKey as int
SELECT @verify@salesTerritoryKey = 0
SELECT @verify@salesTerritoryKey = SalT_SalesTerritoryKey From SalesTerritory where @salesTerritoryKey = SalT_SalesTerritoryKey

if @verify@salesTerritoryKey = 0 or @verify@salesTerritoryKey is null
begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (1, @userID, GETDATE ())
return 1
end

if @CompanyKey <= 0 or @CompanyKey > 2
begin
Select ER_Message From ERROR Where ER_ErrorID = 11
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (11, @userID, GETDATE ())
return 1
end

--declare @verifysalesOrderNumber as nvarchar(10)
SELECT @verifysalesOrderNumber = 'SO'
SELECT @verifysalesOrderNumber = SalO_salesOrderNumber From SalesOrder where @salesOrderNumber = SalO_salesOrderNumber

if @verifysalesOrderNumber = 'SO' or @verifysalesOrderNumber is null
begin
insert into SalesOrder(SalO_customerKey, SalO_currencyKey, SalO_salesTerritoryKey, SalO_salesOrderNumber, Sal_salesOrderLineNumber, SalO_OrderDate, SalO_dueDate, SalO_shipDate, SalO_companyKey)
values (@CustomerKey, @CurrencyKey, @salesTerritoryKey, @salesOrderNumber, 1, @OrderDate, @dueDate, @shipDate, @CompanyKey)

select SalO_SalesOrderkey
from SalesOrder
where @salesOrderNumber = SalO_salesOrderNumber
end

else
begin
declare @verifySalesOrderLineNumber as int
SELECT @verifySalesOrderLineNumber = 0
SELECT @verifySalesOrderLineNumber = count(Sal_salesOrderLineNumber) From SalesOrder where @salesOrderNumber = SalO_salesOrderNumber
SELECT @verifySalesOrderLineNumber = @verifySalesOrderLineNumber + 1
insert into SalesOrder(SalO_customerKey, SalO_currencyKey, SalO_salesTerritoryKey, SalO_salesOrderNumber, Sal_salesOrderLineNumber, SalO_OrderDate, SalO_dueDate, SalO_shipDate, SalO_companyKey)
values (@CustomerKey, @CurrencyKey, @salesTerritoryKey, @salesOrderNumber, @verifySalesOrderLineNumber, @OrderDate, @dueDate, @shipDate, @CompanyKey)

select top 1 SalO_SalesOrderkey
from SalesOrder
where @salesOrderNumber = SalO_salesOrderNumber and @verifySalesOrderLineNumber = Sal_salesOrderLineNumber
ORDER BY SalO_SalesOrderkey DESC
end
end

exec sp_CreateDelivery 11221, 6, 5, 1, 'SO66666', '2019-11-15 09:00:00', '2020-12-15 09:00:00', '2020-12-14 09:00:00', 1

----------------------------------------------“Adição de Produto a Encomenda--------------------------------------------
/*go
create or alter procedure sp_AddProduct(@productKey int, @orderQuantity int, @SalesOrderKey int, @userID int)
as
begin

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

if @productKey is null or @SalesOrderKey is null or @orderQuantity is null or @orderQuantity <= 0 or @productKey <= 0
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, @userID, GETDATE ())
return 1
end

declare @verifyproductKey as int
SELECT @verifyproductKey = 0
SELECT @verifyproductKey = Pro_productKey From Product where @productKey = Pro_productKey

if @verifyproductKey = 0 
Begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (1, @userID, GETDATE ())
return 1
end

declare @verifySalesOrderKey as int
SELECT @verifySalesOrderKey = 0
SELECT @verifySalesOrderKey = SalO_SalesOrderKey From SalesOrder where SalO_SalesOrderKey =  @SalesOrderKey

if @verifySalesOrderKey = 0 
Begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (1, @userID, GETDATE ())
return 1
end
/*declare @SalesOrderKey as int
select @SalesOrderKey = count(*) From SalesOrder
select @SalesOrderKey = @SalesOrderKey + 1*/

declare @verifyStatus as nvarchar(20)
SELECT @verifyStatus = Pro_Status From Product where @productKey = Pro_productKey
declare @Total as money
if @verifyStatus = 'Current' or @verifyStatus = 'current'
begin
declare @verifyPromoPrice as money
SELECT @verifyPromoPrice = null
SELECT @verifyPromoPrice = Pro_PromotionPrice From Product where @productKey = Pro_productKey

	if @verifyPromoPrice is null
	begin
	SELECT @verifyPromoPrice = Pro_listPrice From Product where @productKey = Pro_productKey
	select @Total = @verifyPromoPrice * @orderQuantity
	insert into SalesOrderDetails(SalOD_productKey, SalOD_SalesOrderKey, SalOD_orderQuantity, SalOD_unitPrice, SalOD_saleAmount, SalOD_Promo)
	values (@productKey, @SalesOrderKey, @orderQuantity, @verifyPromoPrice, @Total, 0)
	end
	else
	begin
	select @Total = @verifyPromoPrice * @orderQuantity
	insert into SalesOrderDetails(SalOD_productKey, SalOD_SalesOrderKey, SalOD_orderQuantity, SalOD_unitPrice, SalOD_saleAmount, SalOD_Promo)
	values (@productKey, @SalesOrderKey, @orderQuantity, @verifyPromoPrice, @Total, 1)
	end

end
else
Begin
Select ER_Message From ERROR Where ER_ErrorID = 12
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (12, @userID, GETDATE ())
return 1
end
end

exec sp_AddProduct 298, 5, 60399, 1

/*select *
from SalesOrder
order by SalO_SalesOrderkey

select *
from SalesOrderDetails
order by SalOD_SalesOrderKey*/
----------------------------------------------Alteração de Quantidade de Produto na Encomenda--------------------------------------------
go
create or alter procedure sp_AlterQuantity(@SalesOrderKey int, @orderQuantity int, @userID int)
as
begin

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

if @SalesOrderKey is null or @orderQuantity is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, @userID, GETDATE ())
return 1
end

Declare @verifySalesOrderKey as int
SELECT @verifySalesOrderKey = null
SELECT @verifySalesOrderKey = SalOD_SalesOrderkey From SalesOrderDetails where SalOD_SalesOrderkey = @SalesOrderKey

if @verifySalesOrderKey is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (1, @userID, GETDATE ())
return 1
end

declare @getShipDate as datetime2
select @getShipDate = SalO_shipDate From SalesOrder where @SalesOrderKey = SalO_SalesOrderkey

declare @currentTime as datetime2
select @currentTime = SYSDATETIME()

if @currentTime > @getShipDate
Begin
Select ER_Message From ERROR Where ER_ErrorID = 3
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (3, @userID, GETDATE ())
return 1
end

update SalesOrderDetails
set SalOD_orderQuantity = @orderQuantity
where @SalesOrderKey = SalOD_SalesOrderKey
end

exec sp_AlterQuantity 60399, 2, 1

*/
----------------------------------------------Remoção de Produto de Encomenda--------------------------------------------
go
create or alter procedure sp_RemoveDelivery(@SalesOrderKey int, @userID int)
as
begin

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

if @SalesOrderKey is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, @userID, GETDATE ())
return 1
end


Declare @verifySalesOrderKey as int
SELECT @verifySalesOrderKey = null
SELECT @verifySalesOrderKey = SalOD_SalesOrderkey From SalesOrderDetails where @SalesOrderKey = SalOD_SalesOrderkey

if @verifySalesOrderKey is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (1, @userID, GETDATE ())
return 1
end

delete from SalesOrderDetails where @SalesOrderKey = SalOD_SalesOrderKey
end

exec sp_RemoveDelivery 60399, 1

----------------------------------------------Edit Subcategory--------------------------------------------
go
create or alter procedure sp_CreateSubCat2( @englishSubName nvarchar(50), @SpanishSubName nvarchar(50), @FrenchSubName nvarchar(50), @userID int)
as
begin

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

insert into ProductSubCategory (ProSB_EnglishProductSubcategoryName, ProSB_SpanishProductSubcategoryName, ProSB_FrenchProductSubcategoryName)
values (@englishSubName, @SpanishSubName, @FrenchSubName)
end

exec sp_CreateSubCat2 'aasa', 'ddfdd', 'uhuuu', 1


----------------------------------------------Delete Subcategory--------------------------------------------
go
create or alter procedure sp_deleteSubCat2( @subKey int, @userID int)
as
begin

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

declare @verifyKey as bit
select @verifyKey = 0
select @verifyKey =  ProSB_productSubCategorykey from ProductSubCategory where ProSB_productSubCategorykey = @subKey

if @verifyKey = 0
begin
begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (1, GETDATE ())
return 1
end
end

delete from ProductSubCategory where @subKey = ProSB_productSubCategorykey
end

exec sp_deleteSubCat2 5, 1

