USE [bex_bob]
GO
set statistics IO on
set statistics time on
DECLARE	@return_value int

EXEC	@return_value = [dbo].[report_3_7]
		@userId = 1,
		@headerId = 75639,
		@unit = N'10',
		@date1 = N' ',
		@itemNo = N' ',
		@dimension2 = N' ',
		@supplier = N' ',
		@itemGroup = N' ',
		@itemCategory = N' ',
		@productGroup = N' ',
		@program = N' ',
		@collection = N' ',
		@color = N' ',
		@size = N' ',
		@length = N' '

SELECT	'Return Value' = @return_value

GO
set statistics IO off
set statistics time off