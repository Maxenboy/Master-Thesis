select YEAR(ext_PostingDate), Count(YEAR(ext_PostingDate))  from HISTORY_MASTER_test
group by YEAR(ext_PostingDate)
order by YEAR(ext_PostingDate)