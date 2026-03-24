
alter database byy modify name=SQL_Analytics
----------------------------------------------------------


select * from customers
select * from products
select * from sales


--1 Select all customers.
select * from customers

--2 List first_name and last_name of customers in “Hyderabad”.
select first_name,last_name from customers where city='Hyderabad'

--3Select all products where price > 20000.
select * from products where price>20000

--4 Show top 3 expensive products with name and price.
select top 3 product_name,
sum(price) as total_price from products 
group by product_name 
order by sum(price) desc

--5 List all customers ordered by last_name.
select * from customers order by last_name

--6 Find total revenue per customer
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


--7 Find average order value per customer

with details as (select c.customer_id,
c.first_name,
c.last_name,
sum(s.quantity*p.price) as total_sales,
sum(s.sale_id) as total_order 
from customers c left join sales s 
on c.customer_id=s.customer_id
left join products p 
on s.product_id=p.product_id 
group by c.customer_id,
c.first_name,
c.last_name)
select 
customer_id,
first_name,
last_name,
total_sales,
total_order,
convert(decimal(10,2),total_sales/total_order) as avg_order_value
from details 
order by avg_order_value desc

--8 Find total sales per product category
select 
p.category,
coalesce(sum(s.quantity*p.price),0) as total_sales 
from products p left join sales s 
on p.product_id=s.product_id 
group by p.category
order by total_sales desc


--9 List top 3 products by total revenue
select 
top 3 
p.product_name,
coalesce(sum(s.quantity*p.price),0) as total_sales 
from products p left join sales s 
on p.product_id=s.product_id 
group by p.product_name
order by total_sales desc

--10 Find customers who have not placed any orders
select
c.customer_id,
c.first_name,
c.last_name 
from customers c left join sales s 
on c.customer_id=s.customer_id 
where s.sale_id is null

--11 Find total quantity sold per product
select 
p.product_name,
coalesce(sum(s.quantity),0) as total_quantity
from products p left join sales s 
on p.product_id=s.product_id 
group by p.product_name
order by total_quantity desc


--12 Find percentage contribution of each product to total revenue

with details as 
(
select 
p.product_name,
coalesce(sum(s.quantity*p.price),0) as total_revenue,
sum(p.price) as total_price
from products p left join sales s 
on p.product_id=s.product_id 
group by p.product_name

)
select product_name,
total_revenue,
total_price,
convert(decimal(10,2),(total_price/total_revenue)*100.0) as sales_percentage 
from details
order by total_revenue desc

--13 Show monthly sales

select 
month(s.sale_date) as month_number,
datename(month,s.sale_date) as month_name,
sum(s.quantity*p.price) as toal_sales 
from sales s left join products p 
on s.product_id=p.product_id 
group by datename(month,s.sale_date),month(s.sale_date)
order by month_number

--14 Show running total of monthly sales

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

--15 Calculate month-over-month growth in sales

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


--16 Find top 2 customers per city by total sales

with overview as 
(
select 
c.first_name,
c.last_name,
c.city,
coalesce(sum(s.quantity*p.price),0) as total_sales 
from customers c left join sales s 
on c.customer_id=s.customer_id
left join products p 
on s.product_id=p.product_id 
group by c.first_name,c.city,
c.last_name
),
details as 
(select *,DENSE_RANK() over(partition by city order by total_sales desc) as ranks from overview)
select * from details where ranks <=2


--17 Find top 2 products per category by revenue

with overview as 
(
select 
p.product_name,
p.category,
coalesce(sum(s.quantity*p.price),0) as total_sales 
from products p left join sales s 
on p.product_id=s.product_id 
group by p.product_name,p.category
),
details as
(select *,dense_rank() over(partition by category order by total_sales desc) as ranks from overview)
select * from details where ranks <=2


--18 Find top customer overall by total revenue

with details as 
(
select 
c.first_name,
c.last_name,
coalesce(sum(s.quantity*p.price),0) as total_sales 
from customers c left join sales s 
on c.customer_id=s.customer_id
left join products p
on s.product_id=p.product_id 
group by c.first_name,c.last_name
)
select *,rank() over(order by total_sales desc) as ranks from details


--19 Find products that never sold

select p.product_name 
from products p left join sales s 
on p.product_id=s.product_id 
where s.sale_id is null

--20 Find customers who bought more than 2 units in a single order

select
c.customer_id,
c.first_name,
c.last_name,
p.product_name,
s.quantity
from customers c left join sales s 
on c.customer_id=s.customer_id
left join products p 
on s.product_id=p.product_id
where s.quantity>2
order by c.customer_id
--------------------------------------------------------