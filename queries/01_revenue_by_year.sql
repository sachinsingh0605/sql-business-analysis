-- Q1. How is revenue trending year on year?
-- Breaking this down by year to see if the business is actually growing
-- or just maintaining. Order count and avg order value give context
-- beyond just the top-line number.

SELECT
    EXTRACT(YEAR FROM o.order_date)::INT              AS year,
    COUNT(DISTINCT o.order_id)                        AS total_orders,
    ROUND(SUM(od.unit_price * od.quantity
        * (1 - od.discount))::NUMERIC, 2)             AS total_revenue,
    ROUND(AVG(od.unit_price * od.quantity
        * (1 - od.discount))::NUMERIC, 2)             AS avg_order_value,
    ROUND((SUM(od.unit_price * od.quantity * (1 - od.discount))
        - LAG(SUM(od.unit_price * od.quantity * (1 - od.discount)))
          OVER (ORDER BY EXTRACT(YEAR FROM o.order_date))
    )::NUMERIC, 2)                                    AS revenue_change_vs_prev_year
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY year
ORDER BY year;
