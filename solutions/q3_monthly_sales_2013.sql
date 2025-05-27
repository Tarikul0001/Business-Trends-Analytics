--Q.3 Write a query to calculate total sales amount for each month in 2013. Display the year, month, and total sales amount.


SELECT D.CalendarYear, D.MonthNumberOfYear, D.EnglishMonthName, ROUND(SUM(S.SalesAmount),2) Total_Sales
FROM dbo.DimDate D 
JOIN (SELECT OrderDateKey, SalesAmount
FROM dbo.FactResellerSales
UNION ALL
SELECT OrderDateKey,SalesAmount
FROM dbo.FactInternetSales) S ON S.OrderDateKey = D.DateKey
WHERE D.CalendarYear = '2013'
GROUP BY D.CalendarYear, D.MonthNumberOfYear, D.EnglishMonthName
ORDER BY 2
