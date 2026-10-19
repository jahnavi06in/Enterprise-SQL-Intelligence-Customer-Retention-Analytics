-- ============================================================
-- PROJECT: Enterprise SQL Intelligence & Customer Retention Analytics
-- DATASET: UCI Online Retail
-- PURPOSE: Sales Analytics, Revenue Intelligence & Retention
--
-- Revenue = Quantity * Unit Price (GBP)
-- The clean_sales table is assumed to contain cleaned,
-- positive-sales transactions according to the project's
-- documented cleaning rules.
--
-- SQL DIALECT: SQLite-compatible SQL
-- ============================================================


-- ============================================================
-- 02. BUSINESS OVERVIEW
-- ============================================================

SELECT
    COUNT(*) AS clean_sales_lines,
    COUNT(DISTINCT invoice_no) AS unique_invoices,
    COUNT(DISTINCT customer_id) AS identified_customers,
    COUNT(DISTINCT stock_code) AS unique_products,
    COUNT(DISTINCT country) AS countries,
    ROUND(SUM(revenue), 2) AS total_sales_revenue_gbp,
    ROUND(
        SUM(revenue) /
        NULLIF(COUNT(DISTINCT invoice_no), 0),
        2
    ) AS average_invoice_value_gbp,
    MIN(invoice_date) AS first_sale,
    MAX(invoice_date) AS last_sale
FROM clean_sales;


-- ============================================================
-- 03. MONTHLY REVENUE & MONTH-OVER-MONTH CHANGE
-- ============================================================

