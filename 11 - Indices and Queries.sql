use PROJETO
SET ANSI_PADDING ON

 -------------------------------o volume de vendas total por produto -----------------------------------
Select sum(SalOD_orderQuantity) as 'Unidades', p.Pro_englishProductName as 'NAME'
From PROJETO.dbo.SalesOrderDetails --join PROJETO.dbo.SalesOrder on SalOD_SalesOrderKey = SalO_SalesOrderkey 
join PROJETO.dbo.Product as p on  SalOD_productKey = p.Pro_productKey
Group by p.Pro_englishProductName
order by p.Pro_englishProductName


CREATE NONCLUSTERED INDEX IX_ProductKeyWithEngName ON Product(
	Pro_productKey ASC,
	Pro_englishProductName ASC
)
/*
CREATE NONCLUSTERED INDEX IX_SalesOrderDetails_ProductKey ON SalesOrderDetails
(
	SalOD_productKey ASC
)*/


drop index IX_ProductKeyWithEngName ON Product
drop index IX_SalesOrderDetails_ProductKey ON SalesOrderDetails

 -------------------------------produto o volume de vendas em promoçao (Um pequeno cursor para alterar todos os valores de 1 de janeiro como promoção como pedia nas notas) -----------------------------------

go
create or alter procedure sp_changeFirstDayToPromo
as
begin
declare @promo bit;
declare cur cursor for 
SELECT SalOD_Promo
from SalesOrderDetails join SalesOrder on SalO_SalesOrderkey = SalOD_SalesOrderKey
Where day(SalO_dueDate) = 1 and month(SalO_dueDate) = 1

OPEN cur  
FETCH NEXT FROM cur INTO @promo

WHILE @@FETCH_STATUS = 0  
begin
	update SalesOrderDetails
	set SalOD_Promo = 1
	from SalesOrderDetails
	join SalesOrder on SalO_SalesOrderkey = SalOD_SalesOrderKey
	Where day(SalO_dueDate) = 1 and month(SalO_dueDate) = 1
	FETCH NEXT FROM cur INTO @promo
end;
close cur;
deallocate cur;
end

exec sp_changeFirstDayToPromo

---------------------------------------- volume de vendas em promoçao por produto(Cont) -----------------------------------

Select sum(SalOD_orderQuantity) as 'Unidades', p.Pro_englishProductName as 'NAME'
From PROJETO.dbo.SalesOrderDetails join PROJETO.dbo.SalesOrder on SalOD_SalesOrderKey = SalO_SalesOrderkey 
join PROJETO.dbo.Product as p on  SalOD_productKey = p.Pro_productKey
Where SalOD_Promo = 1
Group by p.Pro_englishProductName
order by p.Pro_englishProductName


CREATE NONCLUSTERED INDEX IX_SalesOrderDetails_Promo_productKey on SalesOrderDetails(
	[SalOD_Promo] ASC,
	[SalOD_productKey] ASC
)


--drop index IX_SalesOrderDetails_Promo_productKey ON SalesOrderDetails

---------------------------------------- percentagem de vendas por produto efetuada com promoção -----------------------------------

Select CAST(sum(SalOD_orderQuantity) * 100 as float)/ cast((

Select count(SalOD_orderQuantity)
From PROJETO.dbo.SalesOrderDetails join PROJETO.dbo.SalesOrder on SalOD_SalesOrderKey = SalO_SalesOrderkey 
join PROJETO.dbo.Product as p on  SalOD_productKey = p.Pro_productKey

)as float) as 'Percentage', p.Pro_englishProductName as 'NAME'
From PROJETO.dbo.SalesOrderDetails join PROJETO.dbo.SalesOrder on SalOD_SalesOrderKey = SalO_SalesOrderkey 
join PROJETO.dbo.Product as p on  SalOD_productKey = p.Pro_productKey
Where SalOD_Promo = 1
Group by p.Pro_englishProductName


CREATE NONCLUSTERED INDEX IX_SalesOrderDetails_Promo ON SalesOrderDetails
(
	SalOD_Promo ASC
)


--drop index IX_SalesOrderDetails_Promo ON SalesOrderDetails

-------------------------------------- total de vendas anual por Região Geográfica-----------------------------------------------

Select (sum(S.SalOD_orderQuantity) * MAX(S.SalOD_unitPrice)) as 'PROFIT', ST.SalT_SalesTerritoryRegion as 'Region',  YEAR(SalO_OrderDate) AS 'ANO'
From PROJETO.dbo.SalesOrderDetails as S join PROJETO.dbo.SalesOrder as so on S.SalOD_SalesOrderKey = so.SalO_SalesOrderkey 
JOIN PROJETO.dbo.SalesTerritory as ST on so.SalO_salesTerritoryKey = ST.SalT_SalesTerritoryKey
Group by ST.SalT_SalesTerritoryRegion, YEAR(SalO_OrderDate)
Order by ST.SalT_SalesTerritoryRegion


CREATE NONCLUSTERED INDEX IX_SalesOrder_SalesOrderkey_salesTerritoryKey ON SalesOrder
(
	SalO_SalesOrderkey ASC,
	SalO_salesTerritoryKey ASC
)

/*
CREATE NONCLUSTERED INDEX IX_SalesOrderDetails_SalesOrderKey ON SalesOrderDetails
(
	SalOD_SalesOrderKey ASC
)*/


--drop index IX_SalesOrder_SalesOrderkey_salesTerritoryKey ON SalesOrder
--drop index IX_SalesOrderDetails_SalesOrderKey ON SalesOrderDetails

-------------------------------------- para cada ano a Região Geográfica com o maior valor total de vendas-----------------------------------------------

SELECT top 1 with ties sum(S.SalOD_saleAmount) as 'PROFIT', ST.SalT_SalesTerritoryRegion as 'Region',  YEAR(SalO_OrderDate) AS 'ANO'
From PROJETO.dbo.SalesOrderDetails as S join PROJETO.dbo.SalesOrder as so on S.SalOD_SalesOrderKey = so.SalO_SalesOrderkey 
JOIN PROJETO.dbo.SalesTerritory as ST on so.SalO_salesTerritoryKey = ST.SalT_SalesTerritoryKey
Group by ST.SalT_SalesTerritoryRegion,YEAR(SalO_OrderDate)
Order by row_number() over (
partition by YEAR(so.SalO_OrderDate)
order by sum(SalOD_saleAmount) desc);

-----------------------------------------Prazo médio entre data de encomenda e envio por Região Geográfica

Select (avg(CAST(datediff(d, s.SalO_OrderDate, s.SalO_shipDate)as float))) as 'Average days', ST.SalT_SalesTerritoryRegion as 'Region'
From PROJETO.dbo.SalesOrder as s join PROJETO.dbo.SalesTerritory as st on s.SalO_salesTerritoryKey = st.SalT_SalesTerritoryKey 
where YEAR(s.SalO_OrderDate) > dateadd(year, -2, 2018/01/01)
Group by st.SalT_SalesTerritoryRegion
Order by ST.SalT_SalesTerritoryRegion


CREATE NONCLUSTERED INDEX IX_SalesOrder_salesTerritoryKey_OrderDate ON SalesOrder
(
	SalO_salesTerritoryKey ASC,
	SalO_OrderDate ASC
)


drop index IX_SalesOrder_salesTerritoryKey_OrderDate ON SalesOrder


