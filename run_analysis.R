## Getting and Cleaning Data Course Project
## load libraries
library(readr)
library(dplyr)

## Step 1: download and unzip the necessary data into a folder called "projectData" 
## in the working directory
url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"projectData.zip")
unzip("projectData.zip",exdir = "projectData")

## Step 2: Load/read the various data sets into R
testx <- read.csv(
    "~/R_Projects/projectData/UCI HAR Dataset/test/X_test.txt",
    sep="",header=FALSE)
testy <- read.csv(
    "~/R_Projects/projectData/UCI HAR Dataset/test/y_test.txt",
    sep="",header=FALSE)
testsubject <- read.csv(
    "~/R_Projects/projectData/UCI HAR Dataset/test/subject_test.txt",
    sep="",header=FALSE)
trainx <- read.csv(
    "~/R_Projects/projectData/UCI HAR Dataset/train/X_train.txt",
    sep="",header=FALSE)
trainy <- read.csv(
    "~/R_Projects/projectData/UCI HAR Dataset/train/y_train.txt",
    sep="",header=FALSE)
trainsubject <- read.csv(
    "~/R_Projects/projectData/UCI HAR Dataset/train/subject_train.txt",
    sep="",header=FALSE)
features <- read.csv(
    "~/R_Projects/projectData/UCI HAR Dataset/features.txt",
    sep="",header=FALSE)
activitylabels <- read.csv(
    "~/R_Projects/projectData/UCI HAR Dataset/activity_labels.txt",
    sep="",header=FALSE)


## Step 3: Merge training and test data sets into one
## testx,testy and testsubject are randomly selected data from the total population (30%)
## trainx,trainy and trainsubject are randomly selected data from the total population (70%)
## this step recombines the two parts into one unified set (i.e. the total population)
    allx <-rbind(testx,trainx)
    ally <-rbind(testy,trainy)
    allsubject <-rbind(testsubject,trainsubject)
    
## Step 4: Select relevant columns: extract the mean and standard deviation for each measurement.  Additionally, combine the activity and subject identifiers to the data and label appropriate

    #label columns in allx to allow proper extraction
    names(allx) <- features$V2

    #reduce data set(x) to mean and std values only
    dffinal <- allx[,(grepl("mean()",names(allx)) | grepl("std()",names(allx))) & !(grepl("meanFreq",names(allx)))]
    
    #clean the column names of extra "()"
    match_str = "[()]"
    names(dffinal) <- gsub(match_str,"",names(dffinal))
    
    #merge with subjects and activities
    dffinal <- cbind(allsubject,ally,dffinal)
    
    ##label the columns new columns
    names(dffinal)[1] <- 'subjectid'    
    names(dffinal)[2] <- 'activity'
    

## Step 5: Replace numeric values for the activities with readable labels
    dffinal$activity <- activitylabels[,2][match(dffinal$activity,activitylabels[,1])]

## Step 6: label the data set with descriptive variable names,and further tidy the data
#tidy the data set - create columns from colnames (warnings about too few values in some rows are expected)
    dffinal <- dffinal %>% 
        gather(measure,value,-subjectid,-activity) %>%
        separate(measure,c("feature","measure","axis"))
    

#sort data set by subjectid and activity in asc order
    dffinal <- arrange(dffinal,subjectid,activity)

## Step7: Summarize and calculate averages for all values.  Create a tidy data set with the average of each variable for each activity and
## each subject.
    dffinalgrp <- group_by(dffinal,subjectid,activity,feature,axis)
    final_df <- summarize(dffinalgrp,count=n(),average = mean(value))

## Step 8: save result
    write.csv(final_df,"~/R_Projects/projectData/UCI HAR Dataset/final_df.txt",fileEncoding = "UTF-8")
    
