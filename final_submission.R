#install.packages("RODBC")
library(RODBC)


# 1(a)
#loading the package RODBC if available else installing it
if(!require(RODBC)){
  cat("Installing the RODBC Package")
  install.packages("RODBC")
}else{
  cat("Loading the RODBC package!")
  library(RODBC)
  cat("\n RODBC Package loading finished....")
}
#creating the connection to the database
channel <- odbcConnectAccess2007("StudyENTE.mdb", pwd="ceopracr")
#Importing the tables as dataframes
D1 <- sqlQuery( channel , paste ("select * from Cannabis"))
D2 <- sqlQuery( channel , paste ("select * from Controles"))
D3 <- sqlQuery( channel , paste ("select * from XTC"))

#mydbase is the single dataframe that contains the data from all the three tables of original database
mydbase<- rbind(D1,D2,D3)
dim(mydbase)

#1(b)----------------------------------------------------------------------------------------------
sourced_D1<-D1
sourced_D1$group<-c("Cannabis")
sourced_D2<-D2
sourced_D2$group<-c("Controles")
sourced_D3<-D3
sourced_D3$group<-c("Ecstasy")

sourced_dbase<-rbind(sourced_D3, sourced_D2, sourced_D1)
rm(sourced_D1,sourced_D2, sourced_D3)
#converting the variable group to a factor using as.factor() function 
sourced_dbase$group <-as.factor(sourced_dbase$group)
#the factor has levels 1, 2, 3 for Cannabis, Controles and XTC respectively
sourced_dbase$group <- relevel(sourced_dbase$group, ref = "Ecstasy")

levels(sourced_dbase$group)


#1(c)
#creating a sorted dataframe based on the group and volunteer id
sorted_sourcedb<-sourced_dbase[order(sourced_dbase$group, sourced_dbase$vol),]

#1(d)
dim(sorted_sourcedb)[1] #gives 93 rows for the entire database
missing<-unique(which(is.na(sorted_sourcedb), arr.ind = T)[,1]) #gives 3 rows with missing values
sorted_sourcedb[missing,] #prints those rows with missing values

#sorted cleaned is the dataframe which doesn't contains any row with missing values
sorted_cleaned<-na.omit(sorted_sourcedb)
dim(sorted_cleaned)[1] #gives 90 rows with no row having a missing value

#sorted_cleaned is the new dataframe with desired properties being "No Missing Values"

#1(e)
library(plyr)
sorted_cleaned$sex<-as.factor(sorted_cleaned$sex)
sorted_cleaned$sex<- revalue(sorted_cleaned$sex, c("1"="Male", "2"="Female"))

#1(f)

# (-Inf,21],(21,24],(24,Inf)
#new<-sorted_cleaned$age
sorted_cleaned$age_cat<-cut(sorted_cleaned$age, breaks = c(-Inf,21,24,Inf),
                            labels = c("<= 21","22-24", ">=25")) #with default labels
# sorted_cleaned$age_cat<-cut(sorted_cleaned$age, breaks = c(-Inf,21,24,Inf), 
#                             labels = c("low","medium","high")) # with labels defined

#1(g)
#creating standardized variable for all four vairables requested
standard_corcub<-(sorted_cleaned$corcub-mean(sorted_cleaned$corcub))/sd(sorted_cleaned$corcub)
standard_sdmttoco<-(sorted_cleaned$sdmttoco-mean(sorted_cleaned$sdmttoco)
                    )/sd(sorted_cleaned$sdmttoco)
standard_lnsscore<-(sorted_cleaned$lnsscore-mean(sorted_cleaned$lnsscore)
                    )/sd(sorted_cleaned$lnsscore)
standard_waisvocd<-(sorted_cleaned$waisvocd-mean(sorted_cleaned$waisvocd)
                    )/sd(sorted_cleaned$waisvocd)
#Creating the composite variable by adding the four standarized variables
sorted_cleaned$composite<-standard_corcub+standard_lnsscore+standard_sdmttoco+standard_waisvocd


##Another way using mutate of dplyr could have been used but avoided since it was expected that
##marks might be deducted for using a package unless otherwise specified

