setwd("~/Desktop/Trade/USA Trade")
if(!("XLConnect" %in% installed.packages())){install.packages("XLConnect")}
if(!("rJava" %in% installed.packages())){install.packages("rJava")}
if(!("dplyr" %in% installed.packages())){install.packages("dplyr")}
if(!("reshape" %in% installed.packages())){install.packages("reshape")}

library(rJava)
library(XLConnect)
library(dplyr)
library(reshape)

##Read Xlxs Workbook
for (i in 1991:2016) {
  x <- paste("wt",i, sep="")
  eval(call("<-", as.name(x), loadWorkbook(paste(i,"USA.xlsx",sep=""))))
}
##Read Sheet
for (i in 1991:2016) {
  x <- paste("USA",i, sep="")
  eval(call("<-", as.name(x), readWorksheet(eval(parse(text = paste("wt",i,sep=""))),
                                            sheet = "Partner",
                                            header = TRUE)))
}
##Colname check
all.equal(colnames(USA1991),colnames(USA1992),colnames(USA1993),colnames(USA1994),colnames(USA1995),
          colnames(USA1996),colnames(USA1997),colnames(USA1998),colnames(USA1999),colnames(USA2000),colnames(USA2001),
          colnames(USA2002),colnames(USA2003),colnames(USA2004),colnames(USA2005),colnames(USA2006),colnames(USA2007),
          colnames(USA2008),colnames(USA2009),colnames(USA2010),colnames(USA2011),colnames(USA2012),colnames(USA2013),
          colnames(USA2014),colnames(USA2015),colnames(USA2016))
##Merge data

usatrade <- rbind(USA1991,USA1992,USA1993,USA1994,USA1995,USA1996,USA1997,USA1998,USA1999,USA2000,USA2001,USA2002,USA2003,
                  USA2004,USA2005,USA2006,USA2007,USA2008,USA2009,USA2010,USA2011,USA2012,USA2013,USA2014,USA2015,USA2016)
##Extract Data We Use
tradedata <- usatrade[,c(1,2,3,c(5:13),38)]
write.csv(tradedata,file="USATradeData.csv")

##Add cate

#Keep Only Country Entry

country <- unique(usatrade$Partner.Name)
regionentry <- c("world","Fr. So. Ant. Tr","British Indian Ocean Ter.","East Asia & Pacific","Europe & Central Asia","Middle East & North Africa",
                 "Occ.Pal.Terr","Other Asia, nes","Pacific Islands","Reunion","South Asia","Sub-Saharan Africa","Unspecified")

usatrade <- usatrade[!(usatrade$Partner.Name %in% regionentry),]
continent <- read.csv("continent.csv")
countrylist <- as.data.frame(unique(usatrade$Partner.Name))
continent$Country <- as.character(continent$Country)
continent$Region <- as.character(continent$Region)
colnames(countrylist) <- "Country"
countrylist$Country <- as.character(countrylist$Country)
continent$Country <-  sapply(continent$Country,function(x){trimws(x,"r")})
temp <- left_join(countrylist,continent,by = "Country")
lackcont <- subset(temp,is.na(temp$Region))
#write.csv(lackcont,"continent2.csv")
continent2 <- read.csv("continent2.csv")
continent2$Country <- as.character(continent2$Country)
continent2$Region <- as.character(continent2$Region)
temp <- left_join(temp,continent2,by = "Country")
temp$Region <- coalesce(temp$Region.x,temp$Region.y)
temp <- cbind(temp$Country,temp$Region)
colnames(temp) <- c("Partner.Name","Region")
temp <- as.data.frame(temp)
temp$Partner.Name <- as.character(temp$Partner.Name)
temp$Region <- as.character(temp$Region)
#Combine country and region

regiontrade <- left_join(tradedata,temp,by="Partner.Name")

regiontrade <- regiontrade[,-c(1,4,5)]
##regiontrade is the latest clean dataset as of Nov.5 2018
colnames(regiontrade)

## Add GDP data

gdp <- read.csv("GDP.csv")
colnames(gdp) <- c("Partner.Name","1991","1992","1993","1994","1995","1996","1997","1998","1999",
                  "2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010",
                  "2011","2012","2013","2014","2015","2016","2017")
gdp$Partner.Name <- as.character(gdp$Partner.Name)
gdp <- melt(gdp,id="Partner.Name")
gdp$variable <- as.character(gdp$variable)
gdp$variable <- as.numeric(gdp$variable)
colnames(gdp) <- c("Partner.Name","Year","GDP")

gdptrade <- left_join(regiontrade,gdp,by=c("Partner.Name","Year"))
gdptrade <- gdptrade[!(is.na(gdptrade$Region)),]

write.csv(gdptrade,"gdptrade.csv")
##gdptrade is the latest clean dataset as of Nov. 8 2018(With gdp and region information)

### API Approach for accessing data

#install.packages("RJSDMX")
#library(RJSDMX)

#getCodes('ECB','EXR','FREQ')
#getFlows('ECB')
#getDimensions('ECB','EXR') 

