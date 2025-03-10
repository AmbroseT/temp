

## WEATHER SYSTEMS AND THEIR IMPACT ACROSS THE U.S.
***

## Section I: Synopsis

Synopsis: Immediately after the title, there should be a synopsis which describes and summarizes your analysis in at most 10 complete sentences.

## Section II: Data Processing

There should be a section titled Data Processing which describes (in words and code) how the data were loaded into R and processed for analysis. In particular, your analysis must start from the raw CSV file containing the data. You cannot do any preprocessing outside the document. If preprocessing is time-consuming you may consider using the cache = TRUE option for certain code chunks.

The basic goal of this assignment is to explore the NOAA Storm Database and answer some 
basic questions about severe weather events. You must use the database to answer the 
questions below and show the code for your entire analysis. Your analysis can consist of 
tables, figures, or other summaries. You may use any R package you want to support your analysis.

### Libraries

4 libraries were added for this assignment, which are the **ggplot2** graphics library, the **grid** library, the **gridExtra** library, and the **xtable** library:


```r
library(ggplot2)
library(grid)
library(gridExtra)
library(xtable)
```

All plots created in this assignment are **ggplot2** plots, consisting of histograms and time series plots.  The **gridExtra** library package allows for grid arrangement of multiple plots created with **ggplot2**, and **grid** is required for **gridExtra**. **xtable** is used to convert tables into HTML format.

### Downloading and Reading the Data

The following code details the directory creation, download of the raw data set, and reading in that raw data set. The directory structure, that this analysis was run, was separated to store some data into a directory off of the working directory for local reasons (i.e. separating assignments, projects, etc). The ```dataDir``` was created to add some flexibility here, for local changes or to accomodate other systems that are organized differently.


```r
## ----------------------
## downloading code chunk
## ----------------------
## set the data directory for the analysis. As a single point of reference, 
## changes can be made here if required.
dataDir <- "./data/temp/repdata2/"

## set the name of the file to be used after download. As a single point of reference, 
## changes can be made here if required.
filename <- "StormData.csv"

## Preparing the directory locations:
## check if destination directories to be used already exist, relative to
## the working directory

if(!file.exists("data")) {dir.create("data")}
if(!file.exists(dataDir)) {dir.create(dataDir)}

## Check to see if the file already exists locally
if(!file.exists(paste(dataDir, filename, sep=""))) {
    
    ## file does not exist locally:
    ## note that BZ2 files are text files that R recognizes, so there is no need 
    ## for extraction. Download file renamed to StormData.csv, write to a text file
    ## today's date of download. If the CSV file does not exist, but the downloaded.txt 
    ## file already exists, the text file will be over written with a new file.
    
    fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
    download.file(fileUrl, destfile=paste(dataDir, filename, sep=""))
    writeLines(date(),paste(dataDir, "datedownloaded.txt", sep =""))
    datedownloaded <- paste(readLines(paste(dataDir, "datedownloaded.txt", sep ="")),
                            ", downloaded today", sep="")

} else {
    
    ## file exists locally:
    ## Save variable as local copy if file already exists.
    
    datedownloaded <- paste(readLines(paste(dataDir, "datedownloaded.txt", sep ="")),
                            ", localCopy", sep="")
}
```

Now that we have downloaded the raw data set, we can store it into a data frame named ```weatherData```:


```r
## ------------------
## reading code chunk
## ------------------
weatherData <- read.csv(filename, sep=",")
```

Using inline R code, the following HTML table just states and records ```filename``` and ```datedownloaded``` from the downloading code chunk above:

|            | File Used      | Downloaded                         |
| ----------:| --------------:| ----------------------------------:|
| **Record** | StormData.csv   | Wed Aug 20 14:19:13 2014, localCopy                 |

Recording this information will help in determining accuracy of the analysis if the data source should change in the future. If there is an updated data set at the source site, then the date of the new data set can be compared against ```datedownloaded``` of this analysis.  Adjustments can then be made to the analysis code to reflect the change, or margins of error can be calculated based on the differences.

Next we will use the ```weatherData``` data set and run some analysis against it. First, let's check the summary of the data set:


