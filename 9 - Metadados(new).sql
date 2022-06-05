USE PROJETO

GO
create or alter procedure sp_InsertProcedure2 (@SchemaName nvarchar(40), @TableName nvarchar(40))
AS
BEGIN
	Declare @sql nvarchar(max);
	Set @sql= N'Create ' + @SchemaName +'.Proc sp_[t]_Insert
	 '

	Declare @columnName nvarchar(100);
	Declare @DateType nvarchar(25);
	Declare @VarMaxLen int;
	Declare @isIdentity bit;

	Declare @user nvarchar(50);
	

	Declare @pkColumnName nvarchar(100);
	
	Declare cursorTable scroll Cursor for (Select COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
	from INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME = @TableName AND TABLE_SCHEMA = @SchemaName);

	Open cursorTable;
	Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;


	while @@FETCH_STATUS=0
	BEGIN

		if(@columnName not in (Select COLUMN_NAME
								from INFORMATION_SCHEMA.COLUMNS
								where COLUMNPROPERTY(object_id(@SchemaName+'.'+@TableName), COLUMN_NAME, 'IsIdentity') = 1
								group by COLUMN_NAME))
		BEGIN
			Set @sql = @sql +
			' @'+ @columnName+ ' '+@DateType
			if(@VarMaxLen is not null)
				Set @sql = @sql+'('+Convert(nvarchar(5),@VarMaxLen)+')'
			Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;
			if(@@FETCH_STATUS=0)
				Set @sql = @sql +', 
				'
		END;
		else
			Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;
	END;

	Set @sql = @sql+' AS BEGIN 
	'
	Fetch first from cursorTable into @columnName, @DateType, @VarMaxLen;
	Set @sql = @sql+' Declare @ErrorMsg nvarchar(100); Declare @tableName nvarchar(50);
	Declare @userError nvarchar(50);
	';

	while @@FETCH_STATUS=0
	BEGIN
		
		if(@columnName not in (Select COLUMN_NAME
					  from INFORMATION_SCHEMA.COLUMNS
					  where COLUMNPROPERTY(object_id(@SchemaName+'.'+@TableName), COLUMN_NAME, 'IsIdentity') = 1
					  group by COLUMN_NAME))
		BEGIN

			if(@columnName in (Select COLUMN_NAME
						   from INFORMATION_SCHEMA.COLUMNS
						   where TABLE_NAME = @TableName AND IS_NULLABLE ='NO'))
			BEGIN --Set @userError = USER_NAME(); 
			Set @sql=@sql+'if(@'+@columnName+' is null) BEGIN
			'+' SET @ErrorMsg = '''+@columnName+ ' cannot be NULL'''+ ' Set @userError = 0; 
			Select ER_Message From ERROR Where ER_ErrorID = 2
			insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, 0, GETDATE ())
			END
			ELSE
			'
			END;

		END;
		Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;
	END;

	Fetch first from cursorTable into  @columnName, @DateType, @VarMaxLen;
	Set @sql = @sql +' Insert into [t] ('
	while @@FETCH_STATUS=0
	BEGIN

		if(@columnName not in (Select COLUMN_NAME
					  from INFORMATION_SCHEMA.COLUMNS
					  where COLUMNPROPERTY(object_id(@SchemaName+'.'+@TableName), COLUMN_NAME, 'IsIdentity') = 1
					  group by COLUMN_NAME))
	BEGIN
	Set @sql = @sql+@columnName

	Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;
	if (@@FETCH_STATUS!=0)
		Set @sql = @sql+') '
	else
		Set @sql = @sql +', '
	END;
	else
		Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;

	END;

	Set @sql = @sql +'Values (
	'

	Fetch first from cursorTable into @columnName, @DateType, @VarMaxLen;

	while @@FETCH_STATUS=0
	Begin

	if(@columnName not in (Select COLUMN_NAME
					  from INFORMATION_SCHEMA.COLUMNS
					  where COLUMNPROPERTY(object_id(@SchemaName+'.'+@TableName), COLUMN_NAME, 'IsIdentity') = 1
					  group by COLUMN_NAME))
	BEGIN
		Set @sql = @sql+'@'+@columnName
		Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;
		if (@@FETCH_STATUS!=0)
			Set @sql = @sql+') '
		else
			Set @sql = @sql +', '
	END;
	else
		Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;
	end;

	Close cursorTable;
	Deallocate cursorTable;

	Set @sql = @sql+ '
	END;
	'
	Set @sql = REPLACE(@sql, '[t]', @TableName);
	print @sql

END;


exec sp_InsertProcedure2 'dbo', 'Product'


------------------------------------------------------------------------------------------------------

go
create or alter procedure sp_createDeleteProcedure2 (@SchemaName nvarchar(40), @TableName nvarchar(40))
AS

