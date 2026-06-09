-- Q12. How many customers actually come back?
-- Bucketing by order frequency to understand the shape
-- of the customer base. Loyal customers who keep coming back
-- are worth far more than one-time buyers even if the
-- individual order values look similar.

WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.company_name,
        c.country,
        COUNT(DISTINCT o.order_id)                    AS total_orders,
        MIN(o.order_date)                             AS first_order_date,
        MAX(o.order_date)                             AS last_order_date,
        ROUND(SUM(od.unit_price * od.quantity
            * (1 - od.discount))::NUMERIC, 2)         AS lifetime_value
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY c.customer_id, c.company_name, c.country
)
SELECT
    CASE
        WHEN total_orders = 1   THEN '1. One-time buyer'
        WHEN total_orders <= 3  THEN '2. Occasional (2–3 orders)'
        WHEN total_orders <= 7  THEN '3. Regular (4–7 orders)'
        ELSE                         '4. Loyal (8+ orders)'
    END                                               AS customer_segment,
    COUNT(*)                                          AS customer_count,
    ROUND(AVG(lifetime_value)::NUMERIC, 2)            AS avg_lifetime_value,
    ROUND(SUM(lifetime_value)::NUMERIC, 2)            AS segment_revenue,
    ROUND(AVG(last_order_date - first_order_date)::NUMERIC, 0)
                                                      AS avg_customer_lifespan_days
FROM customer_summary
GROUP BY customer_segment
ORDER BY customer_segment;
