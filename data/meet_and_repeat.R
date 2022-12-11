#Mikko Hänninen
#9.12.2022
#data for Assignment 6

#read the data into memory
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

#look at the variables and structure of BPRS
names(BPRS)
str(BPRS)
summary(BPRS)

#There are 40 different observations and 11 different variables
#treatment - one of two treatment options for subject
#subject - identification number of subject
#week0 - brief psychiactic rating scale (BPRS) before treatment
#week1-8 - BPRS after each specified week of treatment

#look at the variables and structure of RATS
names(RATS)
str(RATS)
summary(RATS)

#There are 16 different observations and 13 different variables
#ID - identification number of test subject
#Group - group number of test subject
#WD1-64 - weight (grams) of the test subject for specified day

#Convert treatment and subject variables of BPRS to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

#Convert ID and Group variables of RATS to factors
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#Access the packages dplyr and tidyr
library(dplyr)
library(tidyr)

#Convert BPRS to long form
BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>% arrange(weeks)

#Add the week variable to BPRSL
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5, 5)))

#Convert RATS to long form and add the Time variable to it
RATSL <- pivot_longer(RATS, cols = -c(ID, Group), 
                      names_to = "WD", values_to = "Weight") %>% 
  mutate(Time = as.integer(substr(WD, 3, 4))) %>% arrange(Time)

#look at the variables and structure of BPRSL
names(BPRSL)
str(BPRSL)
summary(BPRSL)

#As we can see, there are now 360 different observations and 5 different variables.
#The difference to BPRS in BPRSL is now that every week is an individual value we 
#have that many more observations as before (number of subjects (40) * number of 
#weeks (9) = 360). It is now possible to evaluate the differences in the bprs 
#value between the treatment groups and the possible change of the value in time.

#look at the variables and structure of RATSL
names(RATSL)
str(RATSL)
summary(RATSL)

#There are 176 observations and 5 different variables in the RATSL data set.
#Similarly to BPRSL before, the difference between RATS and RATSL is that the
#days are now individual values instead of variables, which increases the number
#of observations (number of test subjects (16) * number of days (11) = 176).
#It is now possible to evaluate the differences in the weight of the test 
#subject between the groups and the possible change of the value in time.

#Save the BPRSL data set to the "data" folder
write.csv(BPRSL, file = '~/Documents/Tohtoritutkinto/Open Science/IODS-project/data/BPRSL.csv', row.names = FALSE)

#Save the RATSL data set to the "data" folder
write.csv(RATSL, file = '~/Documents/Tohtoritutkinto/Open Science/IODS-project/data/RATSL.csv', row.names = FALSE)