```r
summary(weatherData)
```

```
##     STATE__                  BGN_DATE             BGN_TIME     
##  Min.   : 1.0   5/25/2011 0:00:00:  1202   12:00:00 AM: 10163  
##  1st Qu.:19.0   4/27/2011 0:00:00:  1193   06:00:00 PM:  7350  
##  Median :30.0   6/9/2011 0:00:00 :  1030   04:00:00 PM:  7261  
##  Mean   :31.2   5/30/2004 0:00:00:  1016   05:00:00 PM:  6891  
##  3rd Qu.:45.0   4/4/2011 0:00:00 :  1009   12:00:00 PM:  6703  
##  Max.   :95.0   4/2/2006 0:00:00 :   981   03:00:00 PM:  6700  
##                 (Other)          :895866   (Other)    :857229  
##    TIME_ZONE          COUNTY         COUNTYNAME         STATE       
##  CST    :547493   Min.   :  0   JEFFERSON :  7840   TX     : 83728  
##  EST    :245558   1st Qu.: 31   WASHINGTON:  7603   KS     : 53440  
##  MST    : 68390   Median : 75   JACKSON   :  6660   OK     : 46802  
##  PST    : 28302   Mean   :101   FRANKLIN  :  6256   MO     : 35648  
##  AST    :  6360   3rd Qu.:131   LINCOLN   :  5937   IA     : 31069  
##  HST    :  2563   Max.   :873   MADISON   :  5632   NE     : 30271  
##  (Other):  3631                 (Other)   :862369   (Other):621339  
##                EVTYPE         BGN_RANGE       BGN_AZI      
##  HAIL             :288661   Min.   :   0          :547332  
##  TSTM WIND        :219940   1st Qu.:   0   N      : 86752  
##  THUNDERSTORM WIND: 82563   Median :   0   W      : 38446  
##  TORNADO          : 60652   Mean   :   1   S      : 37558  
##  FLASH FLOOD      : 54277   3rd Qu.:   1   E      : 33178  
##  FLOOD            : 25326   Max.   :3749   NW     : 24041  
##  (Other)          :170878                  (Other):134990  
##          BGN_LOCATI                  END_DATE             END_TIME     
##               :287743                    :243411              :238978  
##  COUNTYWIDE   : 19680   4/27/2011 0:00:00:  1214   06:00:00 PM:  9802  
##  Countywide   :   993   5/25/2011 0:00:00:  1196   05:00:00 PM:  8314  
##  SPRINGFIELD  :   843   6/9/2011 0:00:00 :  1021   04:00:00 PM:  8104  
##  SOUTH PORTION:   810   4/4/2011 0:00:00 :  1007   12:00:00 PM:  7483  
##  NORTH PORTION:   784   5/30/2004 0:00:00:   998   11:59:00 PM:  7184  
##  (Other)      :591444   (Other)          :653450   (Other)    :622432  
##    COUNTY_END COUNTYENDN       END_RANGE      END_AZI      
##  Min.   :0    Mode:logical   Min.   :  0          :724837  
##  1st Qu.:0    NA's:902297    1st Qu.:  0   N      : 28082  
##  Median :0                   Median :  0   S      : 22510  
##  Mean   :0                   Mean   :  1   W      : 20119  
##  3rd Qu.:0                   3rd Qu.:  0   E      : 20047  
##  Max.   :0                   Max.   :925   NE     : 14606  
##                                            (Other): 72096  
##            END_LOCATI         LENGTH           WIDTH            F         
##                 :499225   Min.   :   0.0   Min.   :   0   Min.   :0       
##  COUNTYWIDE     : 19731   1st Qu.:   0.0   1st Qu.:   0   1st Qu.:0       
##  SOUTH PORTION  :   833   Median :   0.0   Median :   0   Median :1       
##  NORTH PORTION  :   780   Mean   :   0.2   Mean   :   8   Mean   :1       
##  CENTRAL PORTION:   617   3rd Qu.:   0.0   3rd Qu.:   0   3rd Qu.:1       
##  SPRINGFIELD    :   575   Max.   :2315.0   Max.   :4400   Max.   :5       
##  (Other)        :380536                                   NA's   :843563  
##       MAG          FATALITIES     INJURIES         PROPDMG    
##  Min.   :    0   Min.   :  0   Min.   :   0.0   Min.   :   0  
##  1st Qu.:    0   1st Qu.:  0   1st Qu.:   0.0   1st Qu.:   0  
##  Median :   50   Median :  0   Median :   0.0   Median :   0  
##  Mean   :   47   Mean   :  0   Mean   :   0.2   Mean   :  12  
##  3rd Qu.:   75   3rd Qu.:  0   3rd Qu.:   0.0   3rd Qu.:   0  
##  Max.   :22000   Max.   :583   Max.   :1700.0   Max.   :5000  
##                                                               
##    PROPDMGEXP        CROPDMG        CROPDMGEXP          WFO        
##         :465934   Min.   :  0.0          :618413          :142069  
##  K      :424665   1st Qu.:  0.0   K      :281832   OUN    : 17393  
##  M      : 11330   Median :  0.0   M      :  1994   JAN    : 13889  
##  0      :   216   Mean   :  1.5   k      :    21   LWX    : 13174  
##  B      :    40   3rd Qu.:  0.0   0      :    19   PHI    : 12551  
##  5      :    28   Max.   :990.0   B      :     9   TSA    : 12483  
##  (Other):    84                   (Other):     9   (Other):690738  
##                                STATEOFFIC    
##                                     :248769  
##  TEXAS, North                       : 12193  
##  ARKANSAS, Central and North Central: 11738  
##  IOWA, Central                      : 11345  
##  KANSAS, Southwest                  : 11212  
##  GEORGIA, North and Central         : 11120  
##  (Other)                            :595920  
##                                                                                                                                                                                                     ZONENAMES     
##                                                                                                                                                                                                          :594029  
##                                                                                                                                                                                                          :205988  
##  GREATER RENO / CARSON CITY / M - GREATER RENO / CARSON CITY / M                                                                                                                                         :   639  
##  GREATER LAKE TAHOE AREA - GREATER LAKE TAHOE AREA                                                                                                                                                       :   592  
##  JEFFERSON - JEFFERSON                                                                                                                                                                                   :   303  
##  MADISON - MADISON                                                                                                                                                                                       :   302  
##  (Other)                                                                                                                                                                                                 :100444  
##     LATITUDE      LONGITUDE        LATITUDE_E     LONGITUDE_    
##  Min.   :   0   Min.   :-14451   Min.   :   0   Min.   :-14455  
##  1st Qu.:2802   1st Qu.:  7247   1st Qu.:   0   1st Qu.:     0  
##  Median :3540   Median :  8707   Median :   0   Median :     0  
##  Mean   :2875   Mean   :  6940   Mean   :1452   Mean   :  3509  
##  3rd Qu.:4019   3rd Qu.:  9605   3rd Qu.:3549   3rd Qu.:  8735  
##  Max.   :9706   Max.   : 17124   Max.   :9706   Max.   :106220  
##  NA's   :47                      NA's   :40                     
##                                            REMARKS           REFNUM      
##                                                :287433   Min.   :     1  
##                                                : 24013   1st Qu.:225575  
##  Trees down.\n                                 :  1110   Median :451149  
##  Several trees were blown down.\n              :   568   Mean   :451149  
##  Trees were downed.\n                          :   446   3rd Qu.:676723  
##  Large trees and power lines were blown down.\n:   432   Max.   :902297  
##  (Other)                                       :588295
```

