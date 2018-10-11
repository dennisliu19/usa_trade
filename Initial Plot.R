setwd("~/Desktop/Trade/USA Trade")
library(ggplot2)



tradedata <- read.csv("USATradeData.csv")
tradedata$Reporter.Name <- as.character(tradedata$Reporter.Name)
tradedata$Partner.Name <- as.character(tradedata$Partner.Name)
