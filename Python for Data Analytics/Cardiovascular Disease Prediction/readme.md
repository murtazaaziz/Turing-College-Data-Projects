# Cardiovascular Disease Prediction

This notebook explores an analysis of attributes that are potential risk factors for coronary heart disease (CHD). It also fits a logistic regression model for predicting the 10-year risk of CHD.

We look at various demographic, behavioral, and medical risk factors along with lab values and vital signs to uncover patterns, insights, and 10 year risk of CHD

## Executive Summary

This analysis applied logistic regression to predict 10-year coronary heart disease (CHD) risk using the Framingham dataset. At the default threshold (0.5), the model achieved high overall accuracy (86%) but failed to identify most true CHD cases (recall only 0.09). Adjusting the threshold to 0.18 significantly improved recall (0.60) for at-risk individuals, though at the cost of reduced precision (0.30) and lower overall accuracy (73%).

Key predictors of CHD risk include age, systolic blood pressure, smoking, glucose, and blood pressure medication use. Female sex and higher education were protective. These findings align with established cardiovascular risk factors, suggesting the model is clinically meaningful but must be carefully calibrated for deployment.

## Key Takeaways
### **Model performance**

#### Default threshold (0.5):

* Accuracy: 0.86

* Precision (CHD cases): 0.78

* Recall (CHD cases): 0.09

* F1-score (CHD cases): 0.16

* Interpretation: The model is very conservative — it rarely predicts someone will develop CHD, resulting in almost all positives being missed (false negatives).

#### Optimal threshold (0.18):

* Accuracy: 0.73

* Precision (CHD cases): 0.30

* Recall (CHD cases): 0.60

* F1-score (CHD cases): 0.41

* Interpretation: By lowering the threshold, the model identifies more than half of CHD cases (better sensitivity), but at the cost of more false alarms (false positives).

#### Risk Factors

* Strongest risk-increasing predictors: age, systolic blood pressure, smoking intensity, glucose, and use of BP medication.

* Protective predictors: female sex, higher education, lower diastolic BP, and lower resting heart rate.

* Age is the leading risk-increasing factor; increases CHD risk by about 1.69x. However, this is not a modifiable risk factor

## Recomendations


**1. Threshold Calibration for Clinical Use**

* Use a lower threshold (~0.18) if the goal is early detection of high-risk patients (prioritizing recall). This ensures more at-risk individuals are flagged for further screening or intervention.

* Use the default or higher threshold if the goal is to minimize false positives (e.g., in resource-limited screening settings).

**2. Decision Context Matters**

* In preventive healthcare, missing a true case (false negative) is riskier than a false alarm. Therefore, the 0.18 threshold is recommended for clinical screening tools.

* In contexts where downstream testing is costly or invasive, a higher threshold may be preferable.

**3. Model Development Improvements**

* Address class imbalance via oversampling (SMOTE) or class-weighted logistic regression to reduce bias against the minority (CHD) class.

* Explore non-linear models (Random Forest, XGBoost) to potentially improve ROC-AUC and balance precision-recall tradeoffs.

* Reassess using a confusion matrix to quantify false negatives and false positives under different thresholds.

**4. Clinical Integration**

* Combine this model with traditional risk calculators (e.g., Framingham Risk Score) for validation.

* Provide results to clinicians as risk probabilities rather than binary predictions, leaving final decision-making to medical judgment.
