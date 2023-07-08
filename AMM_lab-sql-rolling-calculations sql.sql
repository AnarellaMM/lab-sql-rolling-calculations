use sakila; 

-- Get number of monthly active customers.
SELECT DATE_FORMAT(create_date, '%Y-%m') AS date, COUNT(DISTINCT customer_id) AS active_customers
FROM Customer
GROUP BY date
ORDER BY date;


-- Active users in the previous month.
SELECT t1.month, t1.active_customers AS current_month_active, COALESCE(t2.active_customers, 0) AS previous_month_active
FROM (
  SELECT MONTH(create_date) AS month, COUNT(DISTINCT customer_id) AS active_customers
  FROM Customer
  GROUP BY month
) AS t1
LEFT JOIN (
  SELECT MONTH(create_date) AS month, COUNT(DISTINCT customer_id) AS active_customers
  FROM Customer
  GROUP BY month
) AS t2 ON t1.month = t2.month + 1
ORDER BY t1.month;



-- Percentage change in the number of active customers.
SELECT t1.month, t1.active_customers AS current_month_active, COALESCE(t2.active_customers, 0) AS previous_month_active,
       ROUND(((t1.active_customers - COALESCE(t2.active_customers, 0)) / COALESCE(t2.active_customers, 1)) * 100, 2) AS percentage_change
FROM (
  SELECT MONTH(create_date) AS month, COUNT(DISTINCT customer_id) AS active_customers
  FROM Customer
  GROUP BY month
) AS t1
LEFT JOIN (
  SELECT MONTH(create_date) AS month, COUNT(DISTINCT customer_id) AS active_customers
  FROM Customer
  GROUP BY month
) AS t2 ON t1.month = t2.month + 1
ORDER BY t1.month;

-- Retained customers every month.
SELECT t1.month, t1.active_customers AS current_month_active, COALESCE(t2.retained_customers, 0) AS retained_customers
FROM (
  SELECT MONTH(create_date) AS month, COUNT(DISTINCT customer_id) AS active_customers
  FROM Customer
  GROUP BY month
) AS t1
LEFT JOIN (
  SELECT MONTH(create_date) AS month, COUNT(DISTINCT customer_id) AS retained_customers
  FROM Customer
  WHERE YEAR(create_date) = YEAR(CURDATE()) AND MONTH(create_date) = MONTH(CURDATE())
  GROUP BY month
) AS t2 ON t1.month = t2.month
ORDER BY t1.month;