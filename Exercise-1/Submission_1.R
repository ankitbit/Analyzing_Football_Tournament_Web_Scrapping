#install.packages("RODBC")
library(RODBC)

con<-odbcConnect("StudyENTE.mdb",uid = "xxxx", pwd=code)
ch<-odbcConnectAccess2007("StudyENTE.mdb", pwd="ceopracr")

data <- sqlQuery( ch , paste ("select * from XTC"))

View(data)


#1(b)
# Converting the values of our variable for conversion to factor
for(i in seq(sourced_dbase$group)){
  if(sourced_dbase$group[i]==1){
    sourced_dbase$group[i]<-"Extasis"
  }else{
    sourced_dbase$group[i]<-"Not Extasis"
  }
}
#Converting the variable group to a factor
sourced_dbase$group<-as.factor(sourced_dbase$group)


#1(c)
sorted_sourcedb<-sourced_dbase[order(sourced_dbase$group, sourced_dbase$vol),]

#1(d)
dim(sorted_sourcedb)[1] #gives 93 rows for the entire database
missing<-unique(which(is.na(sorted_sourcedb), arr.ind = T)[,1]) #gives 3 rows with missing values
sorted_sourcedb[missing,] #prints those rows with missing values

sorted_cleaned<-na.omit(sorted_sourcedb)
dim(sorted_cleaned)[1] #gives 90 rows with no row having a missing value

#1(e)
library(plyr)
sorted_cleaned$sex<-as.factor(sorted_cleaned$sex)
sorted_cleaned$sex<- revalue(sorted_cleaned$sex, c("1"="Male", "2"="Female"))

#1(f)

# (-Inf,21],(21,24],(24,Inf)
new<-sorted_cleaned$age
sorted_cleaned$age_cat<-cut(sorted_cleaned$age, breaks = c(-Inf,21,24,Inf)) #with default labels
sorted_cleaned$age_cat<-cut(sorted_cleaned$age, breaks = c(-Inf,21,24,Inf), 
                            labels = c("low","medium","high")) # with labels defined

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

#1(h)

library(dplyr)
#new<-group_by(sorted_cleaned, group) 
summarise(group_by(sorted_cleaned, group), mean=mean(composite, na.rm = T), 
          median=median(composite), std_dev=sd(composite), range=diff(range(composite)))


#1(i)

#1(n)
write.xlsx(iris[iris$Species=="setosa",], file = "myfile.xlsx", sheetName = "Sheet1", 
           col.names = TRUE,
           row.names = F, append = T)
write.xlsx(iris[iris$Species=="versicolor",], file = "myfile.xlsx", sheetName = "Sheet2", 
           col.names = TRUE,
           row.names = F, append = T)