BEGIN

	Declare @sql nvarchar(max);
	Set @sql = 'IF EXISTS ( SELECT  *
				FROM    sys.objects
				WHERE   object_id = OBJECT_ID(N''sp_[t]_Delete'') AND type IN ( N''P'', N''PC'' ) )
				BEGIN
				DROP PROC p_[t]_Delete;
				END; '
	Set @sql = REPLACE(@sql, '[t]', @TableName)
	print @sql;
	Exec sp_executesql @sql;


	-- Inicio
	Set @sql= N'Create Proc' + @SchemaName+'.p_[t]_Delete
	'
	Declare @columnName nvarchar(100);
	Declare @datatype nvarchar(10);
	-- Seleciona a coluna primaria da tabela
	Set @columnName = (Select kc.COLUMN_NAME from INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
											join INFORMATION_SCHEMA.KEY_COLUMN_USAGE kc
											on tc.CONSTRAINT_NAME = kc.CONSTRAINT_NAME
											where tc.TABLE_SCHEMA = @SchemaName AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
											AND kc.TABLE_NAME = @TableName);
	-- Seleciona o datatype da coluna primaria 
	Set @datatype = (Select c.DATA_TYPE from INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
											join INFORMATION_SCHEMA.KEY_COLUMN_USAGE kc
											on tc.CONSTRAINT_NAME = kc.CONSTRAINT_NAME
											join INFORMATION_SCHEMA.COLUMNS c
											on c.TABLE_NAME = kc.TABLE_NAME
											where tc.TABLE_SCHEMA = @SchemaName AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
											AND kc.TABLE_NAME = @TableName
											AND c.COLUMN_NAME = @columnName);
	if(@columnName is null)
	BEGIN

		Declare @errorMsg nvarchar(100);
		Declare @userError nvarchar(50) = USER_NAME();
		Set @sql=@sql+'if(@'+@columnName+' is null) BEGIN
			'+' SET @ErrorMsg = '''+@columnName+ ' cannot be NULL'''+ ' Set @userError = 0; 
			Select ER_Message From ERROR Where ER_ErrorID = 2
			insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, 0, GETDATE ())
			END
			ELSE
			'
	END
	ELSE
	BEGIN
		Set @sql = @sql +' @'+@columnName+' '+ @datatype+' AS BEGIN
		'
		Set @sql = @sql + 'Delete from [t]
		where '+@columnName+' = @'+@columnName +';
		';

	END;

	Set @sql = @sql+' END'
	Set @sql = REPLACE(@sql, '[t]', @TableName)
	print @sql;

END;

exec sp_createDeleteProcedure2 'dbo', 'Product'


-------------------------------------------------------------------------------------------------
GO

