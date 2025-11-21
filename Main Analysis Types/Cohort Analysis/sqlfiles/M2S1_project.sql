WITH 
-- 1. Define user cohorts CTE and group users by the week they started their subscription
user_cohorts AS (
  SELECT
    user_pseudo_id,
    subscription_start,
    subscription_end,
    DATE_TRUNC(subscription_start, WEEK) as cohort_week,
  FROM `tc-da-1.turing_data_analytics.subscriptions`
  --WHERE subscription_start <= '2021-02-07'
),

-- 2. Generate retention CTE to calculate active weeks for each user
retention AS (
  SELECT
    cohort_week,
    user_pseudo_id,
    MIN(DATE_DIFF(
      COALESCE(subscription_end, '2021-02-07'),-- Use the subscription end date if available, otherwise use the analysis date
      subscription_start,
      -- Difference in weeks
      WEEK
    )) AS weeks_active
  FROM
    user_cohorts
  GROUP BY
    cohort_week, user_pseudo_id
)

-- 3. Final select to build retention count table
SELECT
   cohort_week,
  -- Count users still active at week 0
  COUNT(DISTINCT CASE WHEN weeks_active >= 0 THEN user_pseudo_id END) AS week_0,
  -- Count users still active at week 1
  COUNT(DISTINCT CASE WHEN weeks_active >= 1 THEN user_pseudo_id END) AS week_1,
  -- Count users still active at week 2
  COUNT(DISTINCT CASE WHEN weeks_active >= 2 THEN user_pseudo_id END) AS week_2,
  -- Count users still active at week 3
  COUNT(DISTINCT CASE WHEN weeks_active >= 3 THEN user_pseudo_id END) AS week_3,
  -- Count users still active at week 4
  COUNT(DISTINCT CASE WHEN weeks_active >= 4 THEN user_pseudo_id END) AS week_4,
  -- Count users still active at week 5
  COUNT(DISTINCT CASE WHEN weeks_active >= 5 THEN user_pseudo_id END) AS week_5,
  -- Count users still active at week 6
  COUNT(DISTINCT CASE WHEN weeks_active >= 6 THEN user_pseudo_id END) AS week_6
FROM
  retention
GROUP BY
  cohort_week
ORDER BY
  cohort_week;




