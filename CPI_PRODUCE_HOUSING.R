install.packages("tidyverse")
library(tidyverse)
library(plyr)
library(dplyr)
library(ggplot2)
install.packages("skimr")
library(stats)

CPI_Fruits_Veggies = read.csv("C:/Users/snfra/OneDrive/Documents/RAW DATA/CPI_Fruits_Veggies.csv",header = TRUE, sep = ",")

CPI_House = read.csv("C:/Users/snfra/OneDrive/Documents/RAW DATA/CPI_Housing.csv",header = TRUE, sep = ",")

dim(CPI_House)
dim(CPI_Fruits_Veggies)
summary(CPI_House)
summary(CPI_Fruits_Veggies)
skimr::skim(CPI_House)
skimr::skim(CPI_Fruits_Veggies)


# COMBINE THE DATASETS 
CPI <- merge(CPI_Fruits_Veggies, CPI_House, all = TRUE)

# RENAME COLUMNS
CPI <- plyr::rename(CPI, c("CUSR0000SAF113"= "FT.VG",
                           "CPIHOSNS"= "HOUSING"))

colnames(CPI)
any(is.na(CPI))

# CREATE A YEAR ONLY DATASET----
# make sure the date is indeed a date
CPI$DATE <- as.Date(CPI$DATE)

# extract the year and convert to numeric format
CPI$YEAR <- as.numeric(format(CPI$DATE, "%Y"))

# DROP THE FULL DATE TO CREATE DATASET BY YEAR 
CPI.YEAR <- CPI[, -c(1)]
head(CPI.YEAR)




# SIDE NOTE* 
# This code will sum a column(e.i. 'housing') by year
# aggregate(CPI.YEAR$HOUSING, by=list(year=CPI.YEAR$YEAR), FUN=sum)

# spot check for quality; yes, showing the year
head(CPI)

CPI.YEAR <- 

  
# CONVERT DATE (YMD) TO SEPERATE COLUMNS