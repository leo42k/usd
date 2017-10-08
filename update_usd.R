library(dplyr)
library(data.table)

update_usd <- function(if_update = FALSE) {
    thepage = readLines('http://www.boc.cn/sourcedb/whpj/')
    anchor <- grep("美元", thepage)[length(grep("美元", thepage))]
    sell_price <- substr(thepage[anchor + 3], 
                     gregexpr("<td>", thepage[anchor + 3])[[1]][1] + 4, 
                     gregexpr("</td>", thepage[anchor + 3])[[1]][1] - 1) %>% as.numeric()
    price <- substr(thepage[anchor + 5], 
                     gregexpr("<td>", thepage[anchor + 5])[[1]][1] + 4, 
                     gregexpr("</td>", thepage[anchor + 5])[[1]][1] - 1) %>% as.numeric()
    date <- substr(thepage[anchor + 6], 
                gregexpr("<td>", thepage[anchor + 6])[[1]][1] + 4, 
                gregexpr("</td>", thepage[anchor + 6])[[1]][1] - 1) %>% as.Date()
    time <- substr(thepage[anchor + 7], 
               gregexpr("<td>", thepage[anchor + 7])[[1]][1] + 4, 
               gregexpr("</td>", thepage[anchor + 7])[[1]][1] - 1) %>% as.ITime()
    current <- data.frame(sell_price, price, date, time)
    if (if_update) {
        old <- readRDS("record.rds")
        update <- rbind(current, old) %>% unique
        saveRDS(update, "record.rds")
        return(list(latest = current, all = update))
    } else return(current)
}


update_usd(if_update = TRUE)