WITH monthly AS (
    SELECT
        invoice_month AS month,
        SUM(revenue) AS revenue,
        COUNT(DISTINCT invoice_no) AS invoices
    FROM clean_sales
    GROUP BY invoice_month
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue_gbp,
    invoices,
    ROUND(
        100.0 * (
            revenue - LAG(revenue) OVER (ORDER BY month)
        ) / NULLIF(
            LAG(revenue) OVER (ORDER BY month),
            0
        ),
        2
    ) AS mom_revenue_change_pct
FROM monthly
ORDER BY month;


-- ============================================================
-- 04. TOP 20 PRODUCTS BY REVENUE
-- ============================================================

WITH product_performance AS (
    SELECT
        stock_code,
        MAX(description) AS description,
        SUM(quantity) AS units_sold,
        SUM(revenue) AS revenue,
        COUNT(DISTINCT invoice_no) AS invoices
    FROM clean_sales
    GROUP BY stock_code
)
SELECT
    stock_code,
    description,
    units_sold,
    ROUND(revenue, 2) AS revenue_gbp,
    invoices,
    ROUND(
        100.0 * revenue /
        NULLIF(SUM(revenue) OVER (), 0),
        2
    ) AS revenue_share_pct
FROM product_performance
ORDER BY revenue DESC
LIMIT 20;


-- ============================================================
-- 05. COUNTRY PERFORMANCE
-- ============================================================

SELECT
    country,
    COUNT(DISTINCT invoice_no) AS invoices,
    COUNT(DISTINCT customer_id) AS identified_customers,
    SUM(quantity) AS units_sold,
    ROUND(SUM(revenue), 2) AS revenue_gbp,
    ROUND(
        SUM(revenue) /
        NULLIF(COUNT(DISTINCT invoice_no), 0),
        2
    ) AS revenue_per_invoice_gbp
FROM clean_sales
GROUP BY country
ORDER BY revenue_gbp DESC;


-- ============================================================
-- 06. CUSTOMER LIFETIME VALUE PROXY
-- Observed historical spend, NOT predictive lifetime value
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS purchase_invoices,
    SUM(quantity) AS units_bought,
    ROUND(SUM(revenue), 2) AS customer_revenue_gbp,
    ROUND(
        SUM(revenue) /
        NULLIF(COUNT(DISTINCT invoice_no), 0),
        2
    ) AS avg_invoice_value_gbp,
    MIN(invoice_date) AS first_purchase,
    MAX(invoice_date) AS last_purchase,
    DENSE_RANK() OVER (
        ORDER BY SUM(revenue) DESC
    ) AS revenue_rank
FROM clean_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY customer_revenue_gbp DESC
LIMIT 100;


-- ============================================================
-- 07. REPEAT PURCHASE RATE
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS orders
    FROM clean_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS identified_customers,
    SUM(
        CASE WHEN orders >= 2 THEN 1 ELSE 0 END
    ) AS repeat_customers,
    SUM(
        CASE WHEN orders = 1 THEN 1 ELSE 0 END
    ) AS one_time_customers,
    ROUND(
        100.0 * SUM(
            CASE WHEN orders >= 2 THEN 1 ELSE 0 END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_rate_pct
FROM customer_orders;


-- ============================================================
-- 08. CUSTOMER COHORT RETENTION
-- Month 0 represents each customer's first purchase month
-- ============================================================

WITH customer_months AS (
    SELECT DISTINCT
        customer_id,
        invoice_month
    FROM clean_sales
    WHERE customer_id IS NOT NULL
),
first_month AS (
    SELECT
        customer_id,
        MIN(invoice_month) AS cohort_month
    FROM customer_months
    GROUP BY customer_id
),
activity AS (
    SELECT
        f.cohort_month,
        (
            (
                CAST(SUBSTR(m.invoice_month, 1, 4) AS INTEGER)
                -
                CAST(SUBSTR(f.cohort_month, 1, 4) AS INTEGER)
            ) * 12
            +
            CAST(SUBSTR(m.invoice_month, 6, 2) AS INTEGER)
            -
            CAST(SUBSTR(f.cohort_month, 6, 2) AS INTEGER)
        ) AS month_number,
        m.customer_id
    FROM customer_months AS m
    JOIN first_month AS f
        ON m.customer_id = f.customer_id
),
cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(*) AS cohort_customers
    FROM first_month
    GROUP BY cohort_month
)
SELECT
    a.cohort_month,
    a.month_number,
    COUNT(DISTINCT a.customer_id) AS active_customers,
    s.cohort_customers,
    ROUND(
        100.0 * COUNT(DISTINCT a.customer_id)
        / NULLIF(s.cohort_customers, 0),
        2
    ) AS retention_pct
FROM activity AS a
JOIN cohort_sizes AS s
    ON a.cohort_month = s.cohort_month
GROUP BY
    a.cohort_month,
    a.month_number,
    s.cohort_customers
ORDER BY
    a.cohort_month,
    a.month_number;


-- ============================================================
-- 09. TOP 10 CUSTOMER REVENUE CONCENTRATION
-- ROW_NUMBER ensures exactly 10 ranked customers at most
-- ============================================================

WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(revenue) AS revenue
    FROM clean_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT
        customer_id,
        revenue,
        ROW_NUMBER() OVER (
            ORDER BY revenue DESC, customer_id
        ) AS customer_rank
    FROM customer_revenue
)
SELECT
    ROUND(
        SUM(
            CASE
                WHEN customer_rank <= 10 THEN revenue
                ELSE 0
            END
        ),
        2
    ) AS top_10_customer_revenue_gbp,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN customer_rank <= 10 THEN revenue
                ELSE 0
            END
        ) / NULLIF(
            (SELECT SUM(revenue) FROM customer_revenue),
            0
        ),
        2
    ) AS top_10_customer_revenue_share_pct
FROM ranked_customers;


-- ============================================================
-- 10. HOURLY DEMAND ANALYSIS
-- ============================================================

SELECT
    invoice_hour,
    COUNT(DISTINCT invoice_no) AS invoices,
    ROUND(SUM(revenue), 2) AS revenue_gbp
FROM clean_sales
GROUP BY invoice_hour
ORDER BY invoices DESC;


-- ============================================================
-- 11. WEEKDAY DEMAND ANALYSIS
-- ============================================================

SELECT
    weekday,
    COUNT(DISTINCT invoice_no) AS invoices,
    ROUND(SUM(revenue), 2) AS revenue_gbp
