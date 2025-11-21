/* table1 is CTE gathering all unique events using ROW NUMBER() function to partition by user_psuedo_id and event_name*/
WITH 
table1 AS(
  SELECT 
  user_pseudo_id,	  
  event_name,	
  event_timestamp,	
  ROW_NUMBER() OVER (PARTITION BY user_pseudo_id, event_name) AS first_event_timestamp,	
  category as device,		
  country
  FROM `tc-da-1.turing_data_analytics.raw_events` 
  ORDER BY 1,2,3
),
/* table2 is CTE filtering table1 for only row number 1 for the first event_timestamp. It is then ordered by user_pseudo_id and event_timestamp */
table2 AS(
  SELECT *
  FROM table1
  WHERE first_event_timestamp = 1
  ORDER BY 1,3
),
table3 AS(
  SELECT *
  FROM table2
  WHERE country IN (SELECT country FROM(SELECT country, count(*) FROM table2 GROUP BY 1 ORDER BY 2 DESC LIMIT 3))
   AND event_name IN ('page_view', 'view_item', 'add_to_cart', 'add_shipping_info', 'add_payment_info', 'purchase')
),

number_of_events AS (
  SELECT 
    device,
    event_name,
    count(*) AS event_count,
    RANK() OVER(ORDER BY count(*) DESC) AS event_order --68964 dense_rank
  FROM table3
  GROUP BY 1,2
  ORDER BY 3 
),

country1 AS (
  SELECT 
    device,
    country,
    event_name,
    count(*) as first_country_events_US
  FROM table3
  WHERE country = (SELECT country FROM(SELECT country, COUNT(*) FROM table2 GROUP BY 1 ORDER BY 2 DESC LIMIT 1))
  GROUP BY 1,2,3
  ORDER BY 3 DESC
),

country2 AS (
   SELECT 
    device,
    country,
    event_name,
    count(*) as second_country_events_India
  FROM table3
  WHERE country = (SELECT country FROM(SELECT country, COUNT(*) FROM table2 GROUP BY 1 ORDER BY 2 DESC LIMIT 1 OFFSET 1))
  GROUP BY 1,2,3
  ORDER BY 3 DESC
),

country3 AS (
  SELECT 
    device,
    country,
    event_name,
    count(*) as third_country_events_Canada
  FROM table3
  WHERE country = (SELECT country FROM(SELECT country, COUNT(*) FROM table2 GROUP BY 1 ORDER BY 2 DESC LIMIT 1 OFFSET 2))
  GROUP BY 1,2,3
  ORDER BY 3 DESC
)

SELECT
  RANK() OVER (PARTITION BY number_of_events.device ORDER BY country1.first_country_events_US DESC) AS event_order,
  number_of_events.device,
  number_of_events.event_name,
  country1.first_country_events_US,
  country2.second_country_events_India,
  country3.third_country_events_Canada
FROM number_of_events
JOIN country1
ON number_of_events.event_name = country1.event_name
AND number_of_events.device = country1.device
JOIN country2
ON number_of_events.event_name = country2.event_name 
AND number_of_events.device = country2.device
JOIN country3
ON number_of_events.event_name = country3.event_name 
AND number_of_events.device = country3.device
ORDER BY 2,1
