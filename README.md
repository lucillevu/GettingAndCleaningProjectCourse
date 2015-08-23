## Course Project Workflow

'run_analysis.R' script does the following action sequence: \n
      1.	Verify if the existing data was yet download
              i.	If not Downloading and extracting raw data
      2.	Reading instruction content from Activity and Feature introduction file
      3.	Reading and cleaning test dataset in the following way:
              i.	Reads file 'subject_test.txt' with subjects and 'y_test.txt' with activities, and convert data to table data
              ii.	Read file “X_test.txt” file, and merge the header with corresponded name which was listed from Feature table.
              iii.	Merge observation data from (X_test.txt file) with Subject and Activity table
              iv.	Replace activityId with full Label name according to activity_Label.txt file 
               v.	Extract columns “activityId”, “subject” and columns containing 'mean()' and 'std()' in names
      4.	Repeat process of reading and cleaning train dataset (process 3)
      5.	Merging two data set which were extracted from test dataset and train dataset (process 3 & 4). Sorting result dataset by Subject and ActivityId columns
      6.	Create the second dataset from the first one, in which contains only average values of all data of the 1st dataset grouping by subject and activity.
      7.	Write the dataset to “txt” file using write.table() function
