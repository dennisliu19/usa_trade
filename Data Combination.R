setwd("~/Desktop/Trade/USA Trade")
if(!("XLConnect" %in% installed.packages())){install.packages("XLConnect")}
if(!("rJava" %in% installed.packages())){install.packages("rJava")}

library(rJava)
library(XLConnect)

##Read Xlxs Workbook
for (i in 1996:2016) {
  x <- paste("wt",i, sep="")
  eval(call("<-", as.name(x), loadWorkbook(paste(i,"USA.xlsx",sep=""))))
}
##Read Sheet
for (i in 1996:2016) {
  x <- paste("USA",i, sep="")
  eval(call("<-", as.name(x), readWorksheet(eval(parse(text = paste("wt",i,sep=""))),
                                            sheet = "Partner",
                                            header = TRUE)))
}
##Colname check
all.equal(colnames(USA1996),colnames(USA1997),colnames(USA1998),colnames(USA1999),colnames(USA2000),colnames(USA2001),
           colnames(USA2002),colnames(USA2003),colnames(USA2004),colnames(USA2005),colnames(USA2006),colnames(USA2007),
           colnames(USA2008),colnames(USA2009),colnames(USA2010),colnames(USA2011),colnames(USA2012),colnames(USA2013),
           colnames(USA2014),colnames(USA2015),colnames(USA2016))
##Merge data

usatrade <- rbind(USA1996,USA1997,USA1998,USA1999,USA2000,USA2001,USA2002,USA2003,USA2004,
                  USA2005,USA2006,USA2007,USA2008,USA2009,USA2010,USA2011,USA2012,USA2013,
                  USA2014,USA2015,USA2016)
##Extract Data We Use
tradedata <- usatrade[,c(1,2,c(5:13),38)]
write.csv(tradedata,file="USATradeData.csv")
