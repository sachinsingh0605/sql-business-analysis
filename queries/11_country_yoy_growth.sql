-- Q11. How is each country growing year on year?
-- LAG() with PARTITION BY country lets us compare each year
-- to the previous one, per country, in a single pass.
-- Growth % of NULL just means it's the first year of data.

WITH yearly_country AS (
    SELECT
        o.ship_country,
        EXTRACT(YEAR FROM o.order_date)::INT          AS year,
        ROUND(SUM(od.unit_price * od.quantity
            * (1 - od.discount))::NUMERIC, 2)         AS revenue,
        COUNT(DISTINCT o.order_id)                    AS orders
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.ship_country, year
)
SELECT
    ship_country,
    year,
    revenue,
    orders,
    ROUND((revenue -
        LAG(revenue) OVER (
            PARTITION BY ship_country ORDER BY year
        ))::NUMERIC, 2)                               AS revenue_change,
    ROUND(((revenue -
        LAG(revenue) OVER (
            PARTITION BY ship_country ORDER BY year)) /
        NULLIF(LAG(revenue) OVER (
            PARTITION BY ship_country ORDER BY year
        ), 0) * 100)::NUMERIC, 1)                     AS yoy_growth_pct
FROM yearly_country
ORDER BY ship_country, year;
