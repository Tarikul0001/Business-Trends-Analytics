Query 1: Top 10 Over-70-Year-Old Clients with the Biggest Internet Sales
Problem Statement:
Identify the top 10 clients over the age of 70 with the highest total internet sales. The result should include customer name, age, phone number, email address, and total sales.

Explanation:
JOINs: This query joins the DimCustomer table (for customer details) with the FactInternetSales table (for internet sales).

Age Calculation: The DATEDIFF function is used to calculate the customer's age based on their birthdate.

Filter: Customers over 70 years of age are selected by applying a condition on the age.

Grouping: The results are grouped by customer details to aggregate the sales amount.

Ordering: The TOP 10 keyword is used to return only the top 10 customers based on their total sales, sorted in descending order.

sql
Copy
Edit
SELECT TOP 10 C.FirstName + ' ' + C.LastName AS Customer_Name, 
              C.AddressLine1, 
              DATEDIFF(YEAR, CONVERT(DATE, BirthDate), GETDATE()) AS Age, 
              C.Phone, 
              C.EmailAddress,
              ROUND(SUM(FIS.SalesAmount), 2) AS Total_Sales
FROM dbo.DimCustomer C
JOIN dbo.FactInternetSales FIS ON C.CustomerKey = FIS.CustomerKey
WHERE DATEDIFF(YEAR, CONVERT(DATE, BirthDate), GETDATE()) > 70
GROUP BY C.CustomerKey, C.FirstName, C.LastName, C.BirthDate, C.AddressLine1, C.Phone, C.EmailAddress
ORDER BY Total_Sales DESC;
Query 2: Total Sales by Product Category
Problem Statement:
Calculate the total sales for each product category, considering both internet and reseller sales.

Explanation:
UNION ALL: This query combines data from both the FactResellerSales and FactInternetSales tables using UNION ALL to calculate the total sales.

JOINs: The query joins DimProduct, DimProductSubcategory, and DimProductCategory tables to get product details and categories.

Aggregation: The total sales are calculated by summing the sales amount, and results are grouped by product category.

sql
Copy
Edit
SELECT PC.ProductCategoryKey, 
       PC.EnglishProductCategoryName, 
       ROUND(SUM(SM.SalesAmount), 2) Total_Sales
FROM dbo.DimProduct DP
JOIN (SELECT ProductKey, SalesAmount
      FROM dbo.FactResellerSales
      UNION ALL
      SELECT ProductKey, SalesAmount
      FROM dbo.FactInternetSales) SM ON SM.ProductKey = DP.ProductKey
JOIN dbo.DimProductSubcategory PS ON PS.ProductSubcategoryKey = DP.ProductSubcategoryKey
JOIN dbo.DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
GROUP BY PC.ProductCategoryKey, PC.EnglishProductCategoryName
ORDER BY Total_Sales DESC;
Query 3: Total Sales by Month in 2013
Problem Statement:
Calculate the total sales for each month in the year 2013.

Explanation:
JOIN: The query joins the DimDate table with both the FactResellerSales and FactInternetSales tables.

Filter: The WHERE clause filters the data to include only the year 2013.

Aggregation: The sales amounts are aggregated by the month and year.

Ordering: Results are ordered by the month to display the sales in chronological order.

sql
Copy
Edit
SELECT D.CalendarYear, 
       D.MonthNumberOfYear, 
       D.EnglishMonthName, 
       ROUND(SUM(S.SalesAmount), 2) Total_Sales
FROM dbo.DimDate D
JOIN (SELECT OrderDateKey, SalesAmount
      FROM dbo.FactResellerSales
      UNION ALL
      SELECT OrderDateKey, SalesAmount
      FROM dbo.FactInternetSales) S ON S.OrderDateKey = D.DateKey
WHERE D.CalendarYear = '2013'
GROUP BY D.CalendarYear, D.MonthNumberOfYear, D.EnglishMonthName
ORDER BY 2;
Query 4: Top-Performing Sales Region in Each Country
Problem Statement:
Identify the top-performing sales region in each country based on the total sales amount (internet and reseller sales).

Explanation:
CTE (Common Table Expression): The query first creates a CTE to rank sales regions by total sales within each country.

JOINs: The DimSalesTerritory table is joined with both sales fact tables.

Ranking: The RANK() function is used to assign ranks based on total sales in each country.

Filtering: Only the top-ranked region is selected for each country.

