hotspot_points<- function(data,lon=0.5,lat=0.5){
  if(dim(data)[1]>10){
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
  
  w = matrix(1,3,3)
  x = data_dens
  r = raster(x)
  max_z <- function(X) max(X, na.rm=TRUE)
  localmax <- focal(r, w, fun = max_z, pad=TRUE)
  r2 <- r==localmax
  maxXY <- xyFromCell(r2, Which(r2==1, cells=TRUE))
  maxXY <- as.data.frame (maxXY)
  
  maxXY$pop<- extract(r,maxXY)
  maxXY <- maxXY[rev(order(maxXY$pop)),]
  maxXY <- maxXY[maxXY$pop > mean(maxXY$pop),]
  
  maxXY$text <- rep(unique(data$text), length(maxXY$x))
  return(maxXY)
  } 
}
  