#Create a folder in the UCI HAR Dataset directory
Xtrain <- read.table("UCI HAR Dataset//train/X_train.txt")
Xtest <- read.table("UCI HAR Dataset//test/X_test.txt")
subTrain <- read.table("UCI HAR Dataset//train/subject_train.txt")#integer
subTest <- read.table("UCI HAR Dataset//test/subject_test.txt")
actTrain <- read.table ("UCI HAR Dataset//train/y_train.txt")#factor
actTest <- read.table ("UCI HAR Dataset//test/y_test.txt")
#Transform the factors to characters
actTrain[,2] <- as.character(actTrain[,2])
actTest[,2] <- as.character(actTest[,2])
#Create a dataframe with all variables for the train  and test sets
tidyTrain <- data.frame("sub"=subTrain, Xtrain, "Activity"=actTrain)
tidyTest <- data.frame("sub"=subTest, Xtest, "Activity"=actTest)
#join train and test
tidyAll <- rbind(tidyTrain, tidyTest)
features <- read.table("UCI HAR Dataset//features.txt")#factor
features[,2] <- as.character (features[,2])
#Change the names of the features in my tidy DS
names(tidyAll)[2:562]=features[,2]
names(tidyAll)[1] <- 'subject'
names(tidyAll)[563] <- 'activity'
#select mean and std
meanVars <- grep('mean', names(tidyAll))
stdVars <- grep('std', names(tidyAll))
#join mean and std vars, sorted
selVars=sort(c(meanVars, stdVars))
#take the selected vars from the tidy DB
tidy <- tidyAll[,c(1, selVars, 563)]
#change integers for activity by the description
#read descriptions
actName <- read.table("UCI HAR Dataset//activity_labels.txt")
actName[,2] <- as.character(actName[,2])
#change activity variable
for (i in 1:nrow(tidy)){
  tidy[i,81] <- actName[tidy[i,81],2]
  }
#create the final dataset
finalDB <- aggregate(tidy[,2:80], by=list(tidy[,1], tidy [,81]), FUN=mean)
names(finalDB)[1:2] <- c('subject', 'activity')
write.table(finalDB, file ='projectOutput.txt',row.names=FALSE)
