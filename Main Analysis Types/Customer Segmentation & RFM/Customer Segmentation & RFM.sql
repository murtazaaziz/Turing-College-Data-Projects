WITH 
-- Calculating recency, frequency, and monetary values for each customer
rfm_value AS (
  SELECT 
  DISTINCT CustomerID, 
  DATETIME_DIFF(CAST('2011-12-01 23:59:59' AS TIMESTAMP), MAX(InvoiceDate), DAY) as recency,
  COUNT(DISTINCT InvoiceNo) as frequency,
  ROUND(SUM(Quantity * UnitPrice),2) as monetary
FROM `tc-da-1.turing_data_analytics.rfm` 
WHERE CustomerID IS NOT NULL and (Quantity * UnitPrice) > 0 and InvoiceDate BETWEEN "2010-12-01" AND "2011-12-01"
GROUP BY CustomerID
ORDER BY recency DESC
),

--Calculating quartiles for recency, frequency, and monetary values

rfm_quartiles AS (
  SELECT 
    customerID,
    recency,
    frequency,
    monetary,
    -- Recency quartiles (lower values = more recent = better)
    CASE 
      WHEN recency <= PERCENTILE_CONT(recency, 0.25) OVER() THEN 4
      WHEN recency <= PERCENTILE_CONT(recency, 0.50) OVER() THEN 3
      WHEN recency <= PERCENTILE_CONT(recency, 0.75) OVER() THEN 2
      ELSE 1
    END AS r_score,
    
    -- Frequency quartiles
    CASE 
      WHEN frequency >= PERCENTILE_CONT(frequency, 0.75) OVER() THEN 4
      WHEN frequency >= PERCENTILE_CONT(frequency, 0.50) OVER() THEN 3
      WHEN frequency >= PERCENTILE_CONT(frequency, 0.25) OVER() THEN 2
      ELSE 1
    END AS f_score,
    
    -- Monetary quartiles
    CASE 
      WHEN monetary >= PERCENTILE_CONT(monetary, 0.75) OVER() THEN 4
      WHEN monetary >= PERCENTILE_CONT(monetary, 0.50) OVER() THEN 3
      WHEN monetary >= PERCENTILE_CONT(monetary, 0.25) OVER() THEN 2
      ELSE 1
    END AS m_score
  FROM rfm_value
), 

-- Adding segment classifications

rfm_segments AS (
  SELECT 
  *,
  ROUND((r_score+f_score+m_score)/3, 2) AS rfm_score,
  CASE
    WHEN r_score = 4 AND f_score = 4 AND m_score = 4 THEN 'Best Customer'
    WHEN r_score >= 2 AND f_score >= 3 AND m_score >= 2 THEN 'Loyal Customer'
    WHEN r_score <= 2 AND f_score <= 2 AND m_score >= 3 THEN 'Big Spender'
    WHEN r_score = 4 AND f_score > 1 AND m_score > 1 THEN 'New Customers'
    WHEN r_score >= 3 AND f_score <= 2 THEN 'Recent but Infrequent'
    WHEN r_score <= 1 AND f_score <= 1 AND m_score <= 1 THEN 'Lost Customer'
    ELSE 'Average Customers'
  END AS customer_segment
  FROM rfm_quartiles
)

SELECT 
  *
FROM rfm_segments
