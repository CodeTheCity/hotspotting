hotspot_points<- function(data,lon=0.5,lat=0.5){
  
  data$latitude <- as.numeric(data$latitude)
  data$longitude <- as.numeric(data$longitude)
  
  ### Calculate distances to define bandwith for density estimation
  
  ## distance for bandwiths
  
  x_dm = 3.013/lon
  x_dw = 0.05/x_dm
  x_dw
  
  y_dm = 2.781/lat
  y_dw = 0.025/y_dm 
  y_dw
  
  
  data_dens <- kde2d(x=data$longitude,y=data$latitude,h=c(x_dw,y_dw))
  data_dens_df <- data.frame(expand.grid(x=data_dens$x,y=data_dens$y),z=as.vector(data_dens$z))
  
  w = matrix(1,5,5)
  x = data_dens
  r = raster(x)
  max_z <- function(X) max(X, na.rm=TRUE)
  localmax <- focal(r, w, fun = max_z, pad=TRUE)
  r2 <- r==localmax
  maxXY <- xyFromCell(r2, Which(r2==1, cells=TRUE))
  maxXY <- as.data.frame (maxXY)
  maxXY$text <- rep(unique(data$text), dim(maxXY)[1])
  return(maxXY)
  }
  