#1(h)
#We need to display the mean, median, standard deviation and range for the variable composite 
#groupwise where the groups are "Extasis" and "Non Extasis". Shall we do it in such a way that
# three factors "XTC", "Cannabis", "Control" is displayed?
library(dplyr)
#new<-group_by(sorted_cleaned, group) 
summarise(group_by(sorted_cleaned, group), mean=mean(composite, na.rm = T), 
          median=median(composite), std_dev=sd(composite), range=diff(range(composite)))


#1(i)
sqlSave(channel, sorted_cleaned, tablename = "New_Data_Frame")
#We're using sql update also because while practising we had to update the table in MS Access Database
#It was done to overwrite the new data frame which was already inserted.
sqlUpdate(channel, sorted_cleaned, tablename = "New_Data_Frame")

#1(j)
sqlQuery(channel, paste("select group, age_cat from New_Data_Frame"))

#1(k)
mosaicplot(~group + age, data = sorted_cleaned)
#Even the second version seems to be working quite nicely
mosaicplot(~age + group, data = sorted_cleaned)

#1(l)
#install.packages("descr")
library(descr)
#for the categorical age variable, the conditional distribution by study group
CrossTable(sorted_cleaned$age_cat, sorted_cleaned$group)

#For the numerical age variable, the conditional distribution by study group
CrossTable(sorted_cleaned$age, sorted_cleaned$group)


#1(m)
#Closing the connection with the database
odbcClose(channel)


#1(n)
#Exporting the data in an excel file where each sheet is created for a specific group
#write.csv2(sorted_cleaned, "my_data.csv")

#install.packages("xlsx")
library(xlsx)
group_1<-sorted_cleaned[sorted_cleaned$group=="Ecstasy",]
write.xlsx(select(group_1, -group), file = "myfile.xlsx", sheetName = "Group1", 
           col.names = TRUE, row.names = F, append = T)
group_2<-sorted_cleaned[sorted_cleaned$group=="Cannabis",]
write.xlsx(select(group_2, -group), file = "myfile.xlsx", sheetName = "Group2", 
           col.names = TRUE, row.names = F, append = T)
group_3<-sorted_cleaned[sorted_cleaned$group=="Controles",]
write.xlsx(select(group_3, -group), file = "myfile.xlsx", sheetName = "Group3", 
           col.names = TRUE, row.names = F, append = T)

#------------------------------------------Exercise 1 ends here------------------------------------


#------------------------------------------Exercise 2 begins here----------------------------------
#Some information for the variables
#1) The CALCAP Reaction Time program is one of the most comprehensive tools available for assessing reaction times, speed of information processing, 
#rapid visual scanning, form discrimination, brief memory and divided attention.
#We are considering the corcub  variable->	Corsi cubes: total score
#higher score->better performance


#2)SDMT: Number of correct answers:  The Symbol Digit Modalities Test (SDMT) was developed to identify individuals 
#with neurological impairmentThe SDMT assesses key neurocognitive functions that underlie 
#many substitution tasks, including attention, visual scanning, and motor speed.
#Studies suggest that in ages greater than 55 years, there is a lowering of SDMT performance
#but no systematic effect across normal younger individuals.
#Conclusion: Higher SDMT -> better performance

#3) Letter number sequencing: a task that requires the reordering of an initially unordered set of letters and numbers
#Higher LNC-> better performance

#4) The Wechsler Adult Intelligence Scale (WAIS) is an IQ test designed to measure 
#intelligence and cognitive ability in adults and older adolescents
#There are different types of Wechsler tests for different age groups, each using the average scale of 100 points, 
#which is the mean of the normal curve.
#Higher score-> better performance


#group1=Cannabis
#group2=Controles
#group3=XTC


#A

#1)Data regarding corcub
#min(my_data_2_$corcub)=7
#max(my_data_2_$corcub)=24

library(ggplot2)
my_data_2_ <-sorted_cleaned
bar <- ggplot(data = my_data_2_) + 
  geom_bar(
    mapping = aes(x = corcub), fill = "blue", 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)+
  facet_wrap(~ group, nrow = 2)
