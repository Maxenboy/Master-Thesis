USE [bex_bob]
GO
set statistics IO on
set statistics time on
DECLARE	@return_value int

EXEC	@return_value = [dbo].[report_1_5_7]
		@userId = 1,
		@headerId = 75641,
		@unit = N'10',
		@date1 = N'2014-01-01',
		@date2 = N'2015-01-01',
		@location = N' ',
		@supplier = N' ',
		@program = N' ',
		@itemgroup = N' ',
		@itemcat = N' ',
		@prodgroup = N' ',
		@collection = N' ',
		@gender = -1,
		@source = 0

SELECT	'Return Value' = @return_value

GO
set statistics IO off
set statistics time off
