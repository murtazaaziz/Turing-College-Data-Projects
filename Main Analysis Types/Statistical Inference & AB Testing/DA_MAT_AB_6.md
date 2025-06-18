For the graded task, you will use the [Fast Food Marketing Campaign A/B Test dataset](https://www.kaggle.com/datasets/chebotinaa/fast-food-marketing-campaign-ab-test). This dataset is also available in the turing_data_analytics project - [wa_marketing_campaign](https://console.cloud.google.com/bigquery?ws=!1m5!1m4!4m3!1stc-da-1!2sturing_data_analytics!3swa_marketing_campaign)

<br>

# Task

You should follow the structure identical to the one in the hands-on task. Analyze the A/B test and provide recommendations.

Some notes:

- The dataset is aggregated by LocationID, PromotionID, and week. You should aggregate by LocationID and PromotionID before conducting the statistical tests.
- Since there are three marketing campaigns and you have to select the best-performing one, you will have to conduct several tests, comparing campaigns against one another. This kind of testing is known as pairwise comparisons, and it suffers from the [multiple testing problem](https://en.wikipedia.org/wiki/Multiple_comparisons_problem) - if we run a lot of tests, there’s an increased chance of getting a type I error (false positive). It is, therefore, suggested to use the confidence level of 99% instead of the traditional 95% in your graded task.

<br>

# Evaluation Criteria

- General understanding of the topic
- [A/B Testing] SQL queries are correct and follow SQL best practices.
- [A/B Testing] Metrics are correctly calculated.
- The document with AB test results is clear, concise, and follows the required structure.
- [A/B Testing] The results of statistical tests are performed and interpreted correctly.
- Analytical approach to the problem. Did the learner use their analysis to provide justified, useful, and actionable insights?

<br>

# Additional Resources for this Sprint

Probability, statistical inference, and A/B testing are all incredibly rich topics. If you are curious to learn more, jump into the resources below or save them for later use.

- Probability
  - (optional) Harvard course - [Fat Chance](https://www.edx.org/learn/probability/harvard-university-fat-chance-probability-from-the-ground-up?webview=false&campaign=Fat+Chance%3A+Probability+from+the+Ground+Up&source=edx&product_category=course&placement_url=https%3A%2F%2Fwww.edx.org%2Flearn%2Fprobability)
  - (optional) Harvard course - [Introduction to Probability](https://www.edx.org/learn/probability/harvard-university-introduction-to-probability?webview=false&campaign=Introduction+to+Probability&source=edx&product_category=course&placement_url=https%3A%2F%2Fwww.edx.org%2Flearn%2Fprobability)
- Statistical Inference
  - (optional) [Andrew Gelman Blog](https://statmodeling.stat.columbia.edu/)
  - (optional) [Harvard’s Statistics 110: Probability course](https://projects.iq.harvard.edu/stat110)
  - (optional) [Richard McElreath - Statistical Rethinking](https://xcelab.net/rm/)
  - (optional) [Allen Downey Blog](https://www.allendowney.com/blog/)



<br>

### BigQuery Account Information

> **Important note**: To ensure continued access to your projects and to retrieve saved queries, we suggest creating your own BigQuery account. As a reminder, Turing College automatically deletes provided Google accounts and BigQuery access one month after your `maximum platform access` period ends. You can fulfill these steps later in the program.

> To keep all your completed projects and spreadsheet files organized, transfer them to your personal Google Drive. Also, please save all SQL code from your projects in your newly created personal BigQuery account or your notes.

> Instructions for setting up a free BigQuery account and guidelines for running saved queries can be found [here](https://drive.google.com/file/d/1B147mRHDP3wYL11SMK3nAZfbDcH8lP3h/view?usp=sharing).

