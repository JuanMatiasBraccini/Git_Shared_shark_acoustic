  #---------- SCRIPT FOR ANALYSIS ACOUSTIC TAGGING DATA -------#

library(dplyr)
library(lubridate)

# Section 1. read in data -------------------------------------------------
setwd("M:\\Fisheries Research\\FinFish\\Shark\\Bronze whaler\\Data")
Detections=read.csv("Detections.csv",stringsAsFactors=F)
AATAMS.all=read.csv("AATAMS.all.csv",stringsAsFactors=F)
SMN.all=read.csv("SMN.all.csv",stringsAsFactors=F)
TAGS=read.csv("TAGS.csv",stringsAsFactors=F)


#Reported recaptures
setwd("U:/Shark")  # working directory
channel <- odbcConnectAccess2007("Sharks.mdb")      
Rep.Recap=sqlFetch(channel, "Tag data", colnames = F)   
close(channel)


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

TAGS=TAGS%>%mutate(Sex2=ifelse(Sex2%in%c("","?","U","u"),"U",ifelse(Sex2=="f","F",ifelse(Sex2=="m","M",Sex2))),
                   ReleaseLatitude2=-abs(ReleaseLatitude2),
                   TagCode=as.integer(Code2))


Detections=Detections%>%left_join(TAGS,by=c("Species" = "Species2","TagCode","Sex"="Sex2"))%>%
                        select(-c(Code2,ReleaseDate2,ReleaseLatitude2,ReleaseLongitude2))  
  


# Section 4. Procedure section -------------------------------------------------


