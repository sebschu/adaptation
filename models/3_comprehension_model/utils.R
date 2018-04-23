get_correct_catch_trial_counts = function (data) {
  ret = data %>% 
    filter(., catch_trial == 1) %>%
    group_by(workerid) %>%
    summarise(catch_perf = sum(catch_trial_answer_correct))
  
  return(ret)
}


remove_quotes = function(d) {
  d$modal1 = gsub('"', '', d$modal1)
  d$modal2 = gsub('"', '', d$modal2)
  d$pair = gsub('"', '', d$pair)
  d$color = gsub('"', '', d$color)
  return(d)
}

exclude_participants = function(trials.might, trials.probably, exp_trials.might, exp_trials.probably) {

  trials.might = remove_quotes(trials.might)
  trials.probably = remove_quotes(trials.probably)
  

  EXCLUDE_BELOW = 12
  
  catch_trial_perf.trials.might = get_correct_catch_trial_counts(trials.might)
  catch_trial_perf.exp_trials.might = get_correct_catch_trial_counts(exp_trials.might)
  catch_trial_perf.all.might = rbind(catch_trial_perf.trials.might, catch_trial_perf.exp_trials.might) %>%
    group_by(workerid) %>%
    summarise(catch_perf = sum(catch_perf))
  
  
  
  
  catch_trial_perf.exp_trials.probably = get_correct_catch_trial_counts(exp_trials.probably)
  catch_trial_perf.trials.probably = get_correct_catch_trial_counts(trials.probably)
  catch_trial_perf.all.probably = rbind(catch_trial_perf.trials.probably, catch_trial_perf.exp_trials.probably) %>%
    group_by(workerid) %>%
    summarise(catch_perf = sum(catch_perf))
  
  
  exclude.might = catch_trial_perf.all.might %>%
    filter(catch_perf < EXCLUDE_BELOW) %>%
    .$workerid
  
  exclude.probably = catch_trial_perf.all.probably %>%
    filter(catch_perf < EXCLUDE_BELOW) %>%
    .$workerid
  
  print(paste("Excluded", length(exclude.might), "participants in might-biased condition."))
  print(paste("Excluded", length(exclude.probably), "participants in probably-biased condition."))
  
  
  #final data
  d.might = trials.might %>% filter(., !(workerid %in% exclude.might))
  d.probably = trials.probably %>% filter(., !(workerid %in% exclude.probably))

  return(list(might = spread_data(d.might), probably = spread_data(d.probably)))
  
}


spread_data = function(d) {
  
  
  modal1 = d$modal1[1]
  modal2 = d$modal2[1]
  
  
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
  
  d$modal = factor(d$modal)
  d$percentage_blue_f = factor(d$percentage_blue)
  d_blue = d %>% filter(., grepl("blue", sentence2))
  d_orange = d %>% filter(., grepl("orange", sentence2))
  
  d_orange_reverse = d_orange
  d_orange_reverse$percentage_blue = 100-d_orange$percentage_blue
  
  d_comparison = rbind(d_blue, d_orange_reverse)
  d_comparison$blue= grepl("blue", d_comparison$sentence2)
  d_comparison$percentage_blue_f = factor(d_comparison$percentage_blue)
  
  d_comparison$modal = factor(d_comparison$modal, levels = c(modal1, modal2, "other"), ordered = TRUE)
  
  return(d_comparison)
}


plot_condition = function(d, plot_title) {
  
 
  
  p1 = ggplot(d, aes(x=percentage_blue, y=rating)) + geom_point(aes(col=modal)) +
    geom_smooth(aes(col=modal), method="loess") + ggtitle(plot_title) + xlab("percentage") +
    theme(legend.position="none")
  
  p2 = ggplot(d, aes(x=percentage_blue_f, y=rating, fill=modal)) + 
    geom_boxplot() +
    ggtitle(plot_title) + xlab("percentage")
  
  return(list("p1" = p1, "p2" = p2))
  
}
