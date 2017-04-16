library(dplyr)
directory = "UCI HAR Dataset"

source("lib_analysis.R")

### 1. Load
testM <- getMeasuresDataSet(directory, "test")
testA <- getActivitiesDataSet(directory, "test")
testP <- getPeopleDataSet(directory, "test")

trainM = getMeasuresDataSet(directory, "train")
trainA <- getActivitiesDataSet(directory, "train")
trainP <- getPeopleDataSet(directory, "train")
#

### 2. Merge
# Old datasets are removed as soon as they are not needed any more
#
# 2.1. First, horitzontal data merge: people-activities-measures
testDs <- mergePeopleActivitiesMeasures(testP, testA, testM)
rm(testP)
rm(testA)
rm(testM)

trainDs <- mergePeopleActivitiesMeasures(trainP, trainA, trainM)
rm(trainP)
rm(trainA)
rm(trainM)

# 2.2. And second, vertical data merge: test-train
fullDs <- mergeTestTrain(testDs, trainDs)
rm(testDs)
rm(trainDs)
#

### 3. Summarise
summarizedDs <- summariseData(fullDs)
rm(fullDs)

### 4. Save results
saveResults(summarizedDs)







