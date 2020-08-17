---
title: "README.md"
author: "me"
date: "8/17/2020"
output: html_document
---
#This file provides the script used for this project in addition to commentary on why these specific decisions were made and why the finished products can be described as "tidy"


#Packages used#
library(dplyr)
library(plyr)
library(data.table)


#Step 1: Read .txt files and merge into one large data set#


  #initial reading#
  
x_test <- read.table("X_test.txt")
x_train <- read.table("X_train.txt")
y_test <- read.table("y_test.txt")
y_train <- read.table("y_train.txt")
subject_test <- read.table("subject_test.txt")
subject_train <- read.table("subject_train.txt")
features <- read.table("features.txt")


  #initial combining of data#
  
x_total <- bind_rows(x_test,x_train)
y_total <- bind_rows(y_test,y_train)
subject_total <- bind_rows(subject_test,subject_train)


  ##specifying column names of "Activity" and "Subject"##
  
names(y_total)[names(y_total) == "V1"] <- "Activity"
names(subject_total)[names(subject_total) == "V1"] <- "Subject"


  ##Finalizing combining of data into one set##
  
xy <- cbind(x_total,y_total)
Test_Train_Total <- cbind(xy, subject_total)



#Step 2: Extract mean and standard deviation for each measurment#


  ##Locating variables containing mean and standard deviation data using grep()##
  
    ##Only variables that provided both a mean and a SD value were selected in order to maintain uniformity of the dataset.##

grep("-[Mm]ean\\(|-[Ss]td\\(", features$V2)

  
  ##Selecting variables that contain mean and standard deviation data and creating a new dataframe with them##
  
      ##(column numbers used in select() were collected from the output of the previous grep() command)##
      
Q2_Total <- select(Test_Train_Total, 1:6,41:46,81:86,121:126,161,166,201,202,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543,562,563)




#Step 3: changing "Activity" values (see codebook for more info) from numeric class to character class describing each activity"

  ##Mapping each integer value to a descriptive character value and overwriting the previous "Activity" varaiable within the dataframe created in step 2##

Q2_Total$Activity <- mapvalues(Q2_Total$Activity, from = c(1,2,3,4,5,6), to = c("Walking", "Walking_Upstairs","Walking_Downstairs","Sitting","Standing","Laying"))




#Step 4: Renaming variable names to represent tidy data#

  
  ##Loading list of variable names from the provided "features.txt" file##
  

Q4_Variables <- as.vector(features$V2)


  ##Using column numbers retrieved from previous Grep() command (see step 2) to load descriptive variable names containing mean or SD data into the specified vector ("Q4_Variables")##
  
Q4_Variables <- Q4_Variables[c(1:6,41:46,81:86,121:126,161,166,201,202,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543,562,563)]


  ##Using "Q4_Variables" vector to map appropriate variable names onto "the columns of Q2_Total(this is the reduced dataframe containing variables only pretaining to mean and SD values)##
  
names(Q2_Total) <- paste(names(Q2_Total), Q4_Variables, sep = "")


  ##cleaning column names using sub() command to remove unnecessary text in the variables##
  
     ##The following method was chosen in order to make the variable names match perfectly with the "features.txt" variable names. This reduces any confusion the reader may experience when interpreting what the current variables in the dataframe represent.##
      
names(Q2_Total) <- sub("^[Vv]","", names(Q2_Total))
names(Q2_Total) <- sub("*[0-9]","", names(Q2_Total))
names(Q2_Total) <- sub("[0-9]","", names(Q2_Total))
names(Q2_Total) <- sub("[0-9]","", names(Q2_Total))
names(Q2_Total) <- sub("[0-9]","", names(Q2_Total))
names(Q2_Total) <- sub("NA","", names(Q2_Total))



#Step 5: Averaging values of each variable by subject and activity type#

  ##Creating new dataset with grouped data by subject and activity (so that variables describe mean and SD based on each subject's results in each activity type)##
  
   ##This method was used because it seemed to be a short and easily understood method of organizing the data##
    
Q5_averages <- group_by(Q2_Total, Q2_Total$Subject, Q2_Total$Activity)

 ##Updating previously created dataset with averages of each subject per group combination##
  
    ##This method was chosen because it was a concise and easily understood operation to perform following the perviously chosen grouping method##
    
Q5_averages <- summarise_each(Q5_averages, funs(mean))


#Saving the completed table as a .txt file#
  
write.table(Q5_averages, file = "finaltable.txt")

#Variable names were chosen in order to map cleanly on to the original variable names provided in the "features.txt" file. This was done so in order to make the process of interpreting and relating the data as clear and easy as possible, and is therefore considered a "tidy" method in the context of this project.
