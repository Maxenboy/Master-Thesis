USE [bex_bob]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[report_4_5]
		@headerId = 75639,
		@unit = N'10',
		@date1 = N'2014-01-01',
		@date2 = N'2015-01-01',
		@account1 = 1400,
		@account2 = 4991,
		@dimension1 = N' '

SELECT	'Return Value' = @return_value

GO
