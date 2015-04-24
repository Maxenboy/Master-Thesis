USE [bex_bob]
GO
/****** Object:  StoredProcedure [dbo].[report_3_1]    Script Date: 2015-04-17 04:57:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

delete from EXT_REPORT_RESULT_3_1
-- =============================================

declare	@userId int = 1,
	@headerId int = 75642,
	@unit varchar(10) = N'10',
	@location varchar(10) = N' ',
	@date1 datetime = N'2014-01-01',
	@date2 datetime = N'2015-01-01',
	@itemNo varchar(20) = N' ',
	@dimension2 varchar(10) = N' ',
	@supplier varchar(10) = N' ',
	@itemGroup varchar(10) = N' ',
	@itemCategory varchar(10) = N' ',
	@productGroup varchar(10) = N' ',
	@program varchar(10) = N' ',
	@collection varchar(10) = N' ',
	@time1 datetime = SYSDATETIME();

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
--declare @time1 datetime = SYSDATETIME();
	insert into
		EXT_REPORT_RESULT_3_1(
			ext_HeaderId,
			ItemNo,
			SupplierItemNo,
			[Description],
			ItemGroup,
			ItemCategory,
			ProductGroup,
			ColorCode,
			ColorDescription,
			Size,
			[Length],
			ColorSorting,
			SizeSorting,
			LengthSorting,
			PhysicalQty,
			AvailableNow,
			AvailableLater,
			SalesOrderQty,
			PurchaseOrderQty,
			VariantId)

	select
		@headerId,
		item.ext_No,
		case when variant.ext_SupplierItemNo is null or variant.ext_SupplierItemNo = '' then item.ext_SupplierItemNo else variant.ext_SupplierItemNo end as SupplierItemNo,
		item.ext_Description,
		coalesce(group1.ext_Description, '') as ItemGroup,
		coalesce(group2.ext_Description, '') as ItemCategory,
		coalesce(group3.ext_Description, '') as ProductGroup,
		coalesce(variant.ext_ColourCode, '') as ColorCode,
		coalesce(variant.ext_ColourDescription, '') as ColorDescription,
		coalesce(variant.ext_SizeDescription, '') as SizeDescription,
		coalesce(variant.ext_LengthDescription, '') as LengthDescription,
		coalesce(variant.ext_ColourSorting, 0) as ColorSorting,		
		coalesce(variant.ext_SizeSorting, 0) as SizeSorting,		
		coalesce(variant.ext_LengthSorting, 0) as LengthSorting,
		0,--sum(isnull(stock.ext_RemainingQty, 0)) as PhysicalQty,
		0,
		0,
		0,
		0,
		variant.ext_Id
	from
		EXT_ITEM item
	
	left join
		EXT_ITEM_VARIANTS variant
	on
		variant.ext_ItemNo = item.ext_No

/*	left join
		EXT_ITEM_LEDGER_ENTRY stock
	on
		stock.ext_Unit = @unit and
		stock.ext_ItemNo = item.ext_No and		
		stock.ext_LocationCode = case when @location = '' then stock.ext_LocationCode else @location end and
		stock.ext_RemainingQty <> 0 and
		isnull(stock.ext_VariantId, 0) = isnull(variant.ext_Id, 0) */
	
	left join
		EXT_ITEM_GROUP group1
	on
		group1.ext_Code = item.ext_ItemGroupCode
	
	left join
		EXT_ITEM_CATEGORY group2
	on
		group2.ext_Code = item.ext_ItemCategoryCode
	
	left join
		EXT_PRODUCT_GROUP group3
	on
		group3.ext_ItemCategoryCode = item.ext_ItemCategoryCode and
		group3.ext_Code = item.ext_ProductGroupCode
	
	where
		item.ext_No = case when @itemNo = '' then item.ext_No else @itemNo end and
		item.ext_GlobalDimension2Code = case when @dimension2 = '' then item.ext_GlobalDimension2Code else @dimension2 end and
		item.ext_SupplierNo = case when @supplier = '' then item.ext_SupplierNo else @supplier end and
		item.ext_ItemGroupCode = case when @itemGroup = '' then item.ext_ItemGroupCode else @itemGroup end and
		item.ext_ItemCategoryCode = case when @itemCategory = '' then item.ext_ItemCategoryCode else @itemCategory end and
		item.ext_ProductGroupCode = case when @productGroup = '' then item.ext_ProductGroupCode else @productGroup end and
		item.ext_ProgramCode = case when @program = '' then item.ext_ProgramCode else @program end and
		item.ext_Collection = case when @collection = '' then item.ext_Collection else @collection end and
		item.ext_Deleted = 0

	group by
		item.ext_No,
		item.ext_SupplierItemNo,
		variant.ext_SupplierItemNo,
		item.ext_Description,
		group1.ext_Description,
		group2.ext_Description,
		group3.ext_Description,
		variant.ext_ColourCode,
		variant.ext_ColourDescription,
		variant.ext_ColourSorting,
		variant.ext_SizeDescription,
		variant.ext_SizeSorting,
		variant.ext_LengthDescription,
		variant.ext_LengthSorting,
		variant.ext_Id

	order by
		item.ext_No,
		variant.ext_ColourSorting,
		variant.ext_SizeSorting,
		variant.ext_LengthSorting;

