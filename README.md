# PIXEL ART GAME ANALYSIS  

This project analyzes user engagement with data from **October 28th, 2023 to November 10th, 2023**.  

## Business Problems  

1. The tutorial in game version 1.5.2 provided a poor user experience. To address this, version 1.6.0 introduced a redesigned tutorial, with the expectation that it would improve user experience.  
   - _**Q:**_ How can we determine if the new tutorial in version 1.6.0 improved the user experience compared to version 1.5.2?  

2. Version 1.6.0 was rolled out to **50% of users** starting October 28, 2023, meaning half of the new users continued on version 1.5.2 while the other half experienced version 1.6.0.  
   - _**Q:**_ Should we roll out version 1.6.0 to 100% of users? Why or why not?  

## Highlights  

- **New users**: Only users who chose to view the tutorial (joined).  
  - Over 96% completed the tutorial in both versions.  
  - Completion was slightly higher in version 1.6.0 than in version 1.5.2, but the difference was not significant (96.58% vs. 96.43%).  

- **Returning users**:  
  - 203 returning users viewed the tutorial during the test period.  
  - Repeat view rates were slightly lower in version 1.6.0 compared to version 1.5.2 (3.51% vs. 4.23%), though the difference was not significant.  

- **Retention and churn**:  
  - More than 61% of users churned in both versions, while around 40% continued using the app.  
  - Most churn occurred after the first day of play.  
  - Retention was higher in version 1.6.0 than in version 1.5.2, with a difference of over 4%.  

## Project Details  

### Process  

- Conducted **Z-tests** on both versions for:  
  - Tutorial completion rates  
  - Review ratings of the instructions  
  - Churn rates  
  - Extra lives usage rates 

- Tools and methods used:  
  - **T-SQL** for querying and preparing data  
  - **Python** for running Z-tests  
  - **Power BI** for data visualization  

### Files  

- **Pixel Art Game Report.pdf** – summary of insights and recommendations  
- **Process and z test.ipynb** – Python notebook for Z-tests
- **SQL Process** folder – contains T-SQL query files  

## Contact  

For questions, please contact me at [kieumnx@gmail.com](mailto:kieumnx@gmail.com).  