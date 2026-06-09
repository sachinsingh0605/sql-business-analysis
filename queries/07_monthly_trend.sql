-- Q7. What does the monthly revenue trend look like?
-- Month-on-month change helps spot seasonality or dips
-- that aren't obvious in yearly totals. LAG() makes the
-- comparison calculation clean without needing a self-join.

SELECT
    TO_CHAR(o.order_date, 'YYYY-MM')                  AS month,
    COUNT(DISTINCT o.order_id)                        AS orders,
    ROUND(SUM(od.unit_price * od.quantity
        * (1 - od.discount))::NUMERIC, 2)             AS revenue,
    ROUND((
        SUM(od.unit_price * od.quantity * (1 - od.discount)) -
        LAG(SUM(od.unit_price * od.quantity * (1 - od.discount)))
        OVER (ORDER BY TO_CHAR(o.order_date, 'YYYY-MM'))
    )::NUMERIC, 2)                                    AS mom_change,
    ROUND((
        (SUM(od.unit_price * od.quantity * (1 - od.discount)) -
        LAG(SUM(od.unit_price * od.quantity * (1 - od.discount)))
        OVER (ORDER BY TO_CHAR(o.order_date, 'YYYY-MM'))) /
        NULLIF(LAG(SUM(od.unit_price * od.quantity * (1 - od.discount)))
        OVER (ORDER BY TO_CHAR(o.order_date, 'YYYY-MM')), 0) * 100
    )::NUMERIC, 1)                                    AS mom_growth_pct
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY month
ORDER BY month;
