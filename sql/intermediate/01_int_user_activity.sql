DROP TABLE IF EXISTS int_user_activity;

CREATE TABLE int_user_activity AS
SELECT
    DATE(event_time) AS activity_date,
    user_id,
    COUNT(*) AS total_events,
    COUNT(DISTINCT user_session) AS total_sessions,
    SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchase_events,
    SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS view_events,
    SUM(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS cart_events,
    CASE
        WHEN SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) > 0 THEN 1
        ELSE 0
    END AS has_purchase,
    ROUND(
        1.0 * SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) / COUNT(*),
        4
    ) AS purchase_event_rate
FROM stg_events
WHERE user_id IS NOT NULL
GROUP BY activity_date, user_id;