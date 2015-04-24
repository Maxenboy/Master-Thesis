USE [bex_bob]
GO
/****** Object:  StoredProcedure [dbo].[report_2_6]    Script Date: 2015-04-17 03:57:15 ******/

delete from EXT_REPORT_RESULT_2_6

Declare	-- Add the parameters for the stored procedure here
	@userId int = 1,
	@headerId int = 75642,
	@unit varchar(10) = N'10',
	@date1 datetime = N'2014-01-01',
	@date2 datetime = N'2015-01-01',
	@location varchar(10) = N'',
	@supplier varchar(10) = N'',
	@program varchar(10) = N'',
	@itemgroup varchar(10) = N'',
	@itemcat varchar(10) = N'',
	@prodgroup varchar(10) = N'',
	@collection varchar(10) = N'',
	@gender smallint = -1
	declare @time1 datetime = SYSDATETIME();

BEGIN


	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



WITH Sales_CTE
AS (

	select	
		ItemNo				=	I.ext_No,
		SupplierItemNo		=	I.ext_SupplierItemNo,
		[Description]		=	I.ext_Description,
		ReorderPoint		=	I.ext_ReorderPoint,
		ReorderQuantity		=	I.ext_ReorderQuantity,
		ItemGroup			=	coalesce(G.ext_Description, ''),
		ColorCode			=	coalesce(V.ext_ColourCode, ''),
		ColorDescription	=	coalesce(V.ext_ColourDescription, ''),
		ColorSorting		=	coalesce(V.ext_ColourSorting, 0),
		SizeDescription		=	coalesce(V.ext_SizeDescription, ''),
		SizeSorting			=	coalesce(V.ext_SizeSorting, 0),
		LengthDescription	=	coalesce(V.ext_LengthDescription, ''),
		LengthSorting		=	coalesce(V.ext_LengthSorting, 0),
		SalesQty			=	sum(case when (S.ext_DocumentType = 2 or S.ext_DocumentType = 3) and S.ext_SubType = 2 then -S.ext_Quantity else 0 end),
		SalesAmount			=	sum(case when (S.ext_DocumentType = 2 or S.ext_DocumentType = 3) and S.ext_SubType = 2 then -S.ext_AmountLCY else 0 end),
		SalesAmountIncVAT	=	sum(case when (S.ext_DocumentType = 2 or S.ext_DocumentType = 3) and S.ext_SubType = 2 then -S.ext_AmountLCYIncludingVAT else 0 end),
		LatestSalesDate		=	(select 
									max(S2.ext_PostingDate) 
								from 
									HISTORY_MASTER_test S2 
								where 
									S2.ext_Unit = @unit and
									S2.ext_DocumentType = 2 and
									S2.ext_Type = 2 and
									S2.ext_SubType = 2 and
									S2.ext_No = I.ext_No and
									isnull(S2.ext_VariantId, 0) = isnull(V.ext_Id, 0) and
									S2.ext_LocationCode = case when @location = '' then S2.ext_LocationCode else @location end),
		LatestStockDate		=	(select 
									max(S2.ext_PostingDate) 
								from 
									HISTORY_MASTER_test S2 
								where 
									S2.ext_Unit = @unit and
									S2.ext_DocumentType = 12 and
									S2.ext_Type = 2 and
									S2.ext_SubType = 3 and
									S2.ext_No = I.ext_No and
									isnull(S2.ext_VariantId, 0) = isnull(V.ext_Id, 0) and
									S2.ext_LocationCode = case when @location = '' then S2.ext_LocationCode else @location end),
		PhysicalQty			=		0,
		StockValue			=		0,
		AvailableQty		=		0,
		PurchaseQty			=		0,
		VariantId			=		V.ext_Id
	from
		EXT_ITEM I
	left join
		EXT_ITEM_VARIANTS V
	on
		V.ext_ItemNo = I.ext_No
	left join
		EXT_ITEM_GROUP G
	on
		G.ext_Code = I.ext_ItemGroupCode
	left join
		HISTORY_MASTER_test S with(nolock)
	on
		S.ext_Unit = @unit and
		(S.ext_DocumentType = 2 or S.ext_DocumentType = 3 or S.ext_DocumentType = 12) and
		S.ext_PostingDate >= @date1 and
		S.ext_PostingDate < @date2 and
		S.ext_Type = 2 and
		(S.ext_SubType = 2 or S.ext_SubType = 3) and
		S.ext_No = I.ext_No and
		isnull(S.ext_VariantId, 0) = isnull(V.ext_Id, 0) and
		S.ext_LocationCode = case when @location = '' then S.ext_LocationCode else @location end
	where
		@supplier = case when @supplier = '' then @supplier else I.ext_SupplierNo end and
		@program = case when @program = '' then @program else I.ext_ProgramCode end and
		@itemgroup = case when @itemgroup = '' then @itemgroup else I.ext_ItemGroupCode end and
		@itemcat = case when @itemcat = '' then @itemcat else I.ext_ItemCategoryCode end and
		@prodgroup = case when @prodgroup = '' then @prodgroup else I.ext_ProductGroupCode end and
		@collection = case when @collection = '' then @collection else I.ext_Collection end and
		@gender = case when @gender = -1 then @gender else I.ext_Gender end --and
		--I.ext_Blocked = 0 and
		--I.ext_Deleted = 0 and
		--V.ext_Blocked = 0
	group by
		S.ext_Unit,
		I.ext_No,
		I.ext_SupplierItemNo,
		I.ext_Description,
		I.ext_ReorderPoint,
		I.ext_ReorderQuantity,
		G.ext_Description,
		V.ext_Id,
		V.ext_ColourCode,
		V.ext_ColourDescription,
		V.ext_ColourSorting,
		V.ext_SizeCode,
		V.ext_SizeDescription,
		V.ext_SizeSorting,
		V.ext_LengthCode,
		V.ext_LengthDescription,
		V.ext_LengthSorting

		

) 
insert into
	EXT_REPORT_RESULT_2_6
    ([ext_HeaderId]
    ,[ItemNo]
    ,[SupplierItemNo]
    ,[Description]
	,[ReorderPoint]
	,[ReorderQuantity]
    ,[ItemGroup]
    ,[ColorCode]
    ,[ColorDescription]
    ,[SizeDescription]
    ,[LengthDescription]
    ,[SalesQty]
    ,[SalesAmount]
    ,[SalesAmountIncVAT]
    ,[LatestSalesDate]
    ,[LatestStockDate]
    ,[PhysicalQty]
    ,[StockValue]
    ,[AvailableQty]
    ,[PurchaseQty]
    ,[StockDays]
	,[VariantId])
