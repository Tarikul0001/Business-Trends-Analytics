--Q.7 Calculate the year-over-year (YoY) sales growth for 2013 compared to 2012.


WITH CTE AS (SELECT 
ROUND(SUM(CASE WHEN D.CalendarYear = '2013' THEN T.SalesAmount ELSE 0 END),2) AS Sales_2013,
ROUND(SUM(CASE WHEN D.CalendarYear = '2012' THEN T.SalesAmount ELSE 0 END),2) AS Sales_2012
FROM (SELECT OrderDateKey, SalesAmount
FROM dbo.FactResellerSales
UNION ALL
SELECT OrderDateKey, SalesAmount
FROM dbo.FactInternetSales) T
JOIN dbo.DimDate D ON D.DateKey = T.OrderDateKey)

SELECT Sales_2013, Sales_2012, ROUND ((Sales_2013-Sales_2012) / Sales_2012 * 100,2) AS YoYGrowthPercentage
FROM CTE 
