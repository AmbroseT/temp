

## WEATHER SYSTEMS AND THEIR IMPACT ACROSS THE U.S.
***

## Section I: Synopsis



## Section II: Data Processing

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


```r
## Preparing the directory locations:
## check if destination directories to be used already exist, relative to
## the working directory

if(!file.exists("data")) {dir.create("data")}
if(!file.exists("./data/temp/repdata2")) {dir.create("./data/temp/repdata2")}

## set the name of the file to be used after download
filename <- "StormData.csv"

## Check to see if the file already exists locally
if(!file.exists("StormData.csv")) {
    
    ## file does not exist locally:
    ## note that BZ2 files are just text files that R recognizes, so there is no need 
    ## for extraction. Download file renamed to StormData.csv, write to a text file
    ## today's date of download. If the CSV file does not exist, but the downloaded.txt 
    ## file already exists, the text file will be over written with a new file.
    
    fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
    download.file(fileUrl, destfile=filename)
    writeLines(Date(),"datedownloaded.txt")
    datedownloaded <- paste(readLines("datedownloaded.txt"),
                            ", downloaded today", sep="")

} else {
    
    ## file exists locally:
    ## Save variable as local copy if file already exists.
    
    datedownloaded <- paste(readLines("datedownloaded.txt"),
                            ", localCopy", sep="")
} 
```

Now that we have downloaded the raw data set, we can store it into a variable named ```weatherDdata``:


```r
weatherData <- read.csv(filename, sep=",")
```

Using inline R code, the following HTML table just states and records the ```filename``` and ```datedownloaded```, from the above code chunk:

|            | File Used      | Downloaded          |
| ----------:| --------------:| -------------------:|
| **Record** | StormData.csv   | Tue Aug 19 13:30:57 2014, localCopy  |

Recording this information will help in determining accuracy of the analysis if the data should change in the future. If there is an updated date set, then the date of the new data set can be compared against the ```datedownloaded``` of this analysis.  Adjustments can then be made to the analysis code to reflect the change, or margins of error can be calculated based on the differences.

Next we will use the ```weatherData``` data set to run some analysis. First, let's check the summary of the data set:


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

We can take the above summary of the variables in the data set and cross reference the information about the data set in the National Weather Service PDF file [here](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf).


## Section III: Results

### Answering the Questions

Your data analysis must address the following questions:
  
- Across the United States, which types of events (as indicated in the EVTYPE variable) 
 are most harmful with respect to population health?

  
 -- data contains 'fatalities' and 'injuries' with regards to population health
  
  
  
  
- Across the United States, which types of events have the greatest economic consequences?

  
 -- variables related to economy: propdmg, propdmgexp, cropdmg, cropdmgexp
  
### Conclusion  
  
Consider writing your report as if it were to be read by a government or municipal manager 
 who might be responsible for preparing for severe weather events and will need to prioritize 
 resources for different types of events. However, there is no need to make any specific 
 recommendations in your report.

  

 ## Document Layout

 Language: Your document should be written in English.

 Title: Your document should have a title that briefly summarizes your data analysis

 Synopsis: Immediately after the title, there should be a synopsis which describes and 
 summarizes your analysis in at most 10 complete sentences.

 There should be a section titled Data Processing which describes (in words and code) 
 how the data were loaded into R and processed for analysis. In particular, your analysis 
 must start from the raw CSV file containing the data. You cannot do any preprocessing 
 outside the document. If preprocessing is time-consuming you may consider using the 
 cache = TRUE option for certain code chunks.

 There should be a section titled Results in which your results are presented.

 You may have other sections in your analysis, but Data Processing and Results are required.

 The analysis document must have at least one figure containing a plot.

 Your analyis must have no more than three figures. Figures may have multiple plots in them 
 (i.e. panel plots), but there cannot be more than three figures total.

 You must show all your code for the work in your analysis document. This may make the document 
 a bit verbose, but that is okay. In general, you should ensure that echo = TRUE for every code 
 chunk (this is the default setting in knitr).

 Publishing Your Analysis

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
 
  
