USE [bex_bob]
GO
set statistics time on
DECLARE	@return_value int

EXEC	@return_value = [dbo].[report_3_6]
		@userId = 1,
		@headerId = 75639,
		@unit = N'10',
		@location = N' ',
		@date1 = N'2014-01-01',
		@date2 = N'2015-01-01',
		@itemNo = N' ',
		@dimension1 = N' ',
		@dimension2 = N' ',
		@supplier = N' ',
		@itemGroup = N' ',
		@itemCategory = N' ',
		@productGroup = N' ',
		@program = N' ',
		@collection = N' ',
		@gender = -1,
		@account = N' '

SELECT	'Return Value' = @return_value
set statistics time off
GO
