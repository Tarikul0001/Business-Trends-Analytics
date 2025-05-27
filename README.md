# Business-Trends-Analytics

## Project Overview
The **Business-Trends-Analytics** project is a collection of SQL queries designed to extract actionable insights from the AdventureWorksDW2016 data warehouse. This project focuses on analyzing customer demographics, product sales, regional performance, and year-over-year growth for both Internet and Reseller sales channels. The queries are optimized for Microsoft SQL Server and provide a foundation for business intelligence reporting and decision-making.

## Features
- Identify top customers based on age and sales.
- Aggregate sales by product category and region.
- Analyze monthly and yearly sales trends.
- Calculate year-over-year sales growth.
- Rank top-performing products and regions.

## Prerequisites
To run the queries in this project, you need:
- **Database**: AdventureWorksDW2016 database (available from Microsoft).
- **Database Management System**: Microsoft SQL Server (2016 or later).
- **SQL Client**: SQL Server Management Studio (SSMS) or any compatible SQL query tool.

## Installation
1. **Download AdventureWorksDW2016**:
   - Obtain the AdventureWorksDW2016 backup file from the [Microsoft SQL Server Samples repository](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2016.bak).
   - Restore the database to your SQL Server instance using SSMS or T-SQL.

2. **Clone this Repository**:
   ```bash
   git clone https://github.com/Tarikul0001/Business-Trends-Analytics.git
   cd Business-Trends-Analytics
   
   ```

3. **Set Up Database Connection**:
   - Configure your SQL client to connect to the SQL Server instance hosting the AdventureWorksDW2016 database.
   - Ensure the database is accessible with the appropriate credentials.

## Queries Overview
This project includes eight SQL queries, each addressing a specific business question. Below is a summary of each query:

1. **Top 10 Over-70-Year-Old Customers by Internet Sales**:
   - Identifies the top 10 customers aged over 70 with the highest Internet sales.
   - Displays customer name, age, phone, email, and total sales amount.

2. **Total Sales by Product Category**:
   - Aggregates Internet and Reseller sales for each product category.
   - Displays product category key, name, and total sales amount.

3. **Monthly Sales for 2013**:
   - Calculates total sales (Internet and Reseller) for each month in 2013.
   - Displays year, month number, month name, and total sales amount.

4. **Top-Performing Sales Region by Country**:
   - Identifies the top sales region in each country based on total sales.
   - Displays country, sales territory region, and total sales amount.

5. **Top 2 Products by Quantity Sold**:
   - Finds the top two product categories with the highest quantity sold across Internet and Reseller sales.
   - Displays product category name and total order quantity.

6. **Yearly Sales and Quantity by Product Category**:
   - Aggregates sales amount and quantity sold for each product category per calendar year.
   - Displays calendar year, product category name, total sales, and total order quantity.

7. **Year-Over-Year Sales Growth (2012 vs. 2013)**:
   - Calculates the percentage growth in total sales for 2013 compared to 2012.
   - Displays sales for 2012, 2013, and the growth percentage.

8. **Top Customer by Internet Orders and Sales per Year**:
   - Identifies the customer with the highest number of Internet orders and sales each year (with a minimum of 5 orders).
   - Displays year, customer name, address, phone, email, total quantity, and total sales.

## Usage
1. **Open SQL Files**:
   - Navigate to the `queries` folder in the repository.
   - Each query is stored in a separate `.sql` file (e.g., `q1_top_customers.sql`, `q2_product_sales.sql`, etc.).

2. **Execute Queries**:
   - Open the desired `.sql` file in SSMS or your SQL client.
   - Connect to the AdventureWorksDW2016 database.
   - Run the query to view results.

3. **Analyze Results**:
   - Results can be exported to CSV, Excel, or used in reporting tools like Power BI for visualization.

## Folder Structure
```
Business-Trends-Analytics/

├── questions.txt
├── solutions/
│   ├── q1_top_customers.sql
│   ├── q2_product_sales.sql
│   ├── q3_monthly_sales_2013.sql
│   ├── q4_top_sales_region.sql
│   ├── q5_top_products.sql
│   ├── q6_yearly_product_sales.sql
│   ├── q7_yoy_growth.sql
│   ├── q8_top_customer_yearly.sql
│ 
├── solutions_details_explanation.txt
├── README.md
```

## Contributing
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Add or modify queries in the `queries` folder.
4. Update the `README.md` if necessary.
5. Commit changes (`git commit -m "Add your message"`).
6. Push to the branch (`git push origin feature/your-feature`).
7. Open a Pull Request.

Please ensure your queries are well-documented and tested against the AdventureWorksDW2016 database.

## Contact
For questions or feedback, please open an issue on the GitHub repository or contact the project maintainer at [tarikul00001@gmail.com].

## Acknowledgements
- [Microsoft SQL Server Samples](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2016.bak) for providing the AdventureWorksDW2016 database.
- The open-source community for inspiration and resources.
