# Customer Lifetime Value Analysis (CLV)

### Intro

### Data Sources
  [BigQuery Dataset](https://console.cloud.google.com/bigquery?ws=!1m5!1m4!4m3!1stc-da-1!2sturing_data_analytics!3sraw_events)

```
field name                 type

event_date                 STRING	
event_timestamp	           INTEGER	
user_pseudo_id             STRING	
purchase_revenue_in_usd    FLOAT	
```

### Main Analysis
#### 1. Average Revenue per User

In this task, a two CTE's were used. First to extract the user's first event week and ```user_pseudo_id``` was used to distinguish between users
```
WITH 
-- 1. Get each user's first event week (registration cohort)
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
```
