DROP TABLE IF EXISTS mart_retention_rate_monthly;

CREATE TABLE mart_retention_rate_monthly AS
WITH cohort_sizes AS (
    SELECT
        cohort_month,
        retained_users AS cohort_size
    FROM mart_retention_monthly
    WHERE month_number = 0
)
SELECT
    r.cohort_month,
    r.month_number,
    c.cohort_size,
    r.retained_users,
    ROUND(
        1.0 * r.retained_users / NULLIF(c.cohort_size, 0),
        4
    ) AS retention_rate,
    ROUND(
        100.0 * r.retained_users / NULLIF(c.cohort_size, 0),
        2
    ) AS retention_percentage
FROM mart_retention_monthly AS r
INNER JOIN cohort_sizes AS c
    ON r.cohort_month = c.cohort_month
ORDER BY
    r.cohort_month,
    r.month_number;