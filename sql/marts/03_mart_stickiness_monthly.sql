DROP TABLE IF EXISTS mart_stickiness_monthly;

CREATE TABLE mart_stickiness_monthly AS
WITH daily_monthly_agg AS (
    SELECT
        strftime('%Y-%m-01', activity_date) AS month_date,
        ROUND(AVG(dau), 2) AS avg_dau,
        MAX(dau) AS max_dau,
        MIN(dau) AS min_dau,
        COUNT(activity_date) AS active_days_in_month
    FROM mart_kpis_daily
    GROUP BY month_date
)
SELECT
    d.month_date,
    d.avg_dau,
    d.max_dau,
    d.min_dau,
    d.active_days_in_month,
    m.mau,
    ROUND(1.0 * d.avg_dau / NULLIF(m.mau, 0), 4) AS stickiness_ratio,
    ROUND(100.0 * d.avg_dau / NULLIF(m.mau, 0), 2) AS stickiness_percentage
FROM daily_monthly_agg AS d
LEFT JOIN mart_kpis_monthly AS m
    ON d.month_date = m.month_date
ORDER BY d.month_date;