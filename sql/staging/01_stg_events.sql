DROP TABLE IF EXISTS stg_events;

CREATE TABLE stg_events AS

SELECT
    DATETIME(REPLACE(event_time, ' UTC', '')) AS event_timestamp,
    DATE(REPLACE(event_time, ' UTC', '')) AS event_date,
    STRFTIME('%Y-%m', DATETIME(REPLACE(event_time, ' UTC', ''))) AS event_month,
    LOWER(TRIM(event_type)) AS event_type,
    CAST(product_id AS INTEGER) AS product_id,
    CAST(category_id AS INTEGER) AS category_id,
    TRIM(category_code) AS category_code,
    NULLIF(LOWER(TRIM(brand)), '') AS brand,
    CAST(price AS REAL) AS price,
    CAST(user_id AS INTEGER) AS user_id,
    TRIM(user_session) AS user_session
FROM raw_2019_oct

UNION ALL

SELECT
    DATETIME(REPLACE(event_time, ' UTC', '')) AS event_timestamp,
    DATE(REPLACE(event_time, ' UTC', '')) AS event_date,
    STRFTIME('%Y-%m', DATETIME(REPLACE(event_time, ' UTC', ''))) AS event_month,
    LOWER(TRIM(event_type)) AS event_type,
    CAST(product_id AS INTEGER) AS product_id,
    CAST(category_id AS INTEGER) AS category_id,
    TRIM(category_code) AS category_code,
    NULLIF(LOWER(TRIM(brand)), '') AS brand,
    CAST(price AS REAL) AS price,
    CAST(user_id AS INTEGER) AS user_id,
    TRIM(user_session) AS user_session
FROM raw_2019_nov

UNION ALL

SELECT
    DATETIME(REPLACE(event_time, ' UTC', '')) AS event_timestamp,
    DATE(REPLACE(event_time, ' UTC', '')) AS event_date,
    STRFTIME('%Y-%m', DATETIME(REPLACE(event_time, ' UTC', ''))) AS event_month,
    LOWER(TRIM(event_type)) AS event_type,
    CAST(product_id AS INTEGER) AS product_id,
    CAST(category_id AS INTEGER) AS category_id,
    TRIM(category_code) AS category_code,
    NULLIF(LOWER(TRIM(brand)), '') AS brand,
    CAST(price AS REAL) AS price,
    CAST(user_id AS INTEGER) AS user_id,
    TRIM(user_session) AS user_session
FROM raw_2019_dec

UNION ALL

SELECT
    DATETIME(REPLACE(event_time, ' UTC', '')) AS event_timestamp,
    DATE(REPLACE(event_time, ' UTC', '')) AS event_date,
    STRFTIME('%Y-%m', DATETIME(REPLACE(event_time, ' UTC', ''))) AS event_month,
    LOWER(TRIM(event_type)) AS event_type,
    CAST(product_id AS INTEGER) AS product_id,
    CAST(category_id AS INTEGER) AS category_id,
    TRIM(category_code) AS category_code,
    NULLIF(LOWER(TRIM(brand)), '') AS brand,
    CAST(price AS REAL) AS price,
    CAST(user_id AS INTEGER) AS user_id,
    TRIM(user_session) AS user_session
FROM raw_2020_jan

UNION ALL

SELECT
    DATETIME(REPLACE(event_time, ' UTC', '')) AS event_timestamp,
    DATE(REPLACE(event_time, ' UTC', '')) AS event_date,
    STRFTIME('%Y-%m', DATETIME(REPLACE(event_time, ' UTC', ''))) AS event_month,
    LOWER(TRIM(event_type)) AS event_type,
    CAST(product_id AS INTEGER) AS product_id,
    CAST(category_id AS INTEGER) AS category_id,
    TRIM(category_code) AS category_code,
    NULLIF(LOWER(TRIM(brand)), '') AS brand,
    CAST(price AS REAL) AS price,
    CAST(user_id AS INTEGER) AS user_id,
    TRIM(user_session) AS user_session
FROM raw_2020_feb;