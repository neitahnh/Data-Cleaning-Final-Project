library(dplyr)
library(plyr)
library(data.table)



x_test <- read.table("X_test.txt")
x_train <- read.table("X_train.txt")
y_test <- read.table("y_test.txt")
y_train <- read.table("y_train.txt")
subject_test <- read.table("subject_test.txt")
subject_train <- read.table("subject_train.txt")
features <- read.table("features.txt")

x_total <- bind_rows(x_test,x_train)
y_total <- bind_rows(y_test,y_train)
subject_total <- bind_rows(subject_test,subject_train)

names(y_total)[names(y_total) == "V1"] <- "Activity"
names(subject_total)[names(subject_total) == "V1"] <- "Subject"

xy <- cbind(x_total,y_total)
Test_Train_Total <- cbind(xy, subject_total)





grep("-[Mm]ean\\(|-[Ss]td\\(", features$V2)

Q2_Total <- select(Test_Train_Total, 1:6,41:46,81:86,121:126,161,166,201,202,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543,562,563)






Q2_Total$Activity <- mapvalues(Q2_Total$Activity, from = c(1,2,3,4,5,6), to = c("Walking", "Walking_Upstairs","Walking_Downstairs","Sitting","Standing","Laying"))






Q4_Variables <- as.vector(features$V2)
Q4_Variables <- Q4_Variables[c(1:6,41:46,81:86,121:126,161,166,201,202,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543,562,563)]

names(Q2_Total) <- paste(names(Q2_Total), Q4_Variables, sep = "")

names(Q2_Total) <- sub("^[Vv]","", names(Q2_Total))
names(Q2_Total) <- sub("*[0-9]","", names(Q2_Total))
names(Q2_Total) <- sub("[0-9]","", names(Q2_Total))
names(Q2_Total) <- sub("[0-9]","", names(Q2_Total))
names(Q2_Total) <- sub("[0-9]","", names(Q2_Total))
names(Q2_Total) <- sub("NA","", names(Q2_Total))





Q5_averages <- group_by(Q2_Total, Q2_Total$Subject, Q2_Total$Activity)
Q5_averages <- summarise_each(Q5_averages, funs(mean))

write.table(Q5_averages, file = "finaltable.txt", row.name = FALSE)

