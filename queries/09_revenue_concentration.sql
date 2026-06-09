-- Q9. Are we too dependent on a small group of customers?
-- Cumulative revenue % shows how quickly you hit 50% or 80%
-- of total revenue — the faster it climbs, the more concentrated
-- the risk. This is basically a Pareto analysis.

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.company_name,
        c.country,
        ROUND(SUM(od.unit_price * od.quantity
            * (1 - od.discount))::NUMERIC, 2)         AS revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY c.customer_id, c.company_name, c.country
),
ranked AS (
    SELECT *,
        RANK() OVER (ORDER BY revenue DESC)            AS revenue_rank,
        SUM(revenue) OVER ()                           AS total_revenue
    FROM customer_revenue
)
SELECT
    revenue_rank,
    company_name,
    country,
    revenue,
    ROUND((revenue * 100.0 / total_revenue)::NUMERIC, 2)      AS pct_of_total,
    ROUND((SUM(revenue) OVER (ORDER BY revenue DESC)
        * 100.0 / total_revenue)::NUMERIC, 2)                  AS cumulative_pct
FROM ranked
ORDER BY revenue_rank
LIMIT 15;
