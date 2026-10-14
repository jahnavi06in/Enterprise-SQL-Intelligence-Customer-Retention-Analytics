-- Customer Retention & Revenue Intelligence | UCI Online Retail
-- Sales revenue = quantity * unit_price, GBP. Review README for cleaning rules.

-- 02 Business overview
SELECT COUNT(*) clean_sales_lines, COUNT(DISTINCT invoice_no) unique_invoices, COUNT(DISTINCT customer_id) identified_customers, COUNT(DISTINCT stock_code) unique_products, COUNT(DISTINCT country) countries, ROUND(SUM(revenue),2) total_sales_revenue_gbp, ROUND(SUM(revenue)/COUNT(DISTINCT invoice_no),2) average_invoice_value_gbp, MIN(invoice_date) first_sale, MAX(invoice_date) last_sale FROM clean_sales;

-- 03 Monthly revenue and month-over-month movement
WITH monthly AS (SELECT invoice_month month, SUM(revenue) revenue, COUNT(DISTINCT invoice_no) invoices FROM clean_sales GROUP BY invoice_month) SELECT month, ROUND(revenue,2) revenue_gbp, invoices, ROUND(100.0*(revenue-LAG(revenue) OVER(ORDER BY month))/NULLIF(LAG(revenue) OVER(ORDER BY month),0),2) mom_revenue_change_pct FROM monthly ORDER BY month;

-- 04 Top product performance
WITH p AS (SELECT stock_code, description, SUM(quantity) units_sold, SUM(revenue) revenue, COUNT(DISTINCT invoice_no) invoices FROM clean_sales GROUP BY stock_code,description) SELECT stock_code,description,units_sold,ROUND(revenue,2) revenue_gbp,invoices,ROUND(100.0*revenue/SUM(revenue) OVER(),2) revenue_share_pct FROM p ORDER BY revenue DESC LIMIT 20;

-- 05 Country performance
SELECT country,COUNT(DISTINCT invoice_no) invoices,COUNT(DISTINCT customer_id) identified_customers,SUM(quantity) units_sold,ROUND(SUM(revenue),2) revenue_gbp,ROUND(SUM(revenue)/COUNT(DISTINCT invoice_no),2) revenue_per_invoice_gbp FROM clean_sales GROUP BY country ORDER BY revenue_gbp DESC;

-- 06 Customer lifetime value proxy (observed spend, not predictive CLV)
SELECT customer_id,COUNT(DISTINCT invoice_no) purchase_invoices,SUM(quantity) units_bought,ROUND(SUM(revenue),2) customer_revenue_gbp,ROUND(SUM(revenue)/COUNT(DISTINCT invoice_no),2) avg_invoice_value_gbp,MIN(invoice_date) first_purchase,MAX(invoice_date) last_purchase,DENSE_RANK() OVER(ORDER BY SUM(revenue) DESC) revenue_rank FROM clean_sales WHERE customer_id IS NOT NULL GROUP BY customer_id ORDER BY customer_revenue_gbp DESC LIMIT 100;

-- 07 Repeat purchase rate
WITH c AS (SELECT customer_id,COUNT(DISTINCT invoice_no) orders FROM clean_sales WHERE customer_id IS NOT NULL GROUP BY customer_id) SELECT COUNT(*) identified_customers,SUM(CASE WHEN orders>=2 THEN 1 ELSE 0 END) repeat_customers,SUM(CASE WHEN orders=1 THEN 1 ELSE 0 END) one_time_customers,ROUND(100.0*SUM(CASE WHEN orders>=2 THEN 1 ELSE 0 END)/COUNT(*),2) repeat_customer_rate_pct FROM c;

-- 08 Cohort retention
WITH cm AS (SELECT DISTINCT customer_id,invoice_month FROM clean_sales WHERE customer_id IS NOT NULL), first_month AS (SELECT customer_id,MIN(invoice_month) cohort_month FROM cm GROUP BY customer_id), activity AS (SELECT f.cohort_month,((CAST(substr(m.invoice_month,1,4) AS INTEGER)-CAST(substr(f.cohort_month,1,4) AS INTEGER))*12+CAST(substr(m.invoice_month,6,2) AS INTEGER)-CAST(substr(f.cohort_month,6,2) AS INTEGER)) month_number,m.customer_id FROM cm m JOIN first_month f USING(customer_id)), sizes AS (SELECT cohort_month,COUNT(*) cohort_customers FROM first_month GROUP BY cohort_month) SELECT a.cohort_month,a.month_number,COUNT(DISTINCT a.customer_id) active_customers,s.cohort_customers,ROUND(100.0*COUNT(DISTINCT a.customer_id)/s.cohort_customers,2) retention_pct FROM activity a JOIN sizes s USING(cohort_month) GROUP BY a.cohort_month,a.month_number,s.cohort_customers ORDER BY a.cohort_month,a.month_number;