sql
Copy
Edit
WITH CTE AS (
    SELECT T.SalesTerritoryCountry, 
           T.SalesTerritoryRegion, 
           T.Total_Sales,
           RANK() OVER(PARTITION BY T.SalesTerritoryCountry ORDER BY T.Total_Sales DESC) AS RANK
    FROM (SELECT ST.SalesTerritoryRegion, 
                 ST.SalesTerritoryCountry, 
                 ROUND(SUM(S.SalesAmount), 2) Total_Sales
          FROM dbo.DimSalesTerritory ST
          JOIN (SELECT SalesTerritoryKey, SalesAmount
                FROM dbo.FactResellerSales
                UNION ALL
                SELECT SalesTerritoryKey, SalesAmount
                FROM dbo.FactInternetSales) S ON S.SalesTerritoryKey = ST.SalesTerritoryKey
          GROUP BY ST.SalesTerritoryRegion, ST.SalesTerritoryCountry) T
)
SELECT SalesTerritoryCountry, 
       SalesTerritoryRegion, 
       Total_Sales
FROM CTE 
WHERE RANK = 1
ORDER BY Total_Sales DESC;
Query 5: Top 2 Products with the Highest Quantity Sold
Problem Statement:
Identify the top 2 products with the highest quantity sold across both internet and reseller sales, grouped by product category.

Explanation:
UNION ALL: Similar to the previous queries, this query combines data from the FactResellerSales and FactInternetSales tables.

JOINs: Joins are made with the DimProduct, DimProductSubcategory, and DimProductCategory tables to fetch product and category details.

Aggregation: The total quantity sold is summed up, and the results are ordered by total quantity in descending order.

Limiting: The TOP 2 keyword is used to fetch the top 2 products.

sql
Copy
Edit
SELECT TOP 2 PC.EnglishProductCategoryName, 
              SUM(OrderQuantity) AS Total_OrderQuantity
FROM dbo.DimProduct DP
JOIN (SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount
      FROM dbo.FactResellerSales
      UNION ALL
      SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount
      FROM dbo.FactInternetSales) SM ON SM.ProductKey = DP.ProductKey
JOIN dbo.DimProductSubcategory PS ON PS.ProductSubcategoryKey = DP.ProductSubcategoryKey
JOIN dbo.DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
GROUP BY PC.ProductCategoryKey, PC.EnglishProductCategoryName
ORDER BY Total_OrderQuantity DESC;
Query 6: Total Sales and Order Quantity by Calendar Year
Problem Statement:
Find the total sales and total order quantity for each product category, grouped by calendar year.

Explanation:
JOINs: Joins the DimProduct, DimProductCategory, and DimDate tables with both sales fact tables.

Grouping and Aggregation: The query aggregates the sales and order quantity for each product category and calendar year.

Ordering: The results are grouped by year and product category.

