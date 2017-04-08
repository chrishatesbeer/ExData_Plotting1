#this script uses SQL select
require("sqldf")

dataFile <-"household_power_consumption.txt"
zipFile <- "household_power_consumption.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#if the data file doesn't exist, try to unzip it
if (!file.exists(dataFile)) {
  
  #if the zip file does not exist, download it
  if (!file.exists(zipFile)) {
    download.file(fileURL ,destfile=zipFile,method="auto")
  } 
  unzip(zipfile = zipFile)
}

#Read just the dates of interest to save on RAM
dataTable <- read.csv.sql(dataFile,sql = "select * from file WHERE date IN ('1/2/2007','2/2/2007')", header = TRUE, sep = ";")
  
#merge the date and time into a single field
dataTable$DateTime <- with(dataTable, as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S"))

#Create the required graphs
png(filename = "plot4.png", width = 480, height = 480, units = "px", bg = "transparent")

#Set up for 4 graphs (2x2)
par(mfrow=c(2,2))

#Global Active Power
plot(Global_active_power ~ DateTime, data=dataTable, type="l", ylab = "Global Active Power", xlab="")

#Voltage
plot(Voltage ~ DateTime, data=dataTable, type="l", ylab = "Voltage", xlab="datetime")

#Energy sub metering
plot(Sub_metering_1 ~ DateTime, data=dataTable, type="l", ylab = "Energy sub metering", xlab="")
lines(Sub_metering_2 ~ DateTime, data=dataTable, col="red")
lines(Sub_metering_3 ~ DateTime, data=dataTable, col="blue")
legend( x= "topright",legend=c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
        col=c("black", "red", "blue"), lty=1, bty = "n")

#Global Reactive Power
plot(Global_reactive_power ~ DateTime, data=dataTable, type="l", ylab = "Global_reactive_power", xlab="datetime")


dev.off()