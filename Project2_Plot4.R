library(dplyr)
library(data.table)
library(ggplot2)

summary_SCC <- readRDS(file = "./data/summarySCC_PM25.rds")
summary_SCC_df = tbl_df(summary_SCC)

# Source Classification Code Table (Source_Classification_Code.rds): This table provides a mapping from 
# the SCC digit strings int he Emissions table to the actual name of the PM2.5 source. 
class_code <- readRDS(file = "./data/Source_Classification_Code.rds")
class_code_df <- tbl_df(class_code)

#Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?


#Names which are unique to coal combustion related sources
coal_class <- class_code_df[grep("\\b(C|c)oal\\b", class_code_df$SCC.Level.Three),]

#Change SCC into factors 
summary_SCC_df$SCC <- as.factor(summary_SCC_df$SCC)

#InnerJoin Emissions table with coal class code table
summary_SCC_coal <- inner_join(summary_SCC_df, coal_class, by = "SCC")

a1 <- group_by(summary_SCC_coal, year)
a2 <- summarise(a1, totEmissions = sum(Emissions))

a3 <- ggplot(a2, aes(x=year, y = totEmissions)) + 
    geom_line(col = "steelblue") + geom_point(size=4, col = "steelblue", alpha=0.5)

a3 <- a3 + xlab("Years") + ylab(expression(paste("Total Emissions (", "PM"["2.5"], ")", sep = ""))) 

a3 <- a3 + ggtitle("Total Emissions from coal combustion-related sources (1999 - 2008)")

dev.off()
png("Project2_Plot4.png", width = 1000, height = 480)
print(a3)
dev.off()
