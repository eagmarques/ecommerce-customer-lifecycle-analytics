DROP TABLE IF EXISTS mart_customer_purchase_behavior;

CREATE TABLE mart_customer_purchase_behavior AS
WITH purchase_events AS (
    SELECT
        user_id,
        event_timestamp,
        event_date,
        event_month,
        user_session,
        price
    FROM stg_events
    WHERE event_type = 'purchase'
      AND user_id IS NOT NULL
      AND event_date IS NOT NULL
      AND price >= 0
),
per_user AS (
    SELECT
        user_id,
        COUNT(*) AS purchase_event_count,
        ROUND(SUM(price), 2) AS total_revenue,
        ROUND(AVG(price), 2) AS avg_purchase_event_value,
        MIN(event_date) AS first_purchase_date,
        MAX(event_date) AS last_purchase_date,
        COUNT(DISTINCT event_date) AS purchase_days_count,
        COUNT(DISTINCT event_month) AS purchase_months_count,
        COUNT(DISTINCT user_session) AS purchase_sessions_count
    FROM purchase_events
    GROUP BY user_id
)
SELECT
    pu.user_id,
    pu.purchase_event_count,
    pu.total_revenue,
    pu.avg_purchase_event_value,
    pu.first_purchase_date,
    pu.last_purchase_date,
    pu.purchase_days_count,
    pu.purchase_months_count,
    pu.purchase_sessions_count,
    CASE WHEN pu.purchase_event_count > 0 THEN 1 ELSE 0 END AS is_buyer,
    CASE WHEN pu.purchase_days_count > 1 THEN 1 ELSE 0 END AS is_repeat_buyer_by_day,
    CASE WHEN pu.purchase_months_count > 1 THEN 1 ELSE 0 END AS is_repeat_buyer_by_month,
    CASE WHEN pu.purchase_sessions_count > 1 THEN 1 ELSE 0 END AS is_repeat_buyer_by_session
FROM per_user AS pu
ORDER BY pu.total_revenue DESC;