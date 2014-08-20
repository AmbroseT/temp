repdata2 <- function() {
  
  if(!file.exists("data")) {dir.create("data")}
  if(!file.exists("./data/temp/repdata2")) {dir.create("./data/temp/repdata2")}
  
  if(!file.exists("./data/temp/repdata2/StormData.csv")) {   
    fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
    
    ## note that BZ2 files are just text files that R recognizes, so there is no need 
    ## for extraction. Download file renamed to StormData.csv, write to a text file
    ## today's date of download. If the CSV file does not exist, but the downloaded.txt 
    ## file already exists, the text file will be over written with the current date.
   download.file(fileUrl, destfile="./data/temp/repdata2/StormData.csv")
   writeLines(date(),"./data/temp/repdata2/datedownloaded.txt")
   datedownloaded <- paste(readLines("./data/temp/repdata2/datedownloaded.txt"),
                           ", downloaded today", sep="")

  } else {
   ## Save variable as local copy if file already exists.
   datedownloaded <- paste(readLines("./data/temp/repdata2/datedownloaded.txt"),
                           ", localCopy", sep="")
  }  
  message("File used: StormData.csv")
  message("Downloaded: ", datedownloaded)
  
  
  
  
  
  ## The basic goal of this assignment is to explore the NOAA Storm Database and answer some 
  ## basic questions about severe weather events. You must use the database to answer the 
  ## questions below and show the code for your entire analysis. Your analysis can consist of 
  ## tables, figures, or other summaries. You may use any R package you want to support your analysis.
  ##
  
  ## ================================================================================================
  ## Questions
  ##
  ## Your data analysis must address the following questions:
  ##  
  ##   Across the United States, which types of events (as indicated in the EVTYPE variable) 
  ##   are most harmful with respect to population health?
  ##
  
  ## data contains 'fatalities' and 'injuries' with regards to population health
  
  
  
  
  ##   Across the United States, which types of events have the greatest economic consequences?
  ##
  
  ## variables related to economy: propdmg, propdmgexp, cropdmg, cropdmgexp
  
  
  
  ## Consider writing your report as if it were to be read by a government or municipal manager 
  ## who might be responsible for preparing for severe weather events and will need to prioritize 
  ## resources for different types of events. However, there is no need to make any specific 
  ## recommendations in your report.
  ##
  
  ## ================================================================================================ 
  ## Document Layout
  ##
  ## Language: Your document should be written in English.
  ##
  ## Title: Your document should have a title that briefly summarizes your data analysis
  ##
  ## Synopsis: Immediately after the title, there should be a synopsis which describes and 
  ## summarizes your analysis in at most 10 complete sentences.
  ##
  
  ## There should be a section titled Data Processing which describes (in words and code) 
  ## how the data were loaded into R and processed for analysis. In particular, your analysis 
  ## must start from the raw CSV file containing the data. You cannot do any preprocessing 
  ## outside the document. If preprocessing is time-consuming you may consider using the 
  ## cache = TRUE option for certain code chunks.
  ##
  
  ## There should be a section titled Results in which your results are presented.
  ##
  
  ## You may have other sections in your analysis, but Data Processing and Results are required.
  ##
  
  ## The analysis document must have at least one figure containing a plot.
  ##
  
  ## Your analyis must have no more than three figures. Figures may have multiple plots in them 
  ## (i.e. panel plots), but there cannot be more than three figures total.
  ##
  
  ## You must show all your code for the work in your analysis document. This may make the document 
  ## a bit verbose, but that is okay. In general, you should ensure that echo = TRUE for every code 
  ## chunk (this is the default setting in knitr).
  ##
  ## ================================================================================================ 
  ## Publishing Your Analysis
  ##
  ## For this assignment you will need to publish your analysis on RPubs.com. If you do not 
  ## already have an account, then you will have to create a new account. After you have completed 
  ## writing your analysis in RStudio, you can publish it to RPubs by doing the following:
  ##  
  ##   In RStudio, make sure your R Markdown document (.Rmd) document is loaded in the editor
  ##
  ##   Click the Knit HTML button in the doc toolbar to preview your document.
  ##
  ##   In the preview window, click the Publish button.
  ##
  ##   Once your document is published to RPubs, you should get a unique URL to that document. 
  ##   Make a note of this URL as you will need it to submit your assignment.
  ##
  ## NOTE: If you are having trouble connecting with RPubs due to proxy-related or other issues, 
  ## you can upload your final analysis document file as a PDF to Coursera instead.
  ##
  ## Submitting Your Assignment
  ##
  ## In order to submit this assignment, you must copy the RPubs URL for your completed data 
  ## analysis document in to the peer assessment question.
  ## 
  
  
  
}