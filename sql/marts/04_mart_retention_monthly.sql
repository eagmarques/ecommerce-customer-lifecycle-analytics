DROP TABLE IF EXISTS mart_retention_monthly;

CREATE TABLE mart_retention_monthly AS
WITH user_activity_monthly AS (
    SELECT
        user_id,
        STRFTIME('%Y-%m-01', activity_date) AS activity_month
    FROM int_user_activity
    WHERE user_id IS NOT NULL
      AND activity_date IS NOT NULL
    GROUP BY
        user_id,
        STRFTIME('%Y-%m-01', activity_date)
),
cohort_base AS (
    SELECT
        ufa.user_id,
        ufa.cohort_month,
        uam.activity_month,
        CAST(
            (
                CAST(STRFTIME('%Y', uam.activity_month) AS INTEGER) -
                CAST(STRFTIME('%Y', ufa.cohort_month) AS INTEGER)
            ) * 12
            +
            (
                CAST(STRFTIME('%m', uam.activity_month) AS INTEGER) -
                CAST(STRFTIME('%m', ufa.cohort_month) AS INTEGER)
            )
        AS INTEGER) AS month_number
    FROM int_user_first_activity AS ufa
    INNER JOIN user_activity_monthly AS uam
        ON ufa.user_id = uam.user_id
    WHERE ufa.cohort_month IS NOT NULL
      AND uam.activity_month IS NOT NULL
)
SELECT
    cohort_month,
    month_number,
    COUNT(DISTINCT user_id) AS retained_users
FROM cohort_base
WHERE month_number >= 0
GROUP BY
    cohort_month,
    month_number
ORDER BY
    cohort_month,
    month_number;