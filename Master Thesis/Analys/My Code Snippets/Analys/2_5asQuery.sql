use bex_bob

USE [bex_bob]
GO

delete from EXT_REPORT_RESULT_2_5
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
declare
	@headerId int,
	@Unit varchar(10),
	@PurchaseDate1 datetime,
	@PurchaseDate2 datetime,
	@SalesDate1 datetime,
	@SalesDate2 datetime,
	@StockDate datetime,
	@includeInternal bit = null,
	@LocationCode varchar(10),
	@SupplierNo varchar(10),
	@ItemGroupCode varchar(10),
	@ItemCategoryCode varchar(10),
	@ProductGroupCode varchar(10),
	@ProgramCode varchar(10),
	@Collection varchar(10),
	@Gender smallint,
	@time1 datetime = SYSDATETIME();
BEGIN

set @headerId = 75642;
set	@Unit = 10;
set	@PurchaseDate1 = '';
set	@PurchaseDate2 = '';
set	@SalesDate1 = N'2014-01-01';
set	@SalesDate2 = N'2015-01-01';
set	@StockDate = N'2015-01-01';
set	@includeInternal = 1;
set	@LocationCode = '';
set	@SupplierNo = '';
set	@ItemGroupCode = '';
set	@ItemCategoryCode = '';
set	@ProductGroupCode = '';
set	@ProgramCode = '';
set	@Collection = '';
set	@Gender = -1;

--declare @time1 datetime = SYSDATETIME();

	insert into
		EXT_REPORT_RESULT_2_5 (
			ext_HeaderId,			
			ItemNo,
			SupplierItemNo,
			[Description],
			ItemGroup,
			ColorCode,
			Color,
			Size,
			[Length],
			SalesQty,
			SalesAmount,
			SalesAmountIncVAT,
			CostAmount,
			TBPercent,
			PurchaseQty,
			StockQty,
			AvailableQty,
			VariantId)

	select
		@headerId,
		I.ext_No,
		case when V.ext_SupplierItemNo is null or V.ext_SupplierItemNo = '' then I.ext_SupplierItemNo else V.ext_SupplierItemNo end,
		I.ext_Description,
		coalesce(IG.ext_Description, ''),
		coalesce(V.ext_ColourCode, ''),
		coalesce(V.ext_ColourDescription, ''),
		coalesce(V.ext_SizeDescription, ''),
		coalesce(V.ext_LengthDescription, ''),
		sum(case when (H.ext_DocumentType = 2 or H.ext_DocumentType = 3) and H.ext_SubType = 2 then -H.ext_Quantity else 0 end),
		sum(case when (H.ext_DocumentType = 2 or H.ext_DocumentType = 3) and H.ext_SubType = 2 then -H.ext_AmountLCY else 0 end),
		sum(case when (H.ext_DocumentType = 2 or H.ext_DocumentType = 3) and H.ext_SubType = 2 then -H.ext_AmountLCYIncludingVAT else 0 end),
		sum(case when (H.ext_DocumentType = 2 or H.ext_DocumentType = 3) and H.ext_SubType = 2 then H.ext_CostAmount else 0 end),
		0, /*TB*/
		0, /* Purchased qty */
		0,
		0,
		V.ext_Id

	from
		EXT_ITEM I

	left join
		EXT_ITEM_GROUP IG
	on
		IG.ext_Code = I.ext_ItemGroupCode

	left join
		EXT_ITEM_VARIANTS V
	on
		V.ext_ItemNo = I.ext_No

	left join
		HISTORY_MASTER_test H WITH(NOLOCK)
	on
		H.ext_Unit = @unit and
		(H.ext_DocumentType = 2 or H.ext_DocumentType = 3 or H.ext_DocumentType = 12) and
		H.ext_PostingDate >= @SalesDate1 and
		H.ext_PostingDate < @SalesDate2 and
		H.ext_Type = 2 and
		(H.ext_SubType = 2 or H.ext_SubType = 3) and		
		H.ext_No = I.ext_No and
		H.ext_LocationCode = case when @LocationCode = '' then H.ext_LocationCode else @LocationCode end and
		isnull(H.ext_VariantId, 0) = isnull(V.ext_Id, 0)
	
	where
		I.ext_Collection = case when @collection = '' then I.ext_Collection else @collection end and
		I.ext_SupplierNo = case when @SupplierNo = '' then I.ext_SupplierNo else @SupplierNo end and				
		I.ext_ItemGroupCode = case when @ItemGroupCode = '' then I.ext_ItemGroupCode else @ItemGroupCode end and
		I.ext_ItemCategoryCode = case when @ItemCategoryCode = '' then I.ext_ItemCategoryCode else @ItemCategoryCode end and
		I.ext_ProductGroupCode = case when @ProductGroupCode = '' then I.ext_ProductGroupCode else @ProductGroupCode end and
		I.ext_ProgramCode = case when @ProgramCode = '' then I.ext_ProgramCode else @ProgramCode end and
		I.ext_Gender = case when @gender = -1 then I.ext_Gender else @gender end and
		I.ext_Deleted = 0 and
		(
			I.ext_No in (	select 
								ext_No 
							from 
								HISTORY_MASTER_test H WITH(NOLOCK)
							where 
								H.ext_Unit = @unit and
								(H.ext_DocumentType = 2 or H.ext_DocumentType = 3 or H.ext_DocumentType = 12) and
								H.ext_PostingDate >= @SalesDate1 and
								H.ext_PostingDate < @SalesDate2 and
								H.ext_Type = 2 and
								(H.ext_SubType = 2 or H.ext_SubType = 3) and		
								H.ext_No = I.ext_No )
			or
			I.ext_No in (	select 
								L.ext_ItemNo 
							from 
								EXT_ITEM_LEDGER_ENTRY L WITH(NOLOCK)
							where 
								L.ext_Unit = @Unit and
								L.ext_ItemNo = I.ext_No and
								L.ext_PostingDate < @StockDate and
								L.ext_LocationCode = case when @LocationCode = '' then L.ext_LocationCode else @LocationCode end and				
								isnull(L.ext_VariantId, 0) = isnull(V.ext_Id, 0))
		)

	group by
		I.ext_No,
		I.ext_SupplierItemNo,
		I.ext_Description,
		V.ext_SupplierItemNo,
		V.ext_ColourCode,
		V.ext_ColourDescription,
		V.ext_ColourSorting,
		V.ext_SizeDescription,
		V.ext_SizeSorting,
		V.ext_LengthDescription,
		V.ext_LengthSorting,
		I.ext_SupplierItemNo,
		IG.ext_Description,
		V.ext_Id

	order by
		I.ext_No,
		V.ext_ColourSorting,
		V.ext_SizeSorting,
		V.ext_LengthSorting;

