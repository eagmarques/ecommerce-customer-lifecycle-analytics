DROP TABLE IF EXISTS int_user_first_activity;

CREATE TABLE int_user_first_activity AS

WITH first_activity AS (
    SELECT
        user_id,
        MIN(event_date) AS first_activity_date
    FROM stg_events
    WHERE user_id IS NOT NULL              -- Exclude anonymous users
      AND event_date IS NOT NULL           -- Ensure valid timestamps
    GROUP BY user_id
)
SELECT
    user_id,
    first_activity_date,
    DATE(first_activity_date, 'start of month') AS cohort_month,
    STRFTIME('%Y-%m', first_activity_date) AS cohort_month_label
FROM first_activity;