
# run code for cognition paper plots first!

d_blue = d %>% filter(., grepl("blue", sentence2))
d_orange = d %>% filter(., grepl("orange", sentence2))

d_orange_reverse = d_orange
d_orange_reverse$percentage_blue = 100-d_orange$percentage_blue

d = rbind(d_blue, d_orange_reverse)



d = d[rep(1:nrow(d), 10), ]

d_obs = d %>%
  rowwise() %>%
  mutate(rating1 = max(0, rating1), rating2 = max(0, rating2), rating_other = max(0, rating_other))

d_obs = d_obs %>%
  rowwise() %>%
  mutate(modal = sample(c(modal1, modal2, "other" ), prob = c(rating1, rating2, rating_other), size=1))

drops <- c("sentence1", "sentence2")
d_obs = d_obs[ , !(names(d_obs) %in% drops)]

data.cautious = list(obs = d_obs %>% filter(condition == "cautious speaker"))
data.confident = list(obs = d_obs %>% filter(condition == "confident speaker"))

data_string = jsonlite::toJSON(data.cautious, digits=NA)
cat(data_string, file = "/Users/sebschu/Dropbox/Uni/RA/adaptation/adaptation/models/2_adaptation_model/data/speaker_adaptation_cautious.json")
data_string = jsonlite::toJSON(data.confident, digits=NA)
cat(data_string, file = "/Users/sebschu/Dropbox/Uni/RA/adaptation/adaptation/models/2_adaptation_model/data/speaker_adaptation_confident.json")




# balanced
d_blue = d.rep %>% filter(., grepl("blue", sentence2))
d_orange = d.rep %>% filter(., grepl("orange", sentence2))

d_orange_reverse = d_orange
d_orange_reverse$percentage_blue = 100-d_orange$percentage_blue

d.rep = rbind(d_blue, d_orange_reverse)



d = d.rep[rep(1:nrow(d.rep), 10), ]

d_obs = d %>%
  rowwise() %>%
  mutate(rating1 = max(0, rating1), rating2 = max(0, rating2), rating_other = max(0, rating_other))

d_obs = d_obs %>%
  rowwise() %>%
  mutate(modal = sample(c(modal1, modal2, "other" ), prob = c(rating1, rating2, rating_other), size=1))

drops <- c("sentence1", "sentence2")
d_obs = d_obs[ , !(names(d_obs) %in% drops)]

data.cautious = list(obs = d_obs %>% filter(condition == "cautious speaker"))
data.confident = list(obs = d_obs %>% filter(condition == "confident speaker"))

data_string = jsonlite::toJSON(data.cautious, digits=NA)
cat(data_string, file = "/Users/sebschu/Dropbox/Uni/RA/adaptation/adaptation/models/2_adaptation_model/data/speaker_adaptation_balanced_cautious.json")
data_string = jsonlite::toJSON(data.confident, digits=NA)
cat(data_string, file = "/Users/sebschu/Dropbox/Uni/RA/adaptation/adaptation/models/2_adaptation_model/data/speaker_adaptation_balanced_confident.json")