--declare @time2 datetime = SYSDATETIME();

	update
		EXT_REPORT_RESULT_2_5
	set
		PurchaseQty = isnull((
			select
				sum(-ext_Quantity)
			from
				HISTORY_MASTER_test H WITH(NOLOCK)
			where
				H.ext_Unit = @unit and
				(H.ext_DocumentType = 12) and
				H.ext_PostingDate > @SalesDate1 and
				H.ext_PostingDate < @SalesDate2 and
				H.ext_Type = 2 and
				H.ext_SubType = 3 and
				H.ext_No = ItemNo and
				H.ext_LocationCode = case when @LocationCode = '' then H.ext_LocationCode else @LocationCode end and				
				isnull(H.ext_VariantId, 0) = isnull(VariantId, 0)), 0)
	where
		ext_HeaderId = @headerId;

--declare @time3 datetime = SYSDATETIME();

	update
		EXT_REPORT_RESULT_2_5
	set
		StockQty = isnull((
			select
				sum(ext_Quantity)
			from
				EXT_ITEM_LEDGER_ENTRY L WITH(NOLOCK)
			where
				L.ext_Unit = @Unit and
				L.ext_ItemNo = ItemNo and
				L.ext_PostingDate < @StockDate and
				L.ext_LocationCode = case when @LocationCode = '' then L.ext_LocationCode else @LocationCode end and				
				isnull(L.ext_VariantId, 0) = isnull(VariantId, 0)), 0)
	where
		ext_HeaderId = @headerId;

--declare @time4 datetime = SYSDATETIME();

	update
		EXT_REPORT_RESULT_2_5
	set
		AvailableQty = StockQty - isnull((
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
				H.ext_LocationCode = case when @LocationCode = '' then H.ext_LocationCode else @LocationCode end and
				H.ext_XOrderStatus < 4
			where
				L.ext_Unit = @Unit and
				L.ext_Type = 2 and
				L.ext_No = ItemNo and			
				isnull(L.ext_VariantId, 0) = isnull(VariantId, 0)), 0)
	where
		ext_HeaderId = @headerId;

--declare @time5 datetime = SYSDATETIME();

	delete from			
		EXT_REPORT_RESULT_2_5
	where
		ext_HeaderId = @headerId and
		SalesQty = 0 and
		PurchaseQty = 0 and
		StockQty = 0;


--declare @time6 datetime = SYSDATETIME();

	update
		EXT_REPORT_RESULT_2_5
	set 
		TBPercent = case
						when SalesAmount <= 0 then 0
						else round(((SalesAmount - CostAmount) / SalesAmount) * 100, 0)
					end
	where
		ext_HeaderId = @headerId

	OPTION (RECOMPILE)

--select DATEDIFF(MILLISECOND,@time1,@time2),DATEDIFF(MILLISECOND,@time2,@time3),DATEDIFF(MILLISECOND,@time3,@time4),DATEDIFF(MILLISECOND,@time4,@time5),DATEDIFF(MILLISECOND,@time5,@time6),DATEDIFF(MILLISECOND,@time6,SYSDATETIME());
select DATEDIFF(MILLISECOND,@time1,SYSDATETIME())
END
