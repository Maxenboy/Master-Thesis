select YEAR(ext_PostingDate), Count(YEAR(ext_PostingDate))  from ITEM_LEDGER_ENTRY_3_1_test
group by YEAR(ext_PostingDate)
order by YEAR(ext_PostingDate)