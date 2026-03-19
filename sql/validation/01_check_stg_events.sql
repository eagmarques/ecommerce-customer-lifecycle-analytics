DROP TABLE IF EXISTS val_stg_events_summary;

CREATE TABLE val_stg_events_summary AS
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT user_id) AS distinct_users,
    COUNT(DISTINCT product_id) AS distinct_products,

    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id_rows,
    SUM(CASE WHEN event_timestamp IS NULL THEN 1 ELSE 0 END) AS null_event_timestamp_rows,
    SUM(CASE WHEN event_date IS NULL THEN 1 ELSE 0 END) AS null_event_date_rows,
    SUM(CASE WHEN event_month IS NULL THEN 1 ELSE 0 END) AS null_event_month_rows,
    SUM(CASE WHEN event_type IS NULL THEN 1 ELSE 0 END) AS null_event_type_rows,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_price_rows,

    MIN(event_timestamp) AS min_event_timestamp,
    MAX(event_timestamp) AS max_event_timestamp,
    MIN(event_date) AS min_event_date,
    MAX(event_date) AS max_event_date

FROM stg_events;