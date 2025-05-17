

## **Q.1 Write a query to identify the top 10 over-70-year-old clients with the biggest internet sales. Name, age, phone number, email address, and total sales amount of the consumer are displayed.**

**Purpose:**
Identify the top 10 customers over 70 years old with the highest total internet sales, displaying their name, age, phone number, email address, and total sales amount.

```sql
SELECT TOP 10 C.FirstName + ' ' + C.LastName AS Customer_Name, C.AddressLine1, DATEDIFF(YEAR,CONVERT(DATE,BirthDate),GETDATE()) AS Age, C.Phone, C.EmailAddress
, ROUND (SUM(FIS.SalesAmount),2) AS Total_Sales
FROM dbo.DimCustomer C
JOIN dbo.FactInternetSales FIS ON C.CustomerKey = FIS.CustomerKey
WHERE DATEDIFF(YEAR,CONVERT(DATE,BirthDate),GETDATE()) > 70
GROUP BY C.CustomerKey, C.FirstName, C.LastName, C.BirthDate, C.AddressLine1, C.Phone, C.EmailAddress
ORDER BY Total_Sales DESC
```

**Explanation:**

Tables Involved:
DimCustomer (C): Contains customer information (e.g., FirstName, LastName, BirthDate, AddressLine1, Phone, EmailAddress, CustomerKey).
FactInternetSales (FIS): Contains internet sales transactions with fields like CustomerKey and SalesAmount.

Key Components:
Concatenation: C.FirstName + ' ' + C.LastName AS Customer_Name combines the first and last names into a single column.
Age Calculation: DATEDIFF(YEAR, CONVERT(DATE, BirthDate), GETDATE()) calculates the customer’s age by finding the year difference between BirthDate and the current date (GETDATE()). The CONVERT(DATE, BirthDate) ensures the BirthDate is in a proper date format.
Aggregation: ROUND(SUM(FIS.SalesAmount), 2) sums the SalesAmount for each customer and rounds to two decimal places.
Filtering: WHERE DATEDIFF(YEAR, CONVERT(DATE, BirthDate), GETDATE()) > 70 restricts the results to customers over 70 years old.
Grouping: GROUP BY C.CustomerKey, C.FirstName, C.LastName, C.BirthDate, C.AddressLine1, C.Phone, C.EmailAddress ensures aggregation by unique customers and includes all non-aggregated columns.
Limiting: TOP 10 restricts the output to the top 10 customers.
Sorting: ORDER BY Total_Sales DESC sorts results by total sales in descending order.
Logic Flow:
Join DimCustomer and FactInternetSales on CustomerKey to link customers with their internet sales.
Filter for customers over 70 using the WHERE clause.
Group by customer details to calculate total sales per customer.
Select the top 10 based on total sales, displaying the required fields


---

## **Q.2 – Total Sales by Product Category (Internet + Reseller)**

```sql
SELECT PC.ProductCategoryKey, PC.EnglishProductCategoryName, ROUND(SUM(SM.SalesAmount),2) Total_Sales
FROM dbo.DimProduct DP
JOIN (
    SELECT ProductKey, SalesAmount FROM dbo.FactResellerSales
    UNION ALL
    SELECT ProductKey, SalesAmount FROM dbo.FactInternetSales
) SM ON SM.ProductKey = DP.ProductKey
JOIN dbo.DimProductSubcategory PS ON PS.ProductSubcategoryKey = DP.ProductSubcategoryKey
JOIN dbo.DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
GROUP BY PC.ProductCategoryKey, PC.EnglishProductCategoryName
ORDER BY Total_Sales DESC
```

**Explanation:**

* Merges sales from Internet and Reseller.
* Links each sale to a **product**, its subcategory, and category.
* Sums sales per category and orders by sales descending.

---

## **Q.3 – Total Sales per Month for 2013**

```sql
SELECT D.CalendarYear, D.MonthNumberOfYear, D.EnglishMonthName, ROUND(SUM(S.SalesAmount),2) Total_Sales
FROM dbo.DimDate D
JOIN (
    SELECT OrderDateKey, SalesAmount FROM dbo.FactResellerSales
    UNION ALL
    SELECT OrderDateKey, SalesAmount FROM dbo.FactInternetSales
) S ON S.OrderDateKey = D.DateKey
WHERE D.CalendarYear = '2013'
GROUP BY D.CalendarYear, D.MonthNumberOfYear, D.EnglishMonthName
ORDER BY 2
```

**Explanation:**

* Combines both sales sources.
* Joins them to the `DimDate` table using `OrderDateKey`.
* Filters for year 2013 and groups by month.
* Displays sales per month.

---

## **Q.4 – Top Sales Region per Country**

```sql
WITH CTE AS (
    SELECT T.SalesTerritoryCountry, T.SalesTerritoryRegion, T.Total_Sales,
    RANK() OVER(PARTITION BY T.SalesTerritoryCountry ORDER BY T.Total_Sales DESC) AS RANK
    FROM (
        SELECT ST.SalesTerritoryRegion, ST.SalesTerritoryCountry, ROUND(SUM(S.SalesAmount),2) Total_Sales
        FROM dbo.DimSalesTerritory ST
        JOIN (
            SELECT SalesTerritoryKey, SalesAmount FROM dbo.FactResellerSales
            UNION ALL
            SELECT SalesTerritoryKey, SalesAmount FROM dbo.FactInternetSales
        ) S ON S.SalesTerritoryKey = ST.SalesTerritoryKey
        GROUP BY ST.SalesTerritoryRegion, ST.SalesTerritoryCountry
    ) T
)
SELECT SalesTerritoryCountry, SalesTerritoryRegion, Total_Sales
FROM CTE
WHERE RANK = 1
ORDER BY Total_Sales DESC
```

