WITH 
-- 1. Get each user's first event week (registration cohort)
user_first_week AS (
  
  SELECT
    DISTINCT user_pseudo_id,
    DATE_TRUNC(MIN(PARSE_DATE('%Y%m%d', event_date)), WEEK) as cohort_week,
  FROM `tc-da-1.turing_data_analytics.raw_events`
  GROUP BY user_pseudo_id
),
-- 2. Users who purchase, their purchase date parsed as week, and purchase amount
weekly_revenue AS(

  SELECT 
    user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d', event_date), WEEK) as purchase_week,
    purchase_revenue_in_usd AS revenue
  FROM `tc-da-1.turing_data_analytics.raw_events`
  WHERE event_name = 'purchase'
),
-- 3. Join user cohorts with their revenue data
cohort_matrix AS (
SELECT 
  uf.user_pseudo_id,
  uf.cohort_week,
  wr.purchase_week,
  wr.revenue,
  DATE_DIFF(purchase_week, cohort_week,WEEK) as week_diff
FROM user_first_week AS uf
LEFT JOIN  weekly_revenue AS wr
  ON uf.user_pseudo_id = wr.user_pseudo_id
WHERE uf.cohort_week <= '2021-01-24'
),

user_count_per_week AS (
    SELECT
    cohort_week,
    COUNT(DISTINCT user_pseudo_id) as num_users
    FROM cohort_matrix
    GROUP BY cohort_week
)

SELECT 
  cm.cohort_week,
  ROUND(SUM(CASE WHEN week_diff = 0 THEN  revenue END)/ num_users,3)  AS week_0,
  ROUND(SUM(CASE WHEN week_diff = 1 THEN  revenue END) / num_users,3) AS week_1,
  ROUND(SUM(CASE WHEN week_diff = 2 THEN  revenue END) / num_users,3) AS week_2,
  ROUND(SUM(CASE WHEN week_diff = 3 THEN  revenue END) / num_users,3) AS week_3,
  ROUND(SUM(CASE WHEN week_diff = 4 THEN  revenue END) / num_users,3) AS week_4,
  ROUND(SUM(CASE WHEN week_diff = 5 THEN  revenue END) / num_users,3) AS week_5,
  ROUND(SUM(CASE WHEN week_diff = 6 THEN  revenue END) / num_users,3) AS week_6,
  ROUND(SUM(CASE WHEN week_diff = 7 THEN  revenue END) / num_users,3) AS week_7,
  ROUND(SUM(CASE WHEN week_diff = 8 THEN  revenue END) / num_users,3) AS week_8,
  ROUND(SUM(CASE WHEN week_diff = 9 THEN  revenue END) / num_users,3) AS week_9,
  ROUND(SUM(CASE WHEN week_diff = 10 THEN revenue END) / num_users,3) AS week_10,
  ROUND(SUM(CASE WHEN week_diff = 11 THEN revenue END) / num_users,3) AS week_11,
  ROUND(SUM(CASE WHEN week_diff = 12 THEN revenue END) / num_users,3) AS week_12
FROM cohort_matrix cm
JOIN user_count_per_week ucpw ON
ucpw.cohort_week = cm.cohort_week
GROUP BY cm.cohort_week,ucpw.num_users
ORDER BY cm.cohort_week

