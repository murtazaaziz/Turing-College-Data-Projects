# Customer Segmentation & RFM

### Intro
  The success and growth of a business can rely on understanding the needs, behaviors, preferences, and buying patterns of their customers. Customer segmentation and RFM analysis allows businesses to categorize existing and potential customers into different groups and see their shopping habits. RFM analysis looks at recency (R), frequency (F), and the amount of money customers spend (M). This allows marketing and sales teams to tailor their campaigns and actions to boost customer relationships, retention, and overall experience.

### Project Objectives
- Use SQL for calculation and data selection using data from 12-01-2010 to 12-01-2011.
- Calculate recency, frequency, and monetary value and convert those values into R, F, and M scores by using quartiles, 1 to 4 values. 
- Calculate recency from date 2011-12-01.
- Calculate common RFM score.
- Segment customers into Champion, Loyal Customers, Average Customers, Recent Customers, Can't Lose Them, and Lost Customers.
- Present analyses with a dashboard using Tableau or Power BI.
- Present customer segment insights that the marketing team can use for their next campaign.

### Data Sources
  [BigQuery Dataset](https://console.cloud.google.com/bigquery?ws=!1m5!1m4!4m3!1stc-da-1!2sturing_data_analytics!3srfm)

The following is the schema of the dataset:

```
field name      type

(InvoiceNo)     STRING	
StockCode       STRING	
Description     STRING	
(Quantity)      INTEGER	
(InvoiceDate)   TIMESTAMP	
(UnitPrice)     FLOAT	
(CustomerID)    INTEGER	
Country         STRING

```
This ```rfm dataset```, provided by Turing College, has the details from individual invoices from 12-01-2010 to 12-09-2011. The columns that were most relavant to this project are in marked in parenthesis above.

### Questions
1. How do customer segments perform?
2. Which groups need to further attention to change buying patterns and boost retention?
3. What are different ways to increase engagement within these segmented groups?

### Preparation and Process
- Data extraction from rfm table completed using columns relevant to project objectives (see above).
- Queries written to calculate recency, frequency, and monetary values for each unique customer ID
- Quartiles were set for recency, frequency, and monetary values using PERCENTILE_CONT() function
- CASE WHEN function used to assign r_score, f_score, and m_ based on set quartiles
- CASE WHEN function used to classify customers into the following segments: Champions, Loyal Customers, Can't Lose Them, Average Customers, Recent Customers, and Lost Customers.

### Main Analysis

Based on queries and customer segmentation, I prepared a Tableau dashboard to highlight KPIs and the performance and metrics about key groups.

Customers were grouped into the following groups:

- **Best Customers**: have the highest recency, frequency, and monetary score (4)
- **Loyal Customers**: have high freqency scores and monetary scores (>=3) and recency score >=2
- **Recent Customers**: have a high recency score (>=3) and average or below average frequency and monetary scores (<=2)
- **Can't Lose Them**: have average/above average monetary scores (>=3), freqeuncy scores between 2 and 3, and average/below average recency scores (<=2)
- **Lost Customers**: have the lowest recency and monetary score (1) and an average/below average frequency score (<=2)
- **Average Customers**: all other customers

![image](https://github.com/user-attachments/assets/8f935b2d-3491-4d3b-b831-6f2a4a5a6c11)

[Customer Segmentation & RFM Dashboard](https://public.tableau.com/views/RFM_Analysis_17470173719130/SegmentationRFMDashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

### Key Insights
1. **Champions** are composed of ~11% of your total customer base. On average they completed 14 purchases over the past year and spent $8700 on products. They are repeat purchasers that see the value in our products and they are coming back often. These customers should be rewarded for their loyalty. <br /><br /> &ensp; _Consider giving them exclusive offers, implementing a loyalty rewards program, or early access to new products._

2. **Loyal Customers** compose ~42% of our total customers and are our second highest value group. On average they completed 4-5 purchases over the past year and spent $1800 on products. Their frequency and monetary scores are high but recency is lacking. <br /><br /> &ensp; _Incentivise them with a possible loyalty rewards program, early access to new product releases, offer them a subscription plan (if available)._

3. Welcome and impress **Recent Customers** as they have great potential to become Loyal or Best Customers. Follow up with New Customers shortly after their first purchase to deliver a great brand experience. <br /><br /> &ensp; _Some options for engagement might include a purchase confirmation and welcome email, inviting them to follow your blog or social content, signing up for a marketing newsletter._
   
4. Finding out why **Lost Customers** left can help you continue to engage your existing customers. <br /><br /> &ensp; _Quick feedback surveys can help you address your pain points and improve your offerings_

5. Learning why **Can't Lose Them** aren't returning can make a huge impact on your customer experience. They have a high monetary value as they have made bigger purchases but their avg. frequency of orders is typically 1.5x a year and they haven't made a purchase in 175 days on average. <br /><br /> &ensp; _Quick surveys with an included discount code can help tell us why this group does not order more often or why they have not ordered recently._
