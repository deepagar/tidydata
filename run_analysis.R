library(plyr)
library(dplyr)
testx <- tbl_df(read.table("./UCI HAR Dataset/test/X_test.txt"))
trainx <- tbl_df(read.table("./UCI HAR Dataset/train/X_train.txt"))
testlabels <- tbl_df(read.table("./UCI HAR Dataset/test/y_test.txt"))
trainlabels <- tbl_df(read.table("./UCI HAR Dataset/train/y_train.txt"))
subject_test <- tbl_df(read.table("./UCI HAR Dataset/test/subject_test.txt"))
subject_train <- tbl_df(read.table("./UCI HAR Dataset/train/subject_train.txt"))
featurelist <- tbl_df(read.table("./UCI HAR Dataset/features.txt"))
activitylabels <- tbl_df(read.table("./UCI HAR Dataset/activity_labels.txt"))
featuresasrows <- t(featurelist)
colnames(testx) <- featuresasrows[2, ]
colnames(subject_test) <- "subject"
colnames(testlabels) <- "labels"
testlabels$labels <- as.factor(testlabels$labels)
revalue(testlabels$labels, c("1" = "WALKING", "2" = "WALKING_UPSTAIRS", "3" = "WALKING_DOWNSTAIRS", "4" = "SITTING", "5" = "STANDING", "6" = "LAYING")) -> testlabels$labels
colnames(trainx) <- featuresasrows[2, ]
colnames(subject_train) <- "subject"
colnames(trainlabels) <- "labels"
trainlabels$labels <- as.factor(trainlabels$labels)
revalue(trainlabels$labels, c("1" = "WALKING", "2" = "WALKING_UPSTAIRS", "3" = "WALKING_DOWNSTAIRS", "4" = "SITTING", "5" = "STANDING", "6" = "LAYING")) -> trainlabels$labels
test2 <- tbl_df(cbind(subject_test, testlabels, testx))
train2 <- tbl_df(cbind(subject_train, trainlabels, trainx))
total <- tbl_df(rbind(test2, train2))
totaltemp <- total[, grep("mean|std|subject|labels", names(total))]
aggregate <- tbl_df(aggregate(totaltemp[,3:81], list(totaltemp$subject, totaltemp$labels), mean))
aggregate <- rename(aggregate, subject = Group.1, activity = Group.2)