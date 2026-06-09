-- Q8. How much revenue is being lost through discounts?
-- Bucketing by discount band makes it easy to see where
-- the leakage is concentrated. The question isn't just
-- how much we're giving away — it's whether the high-discount
-- buckets are generating enough volume to justify it.

SELECT
    CASE
        WHEN discount = 0    THEN '1. No Discount'
        WHEN discount <= 0.1 THEN '2. Low (1–10%)'
        WHEN discount <= 0.2 THEN '3. Medium (11–20%)'
        ELSE                      '4. High (>20%)'
    END                                               AS discount_band,
    COUNT(*)                                          AS line_items,
    SUM(quantity)                                     AS units_sold,
    ROUND(SUM(unit_price * quantity)::NUMERIC, 2)     AS gross_revenue,
    ROUND(SUM(unit_price * quantity
        * discount)::NUMERIC, 2)                      AS revenue_lost_to_discount,
    ROUND(SUM(unit_price * quantity
        * (1 - discount))::NUMERIC, 2)                AS net_revenue
FROM order_details
GROUP BY discount_band
ORDER BY discount_band;
