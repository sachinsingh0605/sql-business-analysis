-- Q3. Which products are profitable vs just popular?
-- Units sold alone doesn't tell you much — a product can move
-- a lot of volume but still underperform on revenue if it's
-- heavily discounted or low-priced. Looking at both together.

SELECT
    p.product_name,
    cat.category_name,
    SUM(od.quantity)                                  AS units_sold,
    ROUND(SUM(od.unit_price * od.quantity
        * (1 - od.discount))::NUMERIC, 2)             AS net_revenue,
    ROUND(AVG(od.unit_price)::NUMERIC, 2)             AS avg_selling_price,
    ROUND((AVG(od.discount) * 100)::NUMERIC, 1)       AS avg_discount_pct,
    RANK() OVER (
        ORDER BY SUM(od.unit_price * od.quantity
        * (1 - od.discount)) DESC
    )                                                 AS revenue_rank
FROM products p
JOIN order_details od ON p.product_id = od.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY p.product_id, p.product_name, cat.category_name
ORDER BY net_revenue DESC;
