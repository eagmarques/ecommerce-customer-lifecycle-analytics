DROP TABLE IF EXISTS int_user_first_activity;

CREATE TABLE int_user_first_activity AS
SELECT
    user_id,
    MIN(DATE(event_time)) AS first_activity_date,
    strftime('%Y-%m-01', MIN(DATE(event_time))) AS cohort_month
FROM stg_events
WHERE user_id IS NOT NULL
GROUP BY user_id;