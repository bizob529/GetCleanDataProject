#### Getting and Cleaning Data: Course Project ####
#### Johns Hopkins University / Coursera ####


#Be sure that the unzipped "UCI HAR Dataset" folder is in the same location as run_analysis.R. 
#Install the plyr and reshape2 packages if you have not done so.


#Create a function that accomplishes steps 1-4 for this project (which are listed below)
createFirstTidy <- function(dataRootDir = "UCI HAR Dataset") {

        #Below are constants assigned to file locations, along with a filePath function 
        #that prepends the root directory to the file location.
        filePath <- function(file) {
                paste(dataRootDir,"/",file,sep="")
        }
        xTest <- filePath("test/X_test.txt")
        xTrain <- filePath("train/X_train.txt")
        yTest <- filePath("test/y_test.txt")
        yTrain <- filePath("train/y_train.txt")
        subjectTest <- filePath("test/subject_test.txt")
        subjectTrain <- filePath("train/subject_train.txt")
        activityLabelsFile <- filePath("activity_labels.txt")
        featuresFile <- filePath("features.txt")

        #Step 1) Merge training and test sets to create one data set.
        
        testData <- read.table(xTest)
        trainData <- read.table(xTrain)
        allData <- rbind(testData, trainData)
        
        #Step 2) Extract only the measurements on the mean and standard deviation for each measurement.
        
        #First add feature names as column names, then select columns that have mean, std, or 
        #activityLabel in their name.
        featureNames <- read.table(featuresFile, stringsAsFactors=FALSE)[[2]]
        colnames(allData) <- featureNames
        allData <- allData[,grep("mean|std|activityLabel", featureNames)]
 
        #Step 3) Use descriptive activity names to name the activities in the data set.
        
        #First identify activityID and activityLabel in the activity_labels.txt file.        
        activityLabelsData <- read.table(activityLabelsFile, stringsAsFactors=FALSE)
        colnames(activityLabelsData) <- c("activityID","activityLabel")
        #Then create the activity column for the entire dataset.        
        testActivitiesData <- read.table(yTest, stringsAsFactors=FALSE)
        trainActivitiesData <- read.table(yTrain, stringsAsFactors=FALSE)
        allActivitiesData <- rbind(testActivitiesData, trainActivitiesData)
        #Assign the column name activityID to allActivitiesData so it can merge with activity_labels.txt.
        colnames(allActivitiesData)[1] <- "activityID"
        #Use join on the activities and activity label datasets (join preserves order)
        activities <- join(allActivitiesData, activityLabelsData, by="activityID")
        #Finally, add the column to the full dataset
        allData <- cbind(activity=activities[,"activityLabel"], allData)
        
        #Step 4) Appropriately label the data set with the descriptive variable names
        
        #Rename all of the variables so that they are more readable. Use the gsub function to find and
        #substitute the current variable names.
        varNames = names(allData)
        varNames <- gsub(pattern="^t", replacement="Time", x=varNames)
        varNames <- gsub(pattern="^f", replacement="Freq", x=varNames)
        varNames <- gsub(pattern="-?mean[(][)]-?", replacement="Mean", x=varNames)
        varNames <- gsub(pattern="-?std[()][)]-?", replacement="Std", x=varNames)
        varNames <- gsub(pattern="-?meanFreq[()][)]-?", replacement="MeanFreq", x=varNames)
        varNames <- gsub(pattern="BodyBody", replacement="Body", x=varNames)
        names(allData) <- varNames

        #Now include the subject IDs 
        subjectTestData <- read.table(subjectTest, stringsAsFactors=FALSE)
        subjectTrainData <- read.table(subjectTrain, stringsAsFactors=FALSE)
        allSubjectData <- rbind(subjectTestData, subjectTrainData)
        colnames(allSubjectData) <- "subject"
        allData <- cbind(allSubjectData, allData)
      
        sortedData <- allData[order(allData$subject, allData$activity),]
        sortedData
}

#Step 5) From the data set in step 4, creates a second, independent tidy data set with the
### average of each variable for each activity and each subject.

#Create a function that can accomplish step 5, which condenses the first tidy dataset into a much
#smaller table of averages.
createSecondTidy <- function(anyData) {
        #Create a long dataset from a wide one
        moltenData <- melt(anyData, id.vars= c("subject","activity"))
        #Transform the long dataset back into a wide one, aggregating on subject and activity using
        #the mean function.
        castData <- dcast(moltenData, subject+activity ~ variable, fun.aggregate=mean)
        castData
}

#The user must run this function to write the complete and condensed data sets. Simply type into the
#command line "createTidyData()" and hit enter to create the two files.
createTidyData <- function() {
        tidyData1 <- createFirstTidy()
        tidyData2 <- createSecondTidy(tidyData1)
        write.table(tidyData1, file="TidyDataSet1_Complete.txt", sep="\t", row.names=FALSE)
        write.table(tidyData2, file="TidyDataSet2_Averages.txt", sep="\t", row.names=FALSE)
}

############ Please type "createTidyData()" and hit Enter to run this script ############