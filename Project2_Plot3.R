
library(dplyr)
library(data.table)
library(ggplot2)

setwd("D:\\COURSERA\\DataSCientist\\Course4ExploratoryDataAnalysis")

# Load PM2.5 Emissions Data
# fips: A five-digit number (represented as a string) indicating the U.S. county
# 
# SCC: The name of the source as indicated by a digit string (see source code classification table)
# 
# Pollutant: A string indicating the pollutant
# 
# Emissions: Amount of PM2.5 emitted, in tons
# 
# type: The type of source (point, non-point, on-road, or non-road)
# 
# year: The year of emissions recorded

summary_SCC <- readRDS(file = "./data/summarySCC_PM25.rds")
summary_SCC_df = tbl_df(summary_SCC)
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.

a1 <- select(filter(summary_SCC_df, fips == "24510"), type, year, Emissions)
a2 <- group_by(a1, type, year)
a3 <- summarise(a2, totEmissions = sum(Emissions))

#Base plot of requirements
a4 <- ggplot(a3, aes(x=year, y = totEmissions, colour = type)) + geom_line() + geom_point(size=4) 

#Change axis labels
a4 <- a4 + xlab("Years") + ylab(expression(paste("Total Emissions (", "PM"["2.5"], ")", sep = ""))) 

#Add title
a4 <- a4 + ggtitle("Total Emissions in Baltimore from 1999 - 2008 per type")

dev.off()

png("Project2_Plot3.png", width = 480, height = 480)

print(a4)

dev.off()
