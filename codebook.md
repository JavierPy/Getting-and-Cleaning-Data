# Introduction

The script `run_analysis.R`performs the following tasks:

* Prior to the work required, the dataset is downloaded, unpacked in the specified directory and load in the workplace.
* First, the DATA, subject and activities data is merged using the `rbind()` function. At this point, we also read the files  activity_labels.txt and features.txt. Features.txt contains the names of variables measures.
* Then, only columns with the mean and standard deviation measures are taken from the dataset. 
* Next, we get a description of the activities. We replace the numerical values for the corresponding labels.
* Then, We rename variables with more appropriate names. Based on README.txt file, variables are    identified as following: 

    `Acc            accelerometer measures`
    
    ` Gyro          gyroscope measures`
    
    ` t             based on time`
    
    ` f             based on frequency`
    
    ` Body          Body movement`
    
    ` Mag           Magnitud of signal`
    
* Finally, we generate a new dataset with all the average measures for each subject and activity type (30 subjects * 6 activities = 180 rows). The output file is called `tidy.txt`.

# Variables and data

* `x_train`, `y_train`, `x_test`, `y_test`, `subject_train` and `subject_test` contain the data from the downloaded files.
* `actividadAll`, `datosTable` and `sujetoAll` merge the previous datasets.
* `datosFeatures` contains the correct names for the `datosTable` dataset, which we used to extract only the requested variables (mean and standard deviation).
* `actividadLabel` contains descriptions of activities.
* `datosTable` contains aggregate variables grouped by subject and activity.
* Finally, `datosTable` is stored in a text file `tidy.txt` 

