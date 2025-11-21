WITH 
table1 AS(
  SELECT 
  user_pseudo_id,	  
  event_name,	
  event_timestamp,	
  ROW_NUMBER() OVER (PARTITION BY user_pseudo_id, event_name) AS first_event_timestamp,	
  event_date,	
  event_value_in_usd,	
  user_id,	
  user_first_touch_timestamp,	
  category,	
  mobile_model_name,	
  mobile_brand_name,	
  operating_system,	
  language,	
  is_limited_ad_tracking,	
  browser,	
  browser_version,	
  country  
  FROM `tc-da-1.turing_data_analytics.raw_events` as ranked_events_table
  ORDER BY 1,2,3
),
table2 AS(
  SELECT *
  FROM table1
  WHERE first_event_timestamp = 1
)
SELECT country, count(*) as unique_event_count
FROM table2 
GROUP BY 1 
ORDER BY 2 DESC 
LIMIT 3