--declare @time2 datetime = SYSDATETIME();

	update
		EXT_REPORT_RESULT_3_1
	set
		PhysicalQty = isnull((
			select
				sum(ext_RemainingQty)
			from
				EXT_ITEM_LEDGER_ENTRY L
			where
				L.ext_Unit = @Unit and
				L.ext_ItemNo = ItemNo and
				L.ext_LocationCode = case when @location = '' then L.ext_LocationCode else @location end and				
				isnull(L.ext_VariantId, 0) = isnull(VariantId, 0)), 0)
	where
		ext_HeaderId = @headerId;

--declare @time3 datetime = SYSDATETIME();

	with SalesOrderData as (
		select
			lines.ext_No,
			lines.ext_VariantId,
			sum(lines.ext_OutstandingQuantity) as OutstandingQty
		from 
			EXT_SALES_HEADER header
		join
			EXT_SALES_LINE lines
		on
			lines.ext_Unit = header.ext_Unit and
			lines.ext_DocumentType = header.ext_DocumentType and
			lines.ext_DocumentNo = header.ext_No and
			lines.ext_Placeholder = 0
		where
			header.ext_Unit = @unit and 
			(header.ext_DocumentType = 1 or header.ext_DocumentType = 20) and
			header.ext_LocationCode = case when @location = '' then header.ext_LocationCode else @location end and
			header.ext_OrderDate < @date1 and
			header.ext_XOrderStatus < 4
		group by
			lines.ext_No,
			lines.ext_VariantId),
	PurchaseOrderData as (
		select
			lines.ext_No,
			lines.ext_VariantId,
			sum(lines.ext_OutstandingQuantity) as OutstandingQty
		from 
			EXT_PURCHASE_HEADER header
		join
			EXT_PURCHASE_LINE lines
		on
			lines.ext_Unit = header.ext_Unit and
			lines.ext_DocumentType = header.ext_DocumentType and
			lines.ext_DocumentNo = header.ext_No and
			lines.ext_Placeholder = 0 and
			lines.ext_OutstandingQuantity > 0
		where
			header.ext_Unit = @unit and 
			header.ext_DocumentType = 1 and
			header.ext_LocationCode = case when @location = '' then header.ext_LocationCode else @location end and
			header.ext_OrderDate < @date2 and
			header.ext_XOrderStatus < 4
		group by
			lines.ext_No,
			lines.ext_VariantId)

	update
		EXT_REPORT_RESULT_3_1
	set
		SalesOrderQty = isnull( ( 
			select 
				OutstandingQty 
			from 
				SalesOrderData 
			where
				EXT_REPORT_RESULT_3_1.ItemNo = SalesOrderData.ext_No  and
				isnull(EXT_REPORT_RESULT_3_1.VariantId, 0) = isnull(SalesOrderData.ext_VariantId, 0)
			), 0 ),
		PurchaseOrderQty = isnull( ( 
			select 
				OutstandingQty 
			from 
				PurchaseOrderData 
			where
				EXT_REPORT_RESULT_3_1.ItemNo = PurchaseOrderData.ext_No  and
				isnull(EXT_REPORT_RESULT_3_1.VariantId, 0) = isnull(PurchaseOrderData.ext_VariantId, 0)
			), 0 )
	where
		ext_HeaderId = @headerId;

--declare @time4 datetime = SYSDATETIME();

	update
		EXT_REPORT_RESULT_3_1
	set
		AvailableNow = PhysicalQty - SalesOrderQty,
		AvailableLater = PhysicalQty - SalesOrderQty + PurchaseOrderQty
	where
		ext_HeaderId = @headerId;

--declare @time5 datetime = SYSDATETIME();

	delete from
		EXT_REPORT_RESULT_3_1
	where
		ext_HeaderId = @headerId and
		PhysicalQty = 0 and
		SalesOrderQty = 0 and
		PurchaseOrderQty = 0;

--select DATEDIFF(MILLISECOND,@time1,@time2),DATEDIFF(MILLISECOND,@time2,@time3),DATEDIFF(MILLISECOND,@time3,@time4),DATEDIFF(MILLISECOND,@time4,@time5),DATEDIFF(MILLISECOND,@time5,SYSDATETIME());
select DATEDIFF(MILLISECOND,@time1,SYSDATETIME())
END
