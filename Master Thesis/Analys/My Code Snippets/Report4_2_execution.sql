USE [bex_bob]
GO
set statistics IO on
set statistics time on
DECLARE	@return_value int

EXEC	@return_value = [dbo].[report_4_2]
		@headerId = 75639,
		@unit = N'10',
		@date1 = N'2014-01-01',
		@date2 = N'2015-01-01',
		@account1 = 1400,
		@account2 = 4991,
		@dimension2 = N' '

SELECT	'Return Value' = @return_value

GO
set statistics IO off
set statistics time off