select
	@headerId,
	ItemNo,
    SupplierItemNo,
    [Description],
	ReorderPoint,
	ReorderQuantity,
    ItemGroup,
    ColorCode,
    ColorDescription,
    SizeDescription,
    LengthDescription,
    SalesQty,
    SalesAmount,
    SalesAmountIncVAT,
    LatestSalesDate,
    LatestStockDate,
    PhysicalQty,
    StockValue,
    AvailableQty,
    PurchaseQty,
	StockDays = DATEDIFF(day, LatestStockDate, GETDATE()),
	VariantId
from 
	Sales_CTE 
order by 
	ItemNo,
	ColorSorting,
	SizeSorting,
	LengthSorting

--declare @time2 datetime = SYSDATETIME();

	update
		EXT_REPORT_RESULT_2_6
	set
		StockValue = isnull((
			select
				sum(ext_AmountLCY)
			from
				HISTORY_MASTER_test L WITH(NOLOCK)
			where
				L.ext_Unit = @Unit and
				L.ext_DocumentType = 12 and
				L.ext_No = ItemNo and
				L.ext_AccountNo = '1400' and
				--L.ext_PostingDate < @StockDate and
				L.ext_LocationCode = case when @location = '' then L.ext_LocationCode else @location end and				
				isnull(L.ext_VariantId, 0) = isnull(VariantId, 0)), 0)
	where
		ext_HeaderId = @headerId

--declare @time3 datetime = SYSDATETIME();

	update
		EXT_REPORT_RESULT_2_6
	set
		PhysicalQty = isnull((
			select
				sum(ext_Quantity)
			from
				EXT_ITEM_LEDGER_ENTRY L WITH(NOLOCK)
			where
				L.ext_Unit = @Unit and
				L.ext_ItemNo = ItemNo and
				--L.ext_PostingDate < @StockDate and
				L.ext_LocationCode = case when @location = '' then L.ext_LocationCode else @location end and				
				isnull(L.ext_VariantId, 0) = isnull(VariantId, 0)), 0)
	where
		ext_HeaderId = @headerId

--declare @time4 datetime = SYSDATETIME();

	update
		EXT_REPORT_RESULT_2_6
	set
		AvailableQty = PhysicalQty - isnull((
			select
				sum(L.ext_OutstandingQuantity)
			from
				EXT_SALES_LINE L
			join
				EXT_SALES_HEADER H
			on
				H.ext_Unit = L.ext_Unit and
				H.ext_No = L.ext_DocumentNo and
				H.ext_DocumentType = L.ext_DocumentType and
				(H.ext_DocumentType = 1 or H.ext_DocumentType = 20) and
				H.ext_LocationCode = case when @location = '' then H.ext_LocationCode else @location end and
				H.ext_XOrderStatus < 4
			where
				L.ext_Unit = @Unit and
				L.ext_Type = 2 and
				L.ext_No = ItemNo and			
				isnull(L.ext_VariantId, 0) = isnull(VariantId, 0)), 0)
	where
		ext_HeaderId = @headerId;

--declare @time5 datetime = SYSDATETIME();

	update
		EXT_REPORT_RESULT_2_6
	set
		PurchaseQty = isnull((
			select
				sum(-ext_Quantity)
			from
				HISTORY_MASTER_test H WITH(NOLOCK)
			where
				H.ext_Unit = @unit and
				(H.ext_DocumentType = 12) and
				H.ext_PostingDate > @date1 and
				H.ext_PostingDate < @date2 and
				H.ext_Type = 2 and
				H.ext_SubType = 3 and
				H.ext_No = ItemNo and
				H.ext_LocationCode = case when @location = '' then H.ext_LocationCode else @location end and				
				isnull(H.ext_VariantId, 0) = isnull(VariantId, 0)), 0)
	where
		ext_HeaderId = @headerId;

--declare @time6 datetime = SYSDATETIME();

	delete from			
		EXT_REPORT_RESULT_2_6
	where
		ext_HeaderId = @headerId and
		SalesQty = 0 and
		PurchaseQty = 0 and
		PhysicalQty = 0

	OPTION(RECOMPILE)

--select DATEDIFF(MILLISECOND,@time1,@time2),DATEDIFF(MILLISECOND,@time2,@time3),DATEDIFF(MILLISECOND,@time3,@time4),DATEDIFF(MILLISECOND,@time4,@time5),DATEDIFF(MILLISECOND,@time5,@time6),DATEDIFF(MILLISECOND,@time6,SYSDATETIME());
select DATEDIFF(MILLISECOND,@time1, SYSDATETIME())
END