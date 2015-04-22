select YEAR(ext_CreatedDate), Count(YEAR(ext_CreatedDate))  from ITEM_test
group by YEAR(ext_CreatedDate)
order by YEAR(ext_CreatedDate)