-- 09 Top 10 customer revenue concentration
WITH c AS (SELECT customer_id,SUM(revenue) revenue FROM clean_sales WHERE customer_id IS NOT NULL GROUP BY customer_id), r AS (SELECT *,DENSE_RANK() OVER(ORDER BY revenue DESC) revenue_rank FROM c) SELECT ROUND(SUM(CASE WHEN revenue_rank<=10 THEN revenue ELSE 0 END),2) top_10_customer_revenue_gbp,ROUND(100.0*SUM(CASE WHEN revenue_rank<=10 THEN revenue ELSE 0 END)/(SELECT SUM(revenue) FROM c),2) top_10_customer_revenue_share_pct FROM r;

-- 10 Hourly demand
SELECT invoice_hour,COUNT(DISTINCT invoice_no) invoices,ROUND(SUM(revenue),2) revenue_gbp FROM clean_sales GROUP BY invoice_hour ORDER BY invoices DESC;

-- 11 Weekday demand
SELECT weekday,COUNT(DISTINCT invoice_no) invoices,ROUND(SUM(revenue),2) revenue_gbp FROM clean_sales GROUP BY weekday ORDER BY invoices DESC;

-- 12 Order value distribution
WITH orders AS (SELECT invoice_no,SUM(revenue) order_revenue FROM clean_sales GROUP BY invoice_no) SELECT COUNT(*) invoice_count,ROUND(AVG(order_revenue),2) mean_order_value_gbp,ROUND(MIN(order_revenue),2) min_order_value_gbp,ROUND(MAX(order_revenue),2) max_order_value_gbp FROM orders;

-- 13 Cancellation and return audit on raw source table
SELECT COUNT(*) raw_lines,SUM(CASE WHEN UPPER(CAST(invoice_no AS TEXT)) LIKE 'C%' THEN 1 ELSE 0 END) cancellation_lines,SUM(CASE WHEN quantity<0 THEN 1 ELSE 0 END) negative_quantity_lines FROM raw_transactions;

-- 14 Data cleaning impact
SELECT (SELECT COUNT(*) FROM raw_transactions) raw_rows,(SELECT COUNT(*) FROM raw_transactions)-(SELECT COUNT(*) FROM (SELECT DISTINCT * FROM raw_transactions)) exact_duplicate_rows,(SELECT COUNT(*) FROM clean_sales) cleaned_positive_sales_rows,(SELECT SUM(revenue) FROM clean_sales) cleaned_positive_sales_revenue_gbp;

-- 15 Descriptive RFM segmentation (snapshot is the latest clean transaction date)
WITH customer_metrics AS (
  SELECT customer_id, MAX(invoice_date) AS last_purchase,
         COUNT(DISTINCT invoice_no) AS frequency, SUM(revenue) AS monetary
  FROM clean_sales WHERE customer_id IS NOT NULL GROUP BY customer_id
), snapshot AS (SELECT MAX(invoice_date) AS snapshot_date FROM clean_sales),
scored AS (
  SELECT c.*, CAST(julianday(s.snapshot_date)-julianday(c.last_purchase) AS INTEGER) AS recency_days,
         NTILE(5) OVER (ORDER BY CAST(julianday(s.snapshot_date)-julianday(c.last_purchase) AS INTEGER) DESC) AS recency_score,
         NTILE(5) OVER (ORDER BY c.frequency) AS frequency_score,
         NTILE(5) OVER (ORDER BY c.monetary) AS monetary_score
  FROM customer_metrics c CROSS JOIN snapshot s
)
SELECT customer_id, recency_days, frequency, ROUND(monetary,2) AS monetary_gbp,
       recency_score, frequency_score, monetary_score,
       CASE WHEN recency_score>=4 AND frequency_score>=4 AND monetary_score>=4 THEN 'Champions'
            WHEN recency_score>=3 AND frequency_score>=3 THEN 'Loyal / Active'
            WHEN recency_score<=2 AND frequency_score>=3 THEN 'At Risk - Previously Frequent'
            WHEN frequency_score<=2 AND recency_score>=3 THEN 'New / Promising'
            ELSE 'Needs Nurture' END AS segment
FROM scored ORDER BY monetary DESC;
