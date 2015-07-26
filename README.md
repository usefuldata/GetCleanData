---
title: "Reproducible Research Peer Assessment 1"
author: Utpal Datta
date: "Saturday, July 25, 2015"
output: html_document
---

# GetCleanData
Posting the assignment for the course "Getting and Cleaning Data" from Coursera by JHBSPH

### THIS READ ME DESCRIBES HOW THE CODE "run_analysis.R" WORKS
- Step1 : Download Data

### Data is downloaded first and the zip file is unzipped
setInternet2(use = TRUE)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dest="GCData.zip", mode="wb") 
unzip("GCData.zip")

- Step 2: Read The Data
### All the needed datasets are read as data frames to work with.

ActTest <- read.table(file.path("UCI HAR Dataset", "test", "Y_test.txt" ), header = FALSE)
ActTrain <- read.table(file.path("UCI HAR Dataset", "train", "Y_train.txt" ), header = FALSE)
subTest <- read.table(file.path("UCI HAR Dataset", "test" , "subject_test.txt" ),header = FALSE)
subTrain <- read.table(file.path("UCI HAR Dataset", "train" , "subject_train.txt" ),header = FALSE)
ftrTest <- read.table(file.path("UCI HAR Dataset", "test" , "X_test.txt" ),header = FALSE)
ftrTrain <- read.table(file.path("UCI HAR Dataset", "train", "X_train.txt"), header = FALSE)

### Headers are readed from the labels file. 
features_labels <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("activity", "activity_name")

- Step 3: Combine the data (Q1)
### Test and Training data are combined for X, Y and Subjects. They are merged with proper headers.

subject <- rbind(subTrain, subTest)
activity <- rbind(ActTrain, ActTest)
features <- rbind(ftrTrain, ftrTest)
names(subject) <- c("subject")
names(activity) <- c("activity")
names(features) <- features_labels[,2]
merged_data <- cbind(activity, subject, features)

- Step 4: Extracting only the Means and SDs(Q2)
### Extracting from the Merged Dataset the columns with "mean" and "std" in their names.
colVec <- colnames(merged_data) 
subMUSD <- grep("mean\\(\\)|std\\(\\)", colVec, value=T)
msdCols <- c("subject", "activity", subMUSD)
DataMeanStd <- subset(merged_data, select = msdCols)


- Step 5: Using Descriptive Activity Names (Q3)
### Merging the activity labels data with the merged data to use the Activity Names. Then the Activity IDs are removed.
DataActNm <- merge(DataMeanStd,activity_labels, id = "activity")
DataActNm <- DataActNm[,which(names(DataActNm) != c('activity'))]

- Step 6: Labeling the DS with appropriate Variable Names (Q4)
### Appropriate abbreviations are converted to the full texts using gsub function.
names(DataActNm)<-gsub("^t", "time", names(DataActNm))
names(DataActNm)<-gsub("^f", "frequency", names(DataActNm))
names(DataActNm)<-gsub("Acc", "Accelerometer", names(DataActNm))
names(DataActNm)<-gsub("Gyro", "Gyroscope", names(DataActNm))
names(DataActNm)<-gsub("Mag", "Magnitude", names(DataActNm))
names(DataActNm)<-gsub("BodyBody", "Body", names(DataActNm))

- Step 7: Create the Tidy Data Set and Dump it (Q5)
### All the fields are aggregated by activity_name and subject (renamed as subject_id). Then Variable Subject is removed. The variable subject now holds the value of mean(subject) by activity_name and subject, which is same as subject_id. The final data frame is now dumped to the text file.
tidyData <- aggregate(DataActNm[,which(names(DataActNm) != "activity_name")],by = list(activity = DataActNm$activity_name,subject_id = DataActNm$subject),mean)
tidyData <- tidyData[,which(names(tidyData)!="subject")]


## This is the End of this assignment.



#                           :)  Thanks! :)
