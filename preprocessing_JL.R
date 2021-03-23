### MYRIAD COVID Follow-up: Data preprocessing
### Script by Jovita Leung 

rm(list = ls())

## Load libraries---
library(dplyr)
library(lubridate) #format date
library(car)
library(ggplot2)

## Import data --- 
d=read.csv("~/Dropbox/MYRIAD Data/R_analysis/intervention analysis/covid_analysis/myriad_covid_raw_age.csv")
d=d[-1,]

demo=subset(d, select = c("subjno","gender","age","dob"))
demo[c("subjno","gender","age")]=lapply(demo[c("subjno","gender","age")], as.numeric)
demo$dob=as.Date(as.character(parse_date_time(demo$dob, orders="dmY")))
summary(demo)
str(demo)

c=subset(d,select = c("subjno","Q84","Q85","Q86")) #compliance to COVID measures (social distancing, mask wearing, preventive measures)
c[c("subjno","Q84","Q85","Q86")]=lapply(c[c("subjno","Q84","Q85","Q86")], as.numeric) #1=not at all compliant, 5=completely
summary(c)
names(c)=c("subjno","comply_distance","comply_mask","comply_prev")

s=read.csv("~/Dropbox/MYRIAD Data/R_analysis/intervention analysis/SI analysis/all_data_2021.csv")
si=subset(s, select = c("subjno","session","delta_rating","R2R1diff","abs.R2R1diff","intervention","sdq_pro_sum"))
summary(si)
si_t1=subset(si,si$session==1)
si_t2=subset(si,si$session==2)

covid=merge(demo,c, by="subjno")
covid1=merge(covid,si_t1, by="subjno")
summary(covid1)

options(scipen = 999) #convert scientific notation to decimal



## Correlations: SDQ & COVID ---
cor.test(covid1$sdq_pro_sum,covid1$comply_distance) #Yes. r = 0.14, p < .001
cor.test(covid1$sdq_pro_sum,covid1$comply_mask)#Yes. r = 0.05, p = .002
cor.test(covid1$sdq_pro_sum,covid1$comply_prev) #Yes. r = 0.19, p < .001

## Correlations: R2R1diff at T1 & COVID --- 
cor.test(covid1$abs.R2R1diff,covid1$comply_distance) #Yes. r = -0.06, p < .001
cor.test(covid1$abs.R2R1diff,covid1$comply_mask) #No. p = .574
cor.test(covid1$abs.R2R1diff,covid1$comply_prev) #No. p = .226

ggplot(covid1, aes(x=comply_distance, y=sdq_pro_sum))+geom_point()+geom_smooth(method = 'lm')+theme_classic()
