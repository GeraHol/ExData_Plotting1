#script to download data on electric use in households, reproduce plots part of Coursera assignment wk1 "Exploratory Data Analysis"

##always start with a clean slate
rm(list=ls())

# necessary steps
# 0. Download data and read into R
# 1. Reproduce plot 4: 4 line graphs 
# 2. Save as png file

# step 0
fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

library(downloader)
download(fileUrl, dest="dataset.zip", mode="wb") 

#provides data and time of download
dataDownloaded<-Sys.time() 

#create directory data, if it did not exist already
if (!file.exists("data")){        
  dir.create("data")
}

#extract files, these are the raw data, write to directory data
unzip ("dataset.zip", exdir = "./data") 

#get an overview of the files
list.files("./data/") 

#read in the file, need separator ; else you get one long list of data
#only load the rows for Feb 1 and 2 2007; hence skip the first 66637 rows and keep the next 2880 rows
household_power_consumption<-read.table("./data/household_power_consumption.txt", 
                                        skip=66637,nrows=2880,
                                        header=F, stringsAsFactors=FALSE, sep = ";")

#change the class of Date from factor into a proper date format
Date<-as.Date(household_power_consumption[,1], format = "%d/%m/%Y")

#change the class of Time from factor into a proper Time format, combined with the right date
Time<-strptime(household_power_consumption[,2], format = "%H:%M:%S")
datetime<-paste(Date, household_power_consumption[,2])
strptime(datetime, "%Y-%m-%d %H:%M:%S")
datetime<-as.Date(datetime)
newdataframe<-cbind(datetime, household_power_consumption[,3:9])

#Step 1 create 4 plots with lines against 3 specific days

#first create room for 4 plots
par(mfrow = c(2,2))


#draw plot 1: global active power against time
plot(newdataframe$V3, xaxt="n", xlab= "", ylab = "Global Active Power", type="n")
#add the global active power data as a line
lines(newdataframe$V3)
#add the labels of the x axis
axis(side=1, at=c(1,1440,2880), labels = c("Thu","Fri","Sat")) 

#draw plot 2: voltage against time
plot(newdataframe$V5, xaxt="n", xlab= "datetime", ylab = "Voltage", type="n")
#add the global active power data as a line
lines(newdataframe$V5)
#add the labels of the x axis
axis(side=1, at=c(1,1440,2880), labels = c("Thu","Fri","Sat")) 

#draw plot 3: the submeter values against time
#first plot empty, with y label
plot(newdataframe$V7, xaxt="n", xlab= "", ylab = "Energy sub metering", type="n")

#add the sub meter data as lines
lines(newdataframe$V7, col="black")
lines(newdataframe$V8, col="red")
lines(newdataframe$V9, col="blue")

#add the labels of the x axis
axis(side=1, at=c(1,1440,2880), labels = c("Thu","Fri","Sat")) 

#add a legend to the topright
legend("topright", lwd=2, col=c("black","red","blue"), 
       cex = 0.8,
       bty = "n",
       legend=c("Sub_metering_1",
                "Sub_metering_2",
                "Sub_metering_3"))

#draw plot 4: global reactive power against time
plot(newdataframe$V4, xaxt="n", xlab= "datetime", ylab = "Global_reactive_power", type="n")
#add the global active power data as a line
lines(newdataframe$V4)
#add the labels of the x axis
axis(side=1, at=c(1,1440,2880), labels = c("Thu","Fri","Sat")) 

# step 2 copy to png file called plot.png and define pixels
dev.copy(png, "plot4.png", width = 480, height = 480) 

#always close graphics device
dev.off() 

