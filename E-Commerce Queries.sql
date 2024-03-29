SELECT * FROM clothing_ecommerce_sales;

/*Q 01: How many unique orders are there in the dataset?*/
-- ANSWER 01:

SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM clothing_ecommerce_sales;

/*Q 02: What is the average revenue per order? */
-- ANSWER 02:

SELECT AVG(revenue) AS average_revenue_per_order
FROM clothing_ecommerce_sales;

/*Q 03: Which color appears most frequently in the orders */
-- ANSWER 03:

SELECT color, COUNT(*) AS frequency
FROM clothing_ecommerce_sales
GROUP BY color
ORDER BY frequency DESC
LIMIT 1;

/*Q 04: How many orders are there for each size category */
-- ANSWER 04:

SELECT size, COUNT(*) AS order_count
FROM clothing_ecommerce_sales
GROUP BY size;

/*Q 05: Identify the top three most commonly ordered SKUs */
-- ANSWER 05:
SELECT sku, COUNT(*) AS order_count
FROM clothing_ecommerce_sales
GROUP BY sku
ORDER BY order_count DESC
LIMIT 3;

/*Q 06: Calculate the total revenue for the month of June 2022 */
-- ANSWER 06:

SELECT SUM(revenue) AS total_revenue
FROM clothing_ecommerce_sales
WHERE MONTH(order_date) = 6 AND YEAR(order_date) = 2022;

/*Q 07: What is the range of unit prices in the dataset */
-- ANSWER 07 :

SELECT MIN(unit_price) AS min_unit_price, MAX(unit_price) AS max_unit_price
FROM clothing_ecommerce_sales;

/*Q 08: What is the average revenue per order for each month in the dataset */
-- ANSWER 08 :

SELECT EXTRACT(MONTH FROM order_date) AS month,
       AVG(revenue) AS average_revenue_per_order
FROM clothing_ecommerce_sales
GROUP BY month
ORDER BY month;

/*Q 09: Which color and size combination is most popular */
-- ANSWER 09 :

SELECT color, size, COUNT(*) AS order_count
FROM clothing_ecommerce_sales
GROUP BY color, size
ORDER BY order_count DESC
LIMIT 1;

/*Q 10: What is the total revenue generated by each SKU */
-- ANSWER 10 :

SELECT sku, SUM(revenue) AS total_revenue
FROM clothing_ecommerce_sales
GROUP BY sku
ORDER BY total_revenue DESC;

/*Q 11: Which SKU has the highest total revenue */
-- ANSWER 11 :

SELECT sku, SUM(revenue) AS total_revenue
FROM clothing_ecommerce_sales
GROUP BY sku
ORDER BY total_revenue DESC
LIMIT 1;

/*Q 12: Plot a graph showing the trend of the number of orders over time. */
-- ANSWER 12 :

SELECT DATE_FORMAT(order_date, '%Y-%m-%d') AS order_date,
       COUNT(DISTINCT order_id) AS order_count
FROM clothing_ecommerce_sales
GROUP BY order_date
ORDER BY order_date;

/*Q 13: Which size category generates the most revenue */
-- ANSWER 13 :

SELECT size, SUM(revenue) AS total_revenue
FROM clothing_ecommerce_sales
GROUP BY size
ORDER BY total_revenue DESC
LIMIT 1;

/*Q 14: How does the popularity of the top three colors change over time  */
-- ANSWER 14 :

SELECT order_date, color, COUNT(*) AS order_count
FROM clothing_ecommerce_sales
GROUP BY order_date, color
ORDER BY order_count DESC, order_date;

/*Q 15: Build a simple model to predict the revenue of an order based on size and color  */
-- ANSWER 15 :
SELECT
  size,
  color,
  AVG(revenue) AS avg_revenue,
  COUNT(*) AS order_count
FROM
  clothing_ecommerce_sales
GROUP BY
  size, color
ORDER BY
  avg_revenue DESC, order_count DESC;

