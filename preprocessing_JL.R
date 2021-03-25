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

s=read.csv("~/Dropbox/MYRIAD Data/R_analysis/intervention analysis/SI analysis/all_data_2021.csv")
s$X=NULL
# si=subset(s, select = c("subjno","session","delta_rating","R2R1diff","abs.R2R1diff","intervention","sdq_pro_sum"))
# summary(si)
t1=subset(s,s$session==1)
t2=subset(s,s$session==2)


## Data extraction --- 
# Extract demographics 
demo=subset(d, select = c("subjno","gender","age","dob"))
demo[c("subjno","gender","age")]=lapply(demo[c("subjno","gender","age")], as.numeric)
demo[c("subjno","gender")]=lapply(demo[c("subjno","gender")], factor)
demo$dob=as.Date(as.character(parse_date_time(demo$dob, orders="dmY")))
summary(demo)
str(demo)

# Extract relevant covid questions
covid=subset(d,select = c("subjno","Q84","Q85","Q86",
                      "Q78","Q79","support_change_1","support_change_2","support_change_3","support_change_4","support_change_5")) 
covid=as.data.frame(sapply(covid,as.numeric))
colnames(covid)=c("subjno","comply_distance","comply_mask","comply_prev",
           "connect_friends","support_friends",
           "change_support_friends","change_support_fam","share_feel_friends","share_feel_fam","care_feel")
fact=c("subjno","comply_distance","comply_mask","comply_prev","connect_friends","support_friends")
covid[fact]=lapply(covid[fact], factor)
summary(covid)


## Merge data --- 
covid_all=merge(demo,covid, by="subjno")
si_covid_t1=merge(t1, covid_all, by="subjno")
si_covid_t2=merge(t2, covid_all, by="subjno")

## Saving CSVs ---
write.csv(covid_all, file = "~/Dropbox/MYRIAD Data/R_analysis/intervention analysis/covid_analysis/covid_demo.csv")
write.csv(si_covid_t1, file = "~/Dropbox/MYRIAD Data/R_analysis/intervention analysis/covid_analysis/si_covid_t1.csv")
write.csv(si_covid_t2, file = "~/Dropbox/MYRIAD Data/R_analysis/intervention analysis/covid_analysis/si_covid_t2.csv")


