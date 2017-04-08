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

#Create the required linegraph
png(filename = "plot2.png", width = 480, height = 480, units = "px", bg = "transparent")
plot(Global_active_power ~ DateTime, data=dataTable, type="l", ylab = "Global Active Power (kilowatts)")
dev.off()