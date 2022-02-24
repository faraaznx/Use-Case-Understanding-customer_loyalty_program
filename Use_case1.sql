-- Q1 What is the total amount each customer spent at the restaurant?
SELECT 
    customer_id, SUM(price)
FROM
    sales
        JOIN
    members USING (customer_id)
        JOIN
    menu USING (product_id)
GROUP BY 1
ORDER BY 1;
 
  -- Q2 How many days has each customer visited the restaurant?
SELECT 
    customer_id, COUNT(DISTINCT order_date) AS time_visited
FROM
    sales
GROUP BY 1;

-- Q3 What was the first item from the menu purchased by each customer?
SELECT DISTINCT customer_id, product_name FROM
(SELECT *, RANK() OVER (PARTITION BY customer_id ORDER BY order_date) as rn
 FROM sales 
 JOIN members USING (customer_id) 
 JOIN menu USING(product_id)) r
 WHERE rn = 1;
 
 -- Q-4 What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
    product_name, COUNT(product_name)
FROM
    sales
        JOIN
    members USING (customer_id)
        JOIN
    menu USING (product_id)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
 
 -- Q-5 Which item was the most popular for each customer? 
SELECT 
    customer_id, MAX(product_name), MAX(counts)
FROM
    (SELECT 
        customer_id, product_name, COUNT(product_name) AS counts
    FROM
        sales
    JOIN members USING (customer_id)
    JOIN menu USING (product_id)
    GROUP BY 1 , 2) sq
GROUP BY 1;

-- Q6) Which item was purchased first by the customer after they became a member?
SELECT customer_id, product_name 
FROM
(SELECT customer_id, join_date, order_date, product_name, RANK() OVER (PARTITION BY customer_id ORDER BY order_date) as rn
 FROM sales 
 JOIN members USING (customer_id) 
 JOIN menu USING(product_id)
 WHERE order_date >= join_date) sq
 WHERE rn = 1;
 
 -- Q7 Which item was purchased just before the customer became a member?
SELECT customer_id, product_name, order_date FROM
(SELECT customer_id, join_date, order_date, product_name, RANK() OVER (PARTITION BY customer_id ORDER BY order_date DESC) as rn
 FROM sales 
 JOIN members USING (customer_id) 
 JOIN menu USING(product_id)
 WHERE order_date < join_date) sq
WHERE rn = 1;

 -- Q8 What is the total items and amount spent for each member before they became a member? 
 SELECT customer_id, COUNT(product_name), total_amount FROM
 (SELECT customer_id, product_name, price, SUM(price) OVER (PARTITION BY customer_id) AS total_amount
 FROM sales 
 JOIN members USING (customer_id) 
 JOIN menu USING(product_id)
 WHERE order_date< join_date) sq
 
 GROUP BY 1,3;
 
 -- Q9 If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have? 

SELECT DISTINCT customer_id, SUM(CASE WHEN product_name = 'sushi' THEN price*20 ELSE price*10 END) OVER (PARTITION BY customer_id)
 FROM sales 
 JOIN members USING (customer_id) 
 JOIN menu USING(product_id);
 
  -- Q10 In the first week after a customer joins the program (including their join date) they earn 
-- 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

SELECT 
    customer_id,
    SUM(CASE
        WHEN (diff IN (1 , 6) OR product_id = 1) THEN price * 20
        ELSE price * 10
    END) AS points
FROM
    (SELECT 
        customer_id,
            order_date,
            join_date,
            (order_date - join_date) AS diff,
            price,
            product_id
    FROM
        sales
    JOIN members USING (customer_id)
    JOIN menu USING (product_id)) sq
GROUP BY 1;

 