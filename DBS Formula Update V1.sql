BEGIN TRY
	BEGIN TRAN AAA
		DECLARE @TemplateName NVARCHAR(100) = 'DBS CoA' -- Parameter: Template Name
		DECLARE @VersionID INT = (SELECT FinancialTemplateVersionID FROM [FINAnalytiksEngine].[FinancialTemplateVersion] WHERE IsActivated = 1)
		DECLARE @ErrorMsg NVARCHAR(max)

		IF EXISTS (SELECT * FROM [FINAnalytiksEngine].[FinancialTemplateVersion] WHERE [fkFinancialTemplateID] = (SELECT [FinancialTemplateID] FROM [FINAnalytiksEngine].[FinancialTemplate] WHERE [Name] = @TemplateName) AND [FinancialTemplateVersionID] = @VersionID)
		BEGIN
			UPDATE [FINAnalytiksEngine].[FinancialSpreadsheetItem]
			SET [ProjectionFormula] = '<cases><Case><Condition>true</Condition><Formula>YB1.CORP_BS_AMRPST </Formula></Case></cases>'
			WHERE [fkFinancialTemplateVersionID] = @VersionID 
			AND [fkFinancialSpreadsheetVariableID] = (SELECT [FinancialSpreadsheetVariableID] FROM [FINAnalytiksEngine].[FinancialSpreadsheetVariable] WHERE [ShortName] = 'CORP_BS_AMRPST')

			UPDATE [FINAnalytiksEngine].[FinancialSpreadsheetItem]
			SET [HistoricalFormula] = '<cases><Case><Condition>true</Condition><Formula>Y0.CORP_IS_NPAT  - Y0.CORP_IS_IE - Y0.CORP_IS_DEP - Y0.CORP_IS_AMORT - Y0.CORP_IS_COGSD </Formula></Case></cases>'
			,[ProjectionFormula] = '<cases><Case><Condition>true</Condition><Formula>Y0.CORP_IS_NPAT  - Y0.CORP_IS_IE - Y0.CORP_IS_DEP - Y0.CORP_IS_AMORT - Y0.CORP_IS_COGSD </Formula></Case></cases>'
			WHERE [fkFinancialTemplateVersionID] = @VersionID 
			AND [fkFinancialSpreadsheetVariableID] = (SELECT [FinancialSpreadsheetVariableID] FROM [FINAnalytiksEngine].[FinancialSpreadsheetVariable] WHERE [ShortName] = 'CORP_IS_EBIDA')

			UPDATE [FINAnalytiksEngine].[FinancialSpreadsheetItem]
			SET [HistoricalFormula] = '<cases><Case><Condition>true</Condition><Formula>Y0.CORP_IS_NPBT - Y0.CORP_IS_IE - Y0.CORP_IS_DEP - Y0.CORP_IS_AMORT - Y0.CORP_IS_COGSD</Formula></Case></cases>'
			,[ProjectionFormula] = '<cases><Case><Condition>true</Condition><Formula>Y0.CORP_IS_NPBT - Y0.CORP_IS_IE - Y0.CORP_IS_DEP - Y0.CORP_IS_AMORT - Y0.CORP_IS_COGSD</Formula></Case></cases>'
			WHERE [fkFinancialTemplateVersionID] = @VersionID 
			AND [fkFinancialSpreadsheetVariableID] = (SELECT [FinancialSpreadsheetVariableID] FROM [FINAnalytiksEngine].[FinancialSpreadsheetVariable] WHERE [ShortName] = 'CORP_IS_EBITDA')

			UPDATE [FINAnalytiksEngine].[FinancialSpreadsheetItem]
			SET [HistoricalFormula] = '<cases><Case><Condition>true</Condition><Formula>(Y0.CORP_IS_NPBT - Y0.CORP_IS_IE - Y0.CORP_IS_DEP - Y0.CORP_IS_AMORT - Y0.CORP_IS_COGSD) * (12 / Y0.CONST_NumOfMonths ) </Formula></Case></cases>'
			,[ProjectionBaseYearFormula] = '<cases><Case><Condition>true</Condition><Formula>Math.StandardizePeriod ( YB1.CORP_DBS_PC_EBITDA  , YB1.CONST_ProjectionInterval , YB1.CONST_NumOfMonths )  </Formula></Case></cases>'
			,[ProjectionFormula] = '<cases><Case><Condition>true</Condition><Formula>(Y0.CORP_IS_NPBT - Y0.CORP_IS_IE - Y0.CORP_IS_DEP - Y0.CORP_IS_AMORT - Y0.CORP_IS_COGSD) * (12 / Y0.CONST_NumOfMonths ) </Formula></Case></cases>'
			WHERE [fkFinancialTemplateVersionID] = @VersionID 
			AND [fkFinancialSpreadsheetVariableID] = (SELECT [FinancialSpreadsheetVariableID] FROM [FINAnalytiksEngine].[FinancialSpreadsheetVariable] WHERE [ShortName] = 'CORP_DBS_PC_EBITDA')

			UPDATE [FINAnalytiksEngine].[FinancialSpreadsheetItem]
			SET [HistoricalFormula] = '<cases><Case><Condition>true</Condition><Formula>(Y0.CORP_IS_NPBT - Y0.CORP_IS_IE - Y0.CORP_IS_DEP - Y0.CORP_IS_AMORT - Y0.CORP_IS_COGSD) * (12 / Y0.CONST_NumOfMonths ) </Formula></Case></cases>'
			,[ProjectionBaseYearFormula] = '<cases><Case><Condition>true</Condition><Formula>Math.StandardizePeriod ( YB1.CORP_RC_RG_EBITDA  , YB1.CONST_ProjectionInterval , YB1.CONST_NumOfMonths )  </Formula></Case></cases>'
			,[ProjectionFormula] = '<cases><Case><Condition>true</Condition><Formula>(Y0.CORP_IS_NPBT - Y0.CORP_IS_IE - Y0.CORP_IS_DEP - Y0.CORP_IS_AMORT - Y0.CORP_IS_COGSD) * (12 / Y0.CONST_NumOfMonths ) </Formula></Case></cases>'
			WHERE [fkFinancialTemplateVersionID] = @VersionID 
			AND [fkFinancialSpreadsheetVariableID] = (SELECT [FinancialSpreadsheetVariableID] FROM [FINAnalytiksEngine].[FinancialSpreadsheetVariable] WHERE [ShortName] = 'CORP_RC_RG_EBITDA')
		END
		ELSE
		BEGIN
			SET @ErrorMsg = '[ZJ ERROR MSG] There is no activated template version or template does not exist.'
			RAISERROR (@ErrorMsg,16,1)
		END
	COMMIT TRAN AAA
END TRY
BEGIN CATCH
	DECLARE
		   @ErMessage NVARCHAR(MAX),
		   @ErSeverity INT,
		   @ErState INT,
		   @ErLine INT	

	SELECT
		   @ErMessage = ERROR_MESSAGE(),
		   @ErSeverity = ERROR_SEVERITY(),
		   @ErState = ERROR_STATE(),
		   @ErLine = ERROR_LINE()
	
	SET @ErMessage = @ErMessage + ' Line Number: ' + CONVERT(NVARCHAR, @ErLine)
	RAISERROR(@ErMessage
        ,@ErSeverity
        ,@ErState)

	IF @@TRANCOUNT > 0
		ROLLBACK TRAN AAA
END CATCH;