We can take the variables from the above summary of the data set and cross reference the information about the data in the National Weather Service PDF file [here](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf). Take a moment to peruse the PDF file to understand the variables listed in the raw data set.

Now that we understand the meaning behind the variables in the data set, we will move forward to answer some questions.

### Answering the Questions
  
#### Q1. Across the United States, which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?
  
For this analysis, we will define "harm" as a combination of both "fatalities" and "injuries" from the data set. Therefore, we will subset from ```weatherData``` only the variables that apply to this question.  From the summary of ```weatherData``` that we saw previously, the relevant variables that we have chosen are:

* EVTYPE
* FATALITIES
* INJURIES

We saw from the summary of ```weatherData``` that the above listed variables do not have NA's in their observations, so we can now subset ```weatherData``` with the variables listed above, aggregate the event types and calculate the sum of the total harm done by each type, and then order the event type by the most damage done:


```r
## subset the event types and the harm they do, as popHarm
popHarm <- weatherData[, c("EVTYPE", "FATALITIES", "INJURIES")]

## calculate the sum of both fatalities and injuries for each event observation, as sunHarm
sumHarm <- popHarm$FATALITIES + popHarm$INJURIES
sumHarm <- cbind(popHarm, sumHarm)

## aggregate population harm by sum into a new data set, aggregateHarm
aggregateHarm <- aggregate(. ~ EVTYPE, data = sumHarm, FUN = sum)

# Order the data set by the most damaging event type into a new data set, harmOrdered
harmOrdered <- aggregateHarm[order(-aggregateHarm$sumHarm),]
head(harmOrdered)
```

