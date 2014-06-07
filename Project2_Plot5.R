library(dplyr)
library(data.table)
library(ggplot2)

summary_SCC <- readRDS(file = "./data/summarySCC_PM25.rds")
summary_SCC_df = tbl_df(summary_SCC)

# Source Classification Code Table (Source_Classification_Code.rds): This table provides a mapping from 
# the SCC digit strings int he Emissions table to the actual name of the PM2.5 source. 
class_code <- readRDS(file = "./data/Source_Classification_Code.rds")
class_code_df <- tbl_df(class_code)


# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
# 

#Filter all vehicle class codes
vehicle_class <- class_code_df[grep("(V|v)ehicle", class_code_df$SCC.Level.Two),]

#Filter Baltimore city data
a1 <- select(filter(summary_SCC_df, fips == "24510"), SCC, year, Emissions)

summary_SCC_vehicle_baltimore <- inner_join(a1, vehicle_class, by = "SCC")

a2 <- group_by(summary_SCC_vehicle_baltimore, year)
a3 <- summarise(a2, totEmissions = sum(Emissions))

a4 <- ggplot(a3, aes(x=year, y = totEmissions)) + 
    geom_line(col = "steelblue") + geom_point(size=4, col = "steelblue", alpha=0.5)

a4 <- a4 + xlab("Years") + ylab(expression(paste("Total Emissions (", "PM"["2.5"], ")", sep = ""))) 

a4 <- a4 + ggtitle("Total Emissions from vehicles in Baltimore (1999 - 2008)")

dev.off()
png("Projet2_Plot5.png", width = 1000, height = 480)
a4
dev.off()