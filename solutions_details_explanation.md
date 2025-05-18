# Sales Analytics SQL Queries Documentation

## Overview

This documentation provides detailed explanations of SQL queries for analyzing sales data from multiple sales channels. The queries use several tables from a database containing information about customers, products, sales, dates, and more. Below, each query is explained, including the logic, purpose, and key elements.

---

### **Q1: Top 10 Over-70-Year-Old Clients with the Biggest Internet Sales**

#### Query:

```sql
SELECT TOP 10 C.FirstName + ' ' + C.LastName AS Customer_Name, C.AddressLine1, DATEDIFF(YEAR, CONVERT(DATE, BirthDate), GETDATE()) AS Age, C.Phone, C.EmailAddress,
ROUND(SUM(FIS.SalesAmount), 2) AS Total_Sales
FROM dbo.DimCustomer C
JOIN dbo.FactInternetSales FIS ON C.CustomerKey = FIS.CustomerKey
WHERE DATEDIFF(YEAR, CONVERT(DATE, BirthDate), GETDATE()) > 70
GROUP BY C.CustomerKey, C.FirstName, C.LastName, C.BirthDate, C.AddressLine1, C.Phone, C.EmailAddress
ORDER BY Total_Sales DESC
```

#### Explanation:

* **Purpose**: To identify the top 10 clients above the age of 70 who have spent the most money on internet sales.
* **Key Components**:

  * `DATEDIFF(YEAR, BirthDate, GETDATE())`: Calculates the age of customers.
  * `SUM(FIS.SalesAmount)`: Sums the total sales amount from the `FactInternetSales` table.
  * `TOP 10`: Limits the results to the top 10 clients with the highest total sales.
  * The query groups by the customer's personal details (name, phone, email) and calculates the total sales for each customer.
  * The final result is ordered by the total sales in descending order.

---

### **Q2: Total Sales by Product Category (Internet and Reseller)**

#### Query:

```sql
SELECT PC.ProductCategoryKey, PC.EnglishProductCategoryName, ROUND(SUM(SM.SalesAmount), 2) Total_Sales
FROM dbo.DimProduct DP
JOIN (SELECT ProductKey, SalesAmount
FROM dbo.FactResellerSales
UNION ALL
SELECT ProductKey, SalesAmount
FROM dbo.FactInternetSales) SM ON SM.ProductKey = DP.ProductKey
JOIN dbo.DimProductSubcategory PS ON PS.ProductSubcategoryKey = DP.ProductSubcategoryKey
JOIN dbo.DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
GROUP BY PC.ProductCategoryKey, PC.EnglishProductCategoryName
ORDER BY Total_Sales DESC
```

#### Explanation:

* **Purpose**: To calculate the total sales (both Internet and Reseller) for each product category.
* **Key Components**:

  * **`UNION ALL`**: Combines `FactResellerSales` and `FactInternetSales` into one table for both sales channels.
  * **`SUM(SM.SalesAmount)`**: Sums the sales amount for each product category.
  * **`GROUP BY`**: Groups the results by product category name and key.
  * The query orders the result by total sales in descending order.

---

### **Q3: Total Sales by Month for 2013**

#### Query:

```sql
SELECT D.CalendarYear, D.MonthNumberOfYear, D.EnglishMonthName, ROUND(SUM(S.SalesAmount), 2) Total_Sales
FROM dbo.DimDate D
JOIN (SELECT OrderDateKey, SalesAmount
FROM dbo.FactResellerSales
UNION ALL
SELECT OrderDateKey, SalesAmount
FROM dbo.FactInternetSales) S ON S.OrderDateKey = D.DateKey
WHERE D.CalendarYear = '2013'
GROUP BY D.CalendarYear, D.MonthNumberOfYear, D.EnglishMonthName
ORDER BY 2
```

#### Explanation:

