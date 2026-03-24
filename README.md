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
