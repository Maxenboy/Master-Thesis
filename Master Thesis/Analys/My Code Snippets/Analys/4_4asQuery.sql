USE [bex_bob]
GO
/****** Object:  StoredProcedure [dbo].[report_4_4]    Script Date: 2015-04-17 05:28:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

delete from EXT_REPORT_RESULT_4_4;

declare	@userId int = 1,
	@headerId int =  75639,
	@unit varchar(10) = N'10',
	@date1 datetime = N'2014-01-01',
	@date2 datetime = N'2015-01-01',
	@dimension1 varchar(10) = N' '

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @time1 datetime = SYSDATETIME();
    -- Insert statements for procedure here
	with Incoming as (
	
		select
			H.ext_AccountNo,
			A.ext_Description,
			sum(H.ext_AmountLCYIncludingVAT) as Amount
		from
			EXT_HISTORY_MASTER H
		join
			EXT_ACCOUNT A
		on
			H.ext_Unit = @unit and
			H.ext_PostingDate < @date1 and
			H.ext_AccountNo = A.ext_AccountNo
		where
			H.ext_GlobalDimension1Code = case when @dimension1 = '' then H.ext_GlobalDimension1Code when @dimension1 = '#' then '' else @dimension1 end
		group by
			H.ext_AccountNo,
			A.ext_Description),

	Change as (

		select
			H.ext_AccountNo,
			A.ext_Description,
			sum(H.ext_AmountLCYIncludingVAT) as Amount
		from
			EXT_HISTORY_MASTER H
		join
			EXT_ACCOUNT A
		on
			H.ext_Unit = @unit and
			h.ext_PostingDate >= @date1 and
			h.ext_PostingDate <= @date2 and
			H.ext_AccountNo = A.ext_AccountNo
		where
			H.ext_GlobalDimension1Code = case when @dimension1 = '' then H.ext_GlobalDimension1Code when @dimension1 = '#' then '' else @dimension1 end
		group by
			H.ext_AccountNo,
			A.ext_Description)

	insert into
		EXT_REPORT_RESULT_4_4
		(
			ext_HeaderId,
			ext_AccountNo,
			ext_Description,
			ext_Val1,
			ext_Val2,
			ext_Val3
		)	

	select 
		@headerId,
		A.ext_AccountNo,
		A.ext_Description,
		coalesce(Incoming.Amount, 0),
		coalesce(Change.Amount, 0),
		coalesce(Incoming.Amount, 0) + coalesce(Change.Amount, 0)
	from
		EXT_ACCOUNT A
	left join
		Incoming
	on
		Incoming.ext_AccountNo = A.ext_AccountNo
	left join
		Change 
	on
		Change.ext_AccountNo = A.ext_AccountNo
	order by
		A.ext_AccountNo

Select DATEDIFF(MILLISECOND, @time1, SYSDATETIME());

END
