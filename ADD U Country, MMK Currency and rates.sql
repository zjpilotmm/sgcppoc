BEGIN TRY
	BEGIN TRAN AAA

	IF NOT EXISTS (SELECT * FROM [Base].[Country] WHERE [RefCode] = 'U')
	BEGIN
		INSERT INTO [Base].[Country]
           ([RefCode]
           ,[RefCodeExt]
           ,[RefNum]
           ,[CountryName]
           ,[IsOperating]
           ,[fkRegion])
     VALUES
           ('U'
           ,'UUU'
           ,919
           ,'Unknown'
           ,1
           ,6)

		INSERT INTO [Base].[MasterListVersion]
           ([MasterListID]
           ,[IsReplaceRecord]
           ,[IsCommitted]
           ,[DateCommitted]
           ,[CommittedBy]
           ,[DateUncommitted]
           ,[UncommittedBy]
           ,[IsReviewed]
           ,[DateReviewed]
           ,[ReviewedBy]
           ,[IsApproved]
           ,[DateApproved]
           ,[ApprovedBy]
           ,[IsActivated]
           ,[IsPreviousActivated]
           ,[DateActivated]
           ,[ActivatedBy]
           ,[DateDeactivated]
           ,[DeactivatedBy]
           ,[IsFutureActivate]
           ,[DateFutureActivation]
           ,[DateFutureActivationModified]
           ,[FutureActivationModifiedBy]
           ,[DateCreated]
           ,[CreatedBy]
           ,[DateLastModified]
           ,[LastModifiedBy]
           ,[fkMasterListTypeID])
     VALUES
           ((SELECT CountryID FROM [Base].[Country] WHERE [RefCode] = 'U')
           ,0
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL
           ,1
           ,GETDATE()
           ,1
           ,1
           ,GETDATE()
           ,1
           ,1
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL
           ,0
           ,NULL
           ,NULL
           ,NULL
           ,GETDATE()
           ,1
           ,GETDATE()
           ,1
           ,4)
	END

	IF NOT EXISTS(SELECT * FROM [Base].[Currency] WHERE [RefCode] = 'MMK')
	BEGIN
		INSERT INTO [Base].[Currency]
           ([RefCode]
           ,[CurrencyName])
     VALUES
           ('MMK'
           ,'Unknown')


				INSERT INTO [Base].[MasterListVersion]
           ([MasterListID]
           ,[IsReplaceRecord]
           ,[IsCommitted]
           ,[DateCommitted]
           ,[CommittedBy]
           ,[DateUncommitted]
           ,[UncommittedBy]
           ,[IsReviewed]
           ,[DateReviewed]
           ,[ReviewedBy]
           ,[IsApproved]
           ,[DateApproved]
           ,[ApprovedBy]
           ,[IsActivated]
           ,[IsPreviousActivated]
           ,[DateActivated]
           ,[ActivatedBy]
           ,[DateDeactivated]
           ,[DeactivatedBy]
           ,[IsFutureActivate]
           ,[DateFutureActivation]
           ,[DateFutureActivationModified]
           ,[FutureActivationModifiedBy]
           ,[DateCreated]
           ,[CreatedBy]
           ,[DateLastModified]
           ,[LastModifiedBy]
           ,[fkMasterListTypeID])
     VALUES
           ((SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK')
           ,0
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL
           ,1
           ,GETDATE()
           ,1
           ,1
           ,GETDATE()
           ,1
           ,1
           ,1
           ,GETDATE()
           ,1
           ,NULL
           ,NULL
           ,0
           ,NULL
           ,NULL
           ,NULL
           ,GETDATE()
           ,1
           ,GETDATE()
           ,1
           ,2)
	END

	IF NOT EXISTS(SELECT * FROM [Base].[CurrencyRate] WHERE fkCurrencyRateVersionID = (
	SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)
	AND (BaseCurrencyRefCode = 'MMK' OR ToCurrencyRefCode = 'MMK'))
	BEGIN
		INSERT INTO [Base].[CurrencyRate]
			   ([BaseCurrencyRefCode]
			   ,[ToCurrencyRefCode]
			   ,[Rate]
			   ,[BaseCurrencyDescription]
			   ,[ToCurrencyDescription]
			   ,[fkBaseCurrencyID]
			   ,[fkTargetCurrencyID]
			   ,[fkCurrencyRateVersionID])
		 VALUES
			   ('AED','MMK',1,'UAE Dirham','Unknown',1,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('AUD','MMK',1,'Australian Dollar','Unknown',4,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('BDT','MMK',1,'Bangladesh Taka','Unknown',8,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('BND','MMK',1,'Brunei Dollar','Unknown',13,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('BRL','MMK',1,'Brazil Real','Unknown',15,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('CAD','MMK',1,'Canadian Dollar','Unknown',20,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('CHF','MMK',1,'Swiss Franc','Unknown',21,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('CNY','MMK',1,'Chinese Renminbi','Unknown',23,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('DKK','MMK',1,'Danish Krone','Unknown',29,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('EUR','MMK',1,'Euro','Unknown',35,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('GBP','MMK',1,'Sterling Pound','Unknown',37,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('HKD','MMK',1,'Hongkong Dollar','Unknown',43,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('IDR','MMK',1,'Indonesian Rupiah','Unknown',48,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('INR','MMK',1,'Indian Rupee','Unknown',50,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('JPY','MMK',1,'Japanese Yen','Unknown',56,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('KRW','MMK',1,'Korean Won','Unknown',60,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('KWD','MMK',1,'Kuwaiti Dinar','Unknown',61,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('LAK','MMK',1,'Lao Kip','Unknown',64,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('LKR','MMK',1,'Sri Lanka Rupee','Unknown',66,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MOP','MMK',1,'Macau Pataca','Unknown',76,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MYR','MMK',1,'Malaysian Ringgit','Unknown',82,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('NOK','MMK',1,'Norwegian Kroner','Unknown',87,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('NZD','MMK',1,'New Zealand Dollar','Unknown',89,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('PGK','MMK',1,'Papua New Guinea kina','Unknown',93,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('PHP','MMK',1,'Philipine Peso','Unknown',94,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('PKR','MMK',1,'Pakistani Rupee','Unknown',95,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('RUB','MMK',1,'Russia Ruble','Unknown',101,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('SEK','MMK',1,'Swedish Kroner','Unknown',106,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','AED',1,'Unknown','UAE Dirham',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),1,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','AUD',1,'Unknown','Australian Dollar',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),4,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','BDT',1,'Unknown','Bangladesh Taka',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),8,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','BND',1,'Unknown','Brunei Dollar',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),13,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','BRL',1,'Unknown','Brazil Real',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),15,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','CAD',1,'Unknown','Canadian Dollar',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),20,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','CHF',1,'Unknown','Swiss Franc',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),21,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','CNY',1,'Unknown','Chinese Renminbi',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),23,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','DKK',1,'Unknown','Danish Krone',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),29,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','EUR',1,'Unknown','Euro',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),35,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','GBP',1,'Unknown','Sterling Pound',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),37,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','HKD',1,'Unknown','Hongkong Dollar',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),43,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','IDR',1,'Unknown','Indonesian Rupiah',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),48,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','INR',1,'Unknown','Indian Rupee',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),50,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','JPY',1,'Unknown','Japanese Yen',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),56,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','KRW',1,'Unknown','Korean Won',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),60,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','KWD',1,'Unknown','Kuwaiti Dinar',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),61,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','LAK',1,'Unknown','Lao Kip',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),64,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','LKR',1,'Unknown','Sri Lanka Rupee',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),66,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','MOP',1,'Unknown','Macau Pataca',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),76,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','MYR',1,'Unknown','Malaysian Ringgit',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),82,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','NOK',1,'Unknown','Norwegian Kroner',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),87,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','NZD',1,'Unknown','New Zealand Dollar',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),89,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','PGK',1,'Unknown','Papua New Guinea kina',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),93,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','PHP',1,'Unknown','Philipine Peso',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),94,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','PKR',1,'Unknown','Pakistani Rupee',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),95,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','RUB',1,'Unknown','Russia Ruble',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),101,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','SEK',1,'Unknown','Swedish Kroner',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),106,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','MMK',1,'Unknown','Unknown',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','THB',1,'Unknown','Thai Baht',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),114,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','TWD',1,'Unknown','New Taiwan Dollar',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),120,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','USD',1,'Unknown','United States Dollar',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),124,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('MMK','VND',1,'Unknown','Vietnamese Dong',(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),128,(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('THB','MMK',1,'Thai Baht','Unknown',114,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('TWD','MMK',1,'New Taiwan Dollar','Unknown',120,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('USD','MMK',1,'United States Dollar','Unknown',124,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1)),
				('VND','MMK',1,'Vietnamese Dong','Unknown',128,(SELECT CurrencyID FROM [Base].[Currency] WHERE [RefCode] = 'MMK'),(SELECT TOP 1 CurrencyRateVersionID FROM [Base].[CurrencyRateVersion] WHERE IsActivated = 1))
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