USE [bex_bob]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[report_1_2_2]
		@userId = 1,
		@headerId = 75641,
		@unit = N'10',
		@date1 = N'2014-01-01',
		@date2 = N'2015-01-01',
		@source = 0,
		@shop = '',
		@terminal = ''

SELECT	'Return Value' = @return_value

GO
