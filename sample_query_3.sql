-- Sample SQL Query 3: Customer Retention & Churn Analysis
-- Demonstrates LEFT JOIN, COALESCE, EXISTS, UNION ALL, and date arithmetic

-- Part 1: Identify churned customers (no orders in the last 90 days)
SELECT
    c.customer_id,
    c.customer_name,
    c.email,
    c.signup_date,
    MAX(o.order_date) AS last_order_date,
    CURRENT_DATE - MAX(o.order_date) AS days_since_last_order,
    COALESCE(SUM(o.total_amount), 0) AS lifetime_value,
    COUNT(o.order_id) AS total_orders,
    CASE
        WHEN MAX(o.order_date) IS NULL THEN 'Never Purchased'
        WHEN CURRENT_DATE - MAX(o.order_date) > 90 THEN 'Churned'
        WHEN CURRENT_DATE - MAX(o.order_date) > 30 THEN 'At Risk'
        ELSE 'Active'
    END AS customer_status
FROM
    customers c
LEFT JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id, c.customer_name, c.email, c.signup_date
ORDER BY
    lifetime_value DESC;

-- Part 2: Find customers who purchased in Q1 but not in Q2
SELECT
    c.customer_id,
    c.customer_name,
    'Q1 Only' AS segment
FROM
    customers c
WHERE
    EXISTS (
        SELECT 1 FROM orders o
        WHERE o.customer_id = c.customer_id
        AND o.order_date BETWEEN '2024-01-01' AND '2024-03-31'
    )
    AND NOT EXISTS (
        SELECT 1 FROM orders o
        WHERE o.customer_id = c.customer_id
        AND o.order_date BETWEEN '2024-04-01' AND '2024-06-30'
    )

UNION ALL

-- Customers who purchased in both Q1 and Q2
SELECT
    c.customer_id,
    c.customer_name,
    'Retained' AS segment
FROM
    customers c
WHERE
    EXISTS (
        SELECT 1 FROM orders o
        WHERE o.customer_id = c.customer_id
        AND o.order_date BETWEEN '2024-01-01' AND '2024-03-31'
    )
    AND EXISTS (
        SELECT 1 FROM orders o
        WHERE o.customer_id = c.customer_id
        AND o.order_date BETWEEN '2024-04-01' AND '2024-06-30'
    )
ORDER BY
    segment, customer_name;
