---
title: "CodeBook_for_run_analysis"
output: html_document
---

## Study design and data processing
Data included in this project were acquired using the accelerometer and the gyroscope from a smartphone. Data of 3-axial linear acceleration and 3-axial angular velocity were recorded at a constant rate of 50Hz. Data were collected while participants performed six physical tasks, such as walking, walking upstairs, walking downstairs, sitting, standing, and laying. 

The collected data were split into two datasets: 70% of the data were included in a training set and 30% in a test set. Each dataset was then processed in the following way:
1. data were denoised using a low-pass filter.
2. acceleration data were split into body acceleration and gravity acceleration. 
3. data were derived into Jerk signals
4. data were transformed to magnitude using the Euclidian Norm
5. data were transformed to frequencies using a FFT.

--------------------------------------------------------------

## Creating the tidy dataset

1. install and open package reshape2
```{r}
install.packages("reshape2")
library(reshape2)

```

2. define a variable containing the url for the dataset and downloading the file if it does not exist
```{r}
url_dataset <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        
if (!file.exists("galaxy.zip")) {
        download.file(url_dataset, "galaxy.zip")}
if (!file.exists("UCI HAR Dataset")) { 
        unzip("galaxy.zip")}
```

3. load the name of the activities and variables containing information about the mean and standard deviation of the recordings
```{r}
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
features_meanSTD <- grep("mean|std",features[,2])
features_meanSTD.names <- features[features_meanSTD,2]
features_meanSTD.names = gsub('-mean', 'Mean', features_meanSTD.names)
features_meanSTD.names = gsub('-std', 'Std', features_meanSTD.names)
features_meanSTD.names <- gsub('[-()]', '', features_meanSTD.names)
```

4. load training dataset for the variables defined above and writing a table containing the subject number, the activity and the variables
```{r}
training_set <- read.table("UCI HAR Dataset/train/X_train.txt") [features_meanSTD]
training_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
training_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(training_subjects, training_labels, training_set)
```

5. same as 4 but for the test dataset
```{r}
test_set <- read.table("UCI HAR Dataset/test/X_test.txt") [features_meanSTD]
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_labels, test_set)
```

6. merge test and training datasets into one unique table
```{r}
alldat <- rbind(train, test)
colnames(alldat) <- c("subjects", "activity", features_meanSTD.names)
```

7. replace the activity numbers by their names
```{r}
alldat$activity <- factor(alldat$activity, levels = activity_labels[,1], labels = activity_labels[,2])
```

8. creat a tidy dataset
```{r}
alldat.molten <- melt(alldat, id=c("subjects", "activity"))
alldat.mean <- dcast(alldat.molten, subjects + activity ~ variable, mean)
```

9. save the tidy dataset as a txt file
```{r}
write.table(alldat.mean, "tidy_dataset.txt", quote = FALSE, row.names = FALSE)
```

----------------------------------------------------

## Variables included in the tidy dataset

### Dimensions of the dataset: 180 obs. x 68 variables

