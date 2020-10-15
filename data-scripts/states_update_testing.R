#Last Update: 1014

library(dplyr)
library(ggplot2)
library(sf)

#states_update <- st_read("~/Documents/GitHub/lqycovid/docs/states_update.geojson")

#data <- read.csv("https://api.covidtracking.com/v1/states/daily.csv") %>% mutate(posposc = positive - positiveCasesViral) %>%
#  select(date, positiveIncrease, totalTestResultsIncrease) %>% mutate(posrate = positiveIncrease/totalTestResultsIncrease) %>%
  
#plot(data$posrate)

#data_ms <- read.csv("https://api.covidtracking.com/v1/states/ms/daily.csv") %>% mutate(posposc = positive - positiveCasesViral) %>%
#  select(date, positiveIncrease, totalTestResultsIncrease) %>% mutate(posrate = positiveIncrease/totalTestResultsIncrease)
#plot(data_ms$posrate)

#Use positiveCasesViral as positive test results.
#data_ok <- read.csv("https://api.covidtracking.com/v1/states/ok/daily.csv") %>% mutate(posposc = positive - positiveCasesViral) %>%
#  select(date, positiveIncrease, totalTestResultsIncrease) %>% mutate(posrate = positiveIncrease/totalTestResultsIncrease)
#plot(data_ok$posrate)

#data_tx <- read.csv("https://api.covidtracking.com/v1/states/tx/daily.csv") %>% mutate(posposc = positive - positiveCasesViral) %>%
#  select(date, positiveIncrease, totalTestResultsIncrease) %>% mutate(posrate = positiveIncrease/totalTestResultsIncrease)
#plot(data_ms$posrate)

#data_pr <- read.csv("https://api.covidtracking.com/v1/states/pr/daily.csv") %>% mutate(posposc = positive - positiveCasesViral) %>%
#  select(date, positiveIncrease, totalTestResultsIncrease) %>% mutate(posrate = positiveIncrease/totalTestResultsIncrease)
#plot(data_ms$posrate)

### Old Calculation
#old_calc <- read.csv("~/Desktop/old_calc.csv") 

### New Calculation Files
new_pos <- read.csv("~/Documents/GitHub/covid-atlas-research/Testing_Data/python/state_testing_positive.csv")
new_num <- read.csv("~/Documents/GitHub/covid-atlas-research/Testing_Data/python/state_testing_numbers.csv")

# Rename Columns
nc <- ncol(new_num)
for (i in 3:nc) {
  names(new_num)[i] <- 
    paste("t", substr(names(new_num)[i], 2, 5), "-",
          substr(names(new_num)[i], 6, 7), "-",
          substr(names(new_num)[i], 8, 9), sep = "")
}

new_num[,3:nc][is.na(new_num[,3:nc])] <- -1  

nc <- ncol(new_pos)
for (i in 3:nc) {
  names(new_pos)[i] <- 
    paste("pos", substr(names(new_pos)[i], 2, 5), "-",
          substr(names(new_pos)[i], 6, 7), "-",
          substr(names(new_pos)[i], 8, 9), sep = "")
}

new_pos[,3:nc][is.na(new_pos[,3:nc])] <- -1
new_pos$"pos2020-01-21" <- -1
new_pos$"pos2020-01-24" <- -1
new_pos$"pos2020-01-26" <- -1
new_pos$"pos2020-01-30" <- -1
new_pos$"pos2020-01-31" <- -1
new_num <- new_num%>%select(-criteria)
new_num$"t2020-01-21" <- -1
new_num$"t2020-01-24" <- -1
new_num$"t2020-01-26" <- -1
new_num$"t2020-01-30" <- -1
new_num$"t2020-01-31" <- -1


states_update <- as.data.frame(st_read("~/Documents/GitHub/lqycovid/docs/states_update_processing.geojson"))
for (i in 17:264) {#update this number every day
  names(states_update)[i] <- 
    paste(substr(names(states_update)[i], 2, 5), "-",
          substr(names(states_update)[i], 7, 8), "-",
          substr(names(states_update)[i], 10, 11), sep = "")
}

for (i in 265:(ncol(states_update)-3)) {#update this number every day 254-17+255
  names(states_update)[i] <- 
    paste("d", substr(names(states_update)[i], 2, 5), "-",
          substr(names(states_update)[i], 7, 8), "-",
          substr(names(states_update)[i], 10, 11), sep = "")
}

states_update <- left_join(states_update, new_pos, by = c("STUSPS"="state"))
states_update <- left_join(states_update, new_num, by = c("STUSPS"="state"))


# old calc positivity(7dMA)
colstart <- ncol(states_update)
for (i in 1:243){ #+1 everyday
  den <- names(states_update)[21+i]
  for (j in 1:56){
    if (states_update[j,paste("t", den, sep = "")]==-1) {
      states_update[j,colstart+i] <- -1
    } else {
      svn_den <- as.character(as.Date(den)-7)
      sx_den <- as.character(as.Date(den)-6)
      if  (states_update[j,paste("t", svn_den, sep = "")]==-1 | 
           is.null(states_update[j,sx_den]) |
           states_update[j,paste("t",den, sep = "")]-states_update[j,paste("t",svn_den, sep = "")] <= 0){
        states_update[j, colstart+i] <- -1
      } else {
        cases <- 0
        for (k in which(colnames(states_update)==sx_den) : which(colnames(states_update)==den)){
          cases <- cases + states_update[j, k]
        }
        states_update[j, colstart+i] <- cases/
          (states_update[j,paste("t",den, sep = "")]-states_update[j,paste("t",svn_den, sep = "")])
      }
    }
    if (states_update[j, colstart+i]>1) {
      states_update[j, colstart+i] <- -1
    }  
  }
  print(i)
  names(states_update)[colstart+i] <- paste("ccpt",den, sep = "")
}

