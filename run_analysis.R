## Load the train and test data.
train <- read.table("train/X_train.txt")
test <- read.table("test/X_test.txt")

## Q1. Merge the data.
## The train and test data have the same variables
## and different observations.
## dim(test) 2947 561
## dim(train) 7352 561
data <- rbind(train, test)


## Q2. Extract only the measurements on the
## mean and standard deviation for each measurement.
## The file "features_info" indicates that
## I need to extract features of which names have
## mean, std and Mean.f
features <- read.table("features.txt")
names_vec <- !(regexpr("[Mm]ean|std", features[[2]])==-1)
data <- data[,which(names_vec)]

## Q3. Use descriptive activity names
## Each observation has a label from 1 to 6 
## which is stored in separate files.
## Add a new column to the data.
train_lab <- read.table("train/y_train.txt")
test_lab <- read.table("test/y_test.txt")
label_data <- rbind(train_lab, test_lab)[,1]
labels <- read.table("activity_labels.txt")
data <- cbind(labels[label_data,2], data)

## Q4. Label the data set with descriptive
## variable names
name <- as.character(features[which(names_vec), 2])
names(data) <- c("activity", name)

## Q5. Create a second, tidy dataset with average
## of each variable for each activity and each subject.
## Add a new colunme, subject type.
## Now I will use a function, aggregate, to fully
## understand base functions instead of using packages like dplyr.
by_subject <- c(rep("train", nrow(train)), rep("test", nrow(test)))
tidy <- aggregate(data[,2:ncol(data)], list(
			subject = by_subject, activity = data$activity), 
			mean)
write.table(tidy, file="tidydata.txt", row.name=FALSE)