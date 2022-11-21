#Mikko Hänninen
#21.11.2022
#This data cointains information on student performance in two Portuguese schools.
#acquired from https://archive.ics.uci.edu/ml/datasets/Student+Performance

#install required packages if needed
install.packages("tidyverse")
install.packages("boot")
install.packages("readr")
install.packages("dplyr")

#read the data into memory
math <- read.csv("~/Documents/Tohtoritutkinto/Open Science/IODS-project/data/student-mat.csv", sep = ";", header = TRUE)
por <- read.csv("~/Documents/Tohtoritutkinto/Open Science/IODS-project/data/student-por.csv", sep = ";", header = TRUE)

#exploring the dimensions of the data
dim(math)
dim(por)

#exploring the structure of the data
str(math)
str(por)

# access the dplyr package
library(dplyr)

# give the columns that vary in the two data sets
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")

# the rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(por), free_cols)

# join the two data sets by the selected identifiers
math_por <- inner_join(math, por, by = join_cols)

#exploring the dimensions and structure of the joined data set
dim(math_por)
str(math_por)

# creating a new data frame with only the joined columns
alc <- select(math_por, all_of(join_cols))

# getting rid of duplicate records in the joined data set
# for every column name not used for joining...
for(col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

# defining a new column alc_use by combining weekday and weekend alcohol use
# and taking the average of the answers
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# using 'alc_use' we define a new logical column 'high_use', which is TRUE
# for students for which 'alc_use' is greater than 2 and FALSE otherwise
alc <- mutate(alc, high_use = alc_use > 2)

# glimpse at the joined and modified data set
glimpse(alc)

# access the readr package
library(readr)

# saving the joined and modified data set to the 'data' folder
write_csv(alc, file = '~/Documents/Tohtoritutkinto/Open Science/IODS-project/data/alc.csv')