```
##             EVTYPE FATALITIES INJURIES sumHarm
## 834        TORNADO       5633    91346   96979
## 130 EXCESSIVE HEAT       1903     6525    8428
## 856      TSTM WIND        504     6957    7461
## 170          FLOOD        470     6789    7259
## 464      LIGHTNING        816     5230    6046
## 275           HEAT        937     2100    3037
```

We can see that the most damaging event type is TORNADO, which we will plot in the Results section later using the tidy data set ```harmOrdered```.

#### Q2. Across the United States, which types of events have the greatest economic consequences?

For this analysis, we will define "economic consequences" as a measurement of damages to property and crops in monetary value of U.S. dollars. According to page 12, section 2.7 of the National Weather Service PDF [file](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf), monetary values are estimates rounded to three significant digits, followed by an alphabetical character signifying the numerical magnitude. The three alphabetical characters and their designation are as follows:

- **K** - for thousands
- **M** - for millions
- **B** - for billions

This will be represented in R code as:

```r
## The three alphabetical characters and their designation
k <- 1e3
m <- 1e6
b <- 1e9
```

All other designations will be ignored, since they cover other scenarios of ambiguity or exclusion.

From the raw data set ```weatherData```, the numerical estimates are stored in the following variables:

- PROPDMG
- CROPDMG

And as follows, the alphabetical characters are stored in the following variables variables (corresponding to ```PROPDMG``` and ```CROPDMG```):

- PROPDMGEXP
- CROPDMGEXP

When each respective variables are paired, the combination represents the monetary value in USD. Example, using inline R code:

| PROPDMG | PROPDMGEXP | CROPDMG | CROPDMGEXP | VALUE IN USD             |
| -------:| ----------:| -------:| ----------:| ------------------------:|
| 1.55    | m          |         |            | 1550000 |
|         |            | 1.36    | K          | 1360 |

We will use the above model to calculate full monetary values for property damage and crop damage, in new variables respectively, and ```cbind()``` them to a new data set, named ```kmb```.

It is important to note that we will need to consider case sensitivity for ```PROPDMGEXP``` and ```CROPDMGEXP``` since both upper and lower cases have been recorded:


```r
## list the alphabetical characters used for property damage
unique(weatherData$PROPDMGEXP)
```

```
##  [1] K M   B m + 0 5 6 ? 4 2 3 h 7 H - 1 8
## Levels:  - ? + 0 1 2 3 4 5 6 7 8 B h H K m M
```

```r
## list the alphabetical characters used for crop damage
unique(weatherData$CROPDMGEXP)
```

```
## [1]   M K m B ? 0 k 2
## Levels:  ? 0 2 B k K m M
```

The 4 ```weatherData``` variables and the variable ```EVTYPE``` will be the relevant variables to subset from the raw data set ```weatherData```. Reviewing the summary of ```weatherDatda``` shows that the variables mentioned do not have NA values in the observations. a new data set ```kmb``` will be created, then aggregated by event type, and the sum total economic consequences for each event type will be calculated after the ```cbind()``` process. 