sql
Copy
Edit
SELECT D.CalendarYear, 
       PC.EnglishProductCategoryName, 
       ROUND(SUM(SM.S


You said:

ChatGPT said:
Sure! Here's the continuation of the documentation for the remaining queries.

Query 6: Total Sales and Order Quantity by Calendar Year (continued)
Problem Statement:
Find the total sales and total order quantity for each product category, grouped by calendar year.

Explanation:
JOINs: Joins the DimProduct, DimProductCategory, DimProductSubcategory, and DimDate tables with both the FactResellerSales and FactInternetSales tables.

Aggregation: The sales and order quantities are aggregated by product category and calendar year.

Grouping: The results are grouped by calendar year and product category.

Output: For each year and category, the total sales and total quantity ordered are displayed.

sql
Copy
Edit
SELECT D.CalendarYear, 
       PC.EnglishProductCategoryName, 
       ROUND(SUM(SM.SalesAmount), 2) Total_Sales, 
       SUM(OrderQuantity) AS Total_OrderQuantity
FROM dbo.DimProduct DP
JOIN (SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount
      FROM dbo.FactResellerSales
      UNION ALL
      SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount
      FROM dbo.FactInternetSales) SM ON SM.ProductKey = DP.ProductKey
JOIN dbo.DimProductSubcategory PS ON PS.ProductSubcategoryKey = DP.ProductSubcategoryKey
JOIN dbo.DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
JOIN dbo.DimDate D ON D.DateKey = SM.OrderDateKey
GROUP BY D.CalendarYear, PC.ProductCategoryKey, PC.EnglishProductCategoryName;
Query 7: Year-Over-Year Sales Growth for 2013 Compared to 2012
Problem Statement:
Calculate the year-over-year (YoY) sales growth for the year 2013 compared to 2012.

Explanation:
CTE (Common Table Expression): This query uses a CTE to aggregate total sales for 2013 and 2012 separately.

Sales Calculation: The SUM function is used to calculate total sales for each year.

YoY Growth Calculation: The YoY growth percentage is calculated as:

YoY Growth
=
Sales in 2013
−
Sales in 2012
Sales in 2012
×
100
YoY Growth= 
Sales in 2012
Sales in 2013−Sales in 2012
​
 ×100
Result: The query returns total sales for 2013 and 2012, along with the YoY growth percentage.

sql
Copy
Edit
WITH CTE AS (
    SELECT 
    ROUND(SUM(CASE WHEN D.CalendarYear = '2013' THEN T.SalesAmount ELSE 0 END), 2) AS Sales_2013,
    ROUND(SUM(CASE WHEN D.CalendarYear = '2012' THEN T.SalesAmount ELSE 0 END), 2) AS Sales_2012
    FROM (SELECT OrderDateKey, SalesAmount
          FROM dbo.FactResellerSales
          UNION ALL
          SELECT OrderDateKey, SalesAmount
          FROM dbo.FactInternetSales) T
    JOIN dbo.DimDate D ON D.DateKey = T.OrderDateKey
)
SELECT Sales_2013, 
       Sales_2012, 
       ROUND((Sales_2013 - Sales_2012) / Sales_2012 * 100, 2) AS YoYGrowthPercentage
FROM CTE;
Query 8: Customer with Highest Number of Internet Orders and Sales Each Year
Problem Statement:
Identify the customer with the highest number of internet orders and the highest sales each year.

Explanation:
CTE (Common Table Expression): The query uses a CTE to rank customers based on the total order quantity and sales for each year.

JOINs: Joins are made between the DimCustomer, FactInternetSales, and DimDate tables.

Ranking: The RANK() function is used to assign a rank to customers based on the total quantity and total sales for each year.

Filtering: The WHERE clause selects only the top-ranked customer (the one with the highest number of orders and sales) for each year.

Result: The query returns the customer details (name, address, phone, email) and their sales and order quantity.

sql
Copy
Edit
WITH CTE AS (
    SELECT CalendarYear, 
           Customer_Name, 
           AddressLine1, 
           Phone, 
           EmailAddress, 
           Total_Qty, 
           Total_Sales,
           RANK() OVER(PARTITION BY CalendarYear ORDER BY Total_Qty DESC, Total_Sales DESC) AS RNK
    FROM (SELECT D.CalendarYear, 
                 C.FirstName + ' ' + C.LastName AS Customer_Name, 
                 C.AddressLine1, 
                 C.Phone, 
                 C.EmailAddress,
                 SUM(OrderQuantity) AS Total_Qty, 
                 ROUND(SUM(S.SalesAmount), 2) AS Total_Sales
          FROM dbo.DimCustomer C
          JOIN dbo.FactInternetSales S ON S.CustomerKey = C.CustomerKey
          JOIN dbo.DimDate D ON D.DateKey = S.OrderDateKey
          GROUP BY D.CalendarYear, C.FirstName, C.LastName, C.BirthDate, C.AddressLine1, C.Phone, C.EmailAddress
          HAVING SUM(OrderQuantity) > 5) T
)
SELECT CalendarYear, 
       Customer_Name, 
       AddressLine1, 
       Phone, 
       EmailAddress, 
       Total_Qty, 
       Total_Sales
FROM CTE
WHERE RNK = 1;
Conclusion
This document provides an in-depth explanation of 8 SQL queries designed to address various analytical requirements. Each query is designed to extract and aggregate sales data, calculate growth, identify top customers, and analyze product and regional performance across different time periods.

Key Concepts:

JOINs: Many queries combine multiple tables to ensure the data being aggregated comes from all the relevant sources.

Aggregation: Using functions like SUM, ROUND, and COUNT to calculate the total values needed.

Filtering: Conditions such as WHERE clauses or HAVING clauses to refine the results to specific needs (e.g., filtering by age or date).

Window Functions: RANK() is used to rank customers or regions based on a metric (e.g., total sales or order quantity).

Union: The use of UNION ALL combines data from different sources (internet vs. reseller sales) to provide a comprehensive resul
