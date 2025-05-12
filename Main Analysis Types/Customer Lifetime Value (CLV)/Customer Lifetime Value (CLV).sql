-- 1. Identify users' first event week (registration cohort)
WITH 

user_first_week AS (
  
  SELECT
    DISTINCT user_pseudo_id,
    DATE_TRUNC(MIN(PARSE_DATE('%Y%m%d', event_date)), WEEK) as cohort_week,
  FROM `tc-da-1.turing_data_analytics.raw_events`
  GROUP BY user_pseudo_id

),

-- 2. Users who purchased had their purchase date parsed as week and purchase amount extracted

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
    wr.revenue
  FROM user_first_week AS uf
  LEFT JOIN  weekly_revenue AS wr
    ON uf.user_pseudo_id = wr.user_pseudo_id
  WHERE uf.cohort_week <= '2021-01-24'

)

-- 4. Main query calculates average revenue for all users within cohort and for max of 12 weeks after their registration cohort 

SELECT 
  cohort_matrix.cohort_week,
  ROUND(SUM(CASE WHEN cohort_matrix.purchase_week = cohort_matrix.cohort_week THEN cohort_matrix.revenue END)/ (COUNT(DISTINCT user_pseudo_id)),3)  AS week_0,
  ROUND(SUM(CASE WHEN DATE_DIFF(cohort_matrix.purchase_week, cohort_matrix.cohort_week,WEEK) = 1 THEN cohort_matrix.revenue END) / (COUNT(DISTINCT user_pseudo_id)),3) AS week_1,
  ROUND(SUM(CASE WHEN DATE_DIFF(cohort_matrix.purchase_week, cohort_matrix.cohort_week,WEEK) = 2 THEN cohort_matrix.revenue END) / (COUNT(DISTINCT user_pseudo_id)),3) AS week_2,
  ROUND(SUM(CASE WHEN DATE_DIFF(cohort_matrix.purchase_week, cohort_matrix.cohort_week,WEEK) = 3 THEN cohort_matrix.revenue END) / (COUNT(DISTINCT user_pseudo_id)),3) AS week_3,
  ROUND(SUM(CASE WHEN DATE_DIFF(cohort_matrix.purchase_week, cohort_matrix.cohort_week,WEEK) = 4 THEN cohort_matrix.revenue END) / (COUNT(DISTINCT user_pseudo_id)),3) AS week_4,
  ROUND(SUM(CASE WHEN DATE_DIFF(cohort_matrix.purchase_week, cohort_matrix.cohort_week,WEEK) = 5 THEN cohort_matrix.revenue END) / (COUNT(DISTINCT user_pseudo_id)),3) AS week_5,
  ROUND(SUM(CASE WHEN DATE_DIFF(cohort_matrix.purchase_week, cohort_matrix.cohort_week,WEEK) = 6 THEN cohort_matrix.revenue END) / (COUNT(DISTINCT user_pseudo_id)),3) AS week_6,
  ROUND(SUM(CASE WHEN DATE_DIFF(cohort_matrix.purchase_week, cohort_matrix.cohort_week,WEEK) = 7 THEN cohort_matrix.revenue END) / (COUNT(DISTINCT user_pseudo_id)),3) AS week_7,
  ROUND(SUM(CASE WHEN DATE_DIFF(cohort_matrix.purchase_week, cohort_matrix.cohort_week,WEEK) = 8 THEN cohort_matrix.revenue END) / (COUNT(DISTINCT user_pseudo_id)),3) AS week_8,
  ROUND(SUM(CASE WHEN DATE_DIFF(cohort_matrix.purchase_week, cohort_matrix.cohort_week,WEEK) = 9 THEN cohort_matrix.revenue END) / (COUNT(DISTINCT user_pseudo_id)),3) AS week_9,
  ROUND(SUM(CASE WHEN DATE_DIFF(cohort_matrix.purchase_week, cohort_matrix.cohort_week,WEEK) = 10 THEN cohort_matrix.revenue END) / (COUNT(DISTINCT user_pseudo_id)),3) AS week_10,
  ROUND(SUM(CASE WHEN DATE_DIFF(cohort_matrix.purchase_week, cohort_matrix.cohort_week,WEEK) = 11 THEN cohort_matrix.revenue END) / (COUNT(DISTINCT user_pseudo_id)),3) AS week_11,
  ROUND(SUM(CASE WHEN DATE_DIFF(cohort_matrix.purchase_week, cohort_matrix.cohort_week,WEEK) = 12 THEN cohort_matrix.revenue END) / (COUNT(DISTINCT user_pseudo_id)),3) AS week_12
FROM cohort_matrix
GROUP BY cohort_matrix.cohort_week
ORDER BY cohort_matrix.cohort_week
