SELECT MFS.CustomerID AS [DBS CustomerID]
	, CL.ClientID AS [Credit Predix CustomerID]
	, CL.CIF
	, MFS.StatementID AS [DBS StatementID]
	, FS.FinancialSpreadsheetID AS [Credit Predix StatementID]
	, TM.DBSID
	, FSC.Name AS [CategoryName]
	, FSV.DisplayName
	, FSV.ShortName
	, CR.CurrencyName
	, FSD.Value
FROM [FINAnalytiks].[FinancialSpreadsheetData] AS FSD
INNER JOIN [FINAnalytiksEngine].[FinancialSpreadsheetItem] AS FSI
ON FSD.fkFinancialSpreadsheetItemID = FSI.FinancialSpreadsheetItemID
INNER JOIN [FINAnalytiksEngine].[FinancialSpreadsheetVariable] AS FSV
ON FSI.fkFinancialSpreadsheetVariableID = FSV.FinancialSpreadsheetVariableID
INNER JOIN [FINAnalytiksEngine].[FinancialSpreadsheetVariableCategory] AS FSC
ON FSI.fkFinancialSpreadsheetVariableCategoryID = FSC.FinancialSpreadsheetCategoryID
INNER JOIN [FINAnalytiks].[FinancialSpreadsheet] AS FS
ON FSD.fkFinancialSpreadsheetID = FS.FinancialSpreadsheetID
INNER JOIN [Base].[Currency] AS CR
ON FS.fkCurrencyID = CR.CurrencyID
INNER JOIN [dbo].[DBS_Migrated_FinancialSpreadsheets] AS MFS
ON FS.FinancialSpreadsheetID = MFS.FinancialSpreadsheetID
INNER JOIN [Client].[Client] AS CL
ON FS.fkClientID = CL.ClientID
LEFT JOIN [dbo].[DBS_TemplateMapping] AS TM
ON FSV.ShortName = TM.WCRSFinancialVariableShortName