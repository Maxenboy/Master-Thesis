select YEAR(ext_CreatedDate), Count(YEAR(ext_CreatedDate))  from ITEM_2_5_test
group by YEAR(ext_CreatedDate)
order by YEAR(ext_CreatedDate)