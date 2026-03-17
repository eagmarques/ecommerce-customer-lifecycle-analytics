DROP TABLE IF EXISTS mart_churn_monthly;

CREATE TABLE mart_churn_monthly AS
WITH monthly_users AS (
    SELECT
        month_date,
        mau AS active_users
    FROM mart_kpis_monthly
),
lagged AS (
    SELECT
        curr.month_date,
        prev.month_date                AS previous_month_date,
        prev.active_users              AS active_users_previous_month,
        curr.active_users              AS active_users_current_month
    FROM monthly_users AS curr
    LEFT JOIN monthly_users AS prev
        ON prev.month_date = strftime('%Y-%m-01',
               date(curr.month_date, '-1 month'))
),
churn_calc AS (
    SELECT
        month_date,
        previous_month_date,
        active_users_previous_month,
        -- retained = users still active this month (capped at previous month size)
        MIN(active_users_current_month, active_users_previous_month) AS retained_users,
        -- churned = those who were active last month but not this month
        MAX(active_users_previous_month - active_users_current_month, 0) AS churned_users
    FROM lagged
    WHERE previous_month_date IS NOT NULL
)
SELECT
    month_date,
    previous_month_date,
    active_users_previous_month,
    retained_users,
    churned_users,
    ROUND(1.0 * churned_users / NULLIF(active_users_previous_month, 0), 4)   AS churn_rate,
    ROUND(100.0 * churned_users / NULLIF(active_users_previous_month, 0), 2) AS churn_percentage
FROM churn_calc
ORDER BY month_date;
