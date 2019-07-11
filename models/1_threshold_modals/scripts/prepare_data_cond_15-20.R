library(tidyverse)

# Script to create data to estimate model parameters from pre-exposure ratings

setwd("/Users/sebschu/Dropbox/Uni/RA/adaptation/adaptation/models/1_threshold_modals/scripts/")

load_data = function(fname) {
  d = read.csv(fname)
  
  d$modal1 = gsub('"', '', d$modal1)
  d$modal2 = gsub('"', '', d$modal2)
  d$pair = gsub('"', '', d$pair)
  d$color = gsub('"', '', d$color)
  
  d_blue = d %>% filter(., grepl("blue", sentence2))
  d_orange = d %>% filter(., grepl("orange", sentence2))
  
  d_orange_reverse = d_orange
  d_orange_reverse$percentage_blue = 100-d_orange$percentage_blue
  
  d_comparison = rbind(d_blue, d_orange_reverse)
  d_comparison$blue= grepl("blue", d_comparison$sentence2)
  
  return(d_comparison)
}


## Load data from conditions 15-20

d = data.frame()
for (i in 15:20) {
  fname = paste("/Users/sebschu/Dropbox/Uni/RA/adaptation/adaptation/experiments/0_pre_test/data/0_pre_test-cond", i , "-trials.csv", sep="")
  d.part = load_data(fname)
  d = rbind(d, d.part)
}


drops <- c("sentence1", "sentence2")
d_obs = d[ , !(names(d) %in% drops)]
d_obs =  do.call("rbind", replicate(10, d_obs, simplify = FALSE))

d_obs = d_obs %>%
  rowwise() %>%
  mutate(rating1 = max(0, rating1), rating2 = max(0, rating2), rating_other = max(0, rating_other))
d_obs = d_obs %>%
  rowwise() %>%
  mutate(modal = sample(c(modal1, modal2, "other" ), prob = c(rating1, rating2, rating_other), size=1))  


data = list(obs = d_obs)

data_string = jsonlite::toJSON(data, digits = NA)

cat(data_string, file = "../data/data_workerids_cond15-20.json")
