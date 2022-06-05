use PROJETO

go
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

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
Update Product
set Pro_Status = @newStatus
where Pro_productKey = @ProductKey
COMMIT TRAN
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK
END CATCH
end


----------------------------------------------“Adição de Produto a Encomenda--------------------------------------------
go
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
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
SELECT @verifyproductKey = 0
SELECT @verifyproductKey = Pro_productKey From Product where @productKey = Pro_productKey
COMMIT TRAN
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK
END CATCH

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
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	SET NOCOUNT ON
	BEGIN TRY
	BEGIN TRAN
	SELECT @verifyPromoPrice = Pro_listPrice From Product where @productKey = Pro_productKey
	select @Total = @verifyPromoPrice * @orderQuantity
	insert into SalesOrderDetails(SalOD_productKey, SalOD_SalesOrderKey, SalOD_orderQuantity, SalOD_unitPrice, SalOD_saleAmount, SalOD_Promo)
	values (@productKey, @SalesOrderKey, @orderQuantity, @verifyPromoPrice, @Total, 0)
	WAITFOR DELAY '00:00:10'
	COMMIT TRAN
	END TRY
	BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK
	END CATCH
	end


	else
	begin
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	SET NOCOUNT ON
	BEGIN TRY
	BEGIN TRAN
	select @Total = @verifyPromoPrice * @orderQuantity
	insert into SalesOrderDetails(SalOD_productKey, SalOD_SalesOrderKey, SalOD_orderQuantity, SalOD_unitPrice, SalOD_saleAmount, SalOD_Promo)
	values (@productKey, @SalesOrderKey, @orderQuantity, @verifyPromoPrice, @Total, 1)
	WAITFOR DELAY '00:00:10'
	COMMIT TRAN
		END TRY
	BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK
	END CATCH
	end

end
else
Begin
Select ER_Message From ERROR Where ER_ErrorID = 12
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (12, @userID, GETDATE ())
end
end


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
begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, @userID, GETDATE ())
return 1
end

Declare @verifySalesOrderKey as int
SELECT @verifySalesOrderKey = null
-----------------------------------
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
SELECT @verifySalesOrderKey = SalOD_SalesOrderkey From SalesOrderDetails where SalOD_SalesOrderkey = @SalesOrderKey
COMMIT TRAN
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK
END CATCH

-----------------------------------
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

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
update SalesOrderDetails
set SalOD_orderQuantity = @orderQuantity
where @SalesOrderKey = SalOD_SalesOrderKey
COMMIT TRAN
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK
END CATCH
end


exec sp_AddProduct 298, 5, 60399, 1

