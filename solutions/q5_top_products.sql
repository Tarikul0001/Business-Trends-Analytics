--Q.5 Write a query to find the top 2 products with the highest quantity sold across both Internet and Reseller sales. Display product category name and total order quantity.


SELECT TOP 2 PC.EnglishProductCategoryName, SUM(OrderQuantity) AS Total_OrderQuantity
FROM dbo.DimProduct DP
JOIN (SELECT OrderDateKey,ProductKey, OrderQuantity, SalesAmount
FROM dbo.FactResellerSales
UNION ALL
SELECT OrderDateKey,ProductKey, OrderQuantity, SalesAmount
FROM dbo.FactInternetSales) SM ON SM.ProductKey = DP.ProductKey
JOIN dbo.DimProductSubcategory PS ON PS.ProductSubcategoryKey = DP.ProductSubcategoryKey
JOIN dbo.DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
GROUP BY PC.ProductCategoryKey, PC.EnglishProductCategoryName
ORDER BY Total_OrderQuantity DESC
