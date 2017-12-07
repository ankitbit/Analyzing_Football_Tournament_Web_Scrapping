
#install.packages("XML")
library(XML)
url1 <- "http://www.livefutbol.com/calendario/esp-primera-division-2016-2017-spieltag_2/38/"
url2 <- as.character(generate_url("Spain", 2017))
#for the following command, the url returned doesn't contain the data of league
url2 <- as.character(generate_url("Spain", 2016))
liga16 <- readHTMLTable(url2, header = TRUE)[[4]]
head(liga17, 4)

url2 <- "http://www.livefutbol.com/calendario/esp-primera-division-2004-2005-spieltag_2/38/"
liga07 <- readHTMLTable(url2, header = TRUE)[[4]]
head(liga07, 4)

#generic function for creating url for extracting data from the web portal
generate_url<-function(country_name, year){
  
  if(country_name=="Spain"){
    country_url<-"http://www.livefutbol.com/calendario/esp-primera-division"
    year_url<-generate_year(year)
    extension_url<-"spieltag/38/"
    return(paste(country_url, year_url, extension_url, sep = "-"))
  }
  
  if(country_name=="England"){
    country_url<- "http://www.livefutbol.com/calendario/eng-premier-league"
    year_url<-generate_year(year)
    extension_url<-"spieltag/38/"
    return(paste(country_url, year_url, extension_url, sep = "-"))
  }
  
  if(country_name=="Italy"){
    country_url<- "http://www.livefutbol.com/calendario/ita-serie-a"
    year_url<- generate_year(year)
    extension_url<-"spieltag/38/"
    return(paste(country_url, year_url, extension_url, sep = "-"))
  }
  
  if(country_name=="Germany"){
    country_url<-"http://www.livefutbol.com/calendario/bundesliga"
    year_url<-generate_year(year)
    extension_url<-"spieltag/34/"
    return(paste(country_url, year_url, extension_url, sep = "-"))
  }
  
}
generate_year<-function(year){
  return(as.character(paste(as.character(year-1), as.character(year), sep = "-")));
}
#Driver function for generating the tabular format of results of league
#Input parameteres: "Country Name" and "Year of League"
driver_function<-function(country_name,year){
  url<-generate_url(country_name, year)
  league <- readHTMLTable(url, header = TRUE)[[4]]
  
  return(league)
}

champion<-function(country_name, year){
  x<-as.data.frame(driver_function(country_name, year))
  y<-as.vector(x$V3[1])
  cat("Champion in", country_name, "in", year, ":", y)
  
}



