library(data.table)
library(plyr)
library(Hmisc)
library(reshape2)

xtr<-read.csv("./UCI HAR Dataset/train/X_train.txt",sep=" ",header = FALSE)
xte<-read.csv("./UCI HAR Dataset/test/X_test.txt",sep=" ",header = FALSE)
#head(baxt,2)
# Processing of acce x data of the train
res<-xtr[1,!is.na(xtr[1,])]
nxtr<-dim(xtr)[1]
for (i in 2:nxtr){
  res[i,]<-xtr[i,!is.na(xtr[i,])]
}
xtr<-res
# Processing of acce x data of the test
res<-xte[1,!is.na(xte[1,])]
nxte<-dim(xte)[1]
for (i in 2:nxte){
  res[i,]<-xte[i,!is.na(xte[i,])]
}
xte<-res
rm(res)

#Create the unique dataset
xdata<-xtr
for (i in 1:nxte){
  xdata[nxtr+i,]<-xte[i,]
}


# Names features
NamesFeatures<-read.csv("./UCI HAR Dataset/features.txt",sep=" ",header = FALSE)
namesfeatures<-as.character(NamesFeatures$V2)
colnames(xdata)<-namesfeatures

#writing the txt file
write.table(xdata,file = "tidydata.txt",row.names = FALSE,sep = ",")

# Obtaining the Mean values of the features
nfeatures<-dim(xdata)[2]
averagefeatures<-data.frame(mean(xdata[,1]))
colnames(averagefeatures)<-namesfeatures
head(averagefeatures)
write.table(averagefeatures,file = "averagetidydata.txt",row.names = FALSE,sep = ",")