```r
## sprintf("$%14.2f",b)

## subset weatherData for the relevant variables relevant to economic consequences
ecoDmg <- weatherData[, c("EVTYPE", "PROPDMG", "PROPDMGEXP", "CROPDMG", "CROPDMGEXP")]

## convert from factor to character
ecoDmg$PROPDMGEXP <- as.character(ecoDmg$PROPDMGEXP)
ecoDmg$CROPDMGEXP <- as.character(ecoDmg$CROPDMGEXP)

## divide into 2 data sets, one for property (ecoDmg.prop), and one for crops (ecoDmg.crop)
ecoDmg.prop <- ecoDmg[, c("EVTYPE","PROPDMG","PROPDMGEXP")]
ecoDmg.crop <- ecoDmg[, c("EVTYPE","CROPDMG","CROPDMGEXP")]

## testing
head(ecoDmg.prop)
```

```
##    EVTYPE PROPDMG PROPDMGEXP
## 1 TORNADO    25.0          K
## 2 TORNADO     2.5          K
## 3 TORNADO    25.0          K
## 4 TORNADO     2.5          K
## 5 TORNADO     2.5          K
## 6 TORNADO     2.5          K
```

```r
head(ecoDmg.crop)
```

```
##    EVTYPE CROPDMG CROPDMGEXP
## 1 TORNADO       0           
## 2 TORNADO       0           
## 3 TORNADO       0           
## 4 TORNADO       0           
## 5 TORNADO       0           
## 6 TORNADO       0
```

```r
kmb.crop <- ecoDmg.crop[grep("[kK]|[mM]|[bB]", ecoDmg.crop$CROPDMGEXP), ]
kmb.prop <- ecoDmg.prop[grep("[kK]|[mM]|[bB]", ecoDmg.prop$PROPDMGEXP), ]

unique(kmb.crop$CROPDMGEXP)
```

```
## [1] "M" "K" "m" "B" "k"
```

```r
unique(kmb.prop$PROPDMGEXP)
```

```
## [1] "K" "M" "B" "m"
```

```r
head(kmb.crop)
```

```
##                           EVTYPE CROPDMG CROPDMGEXP
## 187566 HURRICANE OPAL/HIGH WINDS      10          M
## 187571        THUNDERSTORM WINDS     500          K
## 187581            HURRICANE ERIN       1          M
## 187583            HURRICANE OPAL       4          M
## 187584            HURRICANE OPAL      10          m
## 187653        THUNDERSTORM WINDS      50          K
```

```r
head(kmb.prop)
```

```
##    EVTYPE PROPDMG PROPDMGEXP
## 1 TORNADO    25.0          K
## 2 TORNADO     2.5          K
## 3 TORNADO    25.0          K
## 4 TORNADO     2.5          K
## 5 TORNADO     2.5          K
## 6 TORNADO     2.5          K
```


```r
## find and replace 'k', 'm', and 'b' with equivalent value for property damage
kmb.prop$PROPDMGEXP <- sapply(kmb.prop$PROPDMGEXP, function(i) ifelse(i=="k" | i=="K", k, i))
kmb.prop$PROPDMGEXP <- sapply(kmb.prop$PROPDMGEXP, function(i) ifelse(i=="m" | i=="M", m, i))
kmb.prop$PROPDMGEXP <- sapply(kmb.prop$PROPDMGEXP, function(i) ifelse(i=="b" | i=="B", b, i))

## testing
## unique(kmb.prop$PROPDMGEXP)
## head(kmb.prop)
## str(kmb.prop)

## find and replace 'k', 'm', and 'b' with equivalent value for crop damage
kmb.crop$CROPDMGEXP <- sapply(kmb.crop$CROPDMGEXP, function(i) ifelse(i=="k" | i=="K", k, i))
kmb.crop$CROPDMGEXP <- sapply(kmb.crop$CROPDMGEXP, function(i) ifelse(i=="m" | i=="M", m, i))
kmb.crop$CROPDMGEXP <- sapply(kmb.crop$CROPDMGEXP, function(i) ifelse(i=="b" | i=="B", b, i))

## testing
## unique(kmb.crop$CROPDMGEXP)
## head(kmb.crop)
## str(kmb.crop)
```


