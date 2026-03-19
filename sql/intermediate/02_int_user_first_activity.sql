DROP TABLE IF EXISTS int_user_first_activity;

CREATE TABLE int_user_first_activity AS
SELECT
    user_id,
    MIN(event_date) AS first_activity_date,
    STRFTIME('%Y-%m-01', MIN(event_date)) AS cohort_month
FROM stg_events
WHERE user_id IS NOT NULL
  AND event_date IS NOT NULL
GROUP BY user_id;