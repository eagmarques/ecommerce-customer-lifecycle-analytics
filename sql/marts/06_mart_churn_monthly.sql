DROP TABLE IF EXISTS mart_churn_monthly;

CREATE TABLE mart_churn_monthly AS
WITH user_activity_monthly AS (
    SELECT
        user_id,
        STRFTIME('%Y-%m-01', activity_date) AS month_date
    FROM int_user_activity
    WHERE user_id IS NOT NULL
      AND activity_date IS NOT NULL
    GROUP BY
        user_id,
        STRFTIME('%Y-%m-01', activity_date)
),
previous_month_users AS (
    SELECT
        user_id,
        month_date
    FROM user_activity_monthly
),
current_month_users AS (
    SELECT
        user_id,
        month_date
    FROM user_activity_monthly
),
churn_base AS (
    SELECT
        prev.month_date AS previous_month_date,
        STRFTIME('%Y-%m-01', DATE(prev.month_date, '+1 month')) AS month_date,
        prev.user_id,
        CASE
            WHEN curr.user_id IS NULL THEN 1
            ELSE 0
        END AS is_churned
    FROM previous_month_users AS prev
    LEFT JOIN current_month_users AS curr
        ON prev.user_id = curr.user_id
       AND curr.month_date = STRFTIME('%Y-%m-01', DATE(prev.month_date, '+1 month'))
),
monthly_churn AS (
    SELECT
        month_date,
        previous_month_date,
        COUNT(DISTINCT user_id) AS active_users_previous_month,
        COUNT(DISTINCT CASE WHEN is_churned = 0 THEN user_id END) AS retained_users,
        COUNT(DISTINCT CASE WHEN is_churned = 1 THEN user_id END) AS churned_users
    FROM churn_base
    GROUP BY
        month_date,
        previous_month_date
)
SELECT
    month_date,
    previous_month_date,
    active_users_previous_month,
    retained_users,
    churned_users,
    ROUND(
        1.0 * churned_users / NULLIF(active_users_previous_month, 0),
        4
    ) AS churn_rate,
    ROUND(
        100.0 * churned_users / NULLIF(active_users_previous_month, 0),
        2
    ) AS churn_percentage
FROM monthly_churn
ORDER BY month_date;