/*Q 16: Can you segment the orders into different groups based on revenue and quantity */
-- ANSWER 16 :

SELECT
  order_id,
  CASE
    WHEN revenue < 200 AND quantity < 2 THEN 'Low Revenue, Low Quantity'
    WHEN revenue >= 200 AND revenue < 500 AND quantity < 3 THEN 'Medium Revenue, Low Quantity'
    WHEN revenue >= 500 AND quantity >= 3 THEN 'High Revenue, High Quantity'
    ELSE 'Other'
  END AS order_segment
FROM
  clothing_ecommerce_sales;

/*Q 17: Analyze the time series data of monthly sales and identify any trends or seasonality */
-- ANSWER 17 :

-- Query 1:
SELECT
  DATE_FORMAT(order_date, '%Y-%m') AS month,
  SUM(revenue) AS monthly_sales
FROM
  clothing_ecommerce_sales
GROUP BY
  month
ORDER BY
  month;

-- Query 2:
SELECT
  month,
  monthly_sales,
  AVG(monthly_sales) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM
  (SELECT
     DATE_FORMAT(order_date, '%Y-%m') AS month,
     SUM(revenue) AS monthly_sales
   FROM
     clothing_ecommerce_sales
   GROUP BY
     month) AS monthly_sales_data
ORDER BY
  month;

-- Query 3:
SELECT
  month,
  monthly_sales,
  LAG(monthly_sales, 1) OVER (ORDER BY month) AS prev_monthly_sales
FROM
  (SELECT
     DATE_FORMAT(order_date, '%Y-%m') AS month,
     SUM(revenue) AS monthly_sales
   FROM
     clothing_ecommerce_sales
   GROUP BY
     month) AS monthly_sales_data
ORDER BY
  month;

/* Q 18: Identify which SKUs are often bought together in the same order. */
-- ANSWER 18 :

WITH SKU_Combinations AS (
  SELECT
    a.order_id AS order_id_a,
    a.sku AS sku_a,
    b.order_id AS order_id_b,
    b.sku AS sku_b
  FROM
    clothing_ecommerce_sales a
  JOIN
    clothing_ecommerce_sales b ON a.order_id = b.order_id AND a.sku < b.sku
)
SELECT
  sku_a,
  sku_b,
  COUNT(DISTINCT order_id_a) AS order_count
FROM
  SKU_Combinations
GROUP BY
  sku_a, sku_b
ORDER BY
  order_count DESC;

/* Q 19: Are there any anomalies in the order quantities or revenue */
-- ANSWER 19 :

WITH OrderAnomalies AS (
  SELECT
    order_id,
    quantity,
    revenue,
    -- Calculate z-scores for quantity and revenue
    (quantity - AVG(quantity) OVER ()) / STDDEV(quantity) OVER () AS quantity_zscore,
    (revenue - AVG(revenue) OVER ()) / STDDEV(revenue) OVER () AS revenue_zscore
  FROM
    clothing_ecommerce_sales
)
SELECT
  order_id,
  quantity,
  revenue
FROM
  OrderAnomalies
WHERE
  ABS(quantity_zscore) > 3 OR ABS(revenue_zscore) > 3;

/* Q 20: What percentage of the total revenue does each SKU contribute */
-- ANSWER 20 :

SELECT
  sku,
  SUM(revenue) AS sku_revenue,
  SUM(revenue) / (SELECT SUM(revenue) FROM clothing_ecommerce_sales) * 100 AS revenue_percentage
FROM
  clothing_ecommerce_sales
GROUP BY
  sku
ORDER BY
  revenue_percentage DESC;

SELECT *
FROM clothing_ecommerce_sales
WHERE quantity > (SELECT AVG(quantity) + 3 * STDDEV(quantity) FROM clothing_ecommerce_sales)
   OR revenue > (SELECT AVG(revenue) + 3 * STDDEV(revenue) FROM clothing_ecommerce_sales);
