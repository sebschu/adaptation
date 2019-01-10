remove_quotes = function(d) {
  d$modal = gsub('"', '', d$modal)
  d$color = gsub('"', '', d$color)
  return(d)
}

prepare_data = function(d) {

  drops <- c("modal1","rating1")
  d2 = d[ , !(names(d) %in% drops)]
  setnames(d2, old=c("rating2","modal2"), new=c("rating", "modal"))
  
  drops <- c("modal2","rating2")
  d3 = d[ , !(names(d) %in% drops)]
  setnames(d3, old=c("rating1","modal1"), new=c("rating", "modal"))
  
  drops <- c("modal2", "rating2", "modal1", "rating1")
  d4 = d[ , !(names(d) %in% drops)]
  d4$rating = d4$rating_other
  d4$modal = "other"

  d = rbind(d2, d3, d4)
  
  d$modal = gsub('"', '', d$modal)
  
  d$modal = factor(d$modal, levels=c("might", "probably", "other"), ordered = TRUE)
  d$percentage_blue_f = factor(d$percentage_blue)
  d_blue = d %>% dplyr::filter(., grepl("blue", sentence2))
  d_orange = d %>% dplyr::filter(., grepl("orange", sentence2))
  
  d_orange_reverse = d_orange
  d_orange_reverse$percentage_blue = 100-d_orange$percentage_blue
  
  d_comparison = rbind(d_blue, d_orange_reverse)
  d_comparison$blue= grepl("blue", d_comparison$sentence2)
  d_comparison$percentage_blue_f = factor(d_comparison$percentage_blue)

  return(d_comparison)
}


prepare_comp_data = function(d) {
  d[d$color == "orange",]$percentage_blue = 100 - d[d$color == "orange",]$percentage_blue

  d %<>% group_by(modal, color, workerid) %>% mutate(rating_norm = rating / sum(rating)) %>% ungroup()
  
  return(d)
}

