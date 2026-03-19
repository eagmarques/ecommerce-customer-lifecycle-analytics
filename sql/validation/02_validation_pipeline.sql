-- ============================================
-- PIPELINE VALIDATION CHECKS
-- ============================================

-- 1) Unexpected duplication in int_user_activity
SELECT
    'duplicate_int_user_activity' AS validation_check,
    activity_date,
    user_id,
    COUNT(*) AS duplicate_rows
FROM int_user_activity
GROUP BY activity_date, user_id
HAVING COUNT(*) > 1;

-- 2) total_events less than mapped tracked events
SELECT
    'invalid_event_totals_subset' AS validation_check,
    activity_date,
    user_id,
    total_events,
    purchase_events,
    view_events,
    cart_events
FROM int_user_activity
WHERE total_events < (purchase_events + view_events + cart_events + remove_from_cart_events);

-- 3) Negative values in int_user_activity
SELECT
    'negative_values_int_user_activity' AS validation_check,
    activity_date,
    user_id,
    total_events,
    total_sessions,
    purchase_events,
    view_events,
    cart_events
FROM int_user_activity
WHERE total_events < 0
   OR total_sessions < 0
   OR purchase_events < 0
   OR view_events < 0
   OR cart_events < 0;

-- 4) Negative values in mart_kpis_daily
SELECT
    'negative_values_mart_kpis_daily' AS validation_check,
    activity_date,
    dau,
    total_events,
    total_sessions,
    purchase_events,
    view_events,
    cart_events
FROM mart_kpis_daily
WHERE dau < 0
   OR total_events < 0
   OR total_sessions < 0
   OR purchase_events < 0
   OR view_events < 0
   OR cart_events < 0;

-- 5) Negative values in mart_kpis_monthly
SELECT
    'negative_values_mart_kpis_monthly' AS validation_check,
    month_date,
    mau,
    total_events,
    total_sessions,
    purchase_events,
    view_events,
    cart_events
FROM mart_kpis_monthly
WHERE mau < 0
   OR total_events < 0
   OR total_sessions < 0
   OR purchase_events < 0
   OR view_events < 0
   OR cart_events < 0;

-- 6) Invalid retention
SELECT
    'invalid_retention_rate' AS validation_check,
    cohort_month,
    month_number,
    cohort_size,
    retained_users,
    retention_rate,
    retention_percentage
FROM mart_retention_rate_monthly
WHERE retention_rate > 1
   OR retention_percentage > 100
   OR retention_rate < 0
   OR retention_percentage < 0;

-- 7) Invalid churn
SELECT
    'invalid_churn_rate' AS validation_check,
    month_date,
    previous_month_date,
    active_users_previous_month,
    retained_users,
    churned_users,
    churn_rate,
    churn_percentage
FROM mart_churn_monthly
WHERE churn_rate > 1
   OR churn_percentage > 100
   OR churn_rate < 0
   OR churn_percentage < 0;

-- 8) Invalid stickiness
SELECT
    'invalid_stickiness' AS validation_check,
    month_date,
    avg_dau,
    mau,
    stickiness_ratio,
    stickiness_percentage
FROM mart_stickiness_monthly
WHERE stickiness_ratio > 1
   OR stickiness_percentage > 100
   OR stickiness_ratio < 0
   OR stickiness_percentage < 0;

-- 9) Negative revenue
SELECT
    'negative_revenue_customer_purchase_behavior' AS validation_check,
    user_id,
    total_revenue
FROM mart_customer_purchase_behavior
WHERE total_revenue < 0;

-- 10) Inconsistent purchase dates
SELECT
    'invalid_purchase_date_order' AS validation_check,
    user_id,
    first_purchase_date,
    last_purchase_date
FROM mart_customer_purchase_behavior
WHERE first_purchase_date > last_purchase_date;

-- 11) Buyer with zero purchase events
SELECT
    'buyer_without_purchase_events' AS validation_check,
    user_id,
    is_buyer,
    purchase_event_count
FROM mart_customer_purchase_behavior
WHERE is_buyer = 1
  AND purchase_event_count <= 0;

-- 12) Inconsistent repeat buyer by day
SELECT
    'repeat_buyer_by_day_inconsistent' AS validation_check,
    user_id,
    is_repeat_buyer_by_day,
    purchase_days_count