```r
## Convert to numeric
kmb.prop$PROPDMGEXP <- as.numeric(kmb.prop$PROPDMGEXP)
kmb.crop$CROPDMGEXP <- as.numeric(kmb.crop$CROPDMGEXP)
```


```r
## Multiply and cbind
kmb.prop <- cbind(kmb.prop, propVal = kmb.prop$PROPDMG * kmb.prop$PROPDMGEXP)
kmb.crop <- cbind(kmb.crop, cropVal = kmb.crop$CROPDMG * kmb.crop$CROPDMGEXP)

## testing, are there NA, other unwanted values
summary(kmb.prop)
```

```
##                EVTYPE         PROPDMG       PROPDMGEXP      
##  HAIL             :91966   Min.   :   0   Min.   :1.00e+03  
##  THUNDERSTORM WIND:81941   1st Qu.:   0   1st Qu.:1.00e+03  
##  TSTM WIND        :62844   Median :   1   Median :1.00e+03  
##  TORNADO          :51827   Mean   :  25   Mean   :1.19e+05  
##  FLASH FLOOD      :32942   3rd Qu.:  10   3rd Qu.:1.00e+03  
##  FLOOD            :17394   Max.   :5000   Max.   :1.00e+09  
##  (Other)          :97128                                    
##     propVal        
##  Min.   :0.00e+00  
##  1st Qu.:0.00e+00  
##  Median :1.00e+03  
##  Mean   :9.80e+05  
##  3rd Qu.:1.00e+04  
##  Max.   :1.15e+11  
## 
```

```r
summary(kmb.crop)
```

```
##                EVTYPE         CROPDMG        CROPDMGEXP      
##  HAIL             :82305   Min.   :  0.0   Min.   :1.00e+03  
##  THUNDERSTORM WIND:81425   1st Qu.:  0.0   1st Qu.:1.00e+03  
##  FLASH FLOOD      :21679   Median :  0.0   Median :1.00e+03  
##  FLOOD            :13622   Mean   :  4.9   Mean   :3.97e+04  
##  HIGH WIND        :11501   3rd Qu.:  0.0   3rd Qu.:1.00e+03  
##  TORNADO          : 9593   Max.   :990.0   Max.   :1.00e+09  
##  (Other)          :63732                                     
##     cropVal        
##  Min.   :0.00e+00  
##  1st Qu.:0.00e+00  
##  Median :0.00e+00  
##  Mean   :1.73e+05  
##  3rd Qu.:0.00e+00  
##  Max.   :5.00e+09  
## 
```

```r
unique(kmb.prop$PROPDMGEXP)
```

```
## [1] 1e+03 1e+06 1e+09
```

```r
unique(kmb.crop$CROPDMGEXP)
```

```
## [1] 1e+06 1e+03 1e+09
```

```r
head(kmb.prop)
```

```
##    EVTYPE PROPDMG PROPDMGEXP propVal
## 1 TORNADO    25.0       1000   25000
## 2 TORNADO     2.5       1000    2500
## 3 TORNADO    25.0       1000   25000
## 4 TORNADO     2.5       1000    2500
## 5 TORNADO     2.5       1000    2500
## 6 TORNADO     2.5       1000    2500
```

```r
head(kmb.crop)
```

```
##                           EVTYPE CROPDMG CROPDMGEXP cropVal
## 187566 HURRICANE OPAL/HIGH WINDS      10      1e+06   1e+07
## 187571        THUNDERSTORM WINDS     500      1e+03   5e+05
## 187581            HURRICANE ERIN       1      1e+06   1e+06
## 187583            HURRICANE OPAL       4      1e+06   4e+06
## 187584            HURRICANE OPAL      10      1e+06   1e+07
## 187653        THUNDERSTORM WINDS      50      1e+03   5e+04
```

```r
str(kmb.prop)
```

```
## 'data.frame':	436042 obs. of  4 variables:
##  $ EVTYPE    : Factor w/ 985 levels "   HIGH SURF ADVISORY",..: 834 834 834 834 834 834 834 834 834 834 ...
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
##  $ PROPDMGEXP: num  1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 ...
##  $ propVal   : num  25000 2500 25000 2500 2500 2500 2500 2500 25000 25000 ...
```

