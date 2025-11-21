# Cardiovascular Disease Prediction

This notebook explores an analysis of attributes that are potential risk factors for coronary heart disease (CHD). It also fits a logistic regression model for predicting the 10-year risk of CHD.

We look at various demographic, behavioral, and medical risk factors along with lab values and vital signs to uncover patterns, insights, and 10 year risk of CHD

## Executive Summary

This project developed a **logistic regression model** to predict **10-year coronary heart disease (CHD) risk** using demographic, behavioral, and clinical variables from the Framingham dataset. After addressing **class imbalance** and removing multicollinear features (isSmoking, diaBP, prevalentHyp, diabetes), the refined model demonstrated **balanced sensitivity and specificity** with improved recall for the minority class (CHD).

At the **default threshold (0.5)**, the model achieved **0.67 accuracy** and **0.68 recall** for CHD cases. When the **threshold was optimized to 0.47, recall improved to 0.73**, indicating the model became better at identifying individuals at risk of CHD, while **accuracy slightly decreased to 0.64** — a reasonable trade-off for improved sensitivity.

The model identified **age, systolic blood pressure, cigarette consumption, total cholesterol, and glucose levels** as the strongest predictors of CHD risk, while **female sex and higher education** were protective. These findings align with established cardiovascular research, supporting the model’s validity and interpretability.

## Key Takeaways
#### **1. Model performance**

| Metric              | Default Threshold (0.5) | Optimal Threshold (0.47) |
| :------------------ | :---------------------: | :----------------------: |
| **Accuracy**        |           0.67          |           0.64           |
| **Precision (CHD)** |           0.27          |           0.26           |
| **Recall (CHD)**    |           0.68          |           0.73           |
| **F1 (CHD)**        |           0.38          |           0.38           |


---

* After addressing class imbalance, the model now detects over two-thirds of true CHD cases, a major improvement from earlier versions.

* However, precision remains modest (~0.26–0.27), meaning that some non-CHD individuals are flagged as high-risk — an acceptable trade-off in preventive screening contexts.

* The slight drop in overall accuracy after rebalancing reflects a model more sensitive to minority cases (CHD), a desired outcome in clinical risk prediction.

#### **2. Feature Insights**

**Top risk-increasing predictors:**
* Age
* Systolic blood pressure
* Cigarettes per day
* Total cholesterol
* Glucose levels
* Use of blood pressure medication

**Protective predictors:**

* Female sex (consistent with lower CHD incidence)
* Higher education (proxy for socioeconomic and behavioral factors)

#### **3. Methodological Improvements**

* **Class imbalance correction** (class-weight adjustment) helped the model better detect CHD cases.

* **Multicollinearity mitigation** improved model stability and interpretability by removing overlapping predictors.

* **Pipeline automation** ensures consistent preprocessing (imputation, scaling, encoding) and model training.

## Recomendations

**For Model Application**

* Use the lower threshold (≈0.47) in clinical screening to prioritize sensitivity (identifying more true CHD cases).

* Present probabilities, not just binary labels, allowing clinicians to interpret risk on a continuous scale.

* Integrate with a risk stratification framework, such as categorizing probabilities into low, moderate, and high risk groups.

**For Further Model Improvement**

* Enhance precision through feature engineering (e.g., interactions between age × BP or smoking × cholesterol).

* Test alternative models (Random Forest, XGBoost, Logistic Regression with ElasticNet regularization) to capture potential nonlinear relationships.

**For Broader Impact**

* Validate the model on an external dataset or recent cohort to ensure generalizability beyond the Framingham population.

* Incorporate the model into a decision-support dashboard where clinicians can input patient data and view individualized CHD risk scores.

* Share findings with clinical collaborators to evaluate potential integration into preventive health programs or patient education tools.
