-- ============================================
-- PURCHASE ANOMALIES MONITORING
-- ============================================

-- Create monitoring table for historical tracking or dashboarding
DROP TABLE IF EXISTS val_purchase_price_anomalies;

CREATE TABLE val_purchase_price_anomalies AS
SELECT
    'purchase_negative_price' AS anomaly_type,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT user_id) AS affected_users,
    MIN(price) AS min_negative_price,
    MAX(price) AS max_negative_price,
    AVG(price) AS avg_negative_price,
    DATE('now') AS check_date
FROM stg_events
WHERE event_type = 'purchase'
  AND price < 0;

-- Informational query (surfaces as [WARNING] in run_pipeline.py)
SELECT
    'negative_purchase_price_warning' AS validation_check,
    user_id,
    event_date,
    price,
    brand
FROM stg_events
WHERE event_type = 'purchase'
  AND price < 0;
