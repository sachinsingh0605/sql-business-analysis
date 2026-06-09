-- Q6. What does freight cost look like, and how long is delivery taking?
-- High freight to a country isn't a problem if revenue is high too,
-- but if we're spending a lot to ship to low-revenue markets,
-- that's worth flagging.

SELECT
    o.ship_country,
    COUNT(o.order_id)                                 AS total_shipments,
    ROUND(AVG(o.freight)::NUMERIC, 2)                 AS avg_freight_cost,
    ROUND(SUM(o.freight)::NUMERIC, 2)                 AS total_freight_cost,
    ROUND(AVG(o.shipped_date - o.order_date)::NUMERIC, 1)
                                                      AS avg_days_to_ship,
    ROUND(SUM(od.unit_price * od.quantity
        * (1 - od.discount))::NUMERIC, 2)             AS total_revenue,
    ROUND((SUM(o.freight) /
        NULLIF(SUM(od.unit_price * od.quantity
        * (1 - od.discount)), 0) * 100)::NUMERIC, 2)  AS freight_as_pct_of_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
WHERE o.shipped_date IS NOT NULL
GROUP BY o.ship_country
ORDER BY total_shipments DESC
LIMIT 10;