### summary of the data:

    subjects                  activity  tBodyAccMeanX    tBodyAccMeanY       tBodyAccMeanZ     
 Min.   : 1.0   WALKING           :30   Min.   :0.2216   Min.   :-0.040514   Min.   :-0.15251  
 1st Qu.: 8.0   WALKING_UPSTAIRS  :30   1st Qu.:0.2712   1st Qu.:-0.020022   1st Qu.:-0.11207  
 Median :15.5   WALKING_DOWNSTAIRS:30   Median :0.2770   Median :-0.017262   Median :-0.10819  
 Mean   :15.5   SITTING           :30   Mean   :0.2743   Mean   :-0.017876   Mean   :-0.10916  
 3rd Qu.:23.0   STANDING          :30   3rd Qu.:0.2800   3rd Qu.:-0.014936   3rd Qu.:-0.10443  
 Max.   :30.0   LAYING            :30   Max.   :0.3015   Max.   :-0.001308   Max.   :-0.07538  
  tBodyAccStdX      tBodyAccStdY       tBodyAccStdZ     tGravityAccMeanX  tGravityAccMeanY   tGravityAccMeanZ  
 Min.   :-0.9961   Min.   :-0.99024   Min.   :-0.9877   Min.   :-0.6800   Min.   :-0.47989   Min.   :-0.49509  
 1st Qu.:-0.9799   1st Qu.:-0.94205   1st Qu.:-0.9498   1st Qu.: 0.8376   1st Qu.:-0.23319   1st Qu.:-0.11726  
 Median :-0.7526   Median :-0.50897   Median :-0.6518   Median : 0.9208   Median :-0.12782   Median : 0.02384  
 Mean   :-0.5577   Mean   :-0.46046   Mean   :-0.5756   Mean   : 0.6975   Mean   :-0.01621   Mean   : 0.07413  
 3rd Qu.:-0.1984   3rd Qu.:-0.03077   3rd Qu.:-0.2306   3rd Qu.: 0.9425   3rd Qu.: 0.08773   3rd Qu.: 0.14946  
 Max.   : 0.6269   Max.   : 0.61694   Max.   : 0.6090   Max.   : 0.9745   Max.   : 0.95659   Max.   : 0.95787  
 tGravityAccStdX   tGravityAccStdY   tGravityAccStdZ   tBodyAccJerkMeanX tBodyAccJerkMeanY   
 Min.   :-0.9968   Min.   :-0.9942   Min.   :-0.9910   Min.   :0.04269   Min.   :-0.0386872  
 1st Qu.:-0.9825   1st Qu.:-0.9711   1st Qu.:-0.9605   1st Qu.:0.07396   1st Qu.: 0.0004664  
 Median :-0.9695   Median :-0.9590   Median :-0.9450   Median :0.07640   Median : 0.0094698  
 Mean   :-0.9638   Mean   :-0.9524   Mean   :-0.9364   Mean   :0.07947   Mean   : 0.0075652  
 3rd Qu.:-0.9509   3rd Qu.:-0.9370   3rd Qu.:-0.9180   3rd Qu.:0.08330   3rd Qu.: 0.0134008  
 Max.   :-0.8296   Max.   :-0.6436   Max.   :-0.6102   Max.   :0.13019   Max.   : 0.0568186  
 tBodyAccJerkMeanZ   tBodyAccJerkStdX  tBodyAccJerkStdY  tBodyAccJerkStdZ   tBodyGyroMeanX    
 Min.   :-0.067458   Min.   :-0.9946   Min.   :-0.9895   Min.   :-0.99329   Min.   :-0.20578  
 1st Qu.:-0.010601   1st Qu.:-0.9832   1st Qu.:-0.9724   1st Qu.:-0.98266   1st Qu.:-0.04712  
 Median :-0.003861   Median :-0.8104   Median :-0.7756   Median :-0.88366   Median :-0.02871  
 Mean   :-0.004953   Mean   :-0.5949   Mean   :-0.5654   Mean   :-0.73596   Mean   :-0.03244  
 3rd Qu.: 0.001958   3rd Qu.:-0.2233   3rd Qu.:-0.1483   3rd Qu.:-0.51212   3rd Qu.:-0.01676  
 Max.   : 0.038053   Max.   : 0.5443   Max.   : 0.3553   Max.   : 0.03102   Max.   : 0.19270  
 tBodyGyroMeanY     tBodyGyroMeanZ     tBodyGyroStdX     tBodyGyroStdY     tBodyGyroStdZ     tBodyGyroJerkMeanX
 Min.   :-0.20421   Min.   :-0.07245   Min.   :-0.9943   Min.   :-0.9942   Min.   :-0.9855   Min.   :-0.15721  
 1st Qu.:-0.08955   1st Qu.: 0.07475   1st Qu.:-0.9735   1st Qu.:-0.9629   1st Qu.:-0.9609   1st Qu.:-0.10322  
 Median :-0.07318   Median : 0.08512   Median :-0.7890   Median :-0.8017   Median :-0.8010   Median :-0.09868  
 Mean   :-0.07426   Mean   : 0.08744   Mean   :-0.6916   Mean   :-0.6533   Mean   :-0.6164   Mean   :-0.09606  
 3rd Qu.:-0.06113   3rd Qu.: 0.10177   3rd Qu.:-0.4414   3rd Qu.:-0.4196   3rd Qu.:-0.3106   3rd Qu.:-0.09110  
 Max.   : 0.02747   Max.   : 0.17910   Max.   : 0.2677   Max.   : 0.4765   Max.   : 0.5649   Max.   :-0.02209  
 tBodyGyroJerkMeanY tBodyGyroJerkMeanZ  tBodyGyroJerkStdX tBodyGyroJerkStdY tBodyGyroJerkStdZ tBodyAccMagMean  
 Min.   :-0.07681   Min.   :-0.092500   Min.   :-0.9965   Min.   :-0.9971   Min.   :-0.9954   Min.   :-0.9865  
 1st Qu.:-0.04552   1st Qu.:-0.061725   1st Qu.:-0.9800   1st Qu.:-0.9832   1st Qu.:-0.9848   1st Qu.:-0.9573  
 Median :-0.04112   Median :-0.053430   Median :-0.8396   Median :-0.8942   Median :-0.8610   Median :-0.4829  
 Mean   :-0.04269   Mean   :-0.054802   Mean   :-0.7036   Mean   :-0.7636   Mean   :-0.7096   Mean   :-0.4973  
 3rd Qu.:-0.03842   3rd Qu.:-0.048985   3rd Qu.:-0.4629   3rd Qu.:-0.5861   3rd Qu.:-0.4741   3rd Qu.:-0.0919  
 Max.   :-0.01320   Max.   :-0.006941   Max.   : 0.1791   Max.   : 0.2959   Max.   : 0.1932   Max.   : 0.6446  
 tBodyAccMagStd    tGravityAccMagMean tGravityAccMagStd tBodyAccJerkMagMean tBodyAccJerkMagStd
 Min.   :-0.9865   Min.   :-0.9865    Min.   :-0.9865   Min.   :-0.9928     Min.   :-0.9946   
 1st Qu.:-0.9430   1st Qu.:-0.9573    1st Qu.:-0.9430   1st Qu.:-0.9807     1st Qu.:-0.9765   
 Median :-0.6074   Median :-0.4829    Median :-0.6074   Median :-0.8168     Median :-0.8014   
 Mean   :-0.5439   Mean   :-0.4973    Mean   :-0.5439   Mean   :-0.6079     Mean   :-0.5842   
 3rd Qu.:-0.2090   3rd Qu.:-0.0919    3rd Qu.:-0.2090   3rd Qu.:-0.2456     3rd Qu.:-0.2173   
 Max.   : 0.4284   Max.   : 0.6446    Max.   : 0.4284   Max.   : 0.4345     Max.   : 0.4506   
 tBodyGyroMagMean  tBodyGyroMagStd   tBodyGyroJerkMagMean tBodyGyroJerkMagStd fBodyAccMeanX    
 Min.   :-0.9807   Min.   :-0.9814   Min.   :-0.99732     Min.   :-0.9977     Min.   :-0.9952  
 1st Qu.:-0.9461   1st Qu.:-0.9476   1st Qu.:-0.98515     1st Qu.:-0.9805     1st Qu.:-0.9787  
 Median :-0.6551   Median :-0.7420   Median :-0.86479     Median :-0.8809     Median :-0.7691  
 Mean   :-0.5652   Mean   :-0.6304   Mean   :-0.73637     Mean   :-0.7550     Mean   :-0.5758  
 3rd Qu.:-0.2159   3rd Qu.:-0.3602   3rd Qu.:-0.51186     3rd Qu.:-0.5767     3rd Qu.:-0.2174  
 Max.   : 0.4180   Max.   : 0.3000   Max.   : 0.08758     Max.   : 0.2502     Max.   : 0.5370  
 fBodyAccMeanY      fBodyAccMeanZ      fBodyAccStdX      fBodyAccStdY       fBodyAccStdZ     fBodyAccJerkMeanX
 Min.   :-0.98903   Min.   :-0.9895   Min.   :-0.9966   Min.   :-0.99068   Min.   :-0.9872   Min.   :-0.9946  
 1st Qu.:-0.95361   1st Qu.:-0.9619   1st Qu.:-0.9820   1st Qu.:-0.94042   1st Qu.:-0.9459   1st Qu.:-0.9828  
 Median :-0.59498   Median :-0.7236   Median :-0.7470   Median :-0.51338   Median :-0.6441   Median :-0.8126  
 Mean   :-0.48873   Mean   :-0.6297   Mean   :-0.5522   Mean   :-0.48148   Mean   :-0.5824   Mean   :-0.6139  
 3rd Qu.:-0.06341   3rd Qu.:-0.3183   3rd Qu.:-0.1966   3rd Qu.:-0.07913   3rd Qu.:-0.2655   3rd Qu.:-0.2820  
 Max.   : 0.52419   Max.   : 0.2807   Max.   : 0.6585   Max.   : 0.56019   Max.   : 0.6871   Max.   : 0.4743  
 fBodyAccJerkMeanY fBodyAccJerkMeanZ fBodyAccJerkStdX  fBodyAccJerkStdY  fBodyAccJerkStdZ    fBodyGyroMeanX   
 Min.   :-0.9894   Min.   :-0.9920   Min.   :-0.9951   Min.   :-0.9905   Min.   :-0.993108   Min.   :-0.9931  
 1st Qu.:-0.9725   1st Qu.:-0.9796   1st Qu.:-0.9847   1st Qu.:-0.9737   1st Qu.:-0.983747   1st Qu.:-0.9697  
 Median :-0.7817   Median :-0.8707   Median :-0.8254   Median :-0.7852   Median :-0.895121   Median :-0.7300  
 Mean   :-0.5882   Mean   :-0.7144   Mean   :-0.6121   Mean   :-0.5707   Mean   :-0.756489   Mean   :-0.6367  
 3rd Qu.:-0.1963   3rd Qu.:-0.4697   3rd Qu.:-0.2475   3rd Qu.:-0.1685   3rd Qu.:-0.543787   3rd Qu.:-0.3387  
 Max.   : 0.2767   Max.   : 0.1578   Max.   : 0.4768   Max.   : 0.3498   Max.   :-0.006236   Max.   : 0.4750  
 fBodyGyroMeanY    fBodyGyroMeanZ    fBodyGyroStdX     fBodyGyroStdY     fBodyGyroStdZ     fBodyAccMagMean  
 Min.   :-0.9940   Min.   :-0.9860   Min.   :-0.9947   Min.   :-0.9944   Min.   :-0.9867   Min.   :-0.9868  
 1st Qu.:-0.9700   1st Qu.:-0.9624   1st Qu.:-0.9750   1st Qu.:-0.9602   1st Qu.:-0.9643   1st Qu.:-0.9560  
 Median :-0.8141   Median :-0.7909   Median :-0.8086   Median :-0.7964   Median :-0.8224   Median :-0.6703  
 Mean   :-0.6767   Mean   :-0.6044   Mean   :-0.7110   Mean   :-0.6454   Mean   :-0.6577   Mean   :-0.5365  
 3rd Qu.:-0.4458   3rd Qu.:-0.2635   3rd Qu.:-0.4813   3rd Qu.:-0.4154   3rd Qu.:-0.3916   3rd Qu.:-0.1622  
 Max.   : 0.3288   Max.   : 0.4924   Max.   : 0.1966   Max.   : 0.6462   Max.   : 0.5225   Max.   : 0.5866  
 fBodyAccMagStd    fBodyBodyAccJerkMagMean fBodyBodyAccJerkMagStd fBodyBodyGyroMagMean fBodyBodyGyroMagStd
 Min.   :-0.9876   Min.   :-0.9940         Min.   :-0.9944        Min.   :-0.9865      Min.   :-0.9815    
 1st Qu.:-0.9452   1st Qu.:-0.9770         1st Qu.:-0.9752        1st Qu.:-0.9616      1st Qu.:-0.9488    
 Median :-0.6513   Median :-0.7940         Median :-0.8126        Median :-0.7657      Median :-0.7727    
 Mean   :-0.6210   Mean   :-0.5756         Mean   :-0.5992        Mean   :-0.6671      Mean   :-0.6723    
 3rd Qu.:-0.3654   3rd Qu.:-0.1872         3rd Qu.:-0.2668        3rd Qu.:-0.4087      3rd Qu.:-0.4277    
 Max.   : 0.1787   Max.   : 0.5384         Max.   : 0.3163        Max.   : 0.2040      Max.   : 0.2367    
 fBodyBodyGyroJerkMagMean fBodyBodyGyroJerkMagStd
 Min.   :-0.9976          Min.   :-0.9976        
 1st Qu.:-0.9813          1st Qu.:-0.9802        
 Median :-0.8779          Median :-0.8941        
 Mean   :-0.7564          Mean   :-0.7715        
 3rd Qu.:-0.5831          3rd Qu.:-0.6081        
 Max.   : 0.1466          Max.   : 0.2878 

