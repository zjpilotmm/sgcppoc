BEGIN TRY
	BEGIN TRAN AAA
		-- Variable declaration
		DECLARE @autoLogoutTimeSpan NVARCHAR(8)
		DECLARE @autoLogoutWarningTimeSpan NVARCHAR(8)
		DECLARE @autoLogoutError NVARCHAR(MAX)
		DECLARE @autoLogoutWarningError NVARCHAR(MAX)

		-- User to define the value for AutoLogoutTimeSpan and AutoLogoutWarningTimeSpan
		-- @autoLogoutTimeSpan - @autoLogoutWarningTimeSpan = when the Warning Message will display. For example, 00:15:00 - 00:03:00 = 00:12:00. Which is at 12 minutes the warning message will display.
		SET @autoLogoutTimeSpan = '23:59:59' -- Please define the total duration for how long a user can idle
		SET @autoLogoutWarningTimeSpan = '00:05:00' -- Please define the duration for how long the warning message will display before auto logout
				
		-- Code to validate and set AutoLogoutTimeSpan and AutoLogoutWarningTimeSpan
		-- Check if AutoLogoutTimeSpan record exist in Base.ParameterConfiguration Table
		IF EXISTS(SELECT * FROM [Base].[ParameterConfiguration] WHERE [Name] = 'AutoLogoutTimeSpan')
		BEGIN
			-- Update AutoLogoutTimeSpan value to user defined value
			UPDATE [Base].[ParameterConfiguration]
			SET [Value] = @autoLogoutTimeSpan
			WHERE [Name] = 'AutoLogoutTimeSpan'
		END
		-- If AutoLogoutTimeSpan record not exist in Base.ParameterConfiguration Table
		ELSE
		BEGIN
			-- Raise developer custom error to inform that AutoLogoutTimeSpan record does not exist
			SET @autoLogoutError = '[Custom Error] There is no parameter configuration with the name "AutoLogoutTimeSpan".'
			RAISERROR (@autoLogoutError,16,1)
		END

		-- Check if AutoLogoutWarningTimeSpan record exist in Base.ParameterConfiguration Table
		IF EXISTS(SELECT * FROM [Base].[ParameterConfiguration] WHERE [Name] = 'AutoLogoutWarningTimeSpan')
		BEGIN
			-- Update AutoLogoutWarningTimeSpan value to user defined value
			UPDATE [Base].[ParameterConfiguration]
			SET [Value] = @autoLogoutWarningTimeSpan
			WHERE [Name] = 'AutoLogoutWarningTimeSpan'
		END
		-- If AutoLogoutWarningTimeSpan record not exist in Base.ParameterConfiguration Table
		ELSE
		BEGIN
			-- Raise developer custom error to inform that AutoLogoutWarningTimeSpan record does not exist
			SET @autoLogoutWarningError = '[Custom Error] There is no parameter configuration with the name "AutoLogoutWarningTimeSpan".'
			RAISERROR (@autoLogoutWarningError,16,1)
		END
	COMMIT TRAN AAA
END TRY
BEGIN CATCH
	DECLARE
		   @ErMessage NVARCHAR(MAX),
		   @ErSeverity INT,
		   @ErState INT

	SELECT
		   @ErMessage = ERROR_MESSAGE(),
		   @ErSeverity = ERROR_SEVERITY(),
		   @ErState = ERROR_STATE()
	
	RAISERROR(@ErMessage
        ,@ErSeverity
        ,@ErState)

	IF @@TRANCOUNT > 0
		ROLLBACK TRAN AAA
END CATCH;