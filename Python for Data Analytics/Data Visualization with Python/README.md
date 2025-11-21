# Coursera Course Analysis
This project explores ~900 courses from the Coursera Course Dataset to uncover what drives course popularity and ratings. Using Python, Pandas, Matplotlib and Seaborn, this Jupyter notebook describes steps of data importing, data cleaning, exploratory data analysis, data conversions, and correlation calculations. At the end of the notebook are findings and insights from this analysis and future improvements.

## Objectives
- Load and clean data from Kaggle
- Perform EDA
- Visualize patterns with Matplotlib & Seaborn.
- Provide clear insights supported by data.

## Dataset Overview
The dataset includes the following columns:

- 'course_title' : Name of the course
- 'course_organization': University or company offering it
- 'course_Certificate_type': Course, Specialization, Professional Certificate
- 'course_rating': Average rating (out of 5)
- 'course_difficulty' : Beginner, Intermediate, Advanced, Mixed
- 'course_students_enrolled' : Number of students enrolled

## Full Dataset
[Kaggle - Coursera Course Dataset](https://www.kaggle.com/datasets/siddharthm1698/coursera-course-dataset/code)

## Data Analysis
### Exploratory Analysis
- Correlation between course rating and students enrolled
- Distribution of course ratings
- Student enrollment patterns
- Course difficulty trends
- Organizational superlatives

## Findings and Insights
- There are 891 course titles and 154 unique organizations represented in this dataset.
- 3 types of courses are offered: Individual Course, Specialization, and Professional Certificate
- 4 Course Difficulties exist: Beginner, Intermediate, Mixed, and Advanced

### Statistical Findings
- There is a very weak correlation between the number of students enrolled and course ratings (r = 0.07)
- Course ratings range from 3.3 to 5.0 but skew generally between 4.5 and 4.9

### General Insights
- Most students are enrolled in Beginner level and Individual courses
- One of the highest rated courses (5.0) is also the least enrolled (1500 students)
- Beginner courses are widely offered, while there are only 19 Advanced courses offered
- Individual courses have >51 million students enrolled while professional certificates have ~2.3 million students enrolled

### Organizational Insights
- University of Pennsylvania offers the most number of courses with 44 Individual courses and 15 Specializations; no professional certificates
- University of Michigan has the most number of student's enrolled with ~7.4 million students

## Future Improvements
Planned enhancements for future versions include:
- Look further into what drives ratings on Coursera.
- Does course difficulty affect the number of students enrolled in a course, specialization, or certificate?
- Which institutions offer professional certificates?
