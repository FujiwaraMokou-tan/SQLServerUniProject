-----------------------Password Hashing----------------------------------
use PROJETO
go
CREATE or alter function fnCodifica--Password
(
@pass varchar(50)
)
RETURNS varbinary(8000)
AS
BEGIN

    RETURN HASHBYTES('SHA1', @pass) 

END

-----------------------Adding a new User with Random Generated Salt----------------------------------
go
create or alter procedure sp_NewUser (@emailAdress nvarchar(50))
as
begin
declare @time  as datetime
declare @email as nvarchar(50)
EXEC sp_MSForEachTable "ALTER TABLE ? NOCHECK CONSTRAINT all"

if @emailAdress is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (2, GETDATE ())
return 1
end

select @email = U_emailAdress from USERS where U_emailAdress = @emailAdress

if @email = @emailAdress
begin
Select ER_Message From ERROR Where ER_ErrorID = 5
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (5,  GETDATE ())
return 1
end

declare @PasswordSalt as nvarchar(10)
SELECT @PasswordSalt = CONVERT(varchar(255), NEWID())
declare @Password as nvarchar(15)
SELECT @Password = CONVERT(varchar(255), NEWID())
----------------------------------------------------------------------------------------------

declare @passwordHash as nvarchar(max)

SELECT @passwordHash = PROJETO.dbo.fnCodifica(@password+ @PasswordSalt)

declare @EmailHash as nvarchar(max)
SELECT @EmailHash = PROJETO.dbo.fnCodifica(@emailAdress)

-----------------------------------------------------------------------------------------------

insert into PROJETO.dbo.sentEmails(
    senE_EmailsAdress,
    senE_Password
)values (@emailAdress, @Password + @PasswordSalt)

insert into PROJETO.dbo.USERS(U_emailAdress, U_PasswordSalt, U_passwordHash, U_loggedOn)
Values(@EmailHash, @PasswordSalt, @passwordHash, 0)

exec sp_MSForEachTable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
end

exec sp_NewUser 'MokouisLove@gmail.com'
exec sp_NewUser 'KaguyaSucks@gmail.com'
exec sp_NewUser 'GetCaved@gmail.com'

/*select *
from USERS

SELECT *
FROM sentEmails

select *
from ERRORLOG*/
--------------------------------- Login----------------------------------

go
create or alter procedure sp_LoginUser(@email nvarchar(50), @passwordwithSalt nvarchar(50))
as
begin
if @email is null or @passwordwithSalt is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (2, GETDATE ())
return 1
end
/*
declare @verifyEmail as nvarchar(50)
select @verifyEmail =  U_emailAdress from USERS where U_emailAdress = @email

if @verifyEmail <> @email
begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (1, GETDATE ())
return 1
end*/
-------------------------------------------------------------------------------

declare @hashedEmail as nvarchar(max)
declare @currentEmail as nvarchar(max)
Select @hashedEmail = PROJETO.dbo.fnCodifica(@email)
Select @currentEmail = U_emailAdress from USERS where @hashedEmail = U_emailAdress

-------------------------------------------------------------------------------
declare @pass as nvarchar(max)
declare @currentPass as nvarchar(max)

Select @pass = PROJETO.dbo.fnCodifica(@passwordwithSalt)
Select @currentPass = U_passwordHash from USERS where @hashedEmail = U_emailAdress

if @pass = @currentPass
begin
UPDATE USERS
SET U_loggedOn = 1
Where U_emailAdress = @hashedEmail

select *
from PROJETO.dbo.USERS
where U_emailAdress = @hashedEmail
end
Else

begin
Select ER_Message From ERROR Where ER_ErrorID = 6
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (6, GETDATE ())
return 1
end
end

exec sp_LoginUser 'MokouisLove@gmail.com', '58EC4B32-D8B7-49D93C31A-A'

--------------------------------- Logout----------------------------------
go
create or alter procedure sp_LogoutUser(@userID int)
as
begin
if @userID is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (2, GETDATE ())
return 1
end

declare @verifyUser as int
select @verifyUser =  U_userID from USERS where U_userID = @userID

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @userID = @verifyUser and @verifylog = 1
begin
UPDATE USERS
SET U_loggedOn = 0
Where U_userID = @userID
end
Else

begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end
end

exec sp_LogoutUser 1
---------------------------------Security Questions in order to receive new Pass----------------------------------
go
create or alter procedure sp_getSecurityQuestion(@questionNum int, @answer nvarchar(20), @userID int)
as
begin
if @questionNum is null or @answer is null or @userID is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (2, GETDATE ())
return 1
end

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

declare @verifyUser as int
select @verifyUser = U_userID from USERS where U_userID = @userID
declare @verifyQuestion as int
select @verifyQuestion = AccRS_accountRecoveryKey From AccountRecoverySystem where AccRS_accountRecoveryKey = @questionNum

if @verifyUser <> @userID or @verifyQuestion <> @questionNum
begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (1, GETDATE ())
return 1
end


EXEC sp_MSForEachTable "ALTER TABLE ? NOCHECK CONSTRAINT all"
insert into PROJETO.dbo.AccountRecoverySystem(
	AccRS_question,
	AccRS_answer,
	AccRS_UserID
)
values(@questionNum, @answer, @userID)
exec sp_MSForEachTable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
end

