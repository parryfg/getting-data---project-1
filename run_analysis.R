##Project 1
##Coursera - Johns Hopkins 
##Getting data 

##Auth: Parry 

##Set working directory 

    wd1 <- file.path( "C:" ,
                      "Users" ,
                      "Parry_2" ,
                      "Google Drive" ,
                      "Data Analytics" , 
                      "Coursera - John Hopkins DS Specialization" ,
                      "03 Getting Data" ,
                      "Project1" ,
                      sep = "/")
    
    setwd(wd1)
    
    list.files()
    
##Load data
    
    if(!file.exists("p1.zip"))
            {
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                    quiet = TRUE, destfile = "p1.zip")
        
        files <- unzip("p1.zip")
            }
    
    feat <- read.table("./UCI HAR Dataset/features.txt") 
    
    act <- read.table("./UCI HAR Dataset/activity_labels.txt")
    
    subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
        
    xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                        col.names=feat[[2]],check.names=F)
        
    ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
        
    subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
        
    xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                         col.names=feat[[2]],check.names=F)
    
    ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
        
##Put the test and train data tables together 
        sub <- rbind(subtest, subtrain)
         
        x <- rbind(xtest, xtrain)
        
        y <- rbind(ytest, ytrain)
        
##Match labels of activities (in act df) with their factor level (in y df) 
        y$V1 <- as.factor(y$V1) 
        levels(y$V1) <- act$V2
        
##Put the full (test&train) data tables together 
        x$activity <- y[,1]
        x$subject <- sub[,1]
       
    ##Put activity and subject columns at start of df  
       x <- x[, append(c("activity", "subject"), head(colnames(x), 561))]
      
    ##Remove unneeded data tables
        rm(list=c('xtest', 'xtrain', 'ytest', 'ytrain', 'subtest', 'subtrain',
                  'feat', 'y', 'sub', 'act'))
        
##Keep mean and standard deviation columns; and activity, subject columns
    x <- x[,grep("[Mm]ean|[Ss]td|activity|subject", colnames(x))]

##Tidy those variable labels 
    colnames(x) <- gsub("()",'', colnames(x), fixed = TRUE)
        #quoting metacharacters
        #Set fixed = TRUE to get exactly what is in quotes (ignore meta)
    
    colnames(x) <- gsub('-'," ", colnames(x))
    colnames(x) <- gsub('BodyA'," A", colnames(x))
    colnames(x) <- gsub('BodyG'," G", colnames(x))
    
##New df with average for each variable by both activity and subject 
    x <- aggregate(. ~ activity * subject, x,mean) 
 
##Output tidied df to .csv file
   write.csv(x, file = "./github/tidydata", row.names = FALSE)
   
##Double check new .csv file
   tidy <- read.csv("./github/tidydata")
   