* **Purpose**: To calculate the total sales for each month of the year 2013.
* **Key Components**:

  * **`WHERE D.CalendarYear = '2013'`**: Filters data for the year 2013.
  * **`SUM(S.SalesAmount)`**: Sums the sales amount for each month.
  * **`GROUP BY`**: Groups the results by month and year.
  * The query orders the result by the month number.

---

### **Q4: Top-Performing Sales Region in Each Country**

#### Query:

```sql
WITH CTE AS (
  SELECT T.SalesTerritoryCountry, T.SalesTerritoryRegion, T.Total_Sales,
  RANK() OVER(PARTITION BY T.SalesTerritoryCountry ORDER BY T.Total_Sales DESC) AS RANK
  FROM (
    SELECT ST.SalesTerritoryRegion, ST.SalesTerritoryCountry, ROUND(SUM(S.SalesAmount), 2) Total_Sales
    FROM dbo.DimSalesTerritory ST
    JOIN (SELECT SalesTerritoryKey, SalesAmount
    FROM dbo.FactResellerSales
    UNION ALL
    SELECT SalesTerritoryKey, SalesAmount
    FROM dbo.FactInternetSales) S ON S.SalesTerritoryKey = ST.SalesTerritoryKey
    GROUP BY ST.SalesTerritoryRegion, ST.SalesTerritoryCountry
  ) T
)
SELECT SalesTerritoryCountry, SalesTerritoryRegion, Total_Sales
FROM CTE
WHERE RANK = 1
ORDER BY Total_Sales DESC
```

#### Explanation:

* **Purpose**: To identify the top-performing sales region in each country based on total sales (Internet and Reseller).
* **Key Components**:

  * **`RANK() OVER(PARTITION BY)`**: Assigns a rank to each sales region within a country based on total sales.
  * **CTE (Common Table Expression)**: Creates an intermediate result that ranks regions.
  * **`WHERE RANK = 1`**: Filters to select only the top-ranked sales region in each country.
  * The result is ordered by total sales in descending order.

---

### **Q5: Top 2 Products with Highest Quantity Sold (Internet and Reseller)**

#### Query:

```sql
SELECT TOP 2 PC.EnglishProductCategoryName, SUM(OrderQuantity) AS Total_OrderQuantity
FROM dbo.DimProduct DP
JOIN (SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount
FROM dbo.FactResellerSales
UNION ALL
SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount
FROM dbo.FactInternetSales) SM ON SM.ProductKey = DP.ProductKey
JOIN dbo.DimProductSubcategory PS ON PS.ProductSubcategoryKey = DP.ProductSubcategoryKey
JOIN dbo.DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
GROUP BY PC.ProductCategoryKey, PC.EnglishProductCategoryName
ORDER BY Total_OrderQuantity DESC
```

#### Explanation:

* **Purpose**: To find the top 2 products with the highest quantity sold across both Internet and Reseller sales channels.
* **Key Components**:

  * **`TOP 2`**: Limits the result to the top 2 products with the highest quantity sold.
  * **`SUM(OrderQuantity)`**: Sums the order quantity for each product category.
  * **`UNION ALL`**: Combines both Internet and Reseller sales data.
  * The result is ordered by total quantity in descending order.

---

### **Q6: Sales and Quantity for Each Product Category by Calendar Year**

#### Query:

```sql
SELECT D.CalendarYear, PC.EnglishProductCategoryName, ROUND(SUM(SM.SalesAmount), 2) Total_Sales, SUM(OrderQuantity) AS Total_OrderQuantity
FROM dbo.DimProduct DP
JOIN (SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount
FROM dbo.FactResellerSales
UNION ALL
SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount
FROM dbo.FactInternetSales) SM ON SM.ProductKey = DP.ProductKey
JOIN dbo.DimProductSubcategory PS ON PS.ProductSubcategoryKey = DP.ProductSubcategoryKey
JOIN dbo.DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
JOIN dbo.DimDate D ON D.DateKey = SM.OrderDateKey
GROUP BY D.CalendarYear, PC.ProductCategoryKey, PC.EnglishProductCategoryName
```

