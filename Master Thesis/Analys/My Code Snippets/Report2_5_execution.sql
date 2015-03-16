USE [bex_bob]
GO
set statistics time on
DECLARE	@return_value int

EXEC	@return_value = [dbo].[report_2_5]
		@headerId = 75642,
		@Unit = 10,
		@PurchaseDate1 = '',
		@PurchaseDate2 = '',
		@SalesDate1 = N'2014-01-01',
		@SalesDate2 = N'2015-01-01',
		@StockDate = N'2015-01-01',
		@includeInternal = 1,
		@LocationCode = '',
		@SupplierNo = '',
		@ItemGroupCode = '',
		@ItemCategoryCode = '',
		@ProductGroupCode = '',
		@ProgramCode = '',
		@Collection = '',
		@Gender = -1

SELECT	'Return Value' = @return_value
set statistics time off
GO
