BEGIN TRAN AAA;

/******************** BEGIN - Parameter Setup ********************/
DECLARE @SITServiceID NVARCHAR(MAX) = 'NT AUTHORITY\NETWORK SERVICE';
DECLARE @UATServiceID NVARCHAR(MAX) = 'NT AUTHORITY\NETWORK SERVICE';
DECLARE @VITServiceID NVARCHAR(MAX) = 'NT AUTHORITY\NETWORK SERVICE';
DECLARE @PRODServiceID NVARCHAR(MAX) = 'NT AUTHORITY\NETWORK SERVICE';
DECLARE @DRServiceID NVARCHAR(MAX) = 'NT AUTHORITY\NETWORK SERVICE';
/******************** END - Parameter Setup ********************/

/******************** BEGIN - Set Service ID Name ********************/
DECLARE @CurrentUserName NVARCHAR(MAX);
IF @@SERVERNAME = 'DWCRSADOS0A' -- SIT Server
	BEGIN
		SET @CurrentUserName = @SITServiceID;
	END
ELSE IF @@SERVERNAME = 'UWCRSDBOS0A' -- UAT Server
	BEGIN
		SET @CurrentUserName = @UATServiceID;
	END
ELSE IF @@SERVERNAME = 'PWCRSDBOS01' -- PROD Server
	BEGIN
		SET @CurrentUserName = @PRODServiceID;
	END
ELSE IF @@SERVERNAME = 'CWCRSDBOS01' -- DR Server
	BEGIN
		SET @CurrentUserName = @DRServiceID;
	END
ELSE -- VIT Server
	BEGIN
		SET @CurrentUserName = @VITServiceID;
	END
/******************** END - Set Service ID Name ********************/

/******************** BEGIN - REMOVE DB_OWNER ********************/
DECLARE @SITServiceIDFound INT;
DECLARE @UATServiceIDFound INT;
DECLARE @VITServiceIDFound INT;
DECLARE @PRODServiceIDFound INT;
DECLARE @DRServiceIDFound INT;

SELECT 
	@SITServiceIDFound = COUNT(*)
	--, db_name() as [database_name] 
	--, r.[name] as [role]
	--, p.[name] as [member] 
FROM sys.database_role_members m 
	JOIN sys.database_principals r on m.role_principal_id = r.principal_id 
	JOIN sys.database_principals p on m.member_principal_id = p.principal_id 
WHERE r.name = 'db_owner'
AND p.name = @SITServiceID;

SELECT 
	@UATServiceIDFound = COUNT(*)
	--, db_name() as [database_name] 
	--, r.[name] as [role]
	--, p.[name] as [member] 
FROM sys.database_role_members m 
	JOIN sys.database_principals r on m.role_principal_id = r.principal_id 
	JOIN sys.database_principals p on m.member_principal_id = p.principal_id 
WHERE r.name = 'db_owner'
AND p.name = @UATServiceID;

SELECT 
	@VITServiceIDFound = COUNT(*)
	--, db_name() as [database_name] 
	--, r.[name] as [role]
	--, p.[name] as [member] 
FROM sys.database_role_members m 
	JOIN sys.database_principals r on m.role_principal_id = r.principal_id 
	JOIN sys.database_principals p on m.member_principal_id = p.principal_id 
WHERE r.name = 'db_owner'
AND p.name = @VITServiceID;

SELECT 
	@PRODServiceIDFound = COUNT(*)
	--, db_name() as [database_name] 
	--, r.[name] as [role]
	--, p.[name] as [member] 
FROM sys.database_role_members m 
	JOIN sys.database_principals r on m.role_principal_id = r.principal_id 
	JOIN sys.database_principals p on m.member_principal_id = p.principal_id 
WHERE r.name = 'db_owner'
AND p.name = @PRODServiceID;

SELECT 
	@DRServiceIDFound = COUNT(*)
	--, db_name() as [database_name] 
	--, r.[name] as [role]
	--, p.[name] as [member] 
FROM sys.database_role_members m 
	JOIN sys.database_principals r on m.role_principal_id = r.principal_id 
	JOIN sys.database_principals p on m.member_principal_id = p.principal_id 
WHERE r.name = 'db_owner'
AND p.name = @DRServiceID;

IF @SITServiceIDFound > 0
	BEGIN 
		DECLARE @SQLSIT NVARCHAR(MAX);
		SET @SQLSIT = 'ALTER ROLE [db_owner] DROP MEMBER ['+@SITServiceID+']';
		EXEC(@SQLSIT);
	END

IF @UATServiceIDFound > 0
	BEGIN 
		DECLARE @SQLUAT NVARCHAR(MAX);
		SET @SQLUAT = 'ALTER ROLE [db_owner] DROP MEMBER ['+@UATServiceID+']';
		EXEC(@SQLUAT);
	END

IF @VITServiceIDFound > 0
	BEGIN 
		DECLARE @SQLVIT NVARCHAR(MAX);
		SET @SQLVIT = 'ALTER ROLE [db_owner] DROP MEMBER ['+@VITServiceID+']';
		EXEC(@SQLVIT);
	END

IF @PRODServiceIDFound > 0
	BEGIN 
		DECLARE @SQLPROD NVARCHAR(MAX);
		SET @SQLPROD = 'ALTER ROLE [db_owner] DROP MEMBER ['+@PRODServiceID+']';
		EXEC(@SQLPROD);
	END

IF @DRServiceIDFound > 0
	BEGIN 
		DECLARE @SQLDR NVARCHAR(MAX);
		SET @SQLDR = 'ALTER ROLE [db_owner] DROP MEMBER ['+@DRServiceID+']';
		EXEC(@SQLDR);
	END
/******************** END - REMOVE DB_OWNER ********************/

DECLARE @name NVARCHAR(MAX);
DECLARE @SQL NVARCHAR(MAX);

DECLARE db_cursor SCROLL CURSOR FOR  
	SELECT s.name
	FROM sys.schemas s
	INNER JOIN sys.database_principals p ON s.principal_id = p.principal_id
	WHERE p.type <> 'R' AND p.authentication_type <> 0
	ORDER BY s.name;

OPEN db_cursor;
FETCH FIRST FROM db_cursor INTO @name;
WHILE @@FETCH_STATUS = 0
	BEGIN   

		SET @SQL = 'GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, EXECUTE ON SCHEMA::' + @name + ' TO [' + @CurrentUserName + ']'
		
		BEGIN TRY
			--PRINT @SQL;
			EXEC(@SQL);
			--PRINT 'Success';
		END TRY
		BEGIN CATCH
			SELECT 
				ERROR_NUMBER() AS ErrorNumber
				,ERROR_SEVERITY() AS ErrorSeverity
				,ERROR_STATE() AS ErrorState
				,ERROR_PROCEDURE() AS ErrorProcedure
				,ERROR_LINE() AS ErrorLine
				,ERROR_MESSAGE() AS ErrorMessage;

			IF @@TRANCOUNT > 0
				PRINT 'Fail';
				ROLLBACK TRAN AAA;
				RETURN;
		END CATCH;

		FETCH NEXT FROM db_cursor INTO @name;
	END   

CLOSE db_cursor;
DEALLOCATE db_cursor;

COMMIT TRAN AAA;