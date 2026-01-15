# Global-Retail-SQL-Analysis-
This project performs end-to-end SQL analysis on a global retail dataset, including schema design, data cleaning, currency normalization, and business performance analytics. It answers real business questions related to revenue, product profitability, customer value, and store efficiency.
# Tools Used
MySQL
SQL (Joins, Aggregations, Date Functions)
Excel (for initial CSV preprocessing)
GitHub (project hosting)

## Dataset

The dataset contains five relational tables:

- **Sales** – Transaction-level data for every product sold  
- **Customers** – Customer demographics and location  
- **Products** – Product details including price and cost  
- **Stores** – Store location, size, and opening date  
- **Exchange_Rates** – Currency conversion rates by date  

Sales data is recorded in multiple currencies and converted to USD using exchange rates.

### Business Question Answered:
**Revenue & Sales Performance**
1. What is the total revenue of the company in USD?
2. What is the total revenue by year?
3. What is the total revenue by month?
4. Which country generates the highest revenue?
5. Which store generates the highest revenue?
6. What is the average order value in USD?
**Product Performance**
7. Which are the top 10 best-selling products by quantity?
8. Which products generate the highest revenue?
9. Which products generate the highest profit?
10. Which product categories are the most profitable?
11. Are there any products that are being sold at a loss?
**Customer Analytics**
12. Who are the top 10 customers by total spending?
13. What is the average customer lifetime value?
14. Which country has the highest-value customers?
15. Do male or female customers spend more on average?
**Store & Operations**
16. Which stores are underperforming based on revenue per square meter?
17. Do older stores perform better than newly opened stores?
18. Which countries have the most efficient stores?

## Project Structure

- `data/` – Raw CSV files for all tables  
- `sql/data_cleaning.sql` – Scripts for fixing date formats and data issues  
- `sql/main_analysis.sql` – SQL queries answering all business questions  
- `screenshots/` – Query result images  
- `README.md` – Project documentation  

## How to Run This Project

1. Import the CSV files into MySQL  
2. Run `data_cleaning.sql` to fix date and currency issues  
3. Run `main_analysis.sql` to generate business insights  
4. View query results in MySQL Workbench or using the screenshots provided  
