SELECT 
    event_name,
    count(event_name) as count
FROM
  `tc-da-1.turing_data_analytics.raw_events` as raw_events
GROUP BY event_name
ORDER BY count DESC
