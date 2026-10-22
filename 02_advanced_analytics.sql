-- ============================================================
-- Project: Advanced E-Commerce Analytics (PostgreSQL)
-- Focus: CTEs, Window Functions, Retention, & Trend Analysis
-- Dataset: Brazilian E-Commerce (Olist)
-- Database Engine: PostgreSQL
-- ============================================================

-- ------------------------------------------------------------
-- 1. Monthly Order Volume, MoM Growth & Cumulative Orders
-- Techniques: CTEs, TO_CHAR, LAG(), SUM() OVER()
-- ------------------------------------------------------------
WITH monthly_metrics AS (
    SELECT 
        TO_CHAR(order_purchase_timestamp::timestamp, 'YYYY-MM') AS year_month,
        COUNT(order_id) AS total_orders,
        COUNT(CASE WHEN LOWER(TRIM(order_status)) = 'delivered' THEN 1 END) AS delivered_orders,
        COUNT(CASE WHEN LOWER(TRIM(order_status)) = 'canceled' THEN 1 END) AS canceled_orders
    FROM olist_orders_dataset
    WHERE order_purchase_timestamp IS NOT NULL
    GROUP BY TO_CHAR(order_purchase_timestamp::timestamp, 'YYYY-MM')
)
SELECT 
    year_month,
    total_orders,
    delivered_orders,
    canceled_orders,
    ROUND(
        ((total_orders - LAG(total_orders, 1) OVER (ORDER BY year_month ASC))::numeric / 
        NULLIF(LAG(total_orders, 1) OVER (ORDER BY year_month ASC), 0)::numeric) * 100, 
        2
    ) AS mom_growth_pct,
    SUM(total_orders) OVER (
        ORDER BY year_month ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_orders
FROM monthly_metrics
ORDER BY year_month ASC;

-- ------------------------------------------------------------
-- 2. Customer RFM Segmentation
-- Techniques: CTEs, NTILE(), CASE WHEN, Recency & Spend Metrics
-- ------------------------------------------------------------
WITH customer_rfm AS (
    SELECT 
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp::timestamp) AS last_order_date,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(p.payment_value::numeric) AS total_monetary_value
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT 
        customer_unique_id,
        total_orders,
        ROUND(total_monetary_value, 2) AS total_monetary_value,
        NTILE(4) OVER (ORDER BY total_monetary_value ASC) AS m_score,
        NTILE(4) OVER (ORDER BY total_orders ASC) AS f_score
    FROM customer_rfm
)
SELECT 
    customer_unique_id,
    total_orders,
    total_monetary_value,
    m_score,
    f_score,
    CASE 
        WHEN m_score = 4 AND f_score = 4 THEN 'VIP High-Value'
        WHEN m_score >= 3 THEN 'Big Spender'
        WHEN f_score >= 3 THEN 'Frequent Shopper'
        ELSE 'Standard Customer'
    END AS customer_segment
FROM rfm_scores
ORDER BY total_monetary_value DESC
LIMIT 100;
