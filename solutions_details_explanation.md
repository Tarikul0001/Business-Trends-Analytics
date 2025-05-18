
---

## 🔷 **Q.1 Write a query to identify the top 10 over-70-year-old clients with the biggest internet sales. Name, age, phone number, email address, and total sales amount of the consumer are displayed.**

```sql
SELECT TOP 10 C.FirstName + ' ' + C.LastName AS Customer_Name, C.AddressLine1, DATEDIFF(YEAR,CONVERT(DATE,BirthDate),GETDATE()) AS Age, C.Phone, C.EmailAddress
, ROUND (SUM(FIS.SalesAmount),2) AS Total_Sales
```

### 🔍 Line-by-Line Breakdown:

* `TOP 10`: Limits the output to only the 10 customers with **highest sales**.
* `C.FirstName + ' ' + C.LastName AS Customer_Name`: Combines first and last name into a single display name.
* `DATEDIFF(YEAR,CONVERT(DATE,BirthDate),GETDATE()) AS Age`: Calculates the customer's age by subtracting their birth year from the current date.
* `ROUND (SUM(FIS.SalesAmount),2) AS Total_Sales`: Totals up all **Internet Sales** per customer and rounds to 2 decimal places.

```sql
FROM dbo.DimCustomer C
JOIN dbo.FactInternetSales FIS ON C.CustomerKey = FIS.CustomerKey
```

* Joins **Customer** and **Internet Sales** tables using the `CustomerKey`.

```sql
WHERE DATEDIFF(YEAR, CONVERT(DATE,BirthDate), GETDATE()) > 70
```

* Filters for **customers older than 70**.

```sql
GROUP BY ... 
ORDER BY Total_Sales DESC
```

* Groups the data per customer to **aggregate** their sales.
* Sorts by `Total_Sales` in **descending order** so the highest-spending customers are first.

### 🧠 Why This Matters:

* Identifies **senior customers** who are still highly active online.
* This data helps in making decisions for **senior-targeted campaigns**, loyalty programs, and personalized offers.

---

## 🔷 **Q.2 Write a query to calculate the total sales (Internet and Reseller) for each product category. ProductCategoryKey, EnglishProductCategoryName, and total sales amount of the consumer are displayed.**

```sql
SELECT PC.ProductCategoryKey, PC.EnglishProductCategoryName, ROUND(SUM(SM.SalesAmount), 2) AS Total_Sales
```

* Selects each product category and **calculates total sales**.
* `ROUND(SUM(SM.SalesAmount),2) Total_Sales` ensures the output is suitable for reporting.

```sql
FROM dbo.DimProduct DP
JOIN (
    SELECT ProductKey, SalesAmount FROM dbo.FactResellerSales
    UNION ALL
    SELECT ProductKey, SalesAmount FROM dbo.FactInternetSales
) SM ON SM.ProductKey = DP.ProductKey
```

* Combines **reseller and internet sales** using `UNION ALL`.
* Joins this result with the **Product dimension** so each sale is linked to a product.

```sql
JOIN dbo.DimProductSubcategory PS ON PS.ProductSubcategoryKey = DP.ProductSubcategoryKey
JOIN dbo.DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
```

* Traverses the product hierarchy:

  * Product ➝ Subcategory ➝ Category

```sql
GROUP BY PC.ProductCategoryKey, PC.EnglishProductCategoryName
ORDER BY Total_Sales DESC
```

* Aggregates and orders by total sales.

### 🧠 Why This Matters:

* Helps the business know **which product categories** are generating the most revenue.
* Supports **category-level decision making** for promotions, inventory, and forecasting.

---

## 🔷 **Q3: Monthly Sales Totals for 2013**

```sql
SELECT D.CalendarYear, D.MonthNumberOfYear, D.EnglishMonthName, ROUND(SUM(S.SalesAmount), 2) AS Total_Sales
```

* Shows **year**, **month number**, and **month name**, along with total sales.

```sql
FROM dbo.DimDate D 
JOIN (
    SELECT OrderDateKey, SalesAmount FROM dbo.FactResellerSales
    UNION ALL
    SELECT OrderDateKey, SalesAmount FROM dbo.FactInternetSales
) S ON S.OrderDateKey = D.DateKey
```

* Merges both sales sources.
* Links sales to the **date dimension** so we can group by month/year.

```sql
WHERE D.CalendarYear = '2013'
GROUP BY D.CalendarYear, D.MonthNumberOfYear, D.EnglishMonthName
ORDER BY D.MonthNumberOfYear
```

* Filters for the **year 2013** only.
* Groups by **month** to show monthly trends.

### 🧠 Why This Matters:

* Crucial for analyzing **seasonal patterns**.
* Helps plan for **inventory, marketing** and understand customer behavior throughout the year.

