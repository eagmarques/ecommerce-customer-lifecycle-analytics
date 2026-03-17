DROP TABLE IF EXISTS mart_kpis_monthly;

CREATE TABLE mart_kpis_monthly AS
SELECT
    strftime('%Y-%m-01', activity_date) AS month_date,
    COUNT(DISTINCT user_id) AS mau,
    SUM(total_events) AS total_events,
    SUM(total_sessions) AS total_sessions,
    SUM(purchase_events) AS purchase_events,
    SUM(view_events) AS view_events,
    SUM(cart_events) AS cart_events,

    ROUND(1.0 * SUM(total_events) / COUNT(DISTINCT user_id), 2) AS avg_events_per_active_user,
    ROUND(1.0 * SUM(total_sessions) / COUNT(DISTINCT user_id), 2) AS avg_sessions_per_active_user,

    COUNT(DISTINCT CASE WHEN purchase_events > 0 THEN user_id END) AS purchasing_users,

    ROUND(
        1.0 * COUNT(DISTINCT CASE WHEN purchase_events > 0 THEN user_id END)
        / COUNT(DISTINCT user_id),
        4
    ) AS monthly_buyer_rate,

    ROUND(
        1.0 * SUM(purchase_events) / NULLIF(SUM(total_events), 0),
        4
    ) AS purchase_event_share

FROM int_user_activity
GROUP BY month_date
ORDER BY month_date;