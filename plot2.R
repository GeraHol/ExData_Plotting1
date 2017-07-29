#script to download data on electric use in households, reproduce plots part of Coursera assignment wk1 "Exploratory Data Analysis"

##always start with a clean slate
rm(list=ls())

# necessary steps
# 0. Download data and read into R
# 1. Reproduce plot 2: linegraph of global active power over time
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

#Step 1 plot Global Active Power against time, label time as days
#first plot empty, with y label
plot(newdataframe$V3, xaxt="n", xlab= "", ylab = "Global Active Power (kilowatts)", type="n")
#add the global active power data as a line
lines(newdataframe$V3)
#add the labels of the x axis
axis(side=1, at=c(1,1440,2880), labels = c("Thu","Fri","Sat")) 


# step 2 copy to png file called plot.png and define pixels
dev.copy(png, "plot2.png", width = 480, height = 480) 

#always close graphics device
dev.off() 