### Data structure
 $ subjects                : int  1 1 1 1 1 1 2 2 2 2 ...
 $ activity                : Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 1 2 3 4 5 6 1 2 3 4 ...
 $ tBodyAccMeanX           : num  0.277 0.255 0.289 0.261 0.279 ...
 $ tBodyAccMeanY           : num  -0.01738 -0.02395 -0.00992 -0.00131 -0.01614 ...
 $ tBodyAccMeanZ           : num  -0.1111 -0.0973 -0.1076 -0.1045 -0.1106 ...
 $ tBodyAccStdX            : num  -0.284 -0.355 0.03 -0.977 -0.996 ...
 $ tBodyAccStdY            : num  0.11446 -0.00232 -0.03194 -0.92262 -0.97319 ...
 $ tBodyAccStdZ            : num  -0.26 -0.0195 -0.2304 -0.9396 -0.9798 ...
 $ tGravityAccMeanX        : num  0.935 0.893 0.932 0.832 0.943 ...
 $ tGravityAccMeanY        : num  -0.282 -0.362 -0.267 0.204 -0.273 ...
 $ tGravityAccMeanZ        : num  -0.0681 -0.0754 -0.0621 0.332 0.0135 ...
 $ tGravityAccStdX         : num  -0.977 -0.956 -0.951 -0.968 -0.994 ...
 $ tGravityAccStdY         : num  -0.971 -0.953 -0.937 -0.936 -0.981 ...
 $ tGravityAccStdZ         : num  -0.948 -0.912 -0.896 -0.949 -0.976 ...
 $ tBodyAccJerkMeanX       : num  0.074 0.1014 0.0542 0.0775 0.0754 ...
 $ tBodyAccJerkMeanY       : num  0.028272 0.019486 0.02965 -0.000619 0.007976 ...
 $ tBodyAccJerkMeanZ       : num  -0.00417 -0.04556 -0.01097 -0.00337 -0.00369 ...
 $ tBodyAccJerkStdX        : num  -0.1136 -0.4468 -0.0123 -0.9864 -0.9946 ...
 $ tBodyAccJerkStdY        : num  0.067 -0.378 -0.102 -0.981 -0.986 ...
 $ tBodyAccJerkStdZ        : num  -0.503 -0.707 -0.346 -0.988 -0.992 ...
 $ tBodyGyroMeanX          : num  -0.0418 0.0505 -0.0351 -0.0454 -0.024 ...
 $ tBodyGyroMeanY          : num  -0.0695 -0.1662 -0.0909 -0.0919 -0.0594 ...
 $ tBodyGyroMeanZ          : num  0.0849 0.0584 0.0901 0.0629 0.0748 ...
 $ tBodyGyroStdX           : num  -0.474 -0.545 -0.458 -0.977 -0.987 ...
 $ tBodyGyroStdY           : num  -0.05461 0.00411 -0.12635 -0.96647 -0.98773 ...
 $ tBodyGyroStdZ           : num  -0.344 -0.507 -0.125 -0.941 -0.981 ...
 $ tBodyGyroJerkMeanX      : num  -0.09 -0.1222 -0.074 -0.0937 -0.0996 ...
 $ tBodyGyroJerkMeanY      : num  -0.0398 -0.0421 -0.044 -0.0402 -0.0441 ...
 $ tBodyGyroJerkMeanZ      : num  -0.0461 -0.0407 -0.027 -0.0467 -0.049 ...
 $ tBodyGyroJerkStdX       : num  -0.207 -0.615 -0.487 -0.992 -0.993 ...
 $ tBodyGyroJerkStdY       : num  -0.304 -0.602 -0.239 -0.99 -0.995 ...
 $ tBodyGyroJerkStdZ       : num  -0.404 -0.606 -0.269 -0.988 -0.992 ...
 $ tBodyAccMagMean         : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...
 $ tBodyAccMagStd          : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...
 $ tGravityAccMagMean      : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...
 $ tGravityAccMagStd       : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...
 $ tBodyAccJerkMagMean     : num  -0.1414 -0.4665 -0.0894 -0.9874 -0.9924 ...
 $ tBodyAccJerkMagStd      : num  -0.0745 -0.479 -0.0258 -0.9841 -0.9931 ...
 $ tBodyGyroMagMean        : num  -0.161 -0.1267 -0.0757 -0.9309 -0.9765 ...
 $ tBodyGyroMagStd         : num  -0.187 -0.149 -0.226 -0.935 -0.979 ...
 $ tBodyGyroJerkMagMean    : num  -0.299 -0.595 -0.295 -0.992 -0.995 ...
 $ tBodyGyroJerkMagStd     : num  -0.325 -0.649 -0.307 -0.988 -0.995 ...
 $ fBodyAccMeanX           : num  -0.2028 -0.4043 0.0382 -0.9796 -0.9952 ...
 $ fBodyAccMeanY           : num  0.08971 -0.19098 0.00155 -0.94408 -0.97707 ...
 $ fBodyAccMeanZ           : num  -0.332 -0.433 -0.226 -0.959 -0.985 ...
 $ fBodyAccStdX            : num  -0.3191 -0.3374 0.0243 -0.9764 -0.996 ...
 $ fBodyAccStdY            : num  0.056 0.0218 -0.113 -0.9173 -0.9723 ...
 $ fBodyAccStdZ            : num  -0.28 0.086 -0.298 -0.934 -0.978 ...
 $ fBodyAccJerkMeanX       : num  -0.1705 -0.4799 -0.0277 -0.9866 -0.9946 ...
 $ fBodyAccJerkMeanY       : num  -0.0352 -0.4134 -0.1287 -0.9816 -0.9854 ...
 $ fBodyAccJerkMeanZ       : num  -0.469 -0.685 -0.288 -0.986 -0.991 ...
 $ fBodyAccJerkStdX        : num  -0.1336 -0.4619 -0.0863 -0.9875 -0.9951 ...
 $ fBodyAccJerkStdY        : num  0.107 -0.382 -0.135 -0.983 -0.987 ...
 $ fBodyAccJerkStdZ        : num  -0.535 -0.726 -0.402 -0.988 -0.992 ...
 $ fBodyGyroMeanX          : num  -0.339 -0.493 -0.352 -0.976 -0.986 ...
 $ fBodyGyroMeanY          : num  -0.1031 -0.3195 -0.0557 -0.9758 -0.989 ...
 $ fBodyGyroMeanZ          : num  -0.2559 -0.4536 -0.0319 -0.9513 -0.9808 ...
 $ fBodyGyroStdX           : num  -0.517 -0.566 -0.495 -0.978 -0.987 ...
 $ fBodyGyroStdY           : num  -0.0335 0.1515 -0.1814 -0.9623 -0.9871 ...
 $ fBodyGyroStdZ           : num  -0.437 -0.572 -0.238 -0.944 -0.982 ...
 $ fBodyAccMagMean         : num  -0.1286 -0.3524 0.0966 -0.9478 -0.9854 ...
 $ fBodyAccMagStd          : num  -0.398 -0.416 -0.187 -0.928 -0.982 ...
 $ fBodyBodyAccJerkMagMean : num  -0.0571 -0.4427 0.0262 -0.9853 -0.9925 ...
 $ fBodyBodyAccJerkMagStd  : num  -0.103 -0.533 -0.104 -0.982 -0.993 ...
 $ fBodyBodyGyroMagMean    : num  -0.199 -0.326 -0.186 -0.958 -0.985 ...
 $ fBodyBodyGyroMagStd     : num  -0.321 -0.183 -0.398 -0.932 -0.978 ...
 $ fBodyBodyGyroJerkMagMean: num  -0.319 -0.635 -0.282 -0.99 -0.995 ...
 $ fBodyBodyGyroJerkMagStd : num  -0.382 -0.694 -0.392 -0.987 -0.995 ...
 
 ##variable names
 
      featDomain featAcceleration featInstrument featJerk featMagnitude
