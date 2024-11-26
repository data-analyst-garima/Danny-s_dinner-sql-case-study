CREATE SCHEMA dannys_diner;
use dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  select * from  sales;
  
  -- 1. What is the total amount each customer spent at the restaurant?
 SELECT s.customer_id,SUM(m.price) AS total_spent FROM sales s JOIN menu m ON s.product_id = m.product_id GROUP BY s.customer_id;

-- 2. How many days has each customer visited the restaurant?
select * from sales;
select customer_id , count(distinct(order_date)) from sales group by customer_id;

-- 3. What was the first item from the menu purchased by each customer?
with first_purchase as (
select customer_id,min(order_date) as first_order_date 
from sales
group by customer_id)
select fp.customer_id , m.product_name from first_purchase fp join sales s on fp.customer_id = s.customer_id and fp.first_order_date = s.order_date
join menu m on s.product_id = m.product_id;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select product_id,count(product_id) from sales group by product_id;
select count(customer_id),customer_id  from sales where product_id = 3 group by customer_id ; 
  
-- 5. Which item was the most popular for each customer?

create temporary table temp1(select customer_id, product_id,count(product_id) as purchase_count 
from sales
group by customer_id, product_id
order by customer_id, product_id desc);

select * from temp1;
 
select customer_id,product_id,purchase_count
from temp1
where product_id = 3;

-- 6. Which item was purchased first by the customer after they became a member?

select s.customer_id,s.order_date,s.product_id from sales s join
(SELECT s.customer_id, MIN(s.order_date) AS first_order_date
FROM sales s
JOIN members mm ON s.customer_id = mm.customer_id
WHERE s.order_date >= mm.join_date
GROUP BY s.customer_id) first_orders on s.customer_id = first_orders.customer_id
AND s.order_date = first_orders.first_order_date ;

-- 7. Which item was purchased just before the customer became a member?

select s.customer_id,s.order_date,s.product_id from sales s join
(SELECT s.customer_id, max(s.order_date) AS first_order_date
FROM sales s
JOIN members mm ON s.customer_id = mm.customer_id
WHERE s.order_date <= mm.join_date
GROUP BY s.customer_id) first_orders on s.customer_id = first_orders.customer_id
AND s.order_date = first_orders.first_order_date ;

-- 8. What is the total items and amount spent for each member before they became a member?

select s.customer_id,count(s.product_id) as total_items,sum(m.price) as total_amount
from sales s join members mm 
on s.customer_id = mm.customer_id
join menu m on s.product_id = m.product_id
where s.order_date < mm.join_date
group by s.customer_id; 
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT s.customer_id,
    SUM(
        CASE 
            WHEN m.product_name = 'sushi' THEN (m.price * 10 * 2) 
            ELSE (m.price * 10) 
        END
    ) AS total_points
FROM sales s
JOIN menu m 
    ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
  
  SELECT 
    s.customer_id,
    SUM(
        CASE 
            WHEN s.order_date BETWEEN mm.join_date AND DATE_ADD(mm.join_date, INTERVAL 6 DAY) THEN (m.price * 10 * 2) -- 2x for all items in first week
            WHEN m.product_name = 'sushi' THEN (m.price * 10 * 2) -- 2x for sushi
            ELSE (m.price * 10) -- Regular points for other items
        END
    ) AS total_points
FROM sales s
JOIN members mm 
    ON s.customer_id = mm.customer_id
JOIN menu m 
    ON s.product_id = m.product_id
WHERE s.order_date < '2021-02-01' -- Filter for January
GROUP BY s.customer_id
HAVING s.customer_id IN ('A', 'B'); -- Restrict to customers A and B

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  