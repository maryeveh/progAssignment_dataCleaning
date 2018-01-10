install.packages("reshape2")
library(reshape2)

url_dataset <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        
if (!file.exists("galaxy.zip")) {
        download.file(url_dataset, "galaxy.zip")}
if (!file.exists("UCI HAR Dataset")) { 
        unzip("galaxy.zip")}

#load data for activities and recordings
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
features_meanSTD <- grep("mean\\(\\)|std\\(\\)",features[,2])
features_meanSTD.names <- features[features_meanSTD,2]
features_meanSTD.names = gsub('-mean', 'Mean', features_meanSTD.names)
features_meanSTD.names = gsub('-std', 'Std', features_meanSTD.names)
features_meanSTD.names <- gsub('[-()]', '', features_meanSTD.names)

#load training data and create a unique table
training_set <- read.table("UCI HAR Dataset/train/X_train.txt") [features_meanSTD]
training_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
training_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(training_subjects, training_labels, training_set)

#load test data and create a unique table
test_set <- read.table("UCI HAR Dataset/test/X_test.txt") [features_meanSTD]
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_labels, test_set)

#merge training and test by rows and rename columns
alldat <- rbind(train, test)
colnames(alldat) <- c("subjects", "activity", features_meanSTD.names)

#label data with descriptive names of the activities       
alldat$activity <- factor(alldat$activity, levels = activity_labels[,1], labels = activity_labels[,2])

#create new tidy dataset
alldat.molten <- melt(alldat, id=c("subjects", "activity"))
alldat.mean <- dcast(alldat.molten, subjects + activity ~ variable, mean)

#create txt file for new tidy dataset (alldat.mean)
write.table(alldat.mean, "tidy_dataset.txt", quote = FALSE, row.names = FALSE)

