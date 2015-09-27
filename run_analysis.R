
library(plyr)
library(dplyr)
#read all the required data
testx <- tbl_df(read.table("./UCI HAR Dataset/test/X_test.txt"))
trainx <- tbl_df(read.table("./UCI HAR Dataset/train/X_train.txt"))
testlabels <- tbl_df(read.table("./UCI HAR Dataset/test/y_test.txt"))
trainlabels <- tbl_df(read.table("./UCI HAR Dataset/train/y_train.txt"))
subject_test <- tbl_df(read.table("./UCI HAR Dataset/test/subject_test.txt"))
subject_train <- tbl_df(read.table("./UCI HAR Dataset/train/subject_train.txt"))
featurelist <- tbl_df(read.table("./UCI HAR Dataset/features.txt"))
activitylabels <- tbl_df(read.table("./UCI HAR Dataset/activity_labels.txt"))


featuresasrows <- t(featurelist)

# set the column names for test, test subjects, test labels data sets
colnames(testx) <- featuresasrows[2, ]
colnames(subject_test) <- "subject"
colnames(testlabels) <- "labels"

#convert the labels column to a column of factors using the activity labels data set
testlabels$labels <- as.factor(testlabels$labels)
revalue(testlabels$labels, c("1" = "WALKING", "2" = "WALKING_UPSTAIRS", "3" = "WALKING_DOWNSTAIRS", "4" = "SITTING", "5" = "STANDING", "6" = "LAYING")) -> testlabels$labels

#set column names for train, train subjects, train labels data sets 
colnames(trainx) <- featuresasrows[2, ]
colnames(subject_train) <- "subject"
colnames(trainlabels) <- "labels"

#convert the labels column to a column of factors using the activity labels data set
trainlabels$labels <- as.factor(trainlabels$labels)
revalue(trainlabels$labels, c("1" = "WALKING", "2" = "WALKING_UPSTAIRS", "3" = "WALKING_DOWNSTAIRS", "4" = "SITTING", "5" = "STANDING", "6" = "LAYING")) -> trainlabels$labels

# bind together for the Test data set (named test2): subject, activity labels, main data
test2 <- tbl_df(cbind(subject_test, testlabels, testx))

# bind together for the Train data set (named train2): subject, activity labels, main data
train2 <- tbl_df(cbind(subject_train, trainlabels, trainx))

# merge the Test2 and Train2 datasets together
total <- tbl_df(rbind(test2, train2))

#extract the relevant columns only
totaltemp <- total[, grep("mean|std|subject|labels", names(total))]

# calculate mean and 
aggregate <- tbl_df(aggregate(totaltemp[,3:81], list(totaltemp$subject, totaltemp$labels), mean))

# rename columns 1 and 2
aggregate <- rename(aggregate, subject = Group.1, activity = Group.2)

#Write the output tidy data set to a table
write.table(aggregate, "tidydatadeepa.txt", row.name=FALSE)