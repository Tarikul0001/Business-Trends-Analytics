--Q.4 Write a query to identifies the top-performing sales region in each country based on total sales amount, including both Internet and Reseller sales. Display Country, territory region and total sales amount.


--STEP 1: identifies the all sales region in each country
WITH CTE AS (
SELECT T.SalesTerritoryCountry, T.SalesTerritoryRegion, T.Total_Sales,
RANK() OVER(PARTITION BY T.SalesTerritoryCountry ORDER BY T.Total_Sales DESC) AS RANK
FROM (SELECT ST.SalesTerritoryRegion, ST.SalesTerritoryCountry, ROUND(SUM(S.SalesAmount),2) Total_Sales
FROM dbo.DimSalesTerritory ST
JOIN (SELECT SalesTerritoryKey, SalesAmount
FROM dbo.FactResellerSales
UNION ALL
SELECT SalesTerritoryKey,SalesAmount
FROM dbo.FactInternetSales) S ON S.SalesTerritoryKey = ST.SalesTerritoryKey
GROUP BY ST.SalesTerritoryRegion, ST.SalesTerritoryCountry) T)

--STEP 2: identifies the top-performing sales region in each country
SELECT SalesTerritoryCountry, SalesTerritoryRegion, Total_Sales
FROM CTE 
WHERE RANK = 1
ORDER BY Total_Sales DESC
