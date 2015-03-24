USE [bex_bob]
GO
set statistics IO on
set statistics time on
DECLARE	@return_value int

EXEC	@return_value = [dbo].[report_1_1_3]
		@userId = 1,
		@headerId = 75638,
		@unit = 10,
		@date1 = N'2014-01-01',
		@date2 = N'2015-01-01',
		@includeInternal = 1,
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

GO
set statistics IO off
set statistics time off