--delete from ITEM_2_5_test where YEAR(ext_CreatedDate)<2015
--select * into  ITEM_2_5_test from EXT_ITEM
--select * from HISTORY_MASTER_2_6_test
--drop table ITEM_LEDGER_ENTRY_3_1_test

--SET IDENTITY_INSERT tableA ON
--insert into HISTORY_MASTER_test (columner) select * from EXT_HISTORY_MASTER 
--SET IDENTITY_INSERT tableA OFF

/*select name + ', ' as [text()] 
from sys.columns 
where object_id = object_id('YourTable') 
for xml path('')*/