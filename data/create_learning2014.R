# Mikko Hänninen 14.11.2022 data for Assignment 2

#read the data into memory
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# using dim(learning2014) I learned there are 183 rows and 60 columns in this 
# data frame

# using str(learning2014) I learned that there are 60 variables with 183 
# observations each and that one variable is a character string, while the other 
# variables are integers

# Access the dplyr library
library(dplyr)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30",
                    "D06","D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29",
                       "SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20",
                         "ST28")

# create column 'deep' by averaging
learning2014$deep <- rowMeans(learning2014[, deep_questions])

# create column 'surf' by averaging
learning2014$surf <- rowMeans(learning2014[, surface_questions])

# create column 'stra' by averaging
learning2014$stra <- rowMeans(learning2014[, strategic_questions])

# exclude observations where exam points are zero
learning2014 <- filter(learning2014, Points > 0)

# create new dataset by choosing which columns/variables to keep from 
# learning2014 in it
student2014 <- learning2014[, c("gender","Age","Attitude", "deep", "stra", 
                                 "surf", "Points")]

# change the name of "Age" to "age"
colnames(student2014)[2] <- "age"

# change the name of "Attitude" to "attitude"
colnames(student2014)[3] <- "attitude"

# change the name of "Points" to "points"
colnames(student2014)[7] <- "points"

# check to see that data has correct amount of observations and variables
str(student2014)

# saving dataset to the 'data' folder
write.csv(student2014, file = '~/Documents/Tohtoritutkinto/Open Science/IODS-project/data/learning2014.csv',
          row.names = FALSE)

# reading data again from file
read_data <- read_csv("~/Documents/Tohtoritutkinto/Open Science/IODS-project/data/learning2014.csv")

# check the structure of data is correct
str(read_data)
head(read_data)