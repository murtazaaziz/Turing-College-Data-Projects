WITH agg_data AS(
  --CTE to aggregate total revenue per location over 4-week promotional period
  SELECT 
    DISTINCT location_id,
    promotion,
    SUM(sales_in_thousands) as revenue_per_location
  FROM `tc-da-1.turing_data_analytics.wa_marketing_campaign`
  GROUP BY location_id, promotion
  ORDER BY promotion ASC
)
--Main query to aggregate total revenue and average revenue per promotion
SELECT 
promotion,
count(location_id) num_locations,
SUM(revenue_per_location)/count(promotion) as avg_revenue
FROM agg_data
GROUP BY promotion
