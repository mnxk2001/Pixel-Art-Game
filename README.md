# Pixel Art Game Analysis
### Gaming Analytics | Tutorial Experiment, User Engagement, and Retention

## Table of Contents
- [Project Overview](#project-overview)
- [Business Context](#business-context)
- [Business Questions](#business-questions)
- [Dataset and Experiment Setup](#dataset-and-experiment-setup)
- [Tools and Methodology](#tools-and-methodology)
- [Key Findings](#key-findings)
- [Project Files](#project-files)
- [Limitations and Further Analysis](#limitations-and-further-analysis)
- [Contact](#contact)

## Project Overview

This project analyzes user engagement in Pixel Art Game and evaluates whether a redesigned tutorial in version **1.6.0** performed better than the previous tutorial in version **1.5.2**.

The analysis focuses on tutorial completion, repeat tutorial views, churn, and retention to assess the observed differences between the two versions and inform the rollout decision.

## Business Context

The tutorial in version **1.5.2** was considered to provide a poor user experience. In response, version **1.6.0** introduced a redesigned tutorial intended to improve the experience for new users.

Starting **October 28, 2023**, version 1.6.0 was rolled out to **50% of users**. The other 50% continued using version 1.5.2, creating two groups for comparison.

## Business Questions

1. Did the redesigned tutorial in version 1.6.0 improve the user experience compared with version 1.5.2?
2. Based on the observed results, should version 1.6.0 be rolled out to 100% of users?

## Dataset and Experiment Setup

- **Analysis period:** October 28, 2023 – November 10, 2023
- **Version 1.5.2:** Existing tutorial
- **Version 1.6.0:** Redesigned tutorial
- **Rollout:** Version 1.6.0 was assigned to 50% of users from October 28, 2023.

### User Groups Used in the Analysis

- **New users:** Users who chose to view the tutorial (joined).
- **Returning users:** Users who had previously used the game and viewed the tutorial during the test period.

## Tools and Methodology

| Tool | Purpose |
|---|---|
| **T-SQL** | Querying and preparing data for analysis. |
| **Python** | Performing Z-tests to compare selected metrics between the two versions. |
| **Power BI** | Visualizing user engagement and analysis results. |

### Statistical Tests

Z-tests were conducted to compare the two versions across the following metrics:

- Tutorial completion rates
- Review ratings of the instructions
- Churn rates
- Extra lives usage rates

## Key Findings

### 1. Tutorial Completion – New Users

- More than **96%** of new users completed the tutorial in both versions.
- Completion was slightly higher in version 1.6.0 than in version 1.5.2:

  - **Version 1.6.0:** 96.58%
  - **Version 1.5.2:** 96.43%

- The difference was **not statistically significant**.

**Interpretation:** The analysis did not find a statistically significant improvement in tutorial completion after the redesign.

### 2. Repeat Tutorial Views – Returning Users

- **203 returning users** viewed the tutorial during the test period.
- Repeat view rates were:

  - **Version 1.6.0:** 3.51%
  - **Version 1.5.2:** 4.23%

- The difference was **not statistically significant**.

**Interpretation:** The observed repeat view rate was slightly lower in version 1.6.0, but the analysis did not establish a statistically significant difference.

### 3. Retention and Churn

- More than **61%** of users churned in both versions.
- Around **40%** continued using the app.
- Most churn occurred after the first day of play.
- Retention was higher in version 1.6.0 than in version 1.5.2, with an observed difference of **over 4%**.

**Interpretation:** The results show an observed retention advantage for version 1.6.0, while churn remained high in both groups. The retention difference should be interpreted alongside the experiment design and statistical evidence before attributing it to the redesigned tutorial.

## Project Files

| File or Folder | Description |
|---|---|
| **Pixel Art Game Report.pdf** | Report summarizing the analysis, insights, and recommendations. |
| **Process and z test.ipynb** | Python Notebook containing the Z-test analysis. |
| **SQL Process/** | Folder containing the T-SQL query files used in the project. |

## Limitations and Further Analysis

The available README summarizes the observed results but does not include the sample sizes for every metric, confidence intervals, p-values, or detailed test assumptions. These should be included in the report or notebook to make the statistical conclusions easier to verify.

Further analysis could include:

- Reporting sample sizes, p-values, and confidence intervals for each tested metric.
- Confirming that users were assigned to the two versions appropriately and that the groups were comparable.
- Defining the retention and churn measurement windows explicitly.
- Investigating the reasons for high churn after the first day, since this pattern appeared in both versions.

## Contact

For questions or feedback, feel free to contact me at [kieumnx@gmail.com](mailto:kieumnx@gmail.com).