states_update$"ccpt2020-01-21" <- -1
states_update$"ccpt2020-01-24" <- -1
states_update$"ccpt2020-01-26" <- -1
states_update$"ccpt2020-01-30" <- -1
states_update$"ccpt2020-01-31" <- -1









#new calc positivity(7dMA)
colstart <- ncol(states_update)
for (i in 1:243){ #+1 everyday
  den <- names(states_update)[21+i]
  for (j in 1:56){
    if (states_update[j,paste("t", den, sep = "")]==-1) {
      states_update[j,colstart+i] <- -1
    } else {
      svn_den <- as.character(as.Date(den)-7)
      sx_den <- as.character(as.Date(den)-6)
      if  (states_update[j,paste("t", svn_den, sep = "")]==-1 | 
           is.null(states_update[j,sx_den]) |
           states_update[j,paste("t",den, sep = "")]-states_update[j,paste("t",svn_den, sep = "")] <= 0){
        states_update[j, colstart+i] <- -1
      } else {
        states_update[j, colstart+i] <- (states_update[j,paste("pos", den, sep = "")]-states_update[j,paste("pos", svn_den, sep = "")])/
          (states_update[j,paste("t",den, sep = "")]-states_update[j,paste("t",svn_den, sep = "")])
      }
    }
    if (states_update[j, colstart+i]>1) {
      states_update[j, colstart+i] <- -1
    }  
  }
  print(i)
  names(states_update)[colstart+i] <- paste("wktpos",den, sep = "")
}
states_update$"wktpos2020-01-21" <- -1
states_update$"wktpos2020-01-24" <- -1
states_update$"wktpos2020-01-26" <- -1
states_update$"wktpos2020-01-30" <- -1
states_update$"wktpos2020-01-31" <- -1





# Testing Capacity (7dMA)
colstart <- ncol(states_update)
for (i in 1:243){ #+1 everyday
  den <- names(states_update)[21+i]
  for (j in 1:56){
    if (states_update[j,paste("t", den, sep = "")]==-1) {
      states_update[j,colstart+i] <- -1
    } else {
      svn_den <- as.character(as.Date(den)-7)
      sx_den <- as.character(as.Date(den)-6)
      if  (states_update[j,paste("t", svn_den, sep = "")]==-1 | 
           is.null(states_update[j,sx_den]) |
           states_update[j,paste("t",den, sep = "")]-states_update[j,paste("t",svn_den, sep = "")] <= 0){
        states_update[j, colstart+i] <- -1
      } else {
        states_update[j, colstart+i] <- (((states_update[j,paste("t",den, sep = "")]-states_update[j,paste("t",svn_den, sep = "")])/7)/
          states_update[j, "population"]) * 100000
      }
    }
    if (states_update[j, "population"]==0) {
      states_update[j, colstart+i] <- -1
    }  
  }
  print(i)
  names(states_update)[colstart+i] <- paste("tcap",den, sep = "")
}
states_update$"tcap2020-01-21" <- -1
states_update$"tcap2020-01-24" <- -1
states_update$"tcap2020-01-26" <- -1
states_update$"tcap2020-01-30" <- -1
states_update$"tcap2020-01-31" <- -1

st_write(states_update, "~/Documents/GitHub/lqycovid/docs/states_update.geojson")





























# Plot Old Calc
old_calc_wtpos <- old_calc %>% select(STUSPS, starts_with("wtpos2020"))
dates <- grep("^wtpos", names(old_calc_wtpos), value = TRUE)
subdat <- old_calc_wtpos[old_calc_wtpos$STUSPS=="MS", dates] %>% 
  select(-wtpos2020.01.21, -wtpos2020.01.24, -wtpos2020.01.26, -wtpos2020.01.30, -wtpos2020.01.31)
subdat_l <- data.frame(date = factor(1:233),
                       Value = unlist(subdat))
plot(subdat_l)

ggplot(subdat_l, aes(x=date, y=Value))

# Plot New Calc
new_calc_wtpos <- states_update %>% select(state, starts_with("wtpos2020"))
dates_new <- grep("^wtpos", names(new_calc_wtpos), value = TRUE)
subdat_new <- new_calc_wtpos[new_calc_wtpos$state=="MS", dates_new] 
subdat_new_l <- data.frame(data = factor(257:1),
                           Value = unlist(subdat_new))
subdat_new_l <- data.frame(subdat_new_l[order(nrow(subdat_new_l):1),])


plot(subdat_new_l)

write_csv(states_update, "~/Documents/GitHub/covid-atlas-research/Testing_Data/python/state_calc_new.csv")
