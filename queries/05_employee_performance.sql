-- Q5. How is each employee performing on sales?
-- Using RANK() to make comparisons easy. Also pulling in
-- orders handled so we can see if high revenue is coming
-- from volume or from larger individual deals.

SELECT
    e.first_name || ' ' || e.last_name                AS employee_name,
    e.title,
    COUNT(DISTINCT o.order_id)                        AS orders_handled,
    ROUND(SUM(od.unit_price * od.quantity
        * (1 - od.discount))::NUMERIC, 2)             AS total_sales,
    ROUND(AVG(od.unit_price * od.quantity
        * (1 - od.discount))::NUMERIC, 2)             AS avg_sale_value,
    RANK() OVER (
        ORDER BY SUM(od.unit_price * od.quantity
        * (1 - od.discount)) DESC
    )                                                 AS sales_rank
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.title
ORDER BY total_sales DESC;