FROM mart_customer_purchase_behavior
WHERE is_repeat_buyer_by_day = 1
  AND purchase_days_count <= 1;

-- 13) Inconsistent repeat buyer by month
SELECT
    'repeat_buyer_by_month_inconsistent' AS validation_check,
    user_id,
    is_repeat_buyer_by_month,
    purchase_months_count
FROM mart_customer_purchase_behavior
WHERE is_repeat_buyer_by_month = 1
  AND purchase_months_count <= 1;

-- 14) Inconsistent repeat buyer by session
SELECT
    'repeat_buyer_by_session_inconsistent' AS validation_check,
    user_id,
    is_repeat_buyer_by_session,
    purchase_sessions_count
FROM mart_customer_purchase_behavior
WHERE is_repeat_buyer_by_session = 1
  AND purchase_sessions_count <= 1;

-- 15) Event month mismatch
SELECT
    'event_month_mismatch' AS validation_check,
    event_date,
    event_month
FROM stg_events
WHERE event_date IS NOT NULL
  AND event_month IS NOT NULL
  AND event_month <> STRFTIME('%Y-%m', event_date);

-- 16) Event timestamp date mismatch
SELECT
    'event_timestamp_date_mismatch' AS validation_check,
    event_timestamp,
    event_date
FROM stg_events
WHERE event_timestamp IS NOT NULL
  AND event_date IS NOT NULL
  AND DATE(event_timestamp) <> event_date;

-- 17) Cohort month mismatch
SELECT
    'cohort_month_mismatch' AS validation_check,
    user_id,
    first_activity_date,
    cohort_month
FROM int_user_first_activity
WHERE first_activity_date IS NOT NULL
  AND cohort_month IS NOT NULL
  AND cohort_month <> STRFTIME('%Y-%m-01', first_activity_date);

-- 18) Negative month number retention
SELECT
    'negative_month_number_retention' AS validation_check,
    cohort_month,
    month_number,
    retained_users
FROM mart_retention_monthly
WHERE month_number < 0;  

-- 19) Cohort size mismatch month zero  
SELECT
    'cohort_size_mismatch_month_zero' AS validation_check,
    cohort_month,
    month_number,
    cohort_size,
    retained_users
FROM mart_retention_rate_monthly
WHERE month_number = 0
  AND cohort_size <> retained_users;

-- 20) Churn component mismatch
SELECT
    'churn_component_mismatch' AS validation_check,
    month_date,
    previous_month_date,
    active_users_previous_month,
    retained_users,
    churned_users
FROM mart_churn_monthly
WHERE ABS(active_users_previous_month - (retained_users + churned_users)) > 1;

-- 21) Avg DAU greater than MAU
SELECT
    'avg_dau_greater_than_mau' AS validation_check,
    month_date,
    avg_dau,
    mau
FROM mart_stickiness_monthly
WHERE avg_dau > mau;

-- 22) Purchasing users greater than DAU
SELECT
    'purchasing_users_greater_than_dau' AS validation_check,
    activity_date,
    dau,
    purchasing_users
FROM mart_kpis_daily
WHERE purchasing_users > dau;

-- 23) Invalid purchase price in stg_events
SELECT
    'null_purchase_price_in_stg' AS validation_check,
    user_id,
    event_date,
    price
FROM stg_events
WHERE event_type = 'purchase'
  AND price IS NULL;


-- 24) Activity before first activity
SELECT
    'activity_before_first_activity' AS validation_check,
    a.user_id,
    a.activity_date,
    f.first_activity_date
FROM int_user_activity AS a
INNER JOIN int_user_first_activity AS f
    ON a.user_id = f.user_id
WHERE a.activity_date < f.first_activity_date;

-- 25) Null user_id in stg_events
SELECT
    'null_user_id_in_stg' AS validation_check,
    COUNT(*) AS null_rows
FROM stg_events
WHERE user_id IS NULL
HAVING COUNT(*) > 0;

-- 26) Invalid event_type in stg_events
SELECT
    'invalid_event_type' AS validation_check,
    event_type,
    COUNT(*) AS total_rows
FROM stg_events
GROUP BY event_type
HAVING event_type NOT IN ('view', 'cart', 'remove_from_cart', 'purchase');