-- ============================================
-- PIPELINE VALIDATION CHECKS
-- Returns rows only when there is an inconsistency
-- ============================================

-- 1) Unexpected duplication in int_user_activity
-- Expected: 0 rows
SELECT
    'duplicate_int_user_activity' AS validation_check,
    activity_date,
    user_id,
    COUNT(*) AS duplicate_rows
FROM int_user_activity
GROUP BY activity_date, user_id
HAVING COUNT(*) > 1;

-- 2) total_events less than the sum of mapped events
-- Expected: 0 rows
SELECT
    'invalid_event_totals' AS validation_check,
    activity_date,
    user_id,
    total_events,
    purchase_events,
    view_events,
    cart_events
FROM int_user_activity
WHERE total_events < (purchase_events + view_events + cart_events);

-- 3) Negative values in int_user_activity
-- Expected: 0 rows
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
-- Expected: 0 rows
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
-- Expected: 0 rows
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
-- Expected: 0 rows
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
-- Expected: 0 rows
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
-- Expected: 0 rows
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
-- Expected: 0 rows
SELECT
    'negative_revenue_customer_purchase_behavior' AS validation_check,
    user_id,
    total_revenue
FROM mart_customer_purchase_behavior
WHERE total_revenue < 0;

-- 10) Inconsistent purchase dates
-- Expected: 0 rows
SELECT
    'invalid_purchase_date_order' AS validation_check,
    user_id,
    first_purchase_date,
    last_purchase_date
FROM mart_customer_purchase_behavior
WHERE first_purchase_date > last_purchase_date;

-- 11) Buyer with zero purchase events
-- Expected: 0 rows
SELECT
    'buyer_without_purchase_events' AS validation_check,
    user_id,
    is_buyer,
    purchase_event_count
FROM mart_customer_purchase_behavior
WHERE is_buyer = 1
  AND purchase_event_count <= 0;

-- 12) Inconsistent repeat buyer by day
-- Expected: 0 rows
SELECT
    'repeat_buyer_by_day_inconsistent' AS validation_check,
    user_id,
    is_repeat_buyer_by_day,
    purchase_days_count
FROM mart_customer_purchase_behavior
WHERE is_repeat_buyer_by_day = 1
  AND purchase_days_count <= 1;

-- 13) Inconsistent repeat buyer by month
-- Expected: 0 rows
SELECT
    'repeat_buyer_by_month_inconsistent' AS validation_check,
    user_id,
    is_repeat_buyer_by_month,
    purchase_months_count
FROM mart_customer_purchase_behavior
WHERE is_repeat_buyer_by_month = 1
  AND purchase_months_count <= 1;

-- 14) Inconsistent repeat buyer by session
-- Expected: 0 rows
SELECT
    'repeat_buyer_by_session_inconsistent' AS validation_check,
    user_id,
    is_repeat_buyer_by_session,
    purchase_sessions_count
FROM mart_customer_purchase_behavior
WHERE is_repeat_buyer_by_session = 1
  AND purchase_sessions_count <= 1;