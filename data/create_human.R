#Mikko Hänninen
#26.11.2022

#access the readr library
library(readr)

#read data sets into memory
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

#explore the structure and dimensions of the data
dim(hd)
str(hd)
dim(gii)
str(gii)

#create summaries of the variables
summary(hd)
summary(gii)

#rename the variables with descriptive names
hd <- setNames(hd, c("HDI.Rank", "Country", "HDI", "Life.Exp", "Edu.Exp", "Edu.Mean", "GNI", "GNI-HDI.Rank"))
gii <- setNames(gii, c("GII.Rank", "Country", "GII", "Mat.Mor", "Ado.Birth", "Parli.F", "Edu2.F", "Edu2.M", "Labo.F", "Labo.M"))

#access the dplyr library
library(dplyr)

#add ratio of female and male populations with secondary education in each country to the gii data set
gii <- mutate(gii, Edu2.FM = Edu2.F / Edu2.M)
#add ratio of labor force participation of females and males in each country to the gii data set
gii <- mutate(gii, Labo.FM = Labo.F / Labo.M)

#join data sets using the variable "Country" as the identifier
human <- inner_join(gii, hd, by = "Country")

#verify structure of the new data set
str(human)

#saving the new data set to the "data" folder
write_csv(human, file = '~/Documents/Tohtoritutkinto/Open Science/IODS-project/data/human.csv')
