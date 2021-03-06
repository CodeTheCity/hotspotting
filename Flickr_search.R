flickr_search <- function(year, text, woeid, extras = NULL){
  baseURL <- paste("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=",api_key,sep="")   #set base URL
  pics<-NULL
  hasgeo<-"1"
  perpage<-"250"
  format<-"rest"
  
  for (y in 1:length(year)){                     #creates object dates
    for (m in 1:12){ daymin<-"01"
    
    ifelse ((m==4|m==6|m==9|m==11), daymax<-"30",daymax<-"31")
    if (m==2){
      ifelse (year[y]==2008|year[y]==2012, daymax<-29,daymax<-28)
    }
    
    ifelse (m==10|m==11|m==12,
            mindate<-as.character(paste(year[y],m,daymin,sep="-")),
            mindate<-as.character(paste(year[y],paste("0",m,sep="")
                                        ,daymin,sep="-")))
    
    ifelse (m==10|m==11|m==12,
            maxdate<-as.character(paste(year[y],m,daymax,sep="-")),
            maxdate<-as.character(paste(year[y],paste("0",m,sep="")
                                        ,daymax,sep="-")))
    
    
    getPhotos <- paste(baseURL                                           #request URL
                       ,"&text=",text,"&min_taken_date=",mindate,
                       "&max_taken_date=",maxdate,"&woe_id=",woeid,
                       "&has_geo=",hasgeo,"&extras=",extras,
                       "&per_page=",perpage,"&format=",format,sep="")
    
    
    
    getPhotos_data <- xmlRoot(xmlTreeParse(getURL                                    #parse URL and extract root node
                                           (getPhotos,ssl.verifypeer=FALSE, useragent = "flickr") ))
    
    #results are returned in different pages so it is necessary to loop through pages to collect all the data
    #parse the total number of pages
    pages_data <- data.frame(xmlAttrs(getPhotos_data[["photos"]]))
    pages_data[] <- lapply(pages_data, as.character)
    pages_data[] <- lapply(pages_data, as.integer)
    colnames(pages_data)<- "value"
    total_pages <- pages_data["pages","value"]
    pics_tmp<-NULL
    
    if(total_pages > 0)
      # loop thru pages of photos and save the list in a DF
      for(i in c(1:total_pages)){
        getPhotos <- paste(baseURL
                           ,"&text=",text,"&min_taken_date=",mindate,
                           "&max_taken_date=",maxdate,"&woe_id=",woeid,
                           "&has_geo=",hasgeo,"&extras=",extras,
                           "&per_page=",perpage,"&format=",format,"&page="
                           ,i,sep="")
        
        
        getPhotos_data <- xmlRoot(xmlTreeParse(getURL
                                               (getPhotos,ssl.verifypeer=FALSE, useragent = "flickr")
                                               ,useInternalNodes = TRUE ))
        
        
        id<-xpathSApply(getPhotos_data,"//photo",xmlGetAttr,"id")                 #extract photo id
        owner<-xpathSApply(getPhotos_data,"//photo",xmlGetAttr,"owner")           #extract user id
        datetaken<-xpathSApply(getPhotos_data,"//photo",xmlGetAttr,"datetaken")   #extract date picture was taken
        tags<- xpathSApply(getPhotos_data,"//photo",xmlGetAttr,"tags")            #extract tags
        latitude<- xpathSApply(getPhotos_data,"//photo",xmlGetAttr,"latitude")    #extract latitude
        longitude<- xpathSApply(getPhotos_data,"//photo",xmlGetAttr,"longitude")  #extract longitude
        
        tmp_df<-data.frame(cbind(id,owner,datetaken,tags,latitude,longitude), text = rep(text, length(id)),stringsAsFactors=FALSE)
        
        
        tmp_df$page <- i
        pics_tmp<-rbind(pics_tmp,tmp_df)
      }
    
    
    pics<-rbind(pics,pics_tmp)
    }}
  return(pics)
}
