library(httpuv)
library(RCurl)
library(XML)
library(httr)
library(ggtern)
library(ggplot2)
library(ggmap)
library(MASS)
library(raster)
library(rjson)
source("Flickr_search.R")
source("Hotspot_points.R")

# Authenticate

api_key<-"8b3a8551185c0113ed72e60c530d0b51"

secret<- "767533312d7907d6"

myapp<-oauth_app("Birdwatching",key= api_key,secret= secret)                  #creates the app passing the key and secret


ep<-oauth_endpoint(request="https://www.flickr.com/services/oauth/request_token"    #get authentication credentials from the API
                   ,authorize="https://www.flickr.com/services/oauth/authorize",
                   access="https://www.flickr.com/services/oauth/access_token")


sig<-oauth1.0_token(ep,myapp,cache=F)                                             #creates variable with authentication credentials

fl_sig <- sign_oauth1.0(myapp,sig)   

# Download data
themes <- c("castles", "waterfall", "unique",
       "outdoor", "wildlife", "historic", "sacred", "family", "accessible",
       "peaceful", "dramatic", "romantic", "beautiful", "nature")

pics <- lapply(themes, function(x){flickr_search(year = seq(2005,2017,1), text=x, 
              woeid="10243", extras="date_taken,geo,tags")})

pics <- do.call(rbind, pics)


write.table(pics, "Flickr_pics.txt", row.names = F)

##################Mapping function################################
pics <- read.table("Flickr_pics.txt", header=T, stringsAsFactors = F)

search_terms <- unique(pics$text)

#hotspots <- lapply(search_terms, function(x){hotspot_points(pics[pics$text == x, ])})

hotspots_castles <- hotspot_points(data = subset(pics, text == "castles"))

hotspots_waterfall <- hotspot_points(data = subset(pics, text == "waterfall"))

hotspots_unique <- hotspot_points(data = subset(pics, text == "unique"))

hotspots_outdoor <- hotspot_points(data = subset(pics, text == "outdoor"))

hotspots_wildlife <- hotspot_points(data = subset(pics, text == "wildlife"))

hotspots_historic <- hotspot_points(data = subset(pics, text == "historic"))

hotspots_family <- hotspot_points(data = subset(pics, text == "family"))

hotspots_peaceful <- hotspot_points(data = subset(pics, text == "peaceful"))

hotspots_beautiful <- hotspot_points(data = subset(pics, text == "beautiful"))

hotspots_nature <- hotspot_points(data = subset(pics, text == "nature"))

hotspots <- rbind(hotspots_castles, hotspots_waterfall, hotspots_unique, hotspots_outdoor,
                  hotspots_wildlife, hotspots_historic, hotspots_family, hotspots_peaceful,
                  hotspots_beautiful, hotspots_nature)

#hotspots_list <- do.call(rbind, hotspots)

############convert to json #######################

hotspots <- toJSON(hotspots)

write(hotspots, file="all_hotspots.JSON")

