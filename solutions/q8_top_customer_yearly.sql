--Q.8 Write a query to find the customer who have the highest number of internet orders and sales each year.


WITH CTE AS (
SELECT CalendarYear, Customer_Name, AddressLine1, Phone, EmailAddress, Total_Qty, Total_Sales,
RANK() OVER(PARTITION BY CalendarYear ORDER BY Total_Qty DESC,Total_Sales DESC) AS RNK
FROM (SELECT D.CalendarYear, C.FirstName + ' ' + C.LastName AS Customer_Name, C.AddressLine1, C.Phone, C.EmailAddress
, SUM(OrderQuantity) AS Total_Qty, ROUND (SUM(S.SalesAmount),2) AS Total_Sales
FROM dbo.DimCustomer C
JOIN  dbo.FactInternetSales S ON S.CustomerKey = C.CustomerKey
JOIN dbo.DimDate D ON D.DateKey = S.OrderDateKey
GROUP BY D.CalendarYear, C.FirstName, C.LastName, C.BirthDate, C.AddressLine1, C.Phone, C.EmailAddress
HAVING SUM(OrderQuantity) > 5) T)

SELECT  CalendarYear, Customer_Name, AddressLine1, Phone, EmailAddress, Total_Qty, Total_Sales
FROM CTE
WHERE RNK = 1