exec sp_getSecurityQuestion 2, 'Hello', 1
exec sp_getSecurityQuestion 3, 'bye', 1
exec sp_getSecurityQuestion 4, 'Hey', 1

---------------------------------Password Reset----------------------------------

go
create or alter procedure sp_resetPass(@userID int)
as
begin
if @userID is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (2, GETDATE ())
return 1
end

declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

declare @verifyUser as int
select @verifyUser = 0
select @verifyUser = U_userID from USERS where U_userID = @userID

if @verifyUser <> @userID
begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (1, GETDATE ())
return 1
end


Declare @NumberOfQuestions as int
Select @NumberOfQuestions = count(@userID) From AccountRecoverySystem where AccRS_answer is not null and AccRS_question is not Null
if @NumberOfQuestions > 2
Begin
declare @Email as nvarchar(50)
select @Email = U_emailAdress from USERS where U_userID = @userID
declare @PasswordSalt as nvarchar(10)
SELECT @PasswordSalt = CONVERT(varchar(255), NEWID())
declare @Password as nvarchar(15)
SELECT @Password = CONVERT(varchar(255), NEWID())
declare @passwordHash as nvarchar(max)
SELECT @passwordHash = PROJETO.dbo.fnCodifica(@password + @PasswordSalt)
Update USERS
set U_PasswordSalt = @PasswordSalt, U_passwordHash = @passwordHash
Where U_userID = @userID

Update sentEmails
set senE_Password = @Password + @PasswordSalt
where senE_EmailsAdress = @Email
end

Else
Begin
Select ER_Message From ERROR Where ER_ErrorID = 7
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (7, @userID, GETDATE ())
return 1
End
end

exec sp_resetPass 1

/*select *
from USERS

select *
from sentEmails*/

---------------------------------Delete User----------------------------------

go
create or alter procedure sp_DeleteUser(@userID int)
as

if @userID is null
Begin
Select ER_Message From ERROR Where ER_ErrorID = 2
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (2, GETDATE ())
return 1
end


declare @verifylog as bit
select @verifylog = 0
select @verifylog =  U_loggedOn from USERS where U_userID = @userID

if @verifylog = 0
begin
Select ER_Message From ERROR Where ER_ErrorID = 13
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
return 1
end

Declare @NumberOfQuestions as int
Select @NumberOfQuestions = count(@userID) From AccountRecoverySystem where AccRS_answer is not null and AccRS_question is not Null
declare @verifyUser as int
select @verifyUser = 0
select @verifyUser = U_userID from USERS where U_userID = @userID

if @verifyUser <> @userID
begin
Select ER_Message From ERROR Where ER_ErrorID = 1
insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (1, GETDATE ())
return 1
end


if (@NumberOfQuestions > 2)
begin
EXEC sp_MSForEachTable "ALTER TABLE ? NOCHECK CONSTRAINT all"
DELETE FROM AccountRecoverySystem Where AccRS_UserID = @userID
DELETE FROM USERS Where @userID = U_userID
exec sp_MSForEachTable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
END
Else
Begin
Select ER_Message From ERROR Where ER_ErrorID = 7
insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (7, @userID, GETDATE ())
return 1
End

exec sp_DeleteUser 1

---------------------------------EDIT User (email)----------------------------------

	go
	create or alter procedure sp_EditUser(@userID int, @OLDemail nvarchar(50), @NEWemail nvarchar(50))
	as
	begin
	if @userID is null or @OLDemail is null or @NEWemail is null
	Begin
	Select ER_Message From ERROR Where ER_ErrorID = 2
	insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (2, GETDATE ())
	return 1
	end

	declare @verifylog as bit
	select @verifylog = 0
	select @verifylog =  U_loggedOn from USERS where U_userID = @userID

	if @verifylog = 0
	begin
	Select ER_Message From ERROR Where ER_ErrorID = 13
	insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (13, GETDATE ())
	return 1
	end

	declare @verifyUser as int
	select @verifyUser = U_userID from USERS where U_userID = @userID
	if @verifyUser <> @userID
	begin
	Select ER_Message From ERROR Where ER_ErrorID = 1
	insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (1, GETDATE ())
	return 1
	end

	declare @EmailHash as nvarchar(max)
	SELECT @EmailHash = PROJETO.dbo.fnCodifica(@OLDemail)

	declare @verifyEmail as nvarchar(50)
	select @verifyEmail = U_emailAdress from USERS where U_userID = @userID

	if @verifyEmail <> @EmailHash
	begin
	Select ER_Message From ERROR Where ER_ErrorID = 1
	insert into ERRORLOG(ERL_ErrorID, ERL_TimeStamp) VALUES (1, GETDATE ())
	return 1
	end

	declare @newEmailHash as nvarchar(max)
	SELECT @newEmailHash = PROJETO.dbo.fnCodifica(@NEWemail)

	Update USERS
	set U_emailAdress = @newEmailHash
	WHERE U_userID = @userID
	end

exec sp_EditUser 1, 'MokouisLove@gmail.com', 'MokouisTrueLove@gmail.com'

/*select *
from USERS*/