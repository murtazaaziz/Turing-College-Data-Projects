# Customer Lifetime Value (CLV) Analysis

### Intro
Customer Lifetime Value (CLV) is a crucial metric within e-commerce analytics that helps businesses segment and personalize marketing efforts. It can also help businesses make smarter decisions that lead to better profitability and growth. While other indicators like new customer acquisition, retention rate, and conversion rate are important, CLV aims to integrate them all. It gives a better and more complete picture of each customer's long-term value.

CLV can be measured in two ways:

- Historical CLV – Based on actual purchases and relationship length so far. This provides concrete insights into spending habits.
- Predictive CLV – An estimate of future spending based on patterns and projections. While not always exact, it helps companies forecast revenue and refine strategies.

There are simplistic ways of calculating CLV but cohort analysis can provide more reliable and actionable insights as customers are segmented into cohorts.

### Project Objectives
- Complete a weekly cohort analysis for a 12-week period
- Track users by their first event week (registration cohort) and analyze spending over 12 weeks
- Write queries using CTE's and JOINS to extract user data (assuming the current week is 2021-01-24)
- Using extracted data, calculate the Average Revenue per User (weekly revenue/number of users in registration cohort) for the initial registration week and the following 12 weeks.
- Calculate Cumulative Average Revenue per User over 12 weeks and Cumulative Growth %
- Predict Cumulative Average Revenu per User for weeks where data is missing using Cumulative Growth %
- Apply conditional formatting as needed 

### Data Sources
  [BigQuery Dataset](https://console.cloud.google.com/bigquery?ws=!1m5!1m4!4m3!1stc-da-1!2sturing_data_analytics!3sraw_events)

raw_events dataset was provided by Turing College. This dataset has details of website events including the date and the times the events occurred.

The following columns, relavant to the project objectives,were used:

```
field name                 type

event_date                 STRING	
event_timestamp	           INTEGER	
user_pseudo_id             STRING	
purchase_revenue_in_usd    FLOAT	
```

### Main Analysis

[Spreadsheets](https://docs.google.com/spreadsheets/d/e/2PACX-1vQ0OhlByDugvBbgB6fifTxA8WVhPxhUPDkum0_7bvZnEqgNUdvrOmy8M0916nP97r7pO5YceraBwkfI/pubhtml)

#### 1. Average Revenue per User

In this task, three CTEs and a main query were used to extract the Average Revenue per User (ARPU). ARPU is defined as weekly revenue divided by the number of registrations in cohort. The data from this website did not have a concept of registration. Therefore, the first visit to the website was used as a registration/cohort date.

![image](https://github.com/user-attachments/assets/406f5a05-8137-4d71-8cfb-716f669f0241)

- Average revenue per user is the highest upon initial website visit and decreases week over week across all cohorts
- Users spent more during Weeks 1-3 after their first website visit
- Cohorts between Nov. 1 and Dec. 13 spent more during the week 0 than cohorts between Dec. 20 through Jan. 24; could indicate a seasonal effect

#### 2. Cumulative Average Revenue per User over 12 weeks

The ARPU was summed over 12 weeks and a cumulative average and percent cumulative growth were calculated.

![image](https://github.com/user-attachments/assets/d144a119-5207-4b7f-81a2-35b2d3e67f55)

- Cumulative average revenue per user for Nov. 1 cohort is $2.37
- Percent cumulative growth slows from 23% at Week 1 to 6% by Week 4

#### 3. Predictions for Cumulative Average Revenue per User 

Missing data for cumulative revenue was calculated using the % cumulative growth from the previous step. 

![image](https://github.com/user-attachments/assets/3d6e7ea0-295b-44ee-ab50-109a167c557a)

- The predicted 12-week cumulative ARPU for November cohorts range between $2.37 to $2.67 in November
- However, the predicted 12-week cumulative ARPU for December cohorts are significantly lower and range between $0.48 to $1.82
- The prediction for Average Lifetime Value for Nov. 1 to Jan. 24 cohorts is calculated to be $1.47 

### Key Insights
1. Average revenue per user is the highest upon initial website visit and generally decreases weekly across all cohorts
2. Users spent more during Weeks 1-3 after their first website visit
3. Seasonality likely has an effect on cohorts between Nov. 1 and Dec. 13
4. The prediction for Average Lifetime Value for Nov. 1 to Jan. 24 cohorts is calculated to be $1.47

### Recommendations
1. Promotions could help boost the ARPU of users for week 0 and beyond for cohorts between Dec. 20 through Jan. 24
2. Upselling and cross-selling to cohorts between Nov. 1 to Jan. 24 may help increase their ARPU and overall Average Lifetime Value 

   
