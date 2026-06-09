-- Q2. Which customers are actually driving revenue?
-- Not just who orders the most, but who spends the most.
-- The gap between order count and revenue can be revealing —
-- some customers order often but in small amounts.

SELECT
    c.company_name,
    c.country,
    COUNT(DISTINCT o.order_id)                        AS orders_placed,
    ROUND(SUM(od.unit_price * od.quantity
        * (1 - od.discount))::NUMERIC, 2)             AS total_revenue,
    ROUND(AVG(od.unit_price * od.quantity
        * (1 - od.discount))::NUMERIC, 2)             AS avg_order_value,
    RANK() OVER (
        ORDER BY SUM(od.unit_price * od.quantity
        * (1 - od.discount)) DESC
    )                                                 AS revenue_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.company_name, c.country
ORDER BY total_revenue DESC
LIMIT 10;
