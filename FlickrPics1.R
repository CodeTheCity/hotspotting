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
themes <- c("castles", "distillery", "waterfall", "stone circle", "unique",
       "outdoor", "wildlife", "historic", "sacred", "family", "accessible",
       "peaceful", "dramatic", "romantic", "beautiful", "nature")

pics <- lapply(themes, function(x){flickr_search(year = seq(2015,2017,1), text=x, 
              woeid="10243", extras="date_taken,geo,tags")})

pics <- do.call(rbind, pics)

##################Mapping function################################

search_terms <- unique(pics$text)

hotspots <- lapply(search_terms,function(x){hotspot_points(pics[pics$text==x,])})

hotspots_list <- do.call(rbind, hotspots)

############convert to json #######################

hotspots <- toJSON(hotspots_list)

