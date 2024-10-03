-- 1) Which product has the highest price? Only return a single row.
select product_name from products
where price=(select max(price) from products);
-- OR
select product_name,price from products
order by price desc
limit 1;

-- 2)  Which customer has made the most orders?
select * from order_items;
select concat(first_name," ",last_name) As Customer_name,count(o.order_id) As total_order
from customers c
join orders o on o.customer_id=c.customer_id
group by Customer_name,c.customer_id
order by total_order desc
limit 3;

-- 3) What's the total revenue per product?
select * from products;
select product_name,sum(price*quantity) As revenue
from products p
join order_items ot on ot.product_id=p.product_id
group by product_name
order by revenue desc;

-- 4) Find the orders and revenue trend

select order_date,count(o.order_id)As orders,sum(price*quantity) As revenue
from orders o
join order_items otm on otm.order_id=o.order_id
join products p on otm.product_id=p.product_id
group by order_date
order by order_date desc;

-- 5) Find the first order (by date) for each customer.
WITH first_orders AS (
SELECT CONCAT(first_name,' ',last_name) AS customer_name,product_name,
DENSE_RANK() OVER(PARTITION BY first_name,last_name ORDER BY order_date) AS rnk
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi 
ON o.order_id=oi.order_id
JOIN products p 
ON p.product_id=oi.product_id)
SELECT customer_name,GROUP_CONCAT(product_name) AS first_order_product
FROM first_orders
WHERE rnk=1
GROUP BY customer_name;

-- 6) Find the top 3 customers who have ordered the most distinct products
with customer As (
select concat(first_name,"",last_name) as customerName,count(distinct(product_id)) as unique_product
from customers c
join orders o on o.customer_id=c.customer_id
join order_items oi on oi.order_id=o.order_id
group by customerName)
select customerName,unique_product,DENSE_RANK() OVER(ORDER BY unique_product DESC) AS rnk
FROM customer;

-- 7) Which product has been bought the highest & least in terms of quantity?
with product_totals as (
select product_name,sum(quantity) as total_qty
from products p
join order_items oi on oi.product_id=p.product_id
group by product_name
)
select
     (select product_name from product_totals order by total_qty desc limit 1) as Most_order_product,
	 (SELECT product_name FROM product_totals ORDER BY total_qty ASC LIMIT 1) AS least_ordered_product;