1:       Time               NA      Gyroscope       NA            NA
2:       Time               NA      Gyroscope       NA            NA
3:       Time               NA      Gyroscope       NA            NA
4:       Time               NA      Gyroscope       NA            NA
5:       Time               NA      Gyroscope       NA            NA
6:       Time               NA      Gyroscope       NA            NA
7:       Time               NA      Gyroscope       NA     Magnitude
8:       Time               NA      Gyroscope       NA     Magnitude
9:       Time               NA      Gyroscope     Jerk            NA
10:       Time               NA      Gyroscope     Jerk            NA
11:       Time               NA      Gyroscope     Jerk            NA
12:       Time               NA      Gyroscope     Jerk            NA
13:       Time               NA      Gyroscope     Jerk            NA
14:       Time               NA      Gyroscope     Jerk            NA
15:       Time               NA      Gyroscope     Jerk     Magnitude
16:       Time               NA      Gyroscope     Jerk     Magnitude
17:       Time             Body  Accelerometer       NA            NA
18:       Time             Body  Accelerometer       NA            NA
19:       Time             Body  Accelerometer       NA            NA
20:       Time             Body  Accelerometer       NA            NA
21:       Time             Body  Accelerometer       NA            NA
22:       Time             Body  Accelerometer       NA            NA
23:       Time             Body  Accelerometer       NA     Magnitude
24:       Time             Body  Accelerometer       NA     Magnitude
25:       Time             Body  Accelerometer     Jerk            NA
26:       Time             Body  Accelerometer     Jerk            NA
27:       Time             Body  Accelerometer     Jerk            NA
28:       Time             Body  Accelerometer     Jerk            NA
29:       Time             Body  Accelerometer     Jerk            NA
30:       Time             Body  Accelerometer     Jerk            NA
31:       Time             Body  Accelerometer     Jerk     Magnitude
32:       Time             Body  Accelerometer     Jerk     Magnitude
33:       Time          Gravity  Accelerometer       NA            NA
34:       Time          Gravity  Accelerometer       NA            NA
35:       Time          Gravity  Accelerometer       NA            NA
36:       Time          Gravity  Accelerometer       NA            NA
37:       Time          Gravity  Accelerometer       NA            NA
38:       Time          Gravity  Accelerometer       NA            NA
39:       Time          Gravity  Accelerometer       NA     Magnitude
40:       Time          Gravity  Accelerometer       NA     Magnitude
41:       Freq               NA      Gyroscope       NA            NA
42:       Freq               NA      Gyroscope       NA            NA
43:       Freq               NA      Gyroscope       NA            NA
44:       Freq               NA      Gyroscope       NA            NA
45:       Freq               NA      Gyroscope       NA            NA
46:       Freq               NA      Gyroscope       NA            NA
47:       Freq               NA      Gyroscope       NA     Magnitude
48:       Freq               NA      Gyroscope       NA     Magnitude
49:       Freq               NA      Gyroscope     Jerk     Magnitude
50:       Freq               NA      Gyroscope     Jerk     Magnitude
51:       Freq             Body  Accelerometer       NA            NA
52:       Freq             Body  Accelerometer       NA            NA
53:       Freq             Body  Accelerometer       NA            NA
54:       Freq             Body  Accelerometer       NA            NA
55:       Freq             Body  Accelerometer       NA            NA
56:       Freq             Body  Accelerometer       NA            NA
57:       Freq             Body  Accelerometer       NA     Magnitude
58:       Freq             Body  Accelerometer       NA     Magnitude
59:       Freq             Body  Accelerometer     Jerk            NA
60:       Freq             Body  Accelerometer     Jerk            NA
61:       Freq             Body  Accelerometer     Jerk            NA
62:       Freq             Body  Accelerometer     Jerk            NA
63:       Freq             Body  Accelerometer     Jerk            NA
64:       Freq             Body  Accelerometer     Jerk            NA
65:       Freq             Body  Accelerometer     Jerk     Magnitude
66:       Freq             Body  Accelerometer     Jerk     Magnitude
        featDomain featAcceleration featInstrument featJerk featMagnitude
        featVariable featAxis   N
