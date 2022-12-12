path <- "fakepath/filename.csv"
ipo_index_month <- read.csv(path)

ipo_index_month[,"ipo_month"] <- as.Date(ipo_index_month[,"ipo_month"])
str(ipo_index_month)

idx <- ipo_index_month[, "ipo_month"]
ipo_index_month <- xts(ipo_index_month[,-1], order.by = idx)

path <- "fakepath/filename.csv"
avg_price_month <- read.csv(path)

avg_price_month[,"ipo_month"] <- as.Date(avg_price_month[,"ipo_month"])
str(avg_price_month)

idx <- avg_price_month[, "ipo_month"]
avg_price_month <- xts(avg_price_month[,-1], order.by = idx)


plot(avg_price_month[,"offer_price"])
plot(diff(avg_price_month[,"offer_price"]))
acf2(diff(avg_price_month[,"offer_price"]))

plot(ipo_index_month[,"total_proceeds"])
plot(diff(ipo_index_month[,"total_proceeds"]))
acf2(diff(ipo_index_month[,"total_proceeds"]))

fit <- auto.arima(ipo_index_month [,"total_proceeds"])
summary(fit)

fit2 <- auto.arima(avg_price_month [,"offer_price"])
summary(fit2)

fit %>% forecast(h=12) %>% autoplot()
fit2 %>% forecast(h=12) %>% autoplot()

checkresiduals(fit)
checkresiduals(fit2)
