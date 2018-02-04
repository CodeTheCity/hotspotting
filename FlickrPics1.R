library(httpuv)
library(RCurl)
library(XML)
library(httr)
library(ggtern)
library(ggplot2)
library(ggmap)
library(MASS)
library(raster)
source("Flickr_search.R")

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


### Calculate distances to define bandwith for density estimation
## distance lon for y axis

## distance lat for x axis
x_dm = 3.013/x
x_dw = 0.05/x_dm
x_dw

y_dm = 2.781/y 
y_dw = 0.025/y_dm 
y_dw

pics$latitude <- as.numeric(pics$latitude)
pics$longitude <- as.numeric(pics$longitude)
pics_dens <- kde2d(x=pics$longitude,y=pics$latitude,h=c(x_dw,y_dw))
pics_dens_df <- data.frame(expand.grid(x=pics_dens$x,y=pics_dens$y),z=as.vector(pics_dens$z))
str(pics_dens_df)

w = matrix(1,5,5)
x = pics_dens
r = raster(x)
max_z <- function(X) max(X, na.rm=TRUE)
localmax <- focal(r, w, fun = max_z, pad=TRUE)
r2 <- r==localmax
maxXY <- xyFromCell(r2, Which(r2==1, cells=TRUE))
maxXY <- as.data.frame (maxXY)



Map <-get_googlemap(c(lon=mean(pics$longitude), lat=mean(pics$latitude)), zoom=11, maptype="roadmap") 

Density_map <-ggmap(Map) + stat_contour(aes(x=x,y=y,z=z,fill=..level..),geom="polygon", data=pics_dens_df)+
  geom_point(aes(x=x,y=y),colour="red", data=maxXY) +
  scale_x_continuous( limits = c(min(pics_dens_df$x),max(pics_dens_df$x)) , expand = c( 0.05 , 0.05) ) +
  scale_y_continuous( limits = c(min(pics_dens_df$y),max(pics_dens_df$y)) , expand = c( 0.05 , 0.05) )

Density_map

Point_map <- ggmap(Map) +
  geom_point(aes(x=x,y=y), data=maxXY) +
  scale_x_continuous( limits = c(min(pics_dens_df$x),max(pics_dens_df$x)) , expand = c( 0.05 , 0.05) ) +
  scale_y_continuous( limits = c(min(pics_dens_df$y),max(pics_dens_df$y)) , expand = c( 0.05 , 0.05) )
Point_map

str(maxXY)


