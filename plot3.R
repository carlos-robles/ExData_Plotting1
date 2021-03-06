# PLOT 3
# Reading data

data <- read.delim("household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?", colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))

#Transform date column into date format
data <- mutate(Date = dmy(Date), data)
str(data)

#Filter data for days between 1st Feb 2007 to 2nd Feb 2007
data <- filter(data, (Date >= "2007-02-01" & Date <= "2007-02-02"))
str(data)

# Delete NAs = ?
data <- data[complete.cases(data), ]
str(data)

# Extract Date and Time columns to join them
dateTime <- paste(data$Date, data$Time)
dateTime <- setNames(dateTime, "DateTime")

# Add dateTime column to data frame

data <- select(data, c("Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
data <- mutate(dateTime = dateTime, data)
data <- data %>% select(dateTime, everything())

# Convert dateTime column into dateTime format

data <- data %>% mutate(dateTime = as.POSIXct(dateTime))
data1 <- data %>% mutate(dateTime = strptime(dateTime, format = "%Y-%m-%d %H:%M:%S"))

### Graph 3
png(file = "plot3.png", width = 480, height = 480, units = "px")
with(data, plot(dateTime, Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "n"))
lines(data$dateTime, data$Sub_metering_1, col = "black")
lines(data$dateTime, data$Sub_metering_2, col = "red")
lines(data$dateTime, data$Sub_metering_3, col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()
