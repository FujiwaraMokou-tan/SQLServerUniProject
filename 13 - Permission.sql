use PROJETO

-- Criar roles

GO
CREATE ROLE AdminRole; --Administrador
GO 
GO 
CREATE ROLE MarketingManager; --Gestor
GO 
GO
CREATE ROLE AnonUser; --Cliente
GO 
GO
CREATE ROLE RegisteredUser; --Cliente registado
GO 

--Criar Logins

create login admingLog with password = 'HentaiKing';

create login marketingLog with password = 'OhHiMark';

create login anonLog with password = 'HowCanAnonLog';

create login registeredLog with password = 'Registered';

-- Criar utilizadores

GO
CREATE USER Administrator FOR LOGIN admingLog;
GO
GO
CREATE USER Manager FOR LOGIN marketingLog;
GO
GO
CREATE USER Kaguya FOR LOGIN anonLog;
GO 
GO
CREATE USER Mokou FOR LOGIN registeredLog;
GO 

-- Adicionar utilizadores aos roles

GO
EXEC sp_addrolemember  @membername = 'Administrator', @rolename = 'AdminRole';
GO
GO
EXEC sp_addrolemember  @membername = 'Manager', @rolename = 'MarketingManager';
GO
GO
EXEC sp_addrolemember  @membername = 'Kaguya', @rolename = 'AnonUser';
GO
GO
EXEC sp_addrolemember  @membername = 'Mokou', @rolename = 'RegisteredUser';
GO

--Permissions to Admin
go
--GRANT SELECT, INSERT, DELETE, UPDATE, EXECUTE on SCHEMA::dbo TO AdminRole
GRANT SELECT, INSERT, DELETE, UPDATE, EXECUTE TO AdminRole
go

---Permissions to AnonClient
go
--REVOKE CONNECT FROM Kaguya
GRANT SELECT on dbo.Product TO Kaguya
go

---Permissions to Manager
go
GRANT SELECT on dbo.Product TO Manager
GRANT EXECUTE ON dbo.sp_EditPromo TO Manager
--GRANT EXECUTE ON dbo.sp_CreateDelivery TO Manager
--GRANT EXECUTE ON dbo.sp_AddProduct TO Manager
--GRANT EXECUTE ON dbo.sp_AlterQuantity TO Manager
go

---Permissions to RegClient
go
GRANT SELECT ON dbo.Customer TO Mokou
--GRANT SELECT ON dbo.Product TO Mokou
GRANT EXECUTE ON dbo.sp_CreateDelivery TO Mokou
GRANT EXECUTE ON dbo.sp_AddProduct TO Mokou
GRANT EXECUTE ON dbo.sp_AlterQuantity TO Mokou



--------------------------------------------------  TESTING Registered User------------------------------------

EXECUTE AS USER = 'Mokou';  
SELECT * FROM fn_my_permissions('dbo.Customer', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO  

EXECUTE AS USER = 'Mokou';  
SELECT * FROM fn_my_permissions('dbo.sp_CreateDelivery', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO

EXECUTE AS USER = 'Mokou';  
SELECT * FROM fn_my_permissions('dbo.sp_AddProduct', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO  

EXECUTE AS USER = 'Mokou';  
SELECT * FROM fn_my_permissions('dbo.sp_AlterQuantity', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO  

-- Should appear empty because this permission isnt granted
EXECUTE AS USER = 'Mokou';  
SELECT * FROM fn_my_permissions('dbo.sp_EditPromo', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO  

--------------------------------------------------------------------------  TESTING Anon User------------------------------------------------------------
EXECUTE AS USER = 'Kaguya';  
SELECT * FROM fn_my_permissions('dbo.Product', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO  

-- Should appear empty because this permission isnt granted
EXECUTE AS USER = 'Kaguya';  
SELECT * FROM fn_my_permissions('dbo.sp_CreateDelivery', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO  

------------------------------------------------------------------------------TESTING MANAGER----------------------------------------------------------------
EXECUTE AS USER = 'Manager';  
SELECT * FROM fn_my_permissions('dbo.Product', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO  

EXECUTE AS USER = 'Manager';  
SELECT * FROM fn_my_permissions('dbo.sp_EditPromo', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO

-- Should appear empty because this permission isnt granted
EXECUTE AS USER = 'Manager';  
SELECT * FROM fn_my_permissions('dbo.sp_AlterQuantity', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO  
