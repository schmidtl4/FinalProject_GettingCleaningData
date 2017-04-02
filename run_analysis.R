## Getting and Cleaning Data Course Project
## load libraries
library(dplyr)
library(tidyr)

## set working directory
localwd = "C:/Users/Les/Documents/R_Projects/projectData/UCI HAR Dataset"
setwd(localwd)

## download and unzip the necessary data into a folder called "projectData" 
## in the working directory
url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"projectData.zip")
unzip("projectData.zip",exdir = "projectData")

## read the various data sets
testx <- read.csv(
    "test/X_test.txt",
    sep="",header=FALSE)
testy <- read.csv(
    "test/y_test.txt",
    sep="",header=FALSE)
testsubject <- read.csv(
    "test/subject_test.txt",
    sep="",header=FALSE)
trainx <- read.csv(
    "train/X_train.txt",
    sep="",header=FALSE)
trainy <- read.csv(
    "train/y_train.txt",
    sep="",header=FALSE)
trainsubject <- read.csv(
    "train/subject_train.txt",
    sep="",header=FALSE)

# read the list of feature names
features <- read.csv(
    "features.txt",
    sep="",header=FALSE)

# read the activity labels 
activitylabels <- read.csv(
    "activity_labels.txt",
    sep="",header=FALSE)


## Step 1: Merge training and test data sets into one
## testx,testy and testsubject are randomly selected data from the total population (30%)
## trainx,trainy and trainsubject are randomly selected data from the total population (70%)
## this step recombines the two parts into one unified set (i.e. the total population)
    allx <-rbind(testx,trainx)
    ally <-rbind(testy,trainy)
    allsubject <-rbind(testsubject,trainsubject)
    

## Step 2: extract the mean and standard deviation for each measurement

    # label columns in allx to allow proper extraction
    names(allx) <- features$V2

    # reduce data set(x) to mean and std values only using regular expressions
    col_str1 <- "(mean|std)[()]{2}-[X-Z]$"
    col_str2 <- "(mean|std)[()]{2}$"

    #create core final dataframe from x values
    dffinal <- allx[, grepl(col_str1,names(allx)) 
        | grepl(col_str2,names(allx))]
    
    # clean the column names of extra "()"
    match_str = "[()]"
    names(dffinal) <- gsub(match_str,"",names(dffinal))
    
    # merge dffinal with subjects and activities (y)
    dffinal <- cbind(allsubject,ally,dffinal)
    
    # label the columns new columns
    names(dffinal)[1] <- 'subjectid'    
    names(dffinal)[2] <- 'activity'
    

## Step 3: name the activities in the data set
    dffinal$activity <- activitylabels[,2][match(dffinal$activity,activitylabels[,1])]

## Step 4: label the data set with descriptive variable names
    # while tidying the data set (separating columns with multiple variables into 
    # separaate columns)
# NOTE: warnings about "Too few values" in some rows are expected as some features
    # do not have axis values so these will default to NA in the axis column.
    dffinal <- dffinal %>% 
        gather(measure,value,-subjectid,-activity) %>%
        separate(measure,c("acceleration","measure","axis")) %>%
        separate(acceleration,c('domain','acceleration'),1) %>%
        extract(acceleration,into=c('signal','instrument'),'(BodyBody|Body|Gravity)(.*)') %>%
        extract(instrument,into=c('instrument','jerk'),'(Acc|Gyro)(.*)') %>%
        extract(jerk,into=c('jerk','magnitude'),'(Jerk)(.*)') 
    
    dffinal$domain <- gsub("f","frequency",dffinal$domain)
    dffinal$domain <- gsub("t","time",dffinal$domain)


# sort data set by subjectid and activity in asc order
    dffinal <- arrange(dffinal,subjectid,activity,instrument,domain,measure)

## Step5: create a tidy data set with the average of each variable for each activity and
## each subject.
    dffinalgrp <- group_by(dffinal,subjectid,activity,instrument,signal,jerk,magnitude,domain,measure,axis)
    final_df <- as.data.frame(unclass(summarize(dffinalgrp,count=n(),average = mean(value))))

## save result
    write.csv(final_df,"final_df.csv",fileEncoding = "UTF-8")
    