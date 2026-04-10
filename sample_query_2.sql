-- Sample SQL Query 2: Product Sales Summary with Subquery and Window Functions
-- Demonstrates CTE, subquery, window functions (RANK, SUM OVER), and CASE

WITH monthly_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        DATE_TRUNC('month', o.order_date) AS sale_month,
        SUM(oi.quantity * oi.unit_price) AS monthly_revenue,
        SUM(oi.quantity) AS units_sold
    FROM
        products p
    INNER JOIN
        order_items oi ON p.product_id = oi.product_id
    INNER JOIN
        orders o ON oi.order_id = o.order_id
    WHERE
        o.order_date >= '2024-01-01'
        AND o.status != 'cancelled'
    GROUP BY
        p.product_id, p.product_name, p.category, DATE_TRUNC('month', o.order_date)
)
SELECT
    product_name,
    category,
    sale_month,
    monthly_revenue,
    units_sold,
    RANK() OVER (PARTITION BY sale_month ORDER BY monthly_revenue DESC) AS revenue_rank,
    SUM(monthly_revenue) OVER (PARTITION BY product_id ORDER BY sale_month) AS cumulative_revenue,
    CASE
        WHEN monthly_revenue >= 10000 THEN 'High'
        WHEN monthly_revenue >= 5000 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_tier
FROM
    monthly_sales
ORDER BY
    sale_month DESC, revenue_rank ASC;