```r
str(kmb.crop)
```

```
## 'data.frame':	283857 obs. of  4 variables:
##  $ EVTYPE    : Factor w/ 985 levels "   HIGH SURF ADVISORY",..: 410 786 406 409 409 786 786 834 834 812 ...
##  $ CROPDMG   : num  10 500 1 4 10 50 50 5 50 15 ...
##  $ CROPDMGEXP: num  1e+06 1e+03 1e+06 1e+06 1e+06 1e+03 1e+03 1e+03 1e+03 1e+03 ...
##  $ cropVal   : num  1.0e+07 5.0e+05 1.0e+06 4.0e+06 1.0e+07 5.0e+04 5.0e+04 5.0e+03 5.0e+04 1.5e+04 ...
```

```r
## convert from factor to character
kmb.prop$EVTYPE <- as.character(kmb.prop$EVTYPE)
kmb.crop$EVTYPE <- as.character(kmb.crop$EVTYPE)

## subset just the necessary variables, 'evtype' and 'propVal'
kmb.prop2 <- kmb.prop[,c("EVTYPE","propVal")]

## subset just the necessary variables, 'evtype' and 'cropVal'
kmb.crop2 <- kmb.crop[,c("EVTYPE","cropVal")]

## aggregate as in Q1
aggregateProp <- aggregate(. ~ EVTYPE, data = kmb.prop2, FUN = sum)
aggregateCrop <- aggregate(. ~ EVTYPE, data = kmb.crop2, FUN = sum)

## convert 'propVal' and 'cropVal' to represent billions in USD
aggregateProp$propVal <- aggregateProp$propVal / 1e9 
aggregateCrop$cropVal <- aggregateCrop$cropVal / 1e9 

## order property data by highest damage value
propTotal <- aggregateProp[order(-aggregateProp$propVal),]

## order crop data by highest damage value
cropTotal <- aggregateCrop[order(-aggregateCrop$cropVal),]

## merge crop and property data
ecoMerged <- merge(propTotal, cropTotal)

## create a new variable that calculates the sum of crop and property damage
## by evtype
ecoTotal <- cbind(ecoMerged, Total = ecoMerged$propVal + ecoMerged$cropVal)

## order total damage value per type by highest damage value
ecoTotal <- ecoTotal[order(-ecoTotal$Total),]
```


```r
## take a look at the highest monetary loss in billions USD under each category
xt1 <- xtable(head(propTotal))
xt2 <- xtable(head(cropTotal))
xt3 <- xtable(head(ecoTotal))

print(xt1, include.rownames=F,  html.table.attributes = getOption("xtable.html.table.attributes",
                                    "border=0"), type="html")
```

<!-- html table generated in R 3.1.1 by xtable 1.7-3 package -->
<!-- Thu Aug 21 17:52:08 2014 -->
<TABLE border=0>
<TR> <TH> EVTYPE </TH> <TH> propVal </TH>  </TR>
  <TR> <TD> FLOOD </TD> <TD align="right"> 144.66 </TD> </TR>
  <TR> <TD> HURRICANE/TYPHOON </TD> <TD align="right"> 69.31 </TD> </TR>
  <TR> <TD> TORNADO </TD> <TD align="right"> 56.94 </TD> </TR>
  <TR> <TD> STORM SURGE </TD> <TD align="right"> 43.32 </TD> </TR>
  <TR> <TD> FLASH FLOOD </TD> <TD align="right"> 16.14 </TD> </TR>
  <TR> <TD> HAIL </TD> <TD align="right"> 15.73 </TD> </TR>
   </TABLE>

```r
print(xt2, include.rownames=F,  html.table.attributes = getOption("xtable.html.table.attributes",
                                    "border=0"), type="html")
```

