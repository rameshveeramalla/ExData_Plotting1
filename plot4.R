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

#plot all 4 graphs as required
par(mfrow = c(2, 2))
with (exdata, {
	plot(exdata$"DateTime", exdata$"Global_active_power", type="l", xlab="", ylab="Global Active Power (kilowatts)")
	plot(exdata$"DateTime", exdata$"Voltage", type="l", xlab="datetime", ylab="Voltage")
	plot(exdata$"DateTime", exdata$"Sub_metering_1", type="l", xlab="", ylab="Energy sub metering")
	lines(exdata$"DateTime", exdata$"Sub_metering_2", col="red")
	lines(exdata$"DateTime", exdata$"Sub_metering_3", col="blue")
	legend("topright", col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),lty=c(1,1,1), bty="n", cex=0.6)
	plot(exdata$"DateTime", exdata$"Global_reactive_power", type="l", xlab="datetime", ylab="Global_reactive_power")
}
)

#copy plots to a PNG and close the device
dev.copy(png, file="Plot4.png")
dev.off()


