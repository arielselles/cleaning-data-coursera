# This R file is part of the run analysis process.
#
# The process visibility improves by taking apart technical procedures, and
# leaving in the main file only meaningfull instructions
# =============================================================================

### Char vector "varNames"
#
# Is a vector with the names of each variable regarding to measures to be read 
#   during the load process.
# The names for those variables which are not usefull for this study, are stored 
#   as Xnnn, for easily be rejected in a future step.
varNames <- NULL

### function "getVarNames"
#
# Returns the varNames vector.
# If it is not assigned yet, this function fill it with the values stored at the
#   "features" dataset.
getVarNames <- function(dir = "UCI HAR Dataset") {
    
    if (is.null(varNames)) {
        # Read from
        varNames <<- read.table(
            file = paste(".", dir, "features.txt", sep = "/"),
            header = FALSE,
            sep = ' ',
            stringsAsFactors = FALSE
        )
        
        for (i in 1:nrow(varNames)) {
            if (!grepl("(?:mean|std)[^a-zA-Z]", varNames[i, 2], perl = TRUE)) {
                
                # Those names not regarding to "mean" or "std" are stored as "Xnnn"
                varNames[i, 2] <<- paste("X", i, sep = "")
                
            } else {
                
                # Otherwise, their names are beautified
                varNames[i, 2] <<- gsub("[-()]", "", varNames[i, 2], perl = TRUE)
                varNames[i, 2] <<-
                    gsub("^t", "time", varNames[i, 2], perl = TRUE)
                varNames[i, 2] <<-
                    gsub("^f", "frequency", varNames[i, 2], perl = TRUE)
            }
        }
        
        varNames <<- varNames[,2]
    }
    
    varNames
}
# ==============================================================================

### Dataset "activityNames"
#
# Is a dataset with pairs id-name of each different activity that the 30 people 
#   did during the study. It works like a dictionary of activity names.
activityNames <- NULL

### Function "getActivityNames"
#
# Returns the activityNames dataset
# If it is not assigned yet, this function fill it with the values stored at the
#   "activity_labels" dataset.
getActivityNames <- function(dir = "UCI HAR Dataset") {
    
    if (is.null(activityNames)) {
        activityNames <<- read.table(
            file = paste(".", dir, "activity_labels.txt", sep = "/"), 
            header = FALSE, 
            sep=' ', 
            stringsAsFactors = FALSE)
    }
    
    activityNames
}
# ==============================================================================

### Function getSourceDirectory
#
# Returns a source dataset, based on:
# - Source directory.
# - Type of data: "test" or "train"
# - Data set preffix: "X_", "y_" or 
getSourceDirectory <- function(dir = "UCI HAR Dataset", typeOfData, dsPreffix) {
    directory <- paste(".", dir, typeOfData, "", sep = "/")
    #file
    paste(directory, dsPreffix, typeOfData, ".txt", sep = "")
}

### Function getMeasuresDataSet
#
# Returns a dataset based on the source one, but selecting only means and 
#   typical deviations
getMeasuresDataSet <- function(dir = "UCI HAR Dataset", typeOfData) {
    
    # Read the measures
    ds = read.table(
        getSourceDirectory(dir, typeOfData, "X_"),
        header = FALSE,
        stringsAsFactors = FALSE,
        col.names = getVarNames(dir))
    
    # Select only means and standard deviations.
    select(ds, matches("(?:mean|std)"))
}


### Function "getActivitiesDataSet"
#
# Returns a list of the activities done by the people each time.
# The number of observations of this list is the same than the measures dataSet.
getActivitiesDataSet <- function(dir = "UCI HAR Dataset", typeOfData) {
    
    # Read the activities, which is a list of ids
    ds <- read.table(
        getSourceDirectory(dir, typeOfData, "y_"),
        header = FALSE,
        stringsAsFactors = FALSE,
        col.names = "Activity")

    # Get the activity names dictionary
    dsActivities <- getActivityNames(dir)
    
    # Change all activity ids by their names
    for (i in 1:nrow(dsActivities)) {
        ds[ds$Activity == i, 1] <- dsActivities[i,2]
    }
    
    ds
}

### Function "getPeopleDataSet"
#
# Returns a list of the people who did the activity each time.
# The number of observations of this list is the same than the measures dataSet.
getPeopleDataSet <- function(dir = "UCI HAR Dataset", typeOfData) {
    read.table(
        getSourceDirectory(dir, typeOfData, "subject_"),
        header = FALSE, 
        stringsAsFactors = FALSE,
        col.names = "Person")
}
# ==============================================================================

### Function "mergePeopleActivitiesMeasures"
#
# Merges "horitzontaly" the loaded datasets
mergePeopleActivitiesMeasures <- function(dsP, dsA, dsM) {
    data.frame(dsP, dsA, dsM)
}

### Function "mergeTestTrain"
#
# Merges "verticaly" the loaded datasets
mergeTestTrain <- function(dsTest, dsTrain) {
    tbl_df(rbind(testDs, trainDs))
}
# ==============================================================================

### Function "summariseData"
#
# Returns the required summarised data, grouping by "Person" and "Activity"
#  variables, and calculating the mean of all the others
summariseData <- function(data) {
    
    data %>%
        group_by(Person, Activity) %>%
        summarise_each(funs(mean), -c(Person, Activity))
}
# ==============================================================================

### Function "saveResults"
#
# Stores the dataset at the computer file system
saveResults <- function(ds, name = "tidy-dataset.txt") {
    write.table(ds, name, sep=" ", row.names = FALSE)
}
