SELECT top 5 * into #temp1 FROM [Person].[Address]  --# local table 
SELECT top 10 * into ##temp2 FROM [Person].[Address]  --# global table 

SELECT * FROM #temp1

DELETE #temp1  --delete rows
DROP table #temp1 --rollback table created again 
TRUNCATE table #temp1 --table is deleted from records cant be rollback

SELECT uu.AddressLine1 from [Person].[Address]uu for json auto
SELECT uu.AddressLine1 from [Person].[Address]uu for xml auto

SELECT TOP 10 * INTO #temp FROM [Sales].[CurrencyRate]

select * from #temp