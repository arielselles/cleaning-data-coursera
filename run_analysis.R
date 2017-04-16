library(dplyr)
directory = "UCI HAR Dataset"
#
# library(dplyr)
# setwd("C:/Dades/Ariel/DataScience/RStudio/M3W4")
# directory = "UCI HAR Dataset"
# source("run_analysis.R")
# m0 = tbl_df(readData(directory, "test"))
# rm("XXX")  # to remove objects
# m0 = group_by(tbl, col1, col2)
# res = summarize(m0, mean(...), sdev(...))
# pack_sum <- summarize(by_package,
# count = n(),
# # unique = n_distinct(ip_id),
# # countries = n_distinct(country),
# # avg_bytes = mean(size))
# 
# filter(data, condition)
# arrange(data, order_criteria)
#
# quantile(m0$field, prob=0.99)
# head(m0)
#
# tbl_df(rbind(readData(directory, "test"), readData(directory, "train")))
# bind_rows? insteadof rbind

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