#### Explanation:

* **Purpose**: To calculate sales and quantity for each product category across all years.
* **Key Components**:

  * **`SUM(SM.SalesAmount)`**: Sums sales amounts for each product category.
  * **`SUM(OrderQuantity)`**: Sums the order quantity for each product category.
  * **`GROUP BY`**: Groups by product category and calendar year.
  * **`JOIN`**: Combines sales data with product categories and dates.

---

### **Q7: Year-over-Year Sales Growth (2013 vs. 2012)**

#### Query:

```sql
WITH CTE AS (
  SELECT ROUND(SUM(CASE WHEN D.CalendarYear = '2013' THEN T.SalesAmount ELSE 0 END), 2) AS Sales_2013,
  ROUND(SUM(CASE WHEN D.CalendarYear = '2012' THEN T.SalesAmount ELSE 0 END), 2) AS Sales_2012
  FROM (SELECT OrderDateKey, SalesAmount
  FROM dbo.FactResellerSales
  UNION ALL
  SELECT OrderDateKey, SalesAmount
  FROM dbo.FactInternetSales) T
  JOIN dbo.DimDate D ON D.DateKey = T.OrderDateKey
)
SELECT Sales_2013, Sales_2012, ROUND((Sales_2013 - Sales_2012) / Sales_2012 * 100, 2) AS YoYGrowthPercentage
FROM CTE
```

#### Explanation:

* **Purpose**: To calculate the year-over-year (YoY) sales growth percentage for 2013 compared to 2012.
* **Key Components**:

  * **`CASE WHEN`**: Conditionally sums sales based on the year (2013 and 2012).
  * **`ROUND()`**: Rounds the sales amount to two decimal places.
  * **YoY Growth Calculation**: `(Sales_2013 - Sales_2012) / Sales_2012 * 100`.

---

### **Q8: Customer with the Highest Number of Internet Orders and Sales Each Year**

#### Query:

```sql
WITH CTE AS (
  SELECT CalendarYear, Customer_Name, AddressLine1, Phone, EmailAddress, Total_Qty, Total_Sales,
  RANK() OVER(PARTITION BY CalendarYear ORDER BY Total_Qty DESC, Total_Sales DESC) AS RNK
  FROM (SELECT D.CalendarYear, C.FirstName + ' ' + C.LastName AS Customer_Name, C.AddressLine1, C.Phone, C.EmailAddress,
  SUM(OrderQuantity) AS Total_Qty, ROUND(SUM(S.SalesAmount), 2) AS Total_Sales
  FROM dbo.DimCustomer C
  JOIN dbo.FactInternetSales S ON S.CustomerKey = C.CustomerKey
  JOIN dbo.DimDate D ON D.DateKey = S.OrderDateKey
  GROUP BY D.CalendarYear, C.FirstName, C.LastName, C.BirthDate, C.AddressLine1, C.Phone, C.EmailAddress
  HAVING SUM(OrderQuantity) > 5) T
)
SELECT CalendarYear, Customer_Name, AddressLine1, Phone, EmailAddress, Total_Qty, Total_Sales
FROM CTE
WHERE RNK = 1
```

#### Explanation:

* **Purpose**: To find the customer with the highest number of internet orders and sales each year.
* **Key Components**:

  * **`RANK() OVER(PARTITION BY)`**: Ranks customers within each year based on the quantity of orders and total sales.
  * **`HAVING SUM(OrderQuantity) > 5`**: Filters customers with more than 5 orders.
  * **CTE (Common Table Expression)**: Identifies the top customer each year based on total quantity and sales.

---

## Conclusion:

This documentation covers the SQL queries needed for various business analytics tasks, including sales analysis, product performance, and customer behavior insights. The queries combine data from multiple tables and aggregate information to provide meaningful metrics for decision-making.