---

## 🔷 **Q4: Top-Performing Region in Each Country**

```sql
WITH CTE AS (
  SELECT T.SalesTerritoryCountry, T.SalesTerritoryRegion, T.Total_Sales,
  RANK() OVER(PARTITION BY T.SalesTerritoryCountry ORDER BY T.Total_Sales DESC) AS RANK
```

* `RANK() OVER (PARTITION BY ...)`: Ranks **regions within each country** by sales.
* The **Common Table Expression (CTE)** is used to isolate top regions.

```sql
FROM (
  SELECT ST.SalesTerritoryRegion, ST.SalesTerritoryCountry, ROUND(SUM(S.SalesAmount), 2) AS Total_Sales
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
FROM CTE WHERE RANK = 1
ORDER BY Total_Sales DESC
```

### 🧠 Why This Matters:

* Pinpoints the **highest performing region** per country.
* Informs decisions on **where to allocate resources, staff, or marketing budgets**.

---

## 🔷 **Q5: Top 2 Products by Quantity Sold**

```sql
SELECT TOP 2 PC.EnglishProductCategoryName, SUM(OrderQuantity) AS Total_OrderQuantity
```

* Shows product categories that sold **the most units**, not just value.

```sql
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

### 🧠 Why This Matters:

* Tells us which products are **fast-moving** or high in demand.
* Useful for **restocking, promotions**, and **supply chain optimization**.

---

## 🔷 **Q6: Yearly Sales and Quantity by Product Category**

```sql
SELECT D.CalendarYear, PC.EnglishProductCategoryName, ROUND(SUM(SM.SalesAmount),2) AS Total_Sales, SUM(OrderQuantity) AS Total_OrderQuantity
```

* Combines **year, category, sales amount**, and **units sold**.

```sql
FROM dbo.DimProduct DP
JOIN (
    SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount FROM dbo.FactResellerSales
    UNION ALL
    SELECT OrderDateKey, ProductKey, OrderQuantity, SalesAmount FROM dbo.FactInternetSales
) SM ON SM.ProductKey = DP.ProductKey
JOIN dbo.DimProductSubcategory PS ...
JOIN dbo.DimProductCategory PC ...
JOIN dbo.DimDate D ON D.DateKey = SM.OrderDateKey
GROUP BY D.CalendarYear, PC.ProductCategoryKey, PC.EnglishProductCategoryName
```

### 🧠 Why This Matters:

* Offers a **historical performance breakdown** by category.
* Aids in **year-over-year product trend analysis**.

---

## 🔷 **Q7: Year-over-Year Sales Growth (2012 vs 2013)**

```sql
WITH CTE AS (
  SELECT 
    ROUND(SUM(CASE WHEN D.CalendarYear = '2013' THEN T.SalesAmount ELSE 0 END),2) AS Sales_2013,
    ROUND(SUM(CASE WHEN D.CalendarYear = '2012' THEN T.SalesAmount ELSE 0 END),2) AS Sales_2012
```

* Uses `CASE` to split totals into 2013 and 2012 buckets.
* `ROUND(SUM(...))` gives neatly formatted numbers.

```sql
FROM (
  SELECT OrderDateKey, SalesAmount FROM dbo.FactResellerSales
  UNION ALL
  SELECT OrderDateKey, SalesAmount FROM dbo.FactInternetSales
) T
JOIN dbo.DimDate D ON D.DateKey = T.OrderDateKey
)
SELECT Sales_2013, Sales_2012, 
ROUND((Sales_2013 - Sales_2012) / Sales_2012 * 100, 2) AS YoYGrowthPercentage
FROM CTE
```

### 🧠 Why This Matters:

* This is a **KPI** — shows business growth year over year.
* Critical for investors, executives, and planning.

---

## 🔷 **Q8: Top Online Customer by Year**

```sql
```


WITH CTE AS (
SELECT CalendarYear, Customer\_Name, ..., Total\_Qty, Total\_Sales,
RANK() OVER(PARTITION BY CalendarYear ORDER BY Total\_Qty DESC, Total\_Sales DESC) AS RNK

````

- `RANK()` gives priority to customers with **most orders**, then **highest spending**.
- `PARTITION BY CalendarYear`: Finds best customer **per year**.

```sql
FROM (
  SELECT D.CalendarYear, ..., SUM(OrderQuantity) AS Total_Qty, ROUND(SUM(S.SalesAmount),2) AS Total_Sales
  ...
  HAVING SUM(OrderQuantity) > 5
) T
)
SELECT ...
FROM CTE WHERE RNK = 1
````

### 🧠 Why This Matters:

* Recognizes **loyal and high-value customers**.
* Essential for **CRM, VIP programs**, or targeted communication.

---
