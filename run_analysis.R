library(reshape2)

# 0.download data, if not there

if (!file.exists("UCI HAR Dataset")) { 
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","dataset.zip",method="curl")
  unzip("dataset.zip") 
}

#set working directory as "UCI HAR Dataset"
setwd("UCI HAR Dataset")

# 1.Merges the training and the test sets to create one data set
activitylabels <- read.table("activity_labels.txt")
features <- read.table("features.txt")
meanstdfeatureslex <- grep(".*mean.*|.*std.*",features[,2])
meanstdfeatures <- features[meanstdfeatureslex,2]

# create a table with x-train.txt & y-train.txt

xtrain <- read.table("train/X_train.txt")
xtrain <- xtrain[meanstdfeatureslex]
ytrain <- read.table("train/y_train.txt")
subtrain <- read.table("train/subject_train.txt")
train <- cbind(subtrain,ytrain,xtrain)

xtest <- read.table("test/X_test.txt")
xtest <- xtest[meanstdfeatureslex]
ytest <- read.table("test/y_test.txt")
subtest <- read.table("test/subject_test.txt")
test <- cbind(subtest,ytest,xtest)

data <- rbind(train,test)
colnames(data) <- c("subject","activity",meanstdfeatures)

data$activity <- factor(data$activity,levels = activitylabels[,1],labels = activitylabels[,2])
data$subject <- as.factor(data$subject)

tidydata <- melt(data,id = c("subject","activity"))
tidydatamean <- dcast(tidydata,subject + activity ~ variable, mean)
write.table(tidydatamean, "tidydatamean.txt", row.name=FALSE)
