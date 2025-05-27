--Q.2 Write a query to calculate the total sales (Internet and Reseller) for each product category. ProductCategoryKey, EnglishProductCategoryName, and total sales amount of the consumer are displayed.


SELECT PC.ProductCategoryKey, PC.EnglishProductCategoryName, ROUND(SUM(SM.SalesAmount),2) Total_Sales
FROM dbo.DimProduct DP
JOIN (SELECT ProductKey, SalesAmount
FROM dbo.FactResellerSales
UNION ALL
SELECT ProductKey,SalesAmount
FROM dbo.FactInternetSales) SM ON SM.ProductKey = DP.ProductKey
JOIN dbo.DimProductSubcategory PS ON PS.ProductSubcategoryKey = DP.ProductSubcategoryKey
JOIN dbo.DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
GROUP BY PC.ProductCategoryKey, PC.EnglishProductCategoryName
ORDER BY Total_Sales DESC
