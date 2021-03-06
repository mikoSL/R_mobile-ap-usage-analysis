# data exploration and visualization

library(readr)
library(dplyr)
library(ggplot2)
library(ggExtra)
library(scales)


#load data
apph <- read_csv("E:/Data/validUserDataforAnalysis/exported_fromR_app_history.csv")

# summarize number of record each user has every day
user_daily_record <- apph %>% dplyr::select(d_id,sdate,tduration) %>% group_by(d_id, sdate) %>% dplyr::summarize(records = sum(tduration)) %>% arrange(d_id,desc(records))

#sum of duration is too long. Devide it by 100
user_daily_record$records <- user_daily_record$records/100

t <- user_daily_record %>% filter(sdate == '2016-10-2') 

#summarize number of record each user has. number of day each user is active.
#total_records--> total app record, 
#nday --> number of days the user is active.

user_record <- user_daily_record %>% group_by(d_id) %>% dplyr::summarize(total_records = sum(records), nday = n()) %>% arrange(desc(total_records))

#day plot (good plot)
#order d_id first.
user_record$d_id <- factor(user_record$d_id,levels = user_record$d_id[order(user_record$nday)])
g_user_day_record <- 
  ggplot(user_record, aes(d_id, nday)) +
  geom_bar(stat = 'identity',fill = 'steelblue') +
  theme_minimal() +
  coord_flip() +
  labs(title = 'Devices active days')
g_user_day_record

#plot (second )
user_record$total_records <- log(user_record$total_records)
user_record$d_id <- factor(user_record$d_id,levels = user_record$d_id[order(user_record$total_records)])
g_user_time_record <- 
  ggplot(user_record, aes(d_id, total_records)) +
  geom_bar(stat = 'identity',fill = 'steelblue') +
  theme_minimal() +
  coord_flip() +
  labs(title = 'Devices active days')
g_user_time_record

#summarize number of record each day has.
date_record <- user_daily_record %>% group_by(sdate) %>% dplyr::summarize(user_record = n(), app_record = sum(records)) %>% arrange(sdate)

#plot (good plot, showing app record in each day)
theme_set(theme_classic())
g_date_record <- ggplot(date_record,aes(x = sdate)) +
  geom_line(aes(y = app_record)) +
  labs(titel = 'Time Series Chart',
       subtitle = 'App record in each day')
g_date_record

#summarize different app usage
app_daily_record <- apph %>% group_by(d_id,sdate,sweekday,shour,app_name_en,app_category) %>% dplyr::summarize(app_record = n())


#summarize the total users for each app
app_user <- app_daily_record %>% group_by(d_id, app_name_en) %>% dplyr::summarize(n())

number_user_app <- app_user %>% group_by(app_name_en) %>% dplyr::summarize(number_of_users = n()) %>% arrange(number_of_users)

percentage_app <- number_user_app %>% group_by(number_of_users) %>% dplyr::summarize(app = n())


#plot the app categrory hourly distribution (good plot)
theme_set(theme_bw())
g_hour_app <- ggplot(hour_app2,aes(shour,app_recod, fill = as.factor(app_name_en) )) + 
  geom_bar(stat = 'identity') +
  labs(title = 'App hourly record ',
       xlab = 'Hours',
       label = 'App')

g_hour_app

#summarize the active hours of each app category
hour_app_ca <- app_daily_record %>% group_by(app_category, shour) %>% dplyr::summarize(app_record = sum(app_record)) %>% arrange(desc(app_record))

wac <- c('Utilities','Productivity','Entertainment','Shopping','Music','Weather','Photo & Video')

hour_app_ca2 <- hour_app_ca %>% filter(app_category %in% wac)

#plot the app categrory hourly distribution (good plot)
theme_set(theme_bw())
g_hour_app_ca <- ggplot(hour_app_ca2,aes(shour,app_record, fill = as.factor(app_category) )) + 
  geom_bar(stat = 'identity') +
  labs(title = 'App category hourly record ',
       xlab = 'Hours',
       label = 'App category')

g_hour_app_ca