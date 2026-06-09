-- Q10. Which products are at risk of running out of stock?
-- Cross-referencing current stock levels against the reorder
-- threshold set for each product. Anything at or below that
-- level while still receiving orders is an operational risk.

SELECT
    p.product_name,
    cat.category_name,
    p.units_in_stock,
    p.reorder_level,
    p.units_on_order,
    COALESCE(SUM(od.quantity), 0)                     AS total_units_ordered,
    ROUND(p.unit_price::NUMERIC, 2)                   AS unit_price,
    CASE
        WHEN p.units_in_stock = 0            THEN 'Out of Stock'
        WHEN p.units_in_stock <= p.reorder_level THEN 'Reorder Now'
        WHEN p.units_in_stock <= p.reorder_level * 1.5 THEN 'Getting Low'
        ELSE 'OK'
    END                                               AS stock_status
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN order_details od ON p.product_id = od.product_id
WHERE p.discontinued = 0
GROUP BY
    p.product_id, p.product_name, cat.category_name,
    p.units_in_stock, p.reorder_level,
    p.units_on_order, p.unit_price
ORDER BY
    CASE stock_status
        WHEN 'Out of Stock'  THEN 1
        WHEN 'Reorder Now'   THEN 2
        WHEN 'Getting Low'   THEN 3
        ELSE 4
    END,
    p.units_in_stock ASC;
