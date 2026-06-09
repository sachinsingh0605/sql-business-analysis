# SQL Business Analysis — Northwind (PostgreSQL)

I loaded the Northwind database into PostgreSQL and used it to answer 12 business questions I'd actually want answered if I were advising this company. Everything is written in plain `.sql` files — no wrappers, no notebooks, just queries you can open and run directly in psql or any PostgreSQL client.

---

## The questions

| File | Question |
|---|---|
| `01_revenue_by_year.sql` | Is revenue actually growing, or just holding flat? |
| `02_top_customers.sql` | Which customers are driving the most money? |
| `03_product_performance.sql` | Which products are profitable vs just popular? |
| `04_revenue_by_category.sql` | Which categories are carrying the business? |
| `05_employee_performance.sql` | How does each employee stack up on sales? |
| `06_shipping_analysis.sql` | What are we spending on freight, and is it justified? |
| `07_monthly_trend.sql` | What does month-on-month growth look like? |
| `08_discount_leakage.sql` | How much revenue are we giving away through discounts? |
| `09_revenue_concentration.sql` | Are we too dependent on a handful of customers? |
| `10_reorder_risk.sql` | Which products are about to run out of stock? |
| `11_country_yoy_growth.sql` | How is each country growing year on year? |
| `12_customer_retention.sql` | How many customers actually come back? |

---

## What stood out

**Revenue concentration is a risk.** Running Q9 shows the cumulative % climbs fast — a small number of customers account for a large chunk of total revenue. That's a fragile position if any of those relationships go cold.

**Discounting is adding up quietly.** Q8 shows how much is being given away across discount bands. The question the data can't answer alone is whether those discounts are winning incremental business or just eroding margin on deals that would have happened anyway.

**Some products are at reorder risk.** Q10 flags products where stock has dropped to or below the reorder threshold while orders keep coming in. In a real operation that's the kind of thing that causes fulfilment problems before anyone notices.

---

## Charts

![Business Analysis Charts](screenshots/sql_analysis_charts.png)

---

## SQL techniques used

- `CTEs` to break complex logic into readable, named steps
- `Window functions` — `RANK()`, `LAG()`, `SUM() OVER()` for running totals and comparisons
- `CASE WHEN` for custom segmentation and bucketing
- `NULLIF()` to handle division by zero cleanly
- Native PostgreSQL date arithmetic (`shipped_date - order_date`)
- `LEFT JOIN` to surface products with no order history
- `PARTITION BY` for per-group year-on-year comparisons

---

## How to run

Make sure PostgreSQL is running and the Northwind database is loaded:

```bash
psql -U postgres -c "CREATE DATABASE northwind;"
psql -U postgres -d northwind -f northwind.sql
```

Then run any query directly:

```bash
psql -U postgres -d northwind -f queries/01_revenue_by_year.sql
```

Or connect interactively and paste queries one by one:

```bash
psql -U postgres -d northwind
```

---

## Tools

PostgreSQL 18 · psql
