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

# CONVERT DATE (YMD) TO SEPERATE COLUMNS 

# first make sure the date is indeed a date
CPI$DATE <- as.Date(CPI$DATE)

library(lubridate)
CPI <- CPI %>% 
  dplyr::mutate(YEAR = lubridate::year(DATE), 
                MONTH = lubridate::month(DATE), 
                DAY = lubridate::day(DATE))

# DROP THE FULL DATE
CPI.YMD <- CPI[, -c(1)]

# REARRANGE COLUMNS
CPI.YMD <- CPI.YMD[, c(3,4,5,1,2)]
head(CPI.YMD)


# CREATE A YEAR ONLY DATASET----

# How to extract the year and convert to numeric format
#CPI$YEAR <- as.numeric(format(CPI$DATE, "%Y"))   # can skip this step. this step creates column "YEAR"

# DROP MONTH AND DAY  
CPI.YEAR <- CPI.YMD[, -c(2,3)]
head(CPI.YEAR)
summary(CPI.YEAR)

# SIDE NOTE* 
# This code will sum a column(e.i. 'housing') by year
# aggregate(CPI.YEAR$HOUSING, by=list(year=CPI.YEAR$YEAR), FUN=sum)


# BASIC PLOTS
hist(CPI.YEAR$FT.VG)
hist(CPI.YEAR$HOUSING)

install.packages("GGally")
library(GGally)
ggpairs(CPI.YEAR[,]) 

# all predictors are strongly correlated

install.packages("hrbrthemes")
library(hrbrthemes)
library(kableExtra)
options(knitr.table.format = "html")
library(streamgraph)
library(viridis)
library(DT)
library(plotly)

# LINE CHART
ggplot(CPI.YMD, aes(x=YEAR, y= FT.VG, group= as.factor(MONTH), color=as.factor(MONTH))) +
  geom_line() +
  scale_color_viridis(discrete = TRUE) +
  theme(
    legend.position="none",
    plot.title = element_text(size=14)
  ) +
  ggtitle("CPI of FRUITS & VEGGIES") +
  theme_ipsum()



