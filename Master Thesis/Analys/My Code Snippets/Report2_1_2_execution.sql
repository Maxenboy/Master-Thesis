USE [bex_bob]
GO
set statistics IO on
set statistics time on
DECLARE	@return_value int

EXEC	@return_value = [dbo].[report_2_1_2]
		@userId = 1,
		@headerId = 75641,
		@unit = N'10',
		@date1 = N'2014-01-01',
		@date2 = N'2015-01-01',
		@itemNo = N' ',
		@gender = -1,
		@dim1 = N' ',
		@dim2 = N' ',
		@location = N' ',
		@country = N' ',
		@supplier = N' ',
		@itemgroup = N' ',
		@itemcat = N' ',
		@prodgroup = N' ',
		@program = N' ',
		@collection = N' '

SELECT	'Return Value' = @return_value

GO
set statistics IO off
set statistics time off