1:         Mean        X 180
2:         Mean        Y 180
3:         Mean        Z 180
4:           SD        X 180
5:           SD        Y 180
6:           SD        Z 180
7:         Mean       NA 180
8:           SD       NA 180
9:         Mean        X 180
10:         Mean        Y 180
11:         Mean        Z 180
12:           SD        X 180
13:           SD        Y 180
14:           SD        Z 180
15:         Mean       NA 180
16:           SD       NA 180
17:         Mean        X 180
18:         Mean        Y 180
19:         Mean        Z 180
20:           SD        X 180
21:           SD        Y 180
22:           SD        Z 180
23:         Mean       NA 180
24:           SD       NA 180
25:         Mean        X 180
26:         Mean        Y 180
27:         Mean        Z 180
28:           SD        X 180
29:           SD        Y 180
30:           SD        Z 180
31:         Mean       NA 180
32:           SD       NA 180
33:         Mean        X 180
34:         Mean        Y 180
35:         Mean        Z 180
36:           SD        X 180
37:           SD        Y 180
38:           SD        Z 180
39:         Mean       NA 180
40:           SD       NA 180
41:         Mean        X 180
42:         Mean        Y 180
43:         Mean        Z 180
44:           SD        X 180
45:           SD        Y 180
46:           SD        Z 180
47:         Mean       NA 180
48:           SD       NA 180
49:         Mean       NA 180
50:           SD       NA 180
51:         Mean        X 180
52:         Mean        Y 180
53:         Mean        Z 180
54:           SD        X 180
55:           SD        Y 180
56:           SD        Z 180
57:         Mean       NA 180
58:           SD       NA 180
59:         Mean        X 180
60:         Mean        Y 180
61:         Mean        Z 180
62:           SD        X 180
63:           SD        Y 180
64:           SD        Z 180
65:         Mean       NA 180
66:           SD       NA 180
    featVariable featAxis   N
 
 