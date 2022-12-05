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

#join data sets into new `human` data set using the variable "Country" as the identifier
human <- inner_join(gii, hd, by = "Country")

#saving the new data set to the "data" folder
write.csv(human, file = '~/Documents/Tohtoritutkinto/Open Science/IODS-project/data/human.csv')

##Continuing with the data wrangling

#look at the dimensions and structure of the new data set
dim(human)
str(human)

#The ´human´ data set has 19 variables with 195 observations. The data has been
#acquired from the UN's Human Developement reports. It is a combination of data
#from the Human Development Index (HDI) and Gender Inequality Index (GII) reports. The data
#shows several factors for each country that affect HDI and GII. We previously 
#createed two new variables that were ratios of two other factors. Going forward,
#we are interested in eight specific factors for each country. They are: ratio 
#of female and male populations with secondary education, ratio of labor force 
#participation of females and males, Life expectancy at birth, Expected years of
#schooling, Gross National Income per capita (GNI), Maternal mortality ratio,
#Adolescent birth rate and Percetange of female representatives in parliament.

# access the stringr package (part of `tidyverse`)
library(stringr)

#transform the GNI variable to numeric 
#(NOTE: it appears it was already numeric)
human$GNI <- as.numeric(human$GNI)

#select columns to keep
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

#exclude unneeded variables
human <- select(human, one_of(keep))

#filter out all rows with missing (NA) values
human <- filter(human, complete.cases(human))

#remove the observations which relate to regions instead of countries (last 7 rows)
# define the last indice we want to keep
last <- nrow(human) - 7

# choose everything until the last 7 observations
human <- human[1:last, ]

# change the human data set from tibble to data frame
human <- as.data.frame(human)

#define the row names of the data by the country names
rownames(human) <- human$Country

#remove the country name column from the data
human <- human[ , -1]

#save the new ´human´ data set by overwriting the old one in the "data" folder
write.csv(human, file = '~/Documents/Tohtoritutkinto/Open Science/IODS-project/data/human.csv')

