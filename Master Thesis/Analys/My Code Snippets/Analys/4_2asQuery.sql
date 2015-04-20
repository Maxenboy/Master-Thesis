USE [bex_bob]
GO
/****** Object:  StoredProcedure [dbo].[report_4_2]    Script Date: 2015-04-17 05:16:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

delete from ext_report_result_4_2;

declare	@headerId int = 75639,
	@unit varchar(10)= N'10',
	@date1 datetime = N'2014-01-01',
	@date2 datetime = N'2015-01-01',
	@account1 int = 1400,
	@account2 int = 4991,
	@dimension2 varchar(10) = N' ',
	@time1 datetime = SYSDATETIME();

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--declare @time1 datetime = SYSDATETIME();

	insert into	
		EXT_REPORT_RESULT_4_2(ext_HeaderId, ext_AccountNo, ext_AccountDescription, ext_Dimension1, ext_Amount)


	select
		@headerId,
		EXT_HISTORY_MASTER.ext_AccountNo,
		EXT_ACCOUNT.ext_Description,
		EXT_HISTORY_MASTER.ext_GlobalDimension1Code,
		sum(EXT_HISTORY_MASTER.ext_AmountLCY)
	from
		EXT_HISTORY_MASTER
	join
		EXT_ACCOUNT
	on
		EXT_ACCOUNT.ext_AccountNo = EXT_HISTORY_MASTER.ext_AccountNo
	where
		EXT_HISTORY_MASTER.ext_Unit = @unit and
		EXT_HISTORY_MASTER.ext_PostingDate >= @date1 and
		EXT_HISTORY_MASTER.ext_PostingDate < @date2 and
		convert(int,EXT_HISTORY_MASTER.ext_AccountNo) >= @account1 and
		convert(int,EXT_HISTORY_MASTER.ext_AccountNo) <= @account2 and
		EXT_HISTORY_MASTER.ext_GlobalDimension2Code = case when @dimension2 = '' then EXT_HISTORY_MASTER.ext_GlobalDimension2Code else @dimension2 end
	group by
		EXT_HISTORY_MASTER.ext_AccountNo,
		EXT_ACCOUNT.ext_Description,
		EXT_HISTORY_MASTER.ext_GlobalDimension1Code
	order by
		EXT_HISTORY_MASTER.ext_AccountNo,
		EXT_HISTORY_MASTER.ext_GlobalDimension1Code

select DATEDIFF(MILLISECOND,@time1,SYSDATETIME());

END
