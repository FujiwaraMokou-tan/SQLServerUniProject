use PROJETO

----------------------------  Store Procedure para Total de Vendas por Ano--------------------------------
go
create or alter procedure sp_SalesPerYear3
as
Begin
Select sum(SalOD_saleAmount) as 'PROFIT', YEAR(SalO_OrderDate) AS 'ANO'
From PROJETO.dbo.SalesOrderDetails join PROJETO.dbo.SalesOrder on SalOD_SalesOrderKey = SalO_SalesOrderkey 
Group by YEAR(SalO_OrderDate)
order by YEAR(SalO_OrderDate) 
END

exec sp_SalesPerYear3

select sum(s.SalesAmount),  YEAR(s.OrderDate) AS 'ANO' From AdventureOldData.dbo.Sales as s
group by YEAR(s.OrderDate)
order by YEAR(s.OrderDate)

----------------------------  Store Procedure para Total de Vendas por Ano e Country--------------------------------
go
create or alter procedure sp_SalesPerYearAndCountry3
as
Begin
Select sum(S.SalOD_saleAmount) as 'PROFIT', ST.SalT_SalesTerritoryCountry as 'Country',  YEAR(SalO_OrderDate) AS 'ANO'
From PROJETO.dbo.SalesOrderDetails as S join PROJETO.dbo.SalesOrder as so on S.SalOD_SalesOrderKey = so.SalO_SalesOrderkey 
JOIN PROJETO.dbo.SalesTerritory as ST on so.SalO_salesTerritoryKey = ST.SalT_SalesTerritoryKey
Group by ST.SalT_SalesTerritoryCountry,YEAR(SalO_OrderDate)
Order by ST.SalT_SalesTerritoryCountry
END

exec sp_SalesPerYearAndCountry3

SELECT sum(s.SalesAmount), st.SalesTerritoryCountry, YEAR(s.OrderDate)  From AdventureOldData.dbo.Sales as s join AdventureOldData.dbo.SalesTerritory as st
						on s.SalesTerritoryRegion = st.SalesTerritoryRegion
						group by ST.SalesTerritoryCountry, YEAR(S.OrderDate)
						order by ST.SalesTerritoryCountry

----------------------------  Store Procedure para Total de Vendas por Ano e SUBCATEGORY--------------------------------
go
create or alter procedure sp_SalesPerYearAndSubcategory2
as
Begin
Select sum(S.SalOD_saleAmount) as 'PROFIT', PSC.ProSB_EnglishProductSubcategoryName, YEAR(SalO_OrderDate) AS 'ANO'
From PROJETO.dbo.SalesOrderDetails as S join PROJETO.dbo.SalesOrder as PS on S.SalOD_SalesOrderKey = PS.SalO_SalesOrderkey
  join PROJETO.dbo.Product as P on S.SalOD_productKey = p.Pro_productKey
  join PROJETO.dbo.ProductLanguageCategory as PLC on PLC.ProLC_productLanguageKey = P.Pro_productLanguageCategoryKey
  join PROJETO.dbo.ProductSubCategory as PSC on PSC.ProSB_productSubCategorykey = PLC.ProLC_productSubCategorykey
 group by PSC.ProSB_EnglishProductSubcategoryName, YEAR(SalO_OrderDate)
 order by PSC.ProSB_EnglishProductSubcategoryName
END

exec sp_SalesPerYearAndSubcategory2

Select sum(s.SalesAmount), ps.EnglishProductSubcategoryName, YEAR(OrderDate) FROM AdventureOldData.dbo.Sales as s join AdventureOldData.dbo.Products as p on s.ProductKey = p.ProductKey
join AdventureOldData.dbo.ProductSubCategory as ps on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
group by ps.EnglishProductSubcategoryName, YEAR(OrderDate)
order by ps.EnglishProductSubcategoryName
----------------------------  Store Procedure para Total de Vendas por Ano e CATEGORY--------------------------------
go
create or alter procedure sp_SalesPerYearAndCategory2
as
Begin
Select sum(S.SalOD_saleAmount) as 'PROFIT', PLC.ProLC_EnglishProductCategoryName, YEAR(SalO_OrderDate) AS 'ANO'
From PROJETO.dbo.SalesOrderDetails as S join PROJETO.dbo.SalesOrder as PS on S.SalOD_SalesOrderKey = PS.SalO_SalesOrderkey
 join PROJETO.dbo.Product as P on S.SalOD_productKey = p.Pro_productKey
 join PROJETO.dbo.ProductLanguageCategory as PLC on PLC.ProLC_productLanguageKey = P.Pro_productLanguageCategoryKey
 group by PLC.ProLC_EnglishProductCategoryName, YEAR(SalO_OrderDate)
 order by PLC.ProLC_EnglishProductCategoryName
END

exec sp_SalesPerYearAndCategory2

Select sum(s.SalesAmount), p.EnglishProductCategoryName, YEAR(OrderDate) FROM AdventureOldData.dbo.Sales as s join AdventureOldData.dbo.Products as p on s.ProductKey = p.ProductKey
group by p.EnglishProductCategoryName, YEAR(OrderDate)
order by p.EnglishProductCategoryName

----------------------------  Store Procedure para numero de clientes por Ano e SALES TERRIORY COUNTRY--------------------------------
go
create or alter procedure sp_PerCustomerYearAndCountry2
as
Begin
Select count(1) as 'Customers', max(ST.SalT_SalesTerritoryCountry) as 'Country', YEAR(SalO_OrderDate) AS 'ANO'
From PROJETO.dbo.SalesOrderDetails as S join PROJETO.dbo.SalesOrder as PS on S.SalOD_SalesOrderKey = PS.SalO_SalesOrderkey
join PROJETO.dbo.Customer as C on PS.SalO_customerKey = C.Cus_customerKey
join PROJETO.dbo.SalesTerritory as ST on PS.SalO_salesTerritoryKey = st.SalT_SalesTerritoryKey
Group By ST.SalT_SalesTerritoryCountry, YEAR(SalO_OrderDate)
 order by ST.SalT_SalesTerritoryCountry, YEAR(SalO_OrderDate)
END

exec sp_PerCustomerYearAndCountry2

select count(c.CustomerKey) as 'Customers', st.SalesTerritoryCountry, YEAR(s.OrderDate) FROM AdventureOldData.dbo.Sales as s join AdventureOldData.dbo.Customer as c on s.CustomerKey = c.CustomerKey
join AdventureOldData.dbo.SalesTerritory as st on s.SalesTerritoryRegion = st.SalesTerritoryRegion
group by st.SalesTerritoryCountry, YEAR(OrderDate)
order by st.SalesTerritoryCountry, YEAR(OrderDate)