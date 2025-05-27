--Q.1 Write a query to identify the top 10 over-70-year-old clients with the biggest internet sales. Name, age, phone number, email address, and total sales amount of the consumer are displayed.


SELECT TOP 10 C.FirstName + ' ' + C.LastName AS Customer_Name, C.AddressLine1, DATEDIFF(YEAR,CONVERT(DATE,BirthDate),GETDATE()) AS Age, C.Phone, C.EmailAddress
, ROUND (SUM(FIS.SalesAmount),2) AS Total_Sales
FROM dbo.DimCustomer C
JOIN dbo.FactInternetSales FIS ON C.CustomerKey = FIS.CustomerKey
WHERE DATEDIFF(YEAR,CONVERT(DATE,BirthDate),GETDATE()) > 70
GROUP BY C.CustomerKey, C.FirstName, C.LastName, C.BirthDate, C.AddressLine1, C.Phone, C.EmailAddress
ORDER BY Total_Sales DESC
