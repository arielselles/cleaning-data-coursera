# cleaning-data-coursera

## Files in the repo

- This explaining file, README.md
- Source code, run_analysis.R. This script catches as input the dataset https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, and generates as output the file tidy-dataset.txt.
- Source code, lib_analysis.R. This scripts contains all technical details on how to complete the task. The previous one contains the high-level instructions. This separation helps the reader to better understand what the code does.
- The code book, code_book.txt.
- The requiered summarised dataset with mean values, tidy-dataset.txt.

## Merged dataset file explanation

This file contains data related to a study based on 30 people who weared a mobile phone while they did 6 different types of activities. The accelerometers and gyroscops of the mobiles recorded 50 values per second, and their means are registered at this dataset. 

For each record it is provided the person-id and the activity names, followed by the 66 means, that are explained at the code_book, and can be better understood with the help of the source code_book.

