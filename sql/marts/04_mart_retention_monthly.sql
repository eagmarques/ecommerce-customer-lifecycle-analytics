DROP TABLE IF EXISTS mart_retention_monthly;

CREATE TABLE mart_retention_monthly AS
WITH user_activity_monthly AS (
    SELECT
        user_id,
        strftime('%Y-%m-01', activity_date) AS activity_month
    FROM int_user_activity
    GROUP BY user_id, activity_month
),
cohort_base AS (
    SELECT
        ufa.user_id,
        ufa.cohort_month,
        uam.activity_month,
        CAST(
            (strftime('%Y', uam.activity_month) - strftime('%Y', ufa.cohort_month)) * 12 +
            (strftime('%m', uam.activity_month) - strftime('%m', ufa.cohort_month))
        AS INTEGER) AS month_number
    FROM int_user_first_activity ufa
    JOIN user_activity_monthly uam
        ON ufa.user_id = uam.user_id
)
SELECT
    cohort_month,
    month_number,
    COUNT(DISTINCT user_id) AS retained_users
FROM cohort_base
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;