BEGIN TRY
	BEGIN TRAN AAA
		UPDATE [Base].[ApplicationServerMachine]
		SET [FQDNHostName] = 'W01TFRDVPOC1A.REG1.UAT1BANK.DBS.COM'
		WHERE MachineID = 1

		UPDATE [Base].[ApplicationServerWebService]
		SET WebServiceAddress = 'http://10.91.144.112/POC/Service/PortfolioProjection/PortfolioProjectionBatchService.svc'
		WHERE WebServiceType = 'PortfolioProjection'
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