library(data.table)
library(plyr)
library(Hmisc)
library(reshape2)

setwd("~/Data Science Specialization/Getting and Cleaning Data/project")

test_labels<-read.table("./UCI HAR Dataset/test/y_test.txt",col.names = "label")
test_subjects<-read.table("./UCI HAR Dataset/test/subject_test.txt",col.names = "subject")
test_data<-read.table("./UCI HAR Dataset/test/X_test.txt")

train_labels<-read.table("./UCI HAR Dataset/train/y_train.txt",col.names = "label")
train_subjects<-read.table("./UCI HAR Dataset/train/subject_train.txt",col.names = "subject")
train_data<-read.table("./UCI HAR Dataset/train/X_train.txt")

alldata<-rbind(cbind(train_subjects,train_labels,train_data),cbind(test_subjects,test_labels,test_data))

# Names features
NamesFeatures<-read.table("./UCI HAR Dataset/features.txt",strip.white = TRUE,stringsAsFactors = FALSE)
NamesFeatures.mean.std <- NamesFeatures[grep("mean\\(\\)|std\\(\\)",NamesFeatures$V2), ]
alldata.mean.std<-alldata[ , c(1,2,NamesFeatures.mean.std$V1+2)]


labels<-read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)

alldata.mean.std$label<-labels[alldata.mean.std$label,2]


temp_colnames<-c("subject","label",NamesFeatures.mean.std$V2)
temp_colnames<-tolower(gsub("[^[:alpha:]]","",temp_colnames))
colnames(alldata.mean.std)<-temp_colnames


new_data <- aggregate(alldata.mean.std[, 3:ncol(alldata.mean.std)], by=list(subject = alldata.mean.std$subject, label = alldata.mean.std$label), mean)


#writing the txt file
write.table(new_data,file = "tidydata.txt",row.names = FALSE,sep = ",")