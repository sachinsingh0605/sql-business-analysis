-- Q4. Where is the money actually coming from by category?
-- Revenue share % makes it easy to spot which categories
-- are carrying the business and which ones are marginal.

SELECT
    cat.category_name,
    COUNT(DISTINCT o.order_id)                        AS orders,
    SUM(od.quantity)                                  AS units_sold,
    ROUND(SUM(od.unit_price * od.quantity
        * (1 - od.discount))::NUMERIC, 2)             AS revenue,
    ROUND((
        SUM(od.unit_price * od.quantity * (1 - od.discount)) /
        SUM(SUM(od.unit_price * od.quantity * (1 - od.discount)))
        OVER () * 100
    )::NUMERIC, 1)                                    AS revenue_share_pct,
    RANK() OVER (
        ORDER BY SUM(od.unit_price * od.quantity
        * (1 - od.discount)) DESC
    )                                                 AS category_rank
FROM categories cat
JOIN products p ON cat.category_id = p.category_id
JOIN order_details od ON p.product_id = od.product_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY cat.category_id, cat.category_name
ORDER BY revenue DESC;
