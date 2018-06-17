library("dplyr")
# set working directory to the location where household_power_consumption.txt is present

# read the file into exdata - only the data for 1/2/2007 and 2/2/2007 are read
class <- c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric")
exdata <- read.table("household_power_consumption.txt",sep=";", skip=grep("1/2/2007", readLines("household_power_consumption.txt"))-1, nrows=2880, colClasses=class)

# name the columns based on the first row of the input file
exdata_colnames <- read.table("household_power_consumption.txt",sep=";", header=TRUE, nrows=1)
colnames(exdata) <- colnames(exdata_colnames)

# create a new column combining Data and Time fields using mutate function and convert it into POSIXlt class
exdata<-mutate(exdata, DateTime = paste(exdata[,1], exdata[,2]))
exdata[, "DateTime"] <- lapply(exdata["DateTime"], function(x){strptime(x, "%d/%m/%Y %H:%M:%S")})

# plot histogram and label as required
hist(exdata$"Global_active_power", col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")

# copy plot to a PNG file and close the device
dev.copy(png, file="Plot1.png")
dev.off()
