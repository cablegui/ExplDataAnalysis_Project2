library(dplyr)
library(data.table)
library(ggplot2)

summary_SCC <- readRDS(file = "./data/summarySCC_PM25.rds")
summary_SCC_df = tbl_df(summary_SCC)

# Source Classification Code Table (Source_Classification_Code.rds): This table provides a mapping from 
# the SCC digit strings int he Emissions table to the actual name of the PM2.5 source. 
class_code <- readRDS(file = "./data/Source_Classification_Code.rds")
class_code_df <- tbl_df(class_code)


# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
# vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

#Filter Baltimore and Los Angeles County city data
a1 <- select(filter(summary_SCC_df, fips == "24510" | fips == "06037"), fips, SCC, year, Emissions)
a1$fips[which(a1$fips == "24510")] <- "Baltimore City" # Replace codes with sensible names of the cities
a1$fips[which(a1$fips == "06037")] <- "Los Angeles County"

#Filter all vehicle class codes
vehicle_class <- class_code_df[grep("(V|v)ehicle", class_code_df$SCC.Level.Two),]

summary_SCC_vehicle_baltimore <- inner_join(a1, vehicle_class, by = "SCC")

a2 <- group_by(summary_SCC_vehicle_baltimore, fips, year)
a3 <- summarise(a2, totEmissions = sum(Emissions))

a4 <- ggplot(a3, aes(x=year, y = totEmissions, colour = fips)) + 
    geom_line() + geom_point(size=4, alpha=0.5)

a4 <- a4 + scale_colour_manual(values = c("red","blue"))

a4 <- a4 + xlab("Years") + ylab(expression(paste("Total Emissions (", "PM"["2.5"], ")", sep = ""))) 

a4 <- a4 + ggtitle("Total Emissions from vehicles in Baltimore (1999 - 2008)")

dev.off()
png("Project2_Plot6.png", width = 1000, height = 480)
a4
dev.off()
