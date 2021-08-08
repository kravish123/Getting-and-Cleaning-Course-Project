setwd("C:/Users/Karthik Ravishankar/Documents/Coursera/Data Science Specialization/Getting and Cleaning Data/UCI HAR Dataset")

library(plyr)
library(data.table)

features <- read.table('./features.txt', col.names = c("n","functions"))
activities <- read.table('./activity_labels.txt', col.names = c("m","activity"))

subjectTrain <- read.table('./train/subject_train.txt', col.names = "subject")
xTrain <- read.table('./train/x_train.txt', col.names = features$functions)
yTrain <-read.table('./train/y_train.txt', col.names = "m")

subjectTest <- read.table('./test/subject_test.txt', col.names = "subject")
xTest <- read.table('./test/x_test.txt', col.names = features$functions)
yTest <- read.table('./test/y_test.txt', col.names = "m")


SubjectTestTrain <- rbind(subjectTrain, subjectTest)
XTestTrain <- rbind(xTrain, xTest)
YTestTrain <- rbind(yTrain, yTest)
MergedTestTrain <- cbind(SubjectTestTrain, YTestTrain, XTestTrain)


# 2
tidyDataSet <- MergedTestTrain %>% select(subject, m, contains("mean"), contains("std"))

# 3
tidyDataSet$m <- activities[tidyDataSet$m, 2]

# 4
names(tidyDataSet)[2] = "activity"
names(tidyDataSet) <- gsub("Acc", "Accelerometer", names(tidyDataSet))
names(tidyDataSet) <- gsub("Gyro", "Gyroscope", names(tidyDataSet))
names(tidyDataSet) <- gsub("BodyBody", "Body", names(tidyDataSet))
names(tidyDataSet) <- gsub("Mag", "Magnitude", names(tidyDataSet))
names(tidyDataSet) <- gsub("^t", "Time", names(tidyDataSet))
names(tidyDataSet) <- gsub("^f", "Frequency", names(tidyDataSet))
names(tidyDataSet) <- gsub("tBody", "TimeBody", names(tidyDataSet))
names(tidyDataSet) <- gsub("-mean()", "Mean", names(tidyDataSet), ignore.case = TRUE)
names(tidyDataSet) <- gsub("-std()", "STD", names(tidyDataSet), ignore.case = TRUE)
names(tidyDataSet) <- gsub("-freq()", "Frequency", names(tidyDataSet), ignore.case = TRUE)
names(tidyDataSet) <- gsub("angle", "Angle", names(tidyDataSet))
names(tidyDataSet) <- gsub("gravity", "Gravity", names(tidyDataSet))

# 5
finalDataSet <- tidyDataSet %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(finalDataSet, "finalDataSet.txt", row.name=FALSE)
