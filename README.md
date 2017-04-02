# Final Project: Getting and Cleaning Data
##### A Coursera/John Hopkins University course

This readme is intended to orient and assist the reviewer in the evaluation of the project.

### Objective
The objective of this project is to develop a clean dataset from previously collected data.  The data contains summary values for 30 participants who wore a Samsung Galaxy SII smartphone on their waste while performing six different activities. 
More information about the study and data collection methodology can be found at: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.  
Additional information about the data used in this project can be found at:

### The Approach
The approach used in completing this project follows the outlines for the project.  In brief, these steps included:
1. Downloading data and saving it to disk locally.
2. Loading the data into R
3. Merging several datasets
4. Selecting the relevant columns
5. Replace numeric values for the activities with more readable labels.
6. Renaming columns for clarity and organizing ("tidying") the data appropriately.
7. Summarizing and calculating the values required for output.
8. Saving the final results file locally.

These steps are documented in the run_analysis.R script in this repository.

### Final Data
The format chosen for the final data output conforms to the principles of tidy data.  Each row represnts an observation.  Each column represents one variable. Additional fixed values known in advance of the observations are in the left-most columns whereas columns containing the collected values appear at the right.  It was deemed that the "tall, skinny" format for the data made it easiest to summarize and present the final, calculated values.

### Steps to reproduce this project
* Open the R script run_analysis.r using a text editor.
* Change the parameter of the localwd variable.
* Save run_analysis.r in the localwd folder.
* Run the R script run_analysis.r. 

### Outputs produced
Tidy dataset file: final_df.csv (comma-delimited text)
