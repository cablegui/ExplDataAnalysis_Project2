
library(dplyr)
library(data.table)


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
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.

a1 <- select(filter(summary_SCC_df, fips=="24510"), year, Emissions)
a2 <- group_by(a1, year)
a3 <- summarise(a2, totEmissions = sum(Emissions))
dev.off()

png("Project2_plot2.png", width = 480, height = 480)
plot(a3, type = "n",
     main = "Total Emissions in Baltimore (1999 - 2008)",
     xlab = "Years",
     ylab = expression(paste("Total Emissions (", "PM"["2.5"], ")", sep = "")))

lines(a3, lty = 2, col = "limegreen",lwd = 2)

points(a3, pch = 16, col = "darkgreen")

dev.off()