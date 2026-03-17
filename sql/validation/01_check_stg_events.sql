DROP TABLE IF EXISTS val_stg_events_summary;

CREATE TABLE val_stg_events_summary AS
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT user_id) AS distinct_users,
    COUNT(DISTINCT product_id) AS distinct_products,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id_rows,
    SUM(CASE WHEN event_time IS NULL THEN 1 ELSE 0 END) AS null_event_time_rows
FROM stg_events;