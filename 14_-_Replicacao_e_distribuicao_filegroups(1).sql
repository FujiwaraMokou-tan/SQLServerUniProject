--Replicação para a zona do pacifico
DROP DATABASE IF EXISTS PROJETOPacific
CREATE DATABASE PROJETOPacific 
On
Primary
(Name = Projeto_dat,
Filename ='C:\Projeto_de_CBD\MSSQL\ReplicacaoPacifico\Projeto_dat.mdf',
Size = 22,
Maxsize = 48,
Filegrowth = 30%)

Log On

(Name = Projeto_log,
Filename = 'C:\Projeto_de_CBD\MSSQL\ReplicacaoPacifico\Projeto_log.ldf',
Size = 22,
Maxsize = 48,
Filegrowth = 30%);


--Replicação para a zona europeia
DROP DATABASE IF EXISTS PROJETOEurope
CREATE DATABASE PROJETOEurope
on
primary
(Name = Projeto_dat,
Filename = 'C:\Projeto_de_CBD\MSSQL\ReplicacaoEuropa\Projeto_log.mdf',
Size = 22,
MaxSize = 48,
Filegrowth = 30%)

Log On
(Name = Projeto_log,
FileName = 'C:\Projeto_de_CBD\MSSQL\ReplicacaoEuropa\Projeto_log.ldf',
Size = 22,
MaxSize = 48,
Filegrowth = 30%);


--Alteração na replicação do pacifico
Alter Database PROJETOPacific
Add Filegroup FG_PROJETOPacific_Customers;
--80KB + 80KB + 80KB + 216KB + 80KB + 80KB + 8648KB = 9264KB * 1.2 = 11116.8 * 1.2 = 13340.16 * 1.2 =~ 16009KB
Alter Database PROJETOPacific
Add File
(Name = Projeto_Customers,
Filename = 'C:\Projeto_de_CBD\MSSQL\ReplicacaoPacifico\Projeto_Customers.ndf',
Size = 9264KB,
Maxsize = 16009KB,
Filegrowth = 20%)
To Filegroup FG_PROJETOPacific_Customers;   

Go

Alter Database PROJETOPacific
Add Filegroup FG_PROJETOPacific_Product;
--168KB + 80KB + 80KB + 408KB + 80KB + 280KB + 80KB + 80KB + 80KB = 1336KB * 1.2 = 1603.2 * 1.2 = 1923.84 * 1.2 =~ 2309KB
Alter Database PROJETOPacific
Add File
(Name = Projeto_Products,
Filename = 'C:\Projeto_de_CBD\MSSQL\ReplicacaoPacifico\Projeto_Products.ndf',
Size = 1336KB,
Maxsize = 2309KB,
Filegrowth = 20%)
To Filegroup FG_PROJETOPacific_Product;;

Go

Alter Database PROJETOPacific
Add Filegroup FG_PROJETOPacific_Sales;
--80KB + 80KB + 80KB + 4760KB + 2256KB =  7256KB * 1.4 = 10158.4 * 1.4 = 14221.76 * 1.4 =~ 19910KB
Alter Database PROJETOPacific
Add File
(Name = Projeto_Sales,
Filename = 'C:\Projeto_de_CBD\MSSQL\ReplicacaoPacifico\Projeto_Sales.ndf',
Size = 7256KB,
Maxsize = 20000KB,
Filegrowth = 40%)
To Filegroup FG_PROJETOPacific_Sales;

Go
Alter Database PROJETOPacific
Add Filegroup FG_PROJETOPacific_AccountManagement;

--168KB + 280KB + 168KB + 80KB + 80KB + 80KB = 856KB * 1.2 = 1207.2 * 1.2 = 1232.64 * 1.2 =~ 1480KB
Alter Database PROJETOPacific
Add File
(Name = Projeto_AccountManagement,
Filename = 'C:\Projeto_de_CBD\MSSQL\ReplicacaoPacifico\Projeto_AccountManagement.ndf',
Size = 856KB,
Maxsize = 1480KB,
Filegrowth = 20%)
To Filegroup FG_PROJETOPacific_AccountManagement;

use PROJETOPacific


--Alteração na replicação europeia

Alter Database PROJETOEurope
Add Filegroup FG_PROJETOEurope_Customers;
--80KB + 80KB + 80KB + 216KB + 80KB + 80KB + 8648KB = 9264KB * 1.2 = 11116.8 * 1.2 = 13340.16 * 1.2 =~ 16009KB
Alter Database PROJETOEurope
Add File
(Name = Projeto_Customers,
Filename = 'C:\Projeto_de_CBD\MSSQL\ReplicacaoEuropa\Projeto_Customers.ndf',
Size = 9264KB,
Maxsize = 16009KB,
Filegrowth = 20%)
To Filegroup FG_PROJETOEurope_Customers;   

Go

Alter Database PROJETOEurope
Add Filegroup FG_PROJETOEurope_Product;
--168KB + 80KB + 80KB + 408KB + 80KB + 280KB + 80KB + 80KB + 80KB = 1336KB * 1.2 = 1603.2 * 1.2 = 1923.84 * 1.2 =~ 2309KB
Alter Database PROJETOEurope
Add File
(Name = Projeto_Products,
Filename = 'C:\Projeto_de_CBD\MSSQL\ReplicacaoEuropa\Projeto_Products.ndf',
Size = 1336KB,
Maxsize = 2309KB,
Filegrowth = 20%)
To Filegroup FG_PROJETOEurope_Product;;

Go

Alter Database PROJETOEurope
Add Filegroup FG_PROJETOEurope_Sales;
--80KB + 80KB + 80KB + 4760KB + 2256KB =  7256KB * 1.4 = 10158.4 * 1.4 = 14221.76 * 1.4 =~ 19910KB
Alter Database PROJETOEurope
Add File
(Name = Projeto_Sales,
Filename = 'C:\Projeto_de_CBD\MSSQL\ReplicacaoEuropa\Projeto_Sales.ndf',
Size = 7256KB,
Maxsize = 20000KB,
Filegrowth = 40%)
To Filegroup FG_PROJETOEurope_Sales;

Go
Alter Database PROJETOEurope
Add Filegroup FG_PROJETOEurope_AccountManagement;

--168KB + 280KB + 168KB + 80KB + 80KB + 80KB = 856KB * 1.2 = 1207.2 * 1.2 = 1232.64 * 1.2 =~ 1480KB
Alter Database PROJETOEurope
Add File
(Name = Projeto_AccountManagement,
Filename = 'C:\Projeto_de_CBD\MSSQL\ReplicacaoEuropa\Projeto_AccountManagement.ndf',
Size = 856KB,
Maxsize = 1480KB,
Filegrowth = 20%)
To Filegroup FG_PROJETOEurope_AccountManagement;

use PROJETOEurope
