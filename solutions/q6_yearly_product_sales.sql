--Q.6 Write a query to find all products with the quantity sold and total sales for each calendar year across both Internet and reseller sales. Calendar Year, english product category name, total sales amount and total order quantity are displayed.


SELECT D.CalendarYear,PC.EnglishProductCategoryName, ROUND(SUM(SM.SalesAmount),2) Total_Sales, SUM(OrderQuantity) AS Total_OrderQuantity
FROM dbo.DimProduct DP
JOIN (SELECT OrderDateKey,ProductKey, OrderQuantity, SalesAmount
FROM dbo.FactResellerSales
UNION ALL
SELECT OrderDateKey,ProductKey, OrderQuantity, SalesAmount
FROM dbo.FactInternetSales) SM ON SM.ProductKey = DP.ProductKey
JOIN dbo.DimProductSubcategory PS ON PS.ProductSubcategoryKey = DP.ProductSubcategoryKey
JOIN dbo.DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
JOIN dbo.DimDate D ON D.DateKey = SM.OrderDateKey
GROUP BY D.CalendarYear,PC.ProductCategoryKey, PC.EnglishProductCategoryName