FROM clean_sales
GROUP BY weekday
ORDER BY invoices DESC;


-- ============================================================
-- 12. ORDER VALUE DISTRIBUTION
-- ============================================================

WITH orders AS (
    SELECT
        invoice_no,
        SUM(revenue) AS order_revenue
    FROM clean_sales
    GROUP BY invoice_no
)
SELECT
    COUNT(*) AS invoice_count,
    ROUND(AVG(order_revenue), 2) AS mean_order_value_gbp,
    ROUND(MIN(order_revenue), 2) AS min_order_value_gbp,
    ROUND(MAX(order_revenue), 2) AS max_order_value_gbp
FROM orders;


-- ============================================================
-- 13. CANCELLATION & NEGATIVE-QUANTITY AUDIT
-- Raw source table
-- These categories may overlap
-- ============================================================

SELECT
    COUNT(*) AS raw_lines,
    SUM(
        CASE
            WHEN UPPER(CAST(invoice_no AS TEXT)) LIKE 'C%'
            THEN 1 ELSE 0
        END
    ) AS cancellation_lines,
    SUM(
        CASE
            WHEN quantity < 0
            THEN 1 ELSE 0
        END
    ) AS negative_quantity_lines
FROM raw_transactions;


-- ============================================================
-- 14. DATA-CLEANING IMPACT
-- Exact duplicate count compares complete raw rows
-- ============================================================

SELECT
    (SELECT COUNT(*)
     FROM raw_transactions) AS raw_rows,

    (SELECT COUNT(*)
     FROM raw_transactions)
    -
    (SELECT COUNT(*)
     FROM (
         SELECT DISTINCT *
         FROM raw_transactions
     )) AS exact_duplicate_rows,

    (SELECT COUNT(*)
     FROM clean_sales) AS cleaned_positive_sales_rows,

    (SELECT ROUND(SUM(revenue), 2)
     FROM clean_sales) AS cleaned_positive_sales_revenue_gbp;


-- ============================================================
-- 15. RFM CUSTOMER SEGMENTATION
-- Descriptive snapshot based on the latest clean transaction
--
-- Recency: lower days means more recent activity
-- Frequency: number of distinct purchase invoices
-- Monetary: total observed revenue in GBP
-- Scores are relative quintiles, not fixed thresholds
-- ============================================================

WITH customer_metrics AS (
    SELECT
        customer_id,
        MAX(invoice_date) AS last_purchase,
        COUNT(DISTINCT invoice_no) AS frequency,
        SUM(revenue) AS monetary
    FROM clean_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),
snapshot AS (
    SELECT
        MAX(invoice_date) AS snapshot_date
    FROM clean_sales
),
scored AS (
    SELECT
        c.customer_id,
        c.last_purchase,
        c.frequency,
        c.monetary,

        CAST(
            JULIANDAY(s.snapshot_date)
            - JULIANDAY(c.last_purchase)
            AS INTEGER
        ) AS recency_days,

        NTILE(5) OVER (
            ORDER BY
                JULIANDAY(s.snapshot_date)
                - JULIANDAY(c.last_purchase) DESC,
                c.customer_id
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY c.frequency, c.customer_id
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY c.monetary, c.customer_id
        ) AS monetary_score

    FROM customer_metrics AS c
    CROSS JOIN snapshot AS s
)
SELECT
    customer_id,
    recency_days,
    frequency,
    ROUND(monetary, 2) AS monetary_gbp,
    recency_score,
    frequency_score,
    monetary_score,

    CASE
        WHEN recency_score >= 4
             AND frequency_score >= 4
             AND monetary_score >= 4
            THEN 'Champions'

        WHEN recency_score >= 3
             AND frequency_score >= 3
            THEN 'Loyal / Active'

        WHEN recency_score <= 2
             AND frequency_score >= 3
            THEN 'At Risk - Previously Frequent'

        WHEN frequency_score <= 2
             AND recency_score >= 3
            THEN 'New / Promising'

        ELSE 'Needs Nurture'
    END AS segment

FROM scored
ORDER BY monetary DESC;
