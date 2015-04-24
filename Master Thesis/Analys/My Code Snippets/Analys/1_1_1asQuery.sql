USE [bex_bob]
GO
/****** Object:  StoredProcedure [dbo].[report_1_1_1]    Script Date: 2015-04-17 05:44:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

delete from EXT_REPORT_RESULT_1_1_1;

declare	@userId int,
	@headerId int,
	@unit varchar(10),
	@date1 datetime,
	@date2 datetime,
	@includeInternal bit,
	@itemNo varchar(20),
	@customerNo varchar(10),
	@customerGroup varchar(10),
	@gender smallint,
	@dim1 varchar(10),
	@dim2 varchar(10),
	@location varchar(10),
	@country varchar(10),
	@supplier varchar(10),
	@itemgroup varchar(10),
	@itemcat varchar(10),
	@prodgroup varchar(10),
	@program varchar(10),	
	@collection varchar(10),
	@allowTB bit = 0

set @userId = 1;
set	@headerId = 75636;
set	@unit = 10;
set	@date1 = N'2014-01-01';
set	@date2 = N'2015-01-01';
set	@includeInternal = 1;
set	@itemNo = '';
set	@customerNo = '';
set	@customerGroup = '';
set	@gender = -1;
set	@dim1 = '';
set	@dim2 = '';
set	@location = '';
set	@country = '';
set	@supplier = '';
set	@itemgroup = '';
set	@itemcat = '';
set	@prodgroup = '';
set	@program = '';	
set	@collection = '';
set	@allowTB = 1;

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

declare @time1 datetime = SYSDATETIME();

	insert into
		EXT_REPORT_RESULT_1_1_1 (
			ext_HeaderId,			
			ItemNo,
			SupplierItemNo,
			[Description],
			ItemGroup,
			ItemCategory,
			ProductGroup,
			Program,
			[Collection],
			Quantity,
			GrossAmount,
			DiscountAmount,
			DiscountPercent,
			Amount,
			AmountIncludingVAT,
			CostAmount,
			TBAmount,
			TBPercent)

	select
		@headerId,
		I.ext_No,
		I.ext_SupplierItemNo,
		I.ext_Description,
		coalesce(IG.ext_Description, ''),
		coalesce(IC.ext_Description, ''),
		coalesce(PG.ext_Description, ''),
		coalesce(P.ext_Description, ''),
		coalesce(C.ext_Description, ''),
		sum(-H.ext_Quantity),
		sum(-H.ext_AmountLCY),
		sum((case when ext_DocumentType = 3 then -H.ext_LineDiscountAmount else H.ext_LineDiscountAmount end * H.ext_CurrencyRate) + ( case when ext_DocumentType = 3 then -H.ext_InvoiceDiscountAmount else H.ext_InvoiceDiscountAmount end * H.ext_CurrencyRate)),
		0,
		sum(-H.ext_AmountLCY),
		sum(-H.ext_AmountLCYIncludingVAT),
		sum(H.ext_CostAmount),
		0,
		0

	from
		HISTORY_MASTER_test H

	join
		EXT_CUSTOMER CU
	on
		CU.ext_No = H.ext_SelltoCustomerNo

	join
		EXT_ITEM I
	on
		I.ext_No = H.ext_No

	left join
		EXT_ITEM_GROUP IG
	on
		IG.ext_Code = I.ext_ItemGroupCode

	left join
		EXT_ITEM_CATEGORY IC
	on
		IC.ext_Code = I.ext_ItemCategoryCode

	left join
		EXT_PRODUCT_GROUP PG
	on
		PG.ext_ItemCategoryCode = I.ext_ItemCategoryCode and
		PG.ext_Code = I.ext_ProductGroupCode

	left join
		EXT_PROGRAM P
	on
		P.ext_Code = I.ext_ProgramCode

	left join
		EXT_COLLECTION C
	on
		C.ext_Code = I.ext_Collection

	where
		H.ext_Unit = @unit and
		(H.ext_DocumentType = 2 or H.ext_DocumentType = 3) and
		H.ext_PostingDate > @date1 and
		H.ext_PostingDate < @date2 and
		H.ext_Type = 2 and
		H.ext_SubType = 2 and		
		H.ext_No = case when @itemNo = '' then H.ext_No else @itemNo end and
		H.ext_SelltoCustomerNo = case when @customerNo = '' then H.ext_SelltoCustomerNo else @customerNo end and
		H.ext_LocationCode = case when @location = '' then H.ext_LocationCode else @location end and
		H.ext_GlobalDimension1Code = case when @dim1 = '' then H.ext_GlobalDimension1Code else @dim1 end and
		I.ext_GlobalDimension2Code = case when @dim2 = '' then I.ext_GlobalDimension2Code else @dim2 end and		
		H.ext_CountryCode = case when @country = '' then H.ext_CountryCode else @country end and
		CU.ext_CustomerGroupCode = case when @customerGroup = '' then CU.ext_CustomerGroupCode else @customerGroup end and
		CU.ext_InternalCompany = case when @includeInternal = 1 then CU.ext_InternalCompany else '' end and
		I.ext_Gender = case when @gender = -1 then I.ext_Gender else @gender end and		
		I.ext_SupplierNo = case when @supplier = '' then I.ext_SupplierNo else @supplier end and
		I.ext_ItemGroupCode = case when @itemgroup = '' then I.ext_ItemGroupCode else @itemgroup end and
		I.ext_ItemCategoryCode = case when @itemcat = '' then I.ext_ItemCategoryCode else @itemcat end and
		I.ext_ProductGroupCode = case when @prodgroup = '' then I.ext_ProductGroupCode else @prodgroup end and
		I.ext_ProgramCode = case when @program = '' then I.ext_ProgramCode else @program end and
		I.ext_Collection = case when @collection = '' then I.ext_Collection else @collection end and
		I.ext_Deleted = 0


	group by
		I.ext_No,
		I.ext_SupplierItemNo,
		I.ext_Description,
		I.ext_SupplierItemNo,
		IG.ext_Description,
		IC.ext_Description,
		PG.ext_Description,
		P.ext_Description,
		C.ext_Description

	order by
		I.ext_No;

declare @time2 datetime = SYSDATETIME();

	update
		EXT_REPORT_RESULT_1_1_1
	set
		GrossAmount = GrossAmount + DiscountAmount
	where
		ext_HeaderId = @headerId;

declare @time3 datetime = SYSDATETIME();

	update
		EXT_REPORT_RESULT_1_1_1
	set
		DiscountPercent =	case
								when GrossAmount <= 0 then 0
								else round(DiscountAmount / GrossAmount * 100, 0)
							end
	where
		ext_HeaderId = @headerId;

	--CASE 
	--WHEN SUM(M.ext_SalesAmountLCY - M.ext_ReturnAmountLCY) <= 0 THEN 0 
	--ELSE (SUM(M.ext_SalesAmountLCY - M.ext_ReturnAmountLCY) - SUM(M.ext_CostAmount)) / (SUM(M.ext_SalesAmountLCY - M.ext_ReturnAmountLCY)) * 100 END

declare @time4 datetime = SYSDATETIME();

	if @allowTB = 0 begin
		update
			EXT_REPORT_RESULT_1_1_1
		set
			CostAmount = 0
		where
			ext_HeaderId = @headerId
	end else begin
		update
			EXT_REPORT_RESULT_1_1_1
		set
			TBAmount = Amount - CostAmount,
			TBPercent = case
							when Amount <= 0 then 0
							else round(((Amount - CostAmount) / Amount) * 100, 0)
						end
		where
			ext_HeaderId = @headerId		
	end

--select DATEDIFF(MILLISECOND,@time1,@time2),DATEDIFF(MILLISECOND,@time2,@time3),DATEDIFF(MILLISECOND,@time3,@time4),DATEDIFF(MILLISECOND,@time4,SYSDATETIME());
select DATEDIFF(MILLISECOND, @time1, SYSDATETIME());

END
