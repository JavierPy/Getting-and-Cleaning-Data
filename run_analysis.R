run_analysis<-function(){
    #
    # Author: Jesus Javier Caballero
    # Last Modif.       : 20/11/2015
    # Name              : run_analysis
    # Purpose           :
    #######
    
    # import packages
    library(dplyr)
    library(data.table)
   
    setwd("D:/Documentos/Cursos/Coursera/Especializacion_Data_Science/CodigoR/3-Obtencion_y_Limpieza_Datos")
    
    # Download dataset 
    if(!file.exists("UCI_Dataset")){         
        dir.create("UCI_Dataset")
    }
    fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile = "./UCI_Dataset/Dataset.zip")
    
    # Unzip DataSet 
    unzip(zipfile="./UCI_Dataset/Dataset.zip",exdir="./UCI_Dataset")
    
    rm(list = ls(all = TRUE))

    #Loading the files into R
    
    # Read subject files.
    sujetoTrain <- read.table("UCI_Dataset/UCI HAR Dataset/train/subject_train.txt")
    sujetoTest  <- read.table("UCI_Dataset/UCI HAR Dataset/test/subject_test.txt")
    
    # Read activity files.
    actividadTrain <- read.table("UCI_Dataset/UCI HAR Dataset/train/y_train.txt")
    actividadTest  <- read.table("UCI_Dataset/UCI HAR Dataset/test/y_test.txt")
    
    #Read data files.
    datosTrain <- read.table("UCI_Dataset/UCI HAR Dataset/train/X_train.txt")
    datosTest  <- read.table("UCI_Dataset/UCI HAR Dataset/test/X_test.txt")
    
    ###########
    ### 1. Merges the training and the test sets to create one data set.
    ##########
    
    # merge training and test data for subject
    sujetoAll <- rbind(sujetoTrain, sujetoTest)
    # rename the variable name
    setnames(sujetoAll, "V1", "Sujeto")
    
    # merge training and test data for activity
    actividadAll<- rbind(actividadTrain, actividadTest)
    # rename the variable name
    setnames(actividadAll, "V1", "ActividadID")
    
    # merge training and test DATA 
    datosTable <- rbind(datosTrain, datosTest)
    
    # rename variables according to feature label (Ej. V1 is "tBodyAcc-mean()-X",
    #   V2 is BodyAcc-mean()-Y, etc)
    datosFeatures <- read.table("UCI_Dataset/UCI HAR Dataset/features.txt")
    setnames(datosFeatures, names(datosFeatures), c("FeatureID", "FeatureNombre"))
    colnames(datosTable) <- datosFeatures$FeatureNombre
    
    #column names for activity labels
    actividadLabel<- read.table("UCI_Dataset/UCI HAR Dataset/activity_labels.txt")
    setnames(actividadLabel, names(actividadLabel), c("ActividadID","ActividadNombre"))
    
    # add  columns for subject (Sujeto) and activity (Actividad) to DATA (datosTable)
    datosSujAct<- cbind(sujetoAll, actividadAll)
    datosTable <- cbind(datosSujAct, datosTable)
    
    ###################
    ##2. Extracts only the measurements on the mean and standard deviation for each measurement.
    ###################
    # extract variables only with "mean" and "std" in the variable name
    datosFeatureStat <- grep("mean\\(\\)|std\\(\\)",datosFeatures$FeatureNombre,value=TRUE) 
    
    # combine variables for the mean and standard deviation and add  2 columns, "Sujeto","ActividadID"
    datosFeatureStat <- union(c("Sujeto","ActividadID"), datosFeatureStat)
    
    # subset containing only the variables for the mean and the std, plus "Sujeto", "ActividadID"
    datosTable<- subset(datosTable,select=datosFeatureStat)
    
    ################
    ##3. Uses descriptive activity names to name the activities in the data set
    ################
    
    # enter activity name ("ActividadNombre") into datosTable
    datosTable <- merge(actividadLabel, datosTable , by="ActividadID", all.x=TRUE)
    
    #############
    ##4. Appropriately labels the data set with descriptive variable names.
    #############
    
    # based on README.txt file, variables are identified as:
    # Acc           accelerometer measures
    # Gyro          gyroscope measures
    # t             based on time
    # f             based on frequency
    # Body          Body measures
    # Mag           Magnitud of signal
    # mean          Mean
    # std           StdDev
    
    names(datosTable)<-gsub("Acc", "Accelerometer", names(datosTable))
    names(datosTable)<-gsub("Gyro", "Gyroscope", names(datosTable))
    names(datosTable)<-gsub("^t", "Time", names(datosTable))
    names(datosTable)<-gsub("^f", "Frequency", names(datosTable))
    names(datosTable)<-gsub("BodyBody", "Body", names(datosTable))
    names(datosTable)<-gsub("Mag", "Magnitude", names(datosTable))
    names(datosTable)<-gsub("std()", "StdDev", names(datosTable))
    names(datosTable)<-gsub("mean()", "Mean", names(datosTable))
    
    ###################
    ##5. From the data set in step 4, creates a second, independent tidy data set with the average of
    ## each variable for each activity and each subject. Write to text file on disk
    ###################
    
    # remove first variable ("ActividadID")
    datosTable <- datosTable[1:nrow(datosTable),2:ncol(datosTable)]
    
    # calculate mean of each variable for each activity and each subject
    datosSummary<- aggregate(. ~ Sujeto - ActividadNombre, data = datosTable, mean) 
    
    # order the data set by Sujeto, ActividadNombre
    datosTable<- tbl_df(arrange(datosSummary,Sujeto,ActividadNombre))
    
    # write to text file
    write.table(datosTable, "tidy.txt", row.name=FALSE)

}