**Explanation:**

* Calculates total sales for each **region in each country**.
* Uses `RANK()` to find the **top-performing region** (i.e., rank = 1) in each country.
* Returns country, region, and total sales.

---

## **Q.5 – Top 2 Products by Quantity Sold**

```sql
SELECT TOP 2 PC.EnglishProductCategoryName, SUM(OrderQuantity) AS Total_OrderQuantity
FROM dbo.DimProduct DP
JOIN (
    SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount FROM dbo.FactResellerSales
    UNION ALL
    SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount FROM dbo.FactInternetSales
) SM ON SM.ProductKey = DP.ProductKey
JOIN dbo.DimProductSubcategory PS ON PS.ProductSubcategoryKey = DP.ProductSubcategoryKey
JOIN dbo.DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
GROUP BY PC.ProductCategoryKey, PC.EnglishProductCategoryName
ORDER BY Total_OrderQuantity DESC
```

**Explanation:**

* Combines Internet and Reseller sales.
* Groups by **product category**.
* Sums quantity ordered, then returns **top 2 categories** with the most units sold.

---

## **Q.6 – Yearly Product Sales and Quantity**

```sql
SELECT D.CalendarYear, PC.EnglishProductCategoryName, ROUND(SUM(SM.SalesAmount),2) Total_Sales, SUM(OrderQuantity) AS Total_OrderQuantity
FROM dbo.DimProduct DP
JOIN (
    SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount FROM dbo.FactResellerSales
    UNION ALL
    SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount FROM dbo.FactInternetSales
) SM ON SM.ProductKey = DP.ProductKey
JOIN dbo.DimProductSubcategory PS ON PS.ProductSubcategoryKey = DP.ProductSubcategoryKey
JOIN dbo.DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
JOIN dbo.DimDate D ON D.DateKey = SM.OrderDateKey
GROUP BY D.CalendarYear, PC.ProductCategoryKey, PC.EnglishProductCategoryName
```

**Explanation:**

* Reports sales and quantity per **product category and year**.
* Combines Internet + Reseller sales.
* Aggregates by year and product category.

---

## **Q.7 – Year-over-Year (YoY) Sales Growth: 2013 vs 2012**

```sql
WITH CTE AS (
    SELECT 
    ROUND(SUM(CASE WHEN D.CalendarYear = '2013' THEN T.SalesAmount ELSE 0 END),2) AS Sales_2013,
    ROUND(SUM(CASE WHEN D.CalendarYear = '2012' THEN T.SalesAmount ELSE 0 END),2) AS Sales_2012
    FROM (
        SELECT OrderDateKey, SalesAmount FROM dbo.FactResellerSales
        UNION ALL
        SELECT OrderDateKey, SalesAmount FROM dbo.FactInternetSales
    ) T
    JOIN dbo.DimDate D ON D.DateKey = T.OrderDateKey
)
SELECT Sales_2013, Sales_2012, ROUND((Sales_2013 - Sales_2012) / Sales_2012 * 100, 2) AS YoYGrowthPercentage
FROM CTE
```

**Explanation:**

* Calculates total sales for 2012 and 2013.
* Computes YoY growth % = ((2013 - 2012) / 2012) \* 100.
* Shows how much sales increased (or decreased) from 2012 to 2013.

---

## **Q.8 – Top Internet Sales Customer per Year**

```sql
WITH CTE AS (
    SELECT CalendarYear, Customer_Name, AddressLine1, Phone, EmailAddress, Total_Qty, Total_Sales,
    RANK() OVER(PARTITION BY CalendarYear ORDER BY Total_Qty DESC, Total_Sales DESC) AS RNK
    FROM (
        SELECT D.CalendarYear, C.FirstName + ' ' + C.LastName AS Customer_Name, C.AddressLine1, C.Phone, C.EmailAddress,
        SUM(OrderQuantity) AS Total_Qty, ROUND(SUM(S.SalesAmount),2) AS Total_Sales
        FROM dbo.DimCustomer C
        JOIN dbo.FactInternetSales S ON S.CustomerKey = C.CustomerKey
        JOIN dbo.DimDate D ON D.DateKey = S.OrderDateKey
        GROUP BY D.CalendarYear, C.FirstName, C.LastName, C.BirthDate, C.AddressLine1, C.Phone, C.EmailAddress
        HAVING SUM(OrderQuantity) > 5
    ) T
)
SELECT CalendarYear, Customer_Name, AddressLine1, Phone, EmailAddress, Total_Qty, Total_Sales
FROM CTE
WHERE RNK = 1
```

**Explanation:**

* For each year, finds the **top customer** based on the **highest order quantity**, and breaks ties using total sales.
* Uses `RANK()` to find the top customer **per year**.
* Returns contact and sales info for each year's top internet customer.

---

If you'd like, I can help turn these into visual dashboards, optimization recommendations, or provide indexes for performance. Let me know
