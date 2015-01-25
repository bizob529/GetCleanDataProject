#Getting and Cleaning Data: Course Project

#Code Book

***

##Original Data
***
A direct link to the dataset from the UCI website can be found here:

>https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The dataset includes experiments that were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each volunteer performed six activities while wearing a Samsung Galaxy S II smartphone on the waist. Accelerometer and gyroscope data from each subject's smartphone were captured. 


##Variables
***
The `subject` variable corresponds to the number designated to the specific volunteer who performed an activity. 

The `activity` variable corresponds to the activity performed by the subject. The 6 activities were:

        - WALKING
        - WALKING_UPSTAIRS
        - WALKING_DOWNSTAIRS
        - SITTING
        - STANDING
        - LAYING

Information on the remaining variables can be found in great detail in the `README.txt` and `features_info.txt` files in the UCI HAR Dataset folder.

The mean and standard deviation were selected from the original data using the `grep` function. 

The feature names of the data have been rewritten to improve readability.

+The prefix `t` was replaced with `Time`
+The prefix `f` was replaced with `Freq` (frequency, shortened for space)
+The variable text `-mean()-` was replaced with `Mean`
+The variable text `-std()-` was replaced with `Std`
+The variable text `-meanFreq()-` was replaced with `MeanFreq`
+The variable text `BodyBody` was replaced with `Body`
        
