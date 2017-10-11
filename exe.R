library(dplyr)
library(data.table)
library(lubridate)
source("update_usd.R")

a <- update_usd(if_update = TRUE)
a

x <- paste(a$all[,3], a$all[,4]) %>% as.POSIXct()
y <- a$all[,1]

plot(x, y)

# lo.model <- loess(y ~ as.numeric(x), data)
# lines(x, lo.model$fitted, col = "blue")
kern <- ksmooth(x %>% as.numeric(), y, kernel = "normal", bandwidth = 20000)
lines(kern, col = "blue")
