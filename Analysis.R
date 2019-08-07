  #---------- SCRIPT FOR ANALYSIS ACOUSTIC TAGGING DATA -------#

library(dplyr)
library(lubridate)

# Section 1. read in data -------------------------------------------------
setwd("M:\\Fisheries Research\\FinFish\\Shark\\Bronze whaler\\Data")
Detections=read.csv("Detections.csv",stringsAsFactors=F)



# Section 2. Input parameters -------------------------------------------------


# Section 3. Data manipulation section -------------------------------------------------
  #convert some variables to date, time, and remove duplicates
Detections=Detections%>%mutate(ReleaseLatitude=-abs(ReleaseLatitude),
                               Latitude=-abs(Latitude),
                               ReleaseDate=ymd(ReleaseDate),
                               DateTime.local=ymd_hms(DateTime.local),
                               Date.local=ymd(Date.local),
                               Time.local=hms(Time.local))%>%
                        distinct(TagCode,DateTime.local,Species,Sex,Latitude,Longitude,.keep_all=T)



# Section 4. Procedure section -------------------------------------------------


