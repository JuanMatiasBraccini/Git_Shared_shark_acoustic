
#---------- SCRIPT FOR ANALYSIS ACOUSTIC TAGGING DATA -------#

library(dplyr)
library(lubridate)
library(leaflet)
library(leaflet.minicharts)

rm(list=ls())  #removes all previous lists

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

##DATA VALIDATION - CD

#subsampling tag data for Bronzies
CPTAGS <- subset(TAGS, Species2 =="bronze whaler")

# subsampling detection data for Bronzies
CP <- subset(Detections, Species =="bronze whaler")

#subsamples unique detection latitudes to map data below
#not sure if this is the best way to do it Dani, but seems to work, If i didnt R would crash with trying to plot 256,000 detections
CPUNI <- distinct(CP, Latitude, .keep_all = T)

#Mapping relase and detection locations - interatctive map, able to look at the location data
j <-   leaflet() %>% addProviderTiles("Esri.WorldImagery") 
j %>%  setView(124,-34,5)  
j %>%  addCircles(CPUNI$Longitude ,CPUNI$Latitude, color=c('red'),radius=20,opacity = 1,fillOpacity = 1) %>%
       addCircles(CPTAGS$ReleaseLongitude ,CPTAGS$ReleaseLatitude, color=c('yellow'),radius=50,opacity = 1,fillOpacity = 1)   %>%    
       addLegend("bottomright", colors=c('red','yellow'),labels = c('Detections','Release Site'), opacity = 1)


# Dates for first and last tagged CP
(Firsttag=min(CP$ReleaseDate,na.rm=T))
(Lasttag=max(CP$ReleaseDate,na.rm=T))


# Dates for first and last detected CP
(Fistdetect=min(CP$Date.local,na.rm=T))
(Lastdetect=max(CP$Date.local,na.rm=T))




>>>>>>> ee17ae663df1bb2dac5b4c178bf963057767b9e3
