USE [bex_bob]
GO
set statistics time on
DECLARE	@return_value int

EXEC	@return_value = [dbo].[report_1_6_1]
		@userId = 1,
		@headerId = 75641,
		@unit = N'10',
		@start = N'2014-01-01',
		@end = N'2015-01-01',
		@salespersonCode = NUll,
		@shopNo = NULL,
		@dimension1 = NULL,
		@workCodeId = NULL,
		@language = NULL 

SELECT	'Return Value' = @return_value
set statistics time off
GO
