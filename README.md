# Superstore Sales Analysis using SQL Server 🗄️

## About the Project
I analyzed a **Superstore sales dataset** using SQL Server to understand **sales trends, top customers, and product performance**.  
This project focuses entirely on **data extraction, transformation, and analysis using SQL**, showing how raw data can be converted into actionable insights.

---

## Project Process
The steps I followed for this project:

- **Data Extraction:** Loaded the Superstore dataset into SQL Server and created tables for `sales`, `products`, and `customers`.  
- **Data Cleaning:** Handled missing values and renamed columns for clarity.  

---

## Problem
The business did not have a clear view of important metrics like **total sales, profit, and quantity**.  
Because of this, stakeholders faced challenges in decision-making.  
The dataset includes **three main tables**: `customers`, `sales`, and `products`.

---

## Solution
To address these challenges, I **analyzed the data using SQL Server** and wrote queries to extract actionable insights.

---

## SQL Analysis


### 1. Find Total Revenue per Customer
This query calculates **total revenue for each customer** by joining the `customers`, `sales`, and `products` tables.

```sql
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(s.quantity * p.price) AS total_sales
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
LEFT JOIN products p ON s.product_id = p.product_id
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_sales DESC;

```
### 2.Find Total Sales per Product Category
This query calculates the **total sales** per category
```sql
select 
p.category,
coalesce(sum(s.quantity*p.price),0) as total_sales 
from products p left join sales s 
on p.product_id=s.product_id 
group by p.category
order by total_sales desc

```
### 3.Show Running Total of Monthly Sales
This query calculates the **running total** of the month
```sql
select 
month_number,
month_name,
current_sales,
sum(current_sales) over(order by month_number) as running_sales from 
(select 
month(s.sale_date) as month_number,
datename(month,s.sale_date) as month_name,
sum(s.quantity*p.price) as current_sales 
from sales s left join products p 
on s.product_id=p.product_id 
group by datename(month,s.sale_date),month(s.sale_date)
)t
```
### 4. Calculate month-over-month growth in sales
This query calculates the month over month growth %
```sql
with overview as 
(
select 
month(s.sale_date) as month_number,
datename(month,s.sale_date) as month_name,
sum(s.quantity*p.price) as current_sales 
from sales s left join products p 
on s.product_id=p.product_id 
group by datename(month,s.sale_date),month(s.sale_date)
),
details as 
(
select
month_number,
month_name,
current_sales,
lag(current_sales) over(order by month_number) as pm_sales from overview)
select 
month_number,
month_name,
current_sales,
pm_sales,
convert(decimal(10,2),((current_sales-pm_sales)*100.0/pm_sales)) as mom_growth 
from details 