create or alter procedure sp_createUpdateProcedure2 (@SchemaName nvarchar(40), @tableName nvarchar(40))
AS
BEGIN
	Declare @sql nvarchar(max);
	Set @sql= N'Create Proc sp_[t]_Update
	 '

	Declare @columnName nvarchar(100);
	Declare @DateType nvarchar(25);
	Declare @VarMaxLen int;
	Declare @isIdentity bit;

	Declare @pkColumnName nvarchar(100);

	Declare cursorTable scroll Cursor for (Select COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
	from INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME = @TableName);

	Open cursorTable;
	Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;

	while @@FETCH_STATUS=0
	BEGIN

		if(@columnName not in (Select COLUMN_NAME
								from INFORMATION_SCHEMA.COLUMNS
								where COLUMNPROPERTY(object_id(@SchemaName+'.'+@TableName), COLUMN_NAME, 'IsIdentity') = 1
								group by COLUMN_NAME))
		BEGIN
			Set @sql = @sql +
			' @'+ @columnName+ ' '+@DateType
			if(@VarMaxLen is not null)
				Set @sql = @sql+'('+Convert(nvarchar(5),@VarMaxLen)+')'
			Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;
			if(@@FETCH_STATUS=0)
				Set @sql = @sql +', 
				'
		END;
		else
			Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;
	END;

	Set @sql = @sql+' AS BEGIN 
	'
	Fetch first from cursorTable into @columnName, @DateType, @VarMaxLen;
	Set @sql = @sql+'Declare @ErrorMsg nvarchar(100); Declare @tableName nvarchar(50); 
	';

	while @@FETCH_STATUS=0
	BEGIN
		
		if(@columnName not in (Select COLUMN_NAME
					  from INFORMATION_SCHEMA.COLUMNS
					  where COLUMNPROPERTY(object_id(@SchemaName+'.'+@TableName), COLUMN_NAME, 'IsIdentity') = 1
					  group by COLUMN_NAME))
		BEGIN

			if(@columnName in (Select COLUMN_NAME
						   from INFORMATION_SCHEMA.COLUMNS
						   where TABLE_NAME = @TableName AND IS_NULLABLE ='NO'))
			BEGIN
			Set @sql=@sql+'if(@'+@columnName+' is null) BEGIN
			'+' SET @ErrorMsg = '''+@columnName+ ' cannot be NULL'''
			+' Select ER_Message From ERROR Where ER_ErrorID = 2
			insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (2, 0, GETDATE ())
			END; 
			'
			END;

			if(@ColumnName in (SELECT kcu.COLUMN_NAME
								FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
								JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu
								ON tc.TABLE_NAME = kcu.TABLE_NAME
								AND tc.CONSTRAINT_CATALOG = kcu.CONSTRAINT_CATALOG
								AND tc.CONSTRAINT_SCHEMA = kcu.CONSTRAINT_SCHEMA
								AND tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
								WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
								AND kcu.TABLE_NAME = @TableName))
			BEGIN
				set @sql= @sql + ' if(@'+@columnName+' in (Select '+@columnName+' from '+@TableName+'))
				BEGIN
				'
				set @sql= @sql + ' Set @ErrorMsg = '''+@columnName+ ' already exists'''+'
				 Select ER_Message From ERROR Where ER_ErrorID = 5
				insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (5, 0, GETDATE ())
				END
				'
			END;

			if(@ColumnName in (SELECT kcu.COLUMN_NAME
								FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
								JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu
								ON tc.TABLE_NAME = kcu.TABLE_NAME
								AND tc.CONSTRAINT_CATALOG = kcu.CONSTRAINT_CATALOG
								AND tc.CONSTRAINT_SCHEMA = kcu.CONSTRAINT_SCHEMA
								AND tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
								WHERE tc.CONSTRAINT_TYPE = 'FOREIGN KEY'
								AND kcu.TABLE_NAME = @TableName))
			BEGIN
			
			Set @pkColumnName=(
			Select ccu.COLUMN_NAME
			from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
			join INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu
			on  rc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
			join INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
			on tc.CONSTRAINT_NAME = rc.UNIQUE_CONSTRAINT_NAME
			join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu
			on ccu.CONSTRAINT_NAME = rc.UNIQUE_CONSTRAINT_NAME
			where kcu.TABLE_NAME = @tableName 
			And kcu.COLUMN_NAME = @columnName)

			Set @sql = @sql +' if(@'+@columnName+' not in(Select '+@pkColumnName+' from 
			';
			Set @sql = @sql +(Select  tc.TABLE_NAME
								from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
								join INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu
								on  rc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
								join INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
								on tc.CONSTRAINT_NAME = rc.UNIQUE_CONSTRAINT_NAME
								join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu
								on ccu.CONSTRAINT_NAME = rc.UNIQUE_CONSTRAINT_NAME
								where kcu.TABLE_NAME = @tableName 
								And kcu.COLUMN_NAME = @columnName);
			Set @sql = @sql +')) BEGIN
			';
			Set @sql = @sql +' Set @ErrorMsg = '''+@columnName+ ' foreign key does not exists'''+';
			Select ER_Message From ERROR Where ER_ErrorID = 14
			insert into ERRORLOG(ERL_ErrorID, ERL_UserID, ERL_TimeStamp) VALUES (14, 0, GETDATE ())
			END
			';
			END;

		END;
		Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;
	END;

	Fetch first from cursorTable into  @columnName, @DateType, @VarMaxLen;
	Set @sql = @sql +' Update [t] '
	Set @sql = @sql +' Set '
	while @@FETCH_STATUS=0
	BEGIN

		if(@columnName not in (Select COLUMN_NAME
					  from INFORMATION_SCHEMA.COLUMNS
					  where COLUMNPROPERTY(object_id(@SchemaName+'.'+@TableName), COLUMN_NAME, 'IsIdentity') = 1
					  group by COLUMN_NAME))
	BEGIN
	Set @sql = @sql+@columnName

	Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;
	if (@@FETCH_STATUS!=0)
		Set @sql = @sql+') '
	else
		Set @sql = @sql +', '
	END;
	else
		Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;

	END;

	Set @sql = @sql +'Values (
	'

	Fetch first from cursorTable into @columnName, @DateType, @VarMaxLen;

	while @@FETCH_STATUS=0
	Begin

	if(@columnName not in (Select COLUMN_NAME
					  from INFORMATION_SCHEMA.COLUMNS
					  where COLUMNPROPERTY(object_id(@SchemaName+'.'+@TableName), COLUMN_NAME, 'IsIdentity') = 1
					  group by COLUMN_NAME))
	BEGIN
		Set @sql = @sql+'@'+@columnName
		Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;
		if (@@FETCH_STATUS!=0)
			Set @sql = @sql+') '
		else
			Set @sql = @sql +', '
	END;
	else
		Fetch next from cursorTable into @columnName, @DateType, @VarMaxLen;
	end;

	Close cursorTable;
	Deallocate cursorTable;

	Set @sql = @sql+ '
	END;
	'
	Set @sql = REPLACE(@sql, '[t]', @TableName);
	print @sql

END;

exec sp_createUpdateProcedure 'dbo', 'Company'







--Exec sp_executesql @sql;