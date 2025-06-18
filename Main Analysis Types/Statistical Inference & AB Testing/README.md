# 🍟 Fast Food Marketing Campaign A/B Test 🍟

## Introduction
A fast-food chain plans to add a new promotional item to its menu. However, they are still undecided between three different marketing campaigns for promoting the new product. To determine which promotion has the greatest effect on sales, these promotional campaigns were implemented at various locations in several randomly selected markets. 

## Problem and Goal
As it can be a substantial investment for the company, it is crucial to determine which marketing campaign will maximize the sales for the new menu item. The primary challenge is to find out which marketing campaign is likely to yield the highest sales for the new menu item.

The goal of this analysis is to complete A/B testing to evaluate which of the 3 marketing campaigns yields the highest sales and provide actionable insights for the company’s marketing decisions.

## Dataset Overview
Full dataset can be found [here](https://www.kaggle.com/datasets/chebotinaa/fast-food-marketing-campaign-ab-test)

Key columns in the dataset are:

- MarketID: unique identifier for market
- MarketSize: size of market area by sales
- LocationID: unique identifier for store location
- AgeOfStore: age of store in years
- Promotion: one of three promotions that were tested
- Week: one of four weeks when the promotions were run
- SalesInThousands: sales amount for a specific LocationID, Promotion, and week

Target metric
There is one key metric available in the dataset - sales in thousands and will be renamed as revenue. Revenue is aggregated by location.

## Data Extraction and Transformation
Relevant data was extracted from the dataset on BigQuery. Columns extracted were LocationID, Promotion, and SalesInThousands

## Experimental Design

Promotions 2 and 3 were available in 47 locations each while Promotion 1 was offered in 43 locations.

<img width="623" alt="image" src="https://github.com/user-attachments/assets/257c4ded-ed61-4ff7-9873-3f1ad30f5793" />

Figure 1

The independent variable is the promotional group (categorical) and the dependent variable is the revenue (numerical and continuous). 

Null Hypothesis (H0): There is no statistically significant difference between the revenue means from each promotional group.

Alternative Hypothesis (Ha): There is a statistically significant difference between the revenue means from each promotional group. 

## Statistical Tests & Analysis
Overall, three test groups will be evaluated with the null hypothesis (H₀) assuming that there is no difference between any of the sample groups.

First, a one-way ANOVA is completed to determine if there is a statistically significant difference between the means of the 3 promotional groups. A one-way ANOVA is chosen as there are more than 2 groups and the groups are independent of each other. No location had multiple promotions in place.

<img width="623" alt="image" src="https://github.com/user-attachments/assets/716ae759-2811-4c41-8287-8370fcdcbf1d" />

Figure 2

In this case, the F test statistic is 5.85 and the F critical value is 4.77. Since the F test statistic is greater than the critical value, we reject the null hypothesis and conclude that there is a statistically significant difference between the means for the three promotional groups.

Three test groups will be evaluated with the null hypothesis (H0) that there is no difference between any of the sample groups. The alternative hypothesis (Ha) is that there is a difference between at least one sample group.

To decrease the likelihood of Type I errors (false positives) during independent samples t-test, a confidence interval of 99% is selected for this analysis.

## Group 1 (1 VS 2)

<img width="627" alt="image" src="https://github.com/user-attachments/assets/3855259a-6069-4f3d-a768-8b4b0794567d" />  


With a p-value less than the alpha value, we can conclude that there is a statistically significant difference between group 1 and group 2.

<img width="438" alt="image" src="https://github.com/user-attachments/assets/a3b43946-9f88-4b6f-a357-ac4173223ef0" />

Promotion 1 generates a higher revenue ($232.40 in thousands) than Promotion 2 ($189.32 in thousands) with a mean difference of $43.08 in thousands.
## Group 2 (1 VS 3)

<img width="628" alt="image" src="https://github.com/user-attachments/assets/75ee2792-7ff4-4cb5-b316-8ee640f26e74" />


With the p-value greater than the alpha value, we can conclude that there is no statistically significant difference between group 1 and group 3.

<img width="463" alt="image" src="https://github.com/user-attachments/assets/1cac0308-f7d1-40e8-be79-559d791a63c6" />

## Group 3 (2 VS 3)

<img width="624" alt="image" src="https://github.com/user-attachments/assets/c97a13ba-4333-4a20-81f0-cc83553e7f77" />


With the p-value greater than the alpha value, we can conclude that there is no statistically significant difference between group 2 and group 3.

<img width="453" alt="image" src="https://github.com/user-attachments/assets/3b912651-3429-4639-bee0-b7963e195568" />

## Results and Findings
Based on the independent t-tests above, the following conclusions can be drawn:
- There is a statistically significant difference between promotion 1 and promotion 2. Promotion 1 generates a significantly higher revenue than promotion 2 with a mean difference of $43.08 thousand.
- There is no statistically significant difference between promotion 1 and promotion 3.
- Although promotion 3 does generate a higher revenue than promotion 2, it is not statistically significant.

## Recommendations
1. It is recommended for the fast-food chain to use promotion 1 for the new menu item as it generated the highest average revenue (232.4 in thousands) across 43 locations.
2. Promotion 3 does generate a high average revenue (221.5 in thousands) across 47 locations but when compared to promotion 1 there is not a significant enough difference.
3. Promotion 2 generates the lowest average revenue (189.3 in thousands) across 47 locations and can likely be discontinued by the marketing team.

## Assumptions & Limitations
**Market Homogeneity:** The analysis assumes that all markets are relatively homogeneous, and the promotional campaigns have a similar impact across different market sizes and store ages.

**Market Differences:** One of the primary limitations is that markets may differ significantly in terms of size, demographics, and other characteristics. This analysis does not account for these potential differences, which could skew the results. To address this limitation, it is advised to test for overall differences between promotions and further investigate the data segmented by market size and other relevant factors such as store age. This approach will help to understand the nuances of each market and promotional effectiveness amongst locations with similar characteristics.

**Sample Sizes:** The smaller sample size for Promotion 1 may result in less precise estimates of the mean and increased sensitivity to outliers, which could influence the results compared to Promotions 2 and 3.

## Appendix 
SQL Query via BigQuery can be viewed in sql file








