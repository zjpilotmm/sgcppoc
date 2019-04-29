/*
This script will loop through all the audit trail triggers
that are still disabled.

For each trigger it will then enable it
*/


--Begin transaction
BEGIN TRAN AAA

--While there are triggers disabled
WHILE EXISTS
(
	SELECT AT.*
	FROM
	(--Get the list of tables that have audit triggers (could be disabled or enabled)
		Select ATC.SchemaName,ATC.TableName
		FROM Audit.AuditTableColumn ATC
		GROUP BY ATC.SchemaName,ATC.TableName
	) AT
	INNER JOIN--join to objects that have triggers
	(--get list of schema names, trigger names, table names that have trigger disabled
		Select
			S.name AS SchemaName
			,O.name AS TriggerName
			,ParentO.name AS TableName
		FROM sys.objects O
		INNER JOIN sys.schemas S ON s.schema_id = O.schema_id
		INNER JOIN sys.objects parentO ON parentO.object_id = O.parent_object_id
		INNER JOIN sys.triggers T ON T.object_id = O.object_id
		WHERE O.[type] = 'TR' --get only trigger types
		AND T.is_disabled = 1 --get only disabled triggers
	) ObjectInfo 
		ON ObjectInfo.SchemaName = AT.schemaName
		AND ObjectInfo.TableName = AT.TableName
)
--BEGIN LOOP
BEGIN

	DECLARE @SQLQuery nvarchar(max)
	DECLARE @TriggerName nvarchar(max)
	DECLARE @TableName nvarchar(max)
	
	--Get the trigger name
	SET @TriggerName =
		(
			SELECT TOP(1)
				ObjectInfo.TriggerName
			FROM
			(
				Select ATC.SchemaName,ATC.TableName
				FROM Audit.AuditTableColumn ATC
				GROUP BY ATC.SchemaName,ATC.TableName
			) AT
			INNER JOIN
			(	
				Select
					S.name AS SchemaName
					,O.name AS TriggerName
					,ParentO.name AS TableName
				FROM sys.objects O
				INNER JOIN sys.schemas S ON s.schema_id = O.schema_id
				INNER JOIN sys.objects parentO ON parentO.object_id = O.parent_object_id
				INNER JOIN sys.triggers T ON T.object_id = O.object_id
				WHERE O.[type] = 'TR' --get only trigger types
				AND T.is_disabled = 1 --get only disabled triggers
	
			) ObjectInfo 
				ON ObjectInfo.SchemaName = AT.schemaName
				AND ObjectInfo.TableName = AT.TableName
		)

	--Get the table name of the trigger retrieved in @TriggerName
	SET @TableName = 
		(
			SELECT TOP(1)
				CONCAT('[',ObjectInfo.SchemaName,']','.','[',ObjectInfo.TableName,']')
			FROM
			(
				Select ATC.SchemaName,ATC.TableName
				FROM Audit.AuditTableColumn ATC
				GROUP BY ATC.SchemaName,ATC.TableName
			) AT
			INNER JOIN
			(	
				Select
					S.name AS SchemaName
					,O.name AS TriggerName
					,ParentO.name AS TableName
				FROM sys.objects O
				INNER JOIN sys.schemas S ON s.schema_id = O.schema_id
				INNER JOIN sys.objects parentO ON parentO.object_id = O.parent_object_id
				INNER JOIN sys.triggers T ON T.object_id = O.object_id
				WHERE O.[type] = 'TR'
				AND O.name = @TriggerName --get only the table for the trigger that was retrieved
				AND T.is_disabled = 1 --get only disabled triggers
	
			) ObjectInfo 
				ON ObjectInfo.SchemaName = AT.schemaName
				AND ObjectInfo.TableName = AT.TableName
		)


	--SET SQL query to disable
	SET @SQLQuery = 'ENABLE TRIGGER ['+@TriggerName+'] ON '+@TableName


	EXEC (@SQLQuery) --execute SQL code
END
--END LOOP

--commit transaction
COMMIT TRAN AAA
GO

DBCC SHRINKDATABASE (DBS_CreditPredix_VIT_PFME_P2_MAIN_1_2_3_1_20190129_Clean, TRUNCATEONLY);
GO

ALTER DATABASE DBS_CreditPredix_VIT_PFME_P2_MAIN_1_2_3_1_20190129_Clean SET RECOVERY FULL WITH NO_WAIT
GO