bar + coord_flip()
#or instead of coord_flip() you can choose the following format
bar + coord_polar()

#2)Data regarding sdmttoco
#min(my_data_2_$sdmttoco)=36
#max(my_data_2_$sdmttoco)=95


bar <- ggplot(data = my_data_2_) + 
  geom_bar(
    mapping = aes(x = sdmttoco), fill = "blue", 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)+
  facet_wrap(~ group, nrow = 2)
bar + coord_flip()
#or 
bar + coord_polar()

#3)Data regarding lnsscore
#min(my_data_2_$lnsscore)=8
#max(my_data_2_$lnsscore)=19

bar <- ggplot(data = my_data_2_) + 
  geom_bar(
    mapping = aes(x = lnsscore), fill = "blue", 
    show.legend = TRUE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)+
  facet_wrap(~ group, nrow = 2)
bar + coord_flip()
#or 
bar + coord_polar()


#4)Data regarding waisvocd
#min(my_data_2_$waisvocd)=30
#max(my_data_2_$waisvocd)=60


bar <- ggplot(data = my_data_2_) + 
  geom_bar(
    mapping = aes(x = waisvocd), fill = "blue", 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)+
  facet_wrap(~ group, nrow = 2)
bar + coord_flip()
#or
bar + coord_polar()

#B-Violin Plot ->A violin plot is a method of plotting numeric data. 
#It is a boxplot with a rotated kernel density plot on each side.

#1)Data regarding corcub variable

ggplot(my_data_2_, aes(factor(group), corcub)) +
  geom_violin(aes(fill = factor(group)))

#2)Data regarding sdmttoco variable

ggplot(my_data_2_, aes(factor(group), sdmttoco)) +
  geom_violin(aes(fill = factor(group)))

#3)Data regarding lnsscore variable

ggplot(my_data_2_, aes(factor(group), lnsscore)) +
  geom_violin(aes(fill = factor(group)))

#4)Data regarding waisvocd variable

ggplot(my_data_2_, aes(factor(group), waisvocd)) +
  geom_violin(aes(fill = factor(group)))

#-------------------------------------------Exercise 2 ends here-----------------------------------



#------------------------------------------Exercise 3 begins here----------------------------------


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
    extension_url_1<-"spieltag/38/"
    extension_url_2<-"spieltag/34/"
    extension_url_3<-"spieltag/30/"
    if(year>2004){
      return(paste(country_url, year_url, extension_url_1, sep = "-"))
    }else{
      if(year>1988){
        return(paste(country_url, year_url, extension_url_2, sep = "-"))
      }else{
        return(paste(country_url, year_url, extension_url_3, sep = "-"))
      }
      
    }
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
  
  #Performing legitimate country_name check
  if(country_name%in%c("Spain", "Germany", "Italy", "England") & is.na(country_name)==F){
    
    #If the country_name is legitimate, performing check for "Recent Year criteria" i.e. Year>1970
    if(year>1970 & is.nan(year)==F & is.infinite(year)==F & is.na(year)==F){
      x<-as.data.frame(driver_function(country_name, year))
      y<-as.vector(as.character(x$V3[1]))
      cat("Champion in", country_name, "in", year, ":", y)
      
    }else{
      print("Oh Oh! You just entered an invalid year.")
      
      new_year<-input_function()
      champion(country_name, new_year)
    }
  }else{
    country_list<-c("Spain", "Germany", "Italy", "England");
    print("Please enter a valid country from the list")
    print(country_list)
    new_country<-input_country_name();
    champion(new_country, year)
  }
}

input_function<-function(){
  n <- readline(prompt="Enter a valid year after summer of '69 (for e.g. 1971) :  ")
  return(as.integer(n))
}
input_country_name<-function(){
  country<-readline(prompt = "Enter the name of the Country to query:  ")
  return(as.character(country))
}
#Function reurn error if country not in the four specified
#Error message specifying user to choose country options
#Error message for year if it is not recent
#Check if both the entered/input things are not NAN, NA or Inf

