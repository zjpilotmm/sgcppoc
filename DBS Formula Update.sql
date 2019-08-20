BEGIN TRY
	BEGIN TRAN AAA
		DECLARE @TemplateName NVARCHAR(100) = 'DBS CoA' -- Parameter: Template Name
		DECLARE @VersionName NVARCHAR(100) = 'DBS CoA' -- Parameter: Version Name
		DECLARE @financialTemplateVersionID INT
		DECLARE @ErrorMsg NVARCHAR(max)

		IF EXISTS (SELECT * FROM [FINAnalytiksEngine].[FinancialTemplateVersion] WHERE [fkFinancialTemplateID] = (SELECT [FinancialTemplateID] FROM [FINAnalytiksEngine].[FinancialTemplate] WHERE [Name] = @TemplateName) AND [VersionName] = @VersionName)
		BEGIN
			SET @financialTemplateVersionID =  (SELECT [FinancialTemplateVersionID] FROM [FINAnalytiksEngine].[FinancialTemplateVersion] WHERE [fkFinancialTemplateID] = (SELECT [FinancialTemplateID] FROM [FINAnalytiksEngine].[FinancialTemplate] WHERE [Name] = @TemplateName) AND [VersionName] = @VersionName)

		--------------------------------------------------------------------------------------------------------------------------------------------------------------
		--Get before image
		--------------------------------------------------------------------------------------------------------------------------------------------------------------
			SELECT FSV.ShortName,
				FSV.DisplayName,
				FSI.AssumptionFormula AS [Before Update Assumption Formula],
				FSI.ProjectionBaseYearFormula AS [Before Update Base Year Formula],
				FSI.ProjectionFormula AS [Before Update Projection Formula]
			FROM [FINAnalytiksEngine].[FinancialSpreadsheetItem] AS FSI
			INNER JOIN [FINAnalytiksEngine].[FinancialSpreadsheetVariable] AS FSV
			ON FSI.fkFinancialSpreadsheetVariableID = FSV.FinancialSpreadsheetVariableID
			WHERE FSI.fkFinancialTemplateVersionID = @financialTemplateVersionID
			AND FSV.ShortName IN ('CORP_ASUM_DEP_PERFA','CORP_BS_CA','CORP_IS_DEP')
			
	  -----------------------------------------------------------------------------------------------------------------------------------------------------------------
	  --1. UPDATE CORP_ASUM_DEP_PERFA, CORP_BS_CA, CORP_IS_DEP
	  -----------------------------------------------------------------------------------------------------------------------------------------------------------------

			--Update existing variables projection formulas
			UPDATE [FINAnalytiksEngine].[FinancialSpreadsheetItem]
			SET [AssumptionFormula] = '<cases><Case><Condition>Math.HasAnyNullOrZero(YBN.CORP_IS_DEP) || Math.HasAnyNullOrZero(YBN.CORP_IS_SR)</Condition><Formula>Math.Abs(Math.Divide(Math.StandardizePeriod(YB1.CORP_IS_DEP, YB1.CONST_ProjectionInterval, YB1.CONST_NumOfMonths), Math.StandardizePeriod(YB1.CORP_IS_SR, YB1.CONST_ProjectionInterval, YB1.CONST_NumOfMonths)))</Formula></Case><Case><Condition>true</Condition><Formula>Math.Abs(Math.AvgIfNotNull(Math.Divide(Math.StandardizePeriod(YBN.CORP_IS_DEP, Y0.CONST_ProjectionInterval, YBN.CONST_NumOfMonths), Math.StandardizePeriod(YBN.CORP_IS_SR, Y0.CONST_ProjectionInterval, YBN.CONST_NumOfMonths))))</Formula></Case></cases>'
			WHERE [fkFinancialTemplateVersionID] = @financialTemplateVersionID 
			AND [fkFinancialSpreadsheetVariableID] = (SELECT [FinancialSpreadsheetVariableID] FROM [FINAnalytiksEngine].[FinancialSpreadsheetVariable] WHERE [ShortName] = 'CORP_ASUM_DEP_PERFA')

			UPDATE [FINAnalytiksEngine].[FinancialSpreadsheetItem]
			SET [ProjectionBaseYearFormula] = '<cases><Case><Condition>true</Condition><Formula>YB1.CORP_BS_CFD + YB1.CORP_BS_MS + YB1.CORP_BS_NAR + YB1.CORP_BS_NARRP + YB1.CORP_BS_INV + YB1.CORP_BS_PE+ YB1.CORP_BS_OACR + YB1.CORP_BS_AMRPST + YB1.CORP_BS_OCA </Formula></Case></cases>'
			WHERE [fkFinancialTemplateVersionID] = @financialTemplateVersionID 
			AND [fkFinancialSpreadsheetVariableID] = (SELECT [FinancialSpreadsheetVariableID] FROM [FINAnalytiksEngine].[FinancialSpreadsheetVariable] WHERE [ShortName] = 'CORP_BS_CA')

			UPDATE [FINAnalytiksEngine].[FinancialSpreadsheetItem]
			SET [ProjectionFormula] = '<cases><Case><Condition>Y0.CORP_ASUM_DEP_PERSR != null </Condition><Formula>  (1 + Math.Round(Y0.CORP_ASUM_DEP_PERSR, 4)) * (YB1.CORP_IS_DEP )</Formula></Case><Case><Condition>Y0.CORP_ASUM_DEP_PERFA != null </Condition><Formula> (Math.round (-Y0.CORP_ASUM_DEP_PERFA, 4) * Y0.CORP_IS_SR) </Formula></Case></cases>'
			WHERE [fkFinancialTemplateVersionID] = @financialTemplateVersionID 
			AND [fkFinancialSpreadsheetVariableID] = (SELECT [FinancialSpreadsheetVariableID] FROM [FINAnalytiksEngine].[FinancialSpreadsheetVariable] WHERE [ShortName] = 'CORP_IS_DEP')

	  --------------------------------------------------------------------------------------------------------------------------------------------------------------
	  --Get After image
	  --------------------------------------------------------------------------------------------------------------------------------------------------------------		

			SELECT FSV.ShortName,
				FSV.DisplayName,
				FSI.AssumptionFormula AS [After Update Assumption Formula],
				FSI.ProjectionBaseYearFormula AS [After Update Base Year Formula],
				FSI.ProjectionFormula AS [After Update Projection Formula]
			FROM [FINAnalytiksEngine].[FinancialSpreadsheetItem] AS FSI
			INNER JOIN [FINAnalytiksEngine].[FinancialSpreadsheetVariable] AS FSV
			ON FSI.fkFinancialSpreadsheetVariableID = FSV.FinancialSpreadsheetVariableID
			WHERE FSI.fkFinancialTemplateVersionID = @financialTemplateVersionID
			AND FSV.ShortName IN ('CORP_ASUM_DEP_PERFA','CORP_BS_CA','CORP_IS_DEP')
		END
		ELSE
		BEGIN
			SET @ErrorMsg = '[ZJ ERROR MSG] Template Version with the name "' + @VersionName + '" Does Not Exist.'
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