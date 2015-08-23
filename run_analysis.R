##Load library
library("data.table")
library("sqldf")
library("plyr")

fileFolder <- "UCI HAR Dataset"

#Create file name 
createName <- function(root, suffix){
    paste(paste(root, suffix, sep="_"), ".txt", sep="")
    
}

#Reading intruction directory includes features file and activity_labels file
featureFile <- paste(fileFolder,"/features.txt",sep="")
featureInfor <- read.table(featureFile, header = FALSE, stringsAsFactors = FALSE, col.names = c("id","FeatureName"))

activityFile <- paste(fileFolder,"/activity_labels.txt",sep="")
activityInfor <- read.table(activityFile, header = FALSE, stringsAsFactors = FALSE, col.names = c("id","ActivityName"))

#Extract subset data which contains columns with "mean()" and "std()" in their name
extractData <- function(fileFolder, subfolder="subfolder"){
    work_Subject <- paste(fileFolder, subfolder, createName("subject", subfolder), sep="/")
    subject_Data <- read.table(work_Subject, header=FALSE, col.names = "subject")
  
    work_y <- paste(fileFolder, subfolder, createName("y", subfolder), sep="/")
    Y_Data <- read.table(work_y, header=FALSE, col.names = "activityId", stringsAsFactors = FALSE)
    
    work_X <- paste(fileFolder, subfolder, createName("X", subfolder), sep="/")
    X_Data <- read.table(work_X, header=FALSE, col.names = featureInfor$FeatureName, stringsAsFactors = FALSE)
    
    X_merge <- cbind(Y_Data,subject_Data, X_Data, all=TRUE)
    
    #replace full labels for Activity column
    for (i in 1:nrow(X_merge)){
      for (j in 1:nrow(activityInfor)){
        if (X_merge$activityId[i] == activityInfor$id[j]) {
          X_merge$activityId[i] <- activityInfor$ActivityName[j]
        }
      }
    }
    #extract data contain mean and standard value
    collectData <- data.table(activityId=X_merge$activityId,subject=X_merge$subject)
    for (i in 1:ncol(X_merge)) {
        if (grepl(x = colnames(X_merge)[i], pattern = "mean\\.\\.") || grepl(x = colnames(X_merge)[i], pattern = "std\\.\\."))
           collectData <- cbind(collectData,X_merge[i])
    }
    return(collectData)
   
}

#Re-label column name
correctLabels <- function(labels) {
  labels <- gsub(x = labels, pattern = "_+", replacement = "_")
  labels <- gsub(x = labels, pattern = "_$", replacement = "")
}
#============================================
#Download and unzip the file

#fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
#fileName <- "getdata_projectfiles_UCI HAR Dataset.zip"

#if(!file.exists(fileName)){
#    download.file(fileUrl,fileName, mode = "wb")
#}
#unzip(fileName)

# Reading data and cleaning datasets
testData <- extractData(fileFolder, "test")
trainData <- extractData(fileFolder, "train")
collectDataset <- rbind(testData, trainData)
collectDataset <- collectDataset[order(collectDataset$activityId), ]
meanDataset <- ddply(collectDataset, .(subject, activityId), function(x) colMeans(x[,-c(1:2)]))

# Save result files
write.table(collectDataset, "collectData1.txt")
write.table(meanDataset, "collectData2.txt")
