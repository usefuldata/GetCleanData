# Download Data
setInternet2(use = TRUE)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dest="GCData.zip", mode="wb") 
unzip("GCData.zip")

# Read The Data
ActTest <- read.table(file.path("UCI HAR Dataset", "test", "Y_test.txt" ), header = FALSE)
ActTrain <- read.table(file.path("UCI HAR Dataset", "train", "Y_train.txt" ), header = FALSE)
subTest <- read.table(file.path("UCI HAR Dataset", "test" , "subject_test.txt" ),header = FALSE)
subTrain <- read.table(file.path("UCI HAR Dataset", "train" , "subject_train.txt" ),header = FALSE)
ftrTest <- read.table(file.path("UCI HAR Dataset", "test" , "X_test.txt" ),header = FALSE)
ftrTrain <- read.table(file.path("UCI HAR Dataset", "train", "X_train.txt"), header = FALSE)

# Headers
features_labels <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("activity", "activity_name")

# Combine the data (Q1)

subject <- rbind(subTrain, subTest)
activity <- rbind(ActTrain, ActTest)
features <- rbind(ftrTrain, ftrTest)
names(subject) <- c("subject")
names(activity) <- c("activity")
names(features) <- features_labels[,2]
merged_data <- cbind(activity, subject, features)

# Extracting only the Means and SDs(Q2)
colVec <- colnames(merged_data) 
subMUSD <- grep("mean\\(\\)|std\\(\\)", colVec, value=T)
msdCols <- c("subject", "activity", subMUSD)
DataMeanStd <- subset(merged_data, select = msdCols)

# Using Descriptive Activity Names (Q3)
DataActNm <- merge(DataMeanStd,activity_labels, id = "activity")
DataActNm <- DataActNm[,which(names(DataActNm) != c('activity'))]

#Labeling the DS with appropriate Variable Names (Q4)
names(DataActNm)<-gsub("^t", "time", names(DataActNm))
names(DataActNm)<-gsub("^f", "frequency", names(DataActNm))
names(DataActNm)<-gsub("Acc", "Accelerometer", names(DataActNm))
names(DataActNm)<-gsub("Gyro", "Gyroscope", names(DataActNm))
names(DataActNm)<-gsub("Mag", "Magnitude", names(DataActNm))
names(DataActNm)<-gsub("BodyBody", "Body", names(DataActNm))

# Create the Tidy Data Set and Dump it (Q5)
tidyData <- aggregate(DataActNm[,which(names(DataActNm) != "activity_name")],by = list(activity = DataActNm$activity_name,subject_id = DataActNm$subject),mean)
tidyData <- tidyData[,which(names(tidyData)!="subject")]
write.table(tidyData, file = "TidyData.txt", row.names = FALSE)