<!-- html table generated in R 3.1.1 by xtable 1.7-3 package -->
<!-- Thu Aug 21 17:52:08 2014 -->
<TABLE border=0>
<TR> <TH> EVTYPE </TH> <TH> cropVal </TH>  </TR>
  <TR> <TD> DROUGHT </TD> <TD align="right"> 13.97 </TD> </TR>
  <TR> <TD> FLOOD </TD> <TD align="right"> 5.66 </TD> </TR>
  <TR> <TD> RIVER FLOOD </TD> <TD align="right"> 5.03 </TD> </TR>
  <TR> <TD> ICE STORM </TD> <TD align="right"> 5.02 </TD> </TR>
  <TR> <TD> HAIL </TD> <TD align="right"> 3.03 </TD> </TR>
  <TR> <TD> HURRICANE </TD> <TD align="right"> 2.74 </TD> </TR>
   </TABLE>

```r
print(xt3, include.rownames=F, html.table.attributes = getOption("xtable.html.table.attributes",
                                    "border=0"), type="html")
```

<!-- html table generated in R 3.1.1 by xtable 1.7-3 package -->
<!-- Thu Aug 21 17:52:08 2014 -->
<TABLE border=0>
<TR> <TH> EVTYPE </TH> <TH> propVal </TH> <TH> cropVal </TH> <TH> Total </TH>  </TR>
  <TR> <TD> FLOOD </TD> <TD align="right"> 144.66 </TD> <TD align="right"> 5.66 </TD> <TD align="right"> 150.32 </TD> </TR>
  <TR> <TD> HURRICANE/TYPHOON </TD> <TD align="right"> 69.31 </TD> <TD align="right"> 2.61 </TD> <TD align="right"> 71.91 </TD> </TR>
  <TR> <TD> TORNADO </TD> <TD align="right"> 56.94 </TD> <TD align="right"> 0.41 </TD> <TD align="right"> 57.35 </TD> </TR>
  <TR> <TD> STORM SURGE </TD> <TD align="right"> 43.32 </TD> <TD align="right"> 0.00 </TD> <TD align="right"> 43.32 </TD> </TR>
  <TR> <TD> HAIL </TD> <TD align="right"> 15.73 </TD> <TD align="right"> 3.03 </TD> <TD align="right"> 18.76 </TD> </TR>
  <TR> <TD> FLASH FLOOD </TD> <TD align="right"> 16.14 </TD> <TD align="right"> 1.42 </TD> <TD align="right"> 17.56 </TD> </TR>
   </TABLE>

From the new tidy data sets we created, ```cropTotal```, ```propTotal```, and ```ecoTotal```, we can see different losses under each category, sorted by the highest amount lost in billions USD.  We will use this information to create a plot in the next section.

## Section III: Results

We will now revisit the questions asked in Section II, and plot the results for the answers.

#### Q1. Across the United States, which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?

#### Q2. Across the United States, which types of events have the greatest economic consequences?

### Conclusion  
  
Consider writing your report as if it were to be read by a government or municipal manager 
 who might be responsible for preparing for severe weather events and will need to prioritize 
 resources for different types of events. However, there is no need to make any specific 
 recommendations in your report.


 ## Document Layout

 The analysis document must have at least one figure containing a plot.

 Your analyis must have no more than three figures. Figures may have multiple plots in them 
 (i.e. panel plots), but there cannot be more than three figures total.

 You must show all your code for the work in your analysis document. This may make the document 
 a bit verbose, but that is okay. In general, you should ensure that echo = TRUE for every code 
 chunk (this is the default setting in knitr).

 ## Publishing Your Analysis

 For this assignment you will need to publish your analysis on RPubs.com. If you do not 
 already have an account, then you will have to create a new account. After you have completed 
 writing your analysis in RStudio, you can publish it to RPubs by doing the following:
  
   In RStudio, make sure your R Markdown document (.Rmd) document is loaded in the editor

   Click the Knit HTML button in the doc toolbar to preview your document.

   In the preview window, click the Publish button.

   Once your document is published to RPubs, you should get a unique URL to that document. 
   Make a note of this URL as you will need it to submit your assignment.

 NOTE: If you are having trouble connecting with RPubs due to proxy-related or other issues, 
 you can upload your final analysis document file as a PDF to Coursera instead.

 Submitting Your Assignment

 In order to submit this assignment, you must copy the RPubs URL for your completed data 
 analysis document in to the peer assessment question.
 
  
