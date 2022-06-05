Drop database if exists PROJETO

USE master;
GO
create database PROJETO
On
Primary
(Name = Projeto_dat,
Filename ='C:\Projeto_de_CBD\MSSQL\DATA\Projeto_dat.mdf',
Size = 22,
Maxsize = 48,
Filegrowth = 30%)

Log On

(Name = Projeto_log,
Filename = 'C:\Projeto_de_CBD\MSSQL\DATA\Projeto_log.ldf',
Size = 22,
Maxsize = 48,
Filegrowth = 30%);

Alter Database PROJETO
Add Filegroup FG_Customers;
--80KB + 80KB + 80KB + 216KB + 80KB + 80KB + 8648KB = 9264KB * 1.2 = 11116.8 * 1.2 = 13340.16 * 1.2 =~ 16009KB
Alter Database PROJETO
Add File
(Name = Projeto_Customers,
Filename = 'C:\Projeto_de_CBD\MSSQL\DATA\Projeto_Customers.ndf',
Size = 9264KB,
Maxsize = 16009KB,
Filegrowth = 20%)
To Filegroup FG_Customers;   

Go

Alter Database PROJETO
Add Filegroup FG_Product;
--168KB + 80KB + 80KB + 408KB + 80KB + 280KB + 80KB + 80KB + 80KB = 1336KB * 1.2 = 1603.2 * 1.2 = 1923.84 * 1.2 =~ 2309KB
Alter Database PROJETO
Add File
(Name = Projeto_Products,
Filename = 'C:\Projeto_de_CBD\MSSQL\DATA\Projeto_Products.ndf',
Size = 1336KB,
Maxsize = 2309KB,
Filegrowth = 20%)
To Filegroup FG_Product;

Go

Alter Database PROJETO
Add Filegroup FG_Sales;
--80KB + 80KB + 80KB + 4760KB + 2256KB =  7256KB * 1.4 = 10158.4 * 1.4 = 14221.76 * 1.4 =~ 19910KB
Alter Database PROJETO
Add File
(Name = Projeto_Sales,
Filename = 'C:\Projeto_de_CBD\MSSQL\DATA\Projeto_Sales.ndf',
Size = 7256KB,
Maxsize = 20000KB,
Filegrowth = 40%)
To Filegroup FG_Sales;

Go
Alter Database PROJETO
Add Filegroup FG_AccountManagement;

--168KB + 280KB + 168KB + 80KB + 80KB + 80KB = 856KB * 1.2 = 1207.2 * 1.2 = 1232.64 * 1.2 =~ 1480KB
Alter Database PROJETO
Add File
(Name = Projeto_AccountManagement,
Filename = 'C:\Projeto_de_CBD\MSSQL\DATA\Projeto_AccountManagement.ndf',
Size = 856KB,
Maxsize = 1480KB,
Filegrowth = 20%)
To Filegroup FG_AccountManagement;

use PROJETO