-- Select all customers from Pakistan.
select * from customers
where country ='Pakistan';
-- Get the names and emails of customers who signed up after March 2023.
select name,email from customers
where signup_date>2023-03-31;
-- List all products in the "Electronics" category.
select * from products 
where category='Electronics';
-- Show all orders placed in June 2023.
select * from orders
where order_date between '2023-06-01' AND '2023-06-30';
-- Find the total number of orders.
select count(*) As total_order from orders;
-- List all distinct payment methods used.
select distinct payment_method from orders;
-- What is the total revenue from all orders?
select sum(total_amount) as total_revenue from orders;
-- Find customers who made more than one order.
select customer_id,count(*) As order_count from orders
group by customer_id
having order_count>1 ;
-- List each customer with their total number of orders.
select c.name,count(o.order_id) As total_order from customers c
left join orders o on c.customer_id=o.customer_id 
group by c.name;
-- Show the total amount each customer has spent.
select c.name, sum(o.total_amount) as total_amount_spent from customers c
join orders o on c.customer_id=o.customer_id
group by c.name;
-- Which product was sold the most (by quantity)?
select product_name,sum(quantity) as most_sold_product from products
join order_items on products.product_id=order_items.product_id
group by product_name
order by most_sold_product desc
Limit 1;
-- Which customer has the highest total spend?
select c.name as customer,sum(total_amount) as highest_total_spent from customers c
join orders o on c.customer_id=o.customer_id
group by customer
order by highest_total_spent Desc
limit 1;
-- Find the average order value.
select avg(total_amount) as avg_order_value from orders;
-- Show monthly sales totals.
select month(order_date) as Months,sum(total_amount) from orders
group by months;
-- List all orders with their product names and quantities.
SELECT o.order_id, p.product_name, oi.quantity
FROM orders o
join order_items oi on o.order_id=oi.order_id
join products p on p.product_id=oi.product_id;
-- Which city has the most customers?
select city,count(customer_id) as Most_customers from customers
group by city
order by Most_customers desc
limit 1;
-- Count how many support tickets are unresolved.
select  count(*) As unresolved_ticket from support_tickets
where resolved='0';
-- Find the most recent order for each customer (use ROW_NUMBER()).
with rank_order As (
select * , row_number() over(partition by customer_id order by order_date desc) as row_No
from orders)
select * from rank_order
where row_No=1;
-- Show customers who have never placed an order.
select c.* from customers c
left join orders o on c.customer_id=o.customer_id
where order_id is null;
-- Rank customers by total spending (use RANK() or DENSE_RANK()).
select c.name as customer,sum(total_amount) as total_spending,
rank() over (order by sum(o.total_amount) Desc ) As Rnk
from customers c
join orders o on c.customer_id= o.customer_id
group by customer;
-- Use a CTE to get top 3 most purchased products.
with top_3 as(
select product_id,sum(quantity) as total_quantity from order_items 
group by product_id)
select p.product_name ,t.total_quantity from top_3 as t
join products p on t.product_id = p.product_id
order by t.total_quantity desc
limit 3;
-- What percentage of orders were paid using each payment method?
select payment_method,round(100.0*count(*)/(select count(*) from orders),2) as Percentage
from orders
group by payment_method;
-- Join customers and support_tickets to show customer name with issue_type.
select name,issue_type from customers
join support_tickets on customers.customer_id=support_tickets.customer_id;
-- List each customer and the total number of products they’ve purchased.
select cus.name,sum(oi.quantity) from customers as cus
join orders o on cus.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id
group by cus.name;
-- Show total revenue by product category.
select p.category,sum(oi.price_each*oi.quantity) as total_revenue from order_items as oi
join products p on oi.product_id=p.product_id
group by category;




