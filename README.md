# Superstore Sales Analysis using SQL Server 

## About the Project
I analyzed a Superstore sales dataset using SQL Server to understand sales trends, top customers, and product performance.  
This project focuses entirely on data extraction, transformation, and analysis using SQL, showing how raw data can be converted into actionable insights.

---
# The below line is the process that i did with this project:
- **Data Extraction:** Loaded the Superstore dataset into SQL Server and created tables for sales, products, and customers.  
- **Data Cleaning:** Handled missing values, renamed columns for clarity:

# problem 
The Business didnt have clear view of the important metrices like total_sales,profit,quantity like this .
because of this the stakeholder facing many problem.
I used the sql server to extract some imporant information from the database.
I have 3 Table first is the customers,sales and products .
#Solution
To solve this i analyzed the  the data using sql server .

```sql
1.Find total revenue per customer
select c.customer_id,
c.first_name,
c.last_name,
sum(s.quantity*p.price) as total_sales 
from customers c left join sales s 
on c.customer_id=s.customer_id
left join products p 
on s.product_id=p.product_id 
group by c.customer_id,
c.first_name,
c.last_name
order by total_sales desc
