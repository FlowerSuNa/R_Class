ad <- read.csv("Ad/train_sample.csv", na.strings=c("NA",""))
adT <- ad

head(ad)
names(ad)


library(ggplot2)
library(ggthemes)

gg <- ggplot(data=ad, aes(x=is_attributed))
gb <- geom_bar()
th <- theme_wsj()

gg + gb + th

sapply(ad[,c(2:5,8)], table)


ad$click_time <- as.POSIXlt(ad$click_time)
ad$click_year <- ad$click_time$year+1900
ad$click_month <- ad$click_time$mon+1
ad$click_mday <- ad$click_time$mday+1
ad$click_hour <- ad$click_time$hour
ad$click_min <- ad$click_time$min
ad$click_wday <- ad$click_time$wday

table(ad$click_year)
table(ad$click_month)
table(ad$click_mday)
table(ad$click_hour)
table(ad$click_min)
table(ad$click_wday)

ggplot(data=ad, aes(x=click_hour)) +
  geom_bar()


ad$attributed_time <- as.POSIXlt(ad$attributed_time)
ad$attr_hour <- ad$attributed_time$hour
ad$attr_min <- ad$attributed_time$min

table(ad$attr_hour)
table(ad$attr_min)

ggplot(data=ad, aes(x=attr_hour)) +
  geom_bar()
