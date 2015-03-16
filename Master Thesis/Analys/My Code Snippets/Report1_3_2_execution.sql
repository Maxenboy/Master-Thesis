USE [bex_bob]
GO
set statistics time on
DECLARE	@return_value int

EXEC	@return_value = [dbo].[report_1_3_2]
		@userId = 1,
		@headerId = 75641,
		@unit = 10,
		@date1 = N'2014-01-01',
		@date2 = N'2015-01-01',
		@itemNo = '',
		@customerNo = '',
		@customerGroup = '',
		@gender = -1,
		@dim1 = '',
		@dim2 = '',
		@location = '',
		@country = '',
		@supplier = '',
		@itemgroup = '',
		@itemcat = '',
		@prodgroup = '',
		@program = '',	
		@collection = '',
		@allowTB = 1

SELECT	'Return Value' = @return_value
set statistics time off
GO
