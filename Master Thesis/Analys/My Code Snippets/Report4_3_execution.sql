USE [bex_bob]
GO
set statistics IO on
set statistics time on
DECLARE	@return_value int

EXEC	@return_value = [dbo].[report_4_3]
		@userId = 1,
		@headerId = 75639,
		@unit = N'10',
		@date1 = N'2014-01-01',
		@date2 = N'2015-01-01',
		@date1Acc = N'2014-01-01',
		@date2Acc = N'2015-01-01',
		@dimension1 = N' '

SELECT	'Return Value' = @return_value

GO
set statistics IO off
set statistics time off