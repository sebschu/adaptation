setwd("~/Dropbox/Uni/RA/adaptation/adaptation/papers/cognition/plot-sources/")

library(DescTools)
library(data.table)
library(tidyverse)
library(ggplot2)
library(grid)
library(gridExtra)
library(splines)

source("../../../shared-analysis/data_helpers.R")

theme_set(theme_bw())

###################################
# Population-level pre-test plots
###################################

get_pre_test_grid_plot = function(condition) {
  fname = paste("../../../experiments/0_pre_test/data/0_pre_test-cond", condition, "-trials.csv", sep="")
  d = read.csv(fname)
  d = remove_quotes(d)
  d = spread_data(d)
  plot_data = get_data_for_plotting(d)
  p = plot_condition(plot_data) +
    theme(legend.position="none",
          axis.title.y=element_blank(), 
          axis.title.x=element_blank())
  return(p)
}

plots = lapply(0:20, get_pre_test_grid_plot)
btm_legend = extract_legend(plots[[1]] + theme(legend.position = "bottom"))

btm_legend_partial = extract_legend(plots[[1]] + colscale(c("might", "probably", "bare", "other")) + theme(legend.position = "bottom"))


# Conditions 1-12 (first figure for SI)
g1 = do.call("arrangeGrob", c(plots[1:12], ncol=3, left="mean rating", bottom="event probability"))
pre_test_s1 = grid.arrange(g1, btm_legend, heights=c(32, 2))

# Conditions 13-21 (second figure for SI)
g2 = do.call("arrangeGrob", c(plots[13:21], ncol=3, left="mean rating", bottom="event probability"))
pre_test_s2 = grid.arrange(g2, btm_legend, heights=c(24, 2))

# Conditions 1 (bare-might), 2 (bare-probably), and 6 (might-probably) for figure in main paper
g_main = do.call("arrangeGrob", c(plots[c(1,2,6)], ncol=3, left="mean rating", bottom="event probability"))
pre_test_main = grid.arrange(g_main, btm_legend_partial, heights=c(8, 2))

ggsave(pre_test_main, filename = "../plots/pre_test_main.pdf", width = 30, height = 12, units = "cm")
ggsave(pre_test_s1,   filename = "../plots/pre_test_s1.pdf",   width = 30, height = 36, units = "cm")
ggsave(pre_test_s2,   filename = "../plots/pre_test_s2.pdf",   width = 30, height = 28, units = "cm")


###################################
# Individual-level pre-test plots
###################################

get_pre_test_grid_plot_indiv = function(worker_id, condition) {
  fname = paste("../../../experiments/0_pre_test/data/0_pre_test-cond", condition, "-trials.csv", sep="")
  d = read.csv(fname)
  d = remove_quotes(d)
  d = spread_data(d)
  plot_data = get_data_for_indiv_plotting(d)
  plot_data = plot_data %>% filter(workerid == worker_id)
  p = plot_condition_no_errorbar(plot_data) +
    theme(legend.position="none",
          axis.title.y=element_blank(), 
          axis.title.x=element_blank()) +
    facet_wrap(~workerid, 
               labeller=labeller(.default=function(value) {
                 return(paste("Participant", value))
                 })) +
    colscale(unique(d$modal))
  
  return(p)
}


plots = lapply(c(8,12,15), get_pre_test_grid_plot_indiv, condition=5)
btm_legend = extract_legend(plots[[1]] + theme(legend.position = "bottom"))
g_indiv = do.call("arrangeGrob", c(plots, ncol=3, left="mean rating", bottom="event probability"))
pre_test_main_indiv = grid.arrange(g_indiv, btm_legend, heights=c(8, 2))
ggsave(pre_test_main_indiv, filename = "../plots/pre_test_main_indiv.pdf", width = 30, height = 12, units = "cm")

################
# Norming study modeling plots
################

hdi_data = read.csv("../../../models/1_threshold_modals/runs/threshold-model-expected/hdi_samples.csv")


get_pre_test_model_plot = function(condition) {
  fname = paste("../../../experiments/0_pre_test/data/0_pre_test-cond", condition, "-trials.csv", sep="")
  d = read.csv(fname)
  d = remove_quotes(d)
  d = spread_data(d)
  p = plot_posterior(d, hdi_data) +
    theme(legend.position="none",
          axis.title.y=element_blank(), 
          axis.title.x=element_blank())
  return(p)
}

plots = lapply(0:20, get_pre_test_model_plot)
btm_legend = extract_legend(plots[[1]] + theme(legend.position = "bottom"))
btm_legend_main = extract_legend(plots[[1]] + colscale(c("might", "probably", "bare", "other")) +  theme(legend.position = "bottom"))


g_main = do.call("arrangeGrob", c(plots[c(1,2,6)], ncol=3, left="mean rating", bottom="event probability"))
pre_test_main = grid.arrange(g_main, btm_legend_main, heights=c(8, 2))

# Conditions 1-12 (first figure for SI)
g1 = do.call("arrangeGrob", c(plots[1:12], ncol=3, left="mean rating", bottom="event probability"))
pre_test_s1 = grid.arrange(g1, btm_legend, heights=c(32, 2))

# Conditions 13-21 (second figure for SI)
g2 = do.call("arrangeGrob", c(plots[13:21], ncol=3, left="mean rating", bottom="event probability"))
pre_test_s2 = grid.arrange(g2, btm_legend, heights=c(24, 2))


ggsave(pre_test_main, filename = "../plots/pre_test_model_main.pdf", width = 30, height = 12, units = "cm")
ggsave(pre_test_s1,   filename = "../plots/pre_test_model_s1.pdf",   width = 30, height = 36, units = "cm")
ggsave(pre_test_s2,   filename = "../plots/pre_test_model_s2.pdf",   width = 30, height = 28, units = "cm")


# table with correlations
pretest_loo_correlations(hdi_data, 
                         "/Users/sebschu/Dropbox/Uni/RA/adaptation/adaptation/experiments/0_pre_test/data/", 
                         "/Users/sebschu/Dropbox/Uni/RA/adaptation/adaptation/models/1_threshold_modals/runs/")

# threshold distributions
mle_params = read.csv("../../../models/1_threshold_modals/runs/threshold-model-expected/mle_params.csv")

beta_density = data.table()

beta_modals = c("bare", "might", "probably", "could", "looks_like", "think", "bare_not")

for (modal in beta_modals) {
  alpha_param_name = paste("alpha", modal, sep="_")
  beta_param_name = paste("beta", modal, sep="_")
  
  alpha_param = mle_params[1,alpha_param_name]
  beta_param = mle_params[1,beta_param_name]
  
  x = seq(0,1,.001)
  y = dbeta(x, alpha_param, beta_param)
  #y = y / (max(y))
  
  beta_density = rbind(beta_density, data.frame(x = x, y = y, modal = gsub("_", " ", modal)))
  

    
}

beta_density$modal = factor(beta_density$modal, levels = modals_labels, ordered=T)

threshold_distrs = ggplot(beta_density, aes(x=x, y=y)) + 
  geom_line() + 
  facet_wrap(~modal, ncol = 4, scales = "free_y") + 
  xlab("threshold") +
  ylab("P(x < threshold)") +
  theme(legend.text = element_text(size=14),
        strip.text.x = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12))



ggsave(threshold_distrs, filename = "../plots/threshold-distributions-prior.pdf", width = 30, height = 12, units = "cm")


#############
# Original adaptation plots
#############
d.cautious = read.csv("../../../experiments/1_adaptation/data/1_adaptation-might-trials.csv")
d.confident = read.csv("../../../experiments/1_adaptation/data/1_adaptation-probably-trials.csv")

# re-number participants in confident speaker condition
d.confident$workerid = d.confident$workerid + max(d.cautious$workerid) + 1
d.cautious$condition = "cautious speaker"
d.confident$condition = "confident speaker"

d = rbind(d.cautious, d.confident)
d = remove_quotes(d)

d.exp_trials.cautious = read.csv("../../../experiments/1_adaptation/data/1_adaptation-might-exp_trials.csv")
d.exp_trials.confident = read.csv("../../../experiments/1_adaptation/data/1_adaptation-probably-exp_trials.csv")

d.exp_trials.confident$workerid = d.exp_trials.confident$workerid + max(d.exp_trials.cautious$workerid) + 1

exp_trials = rbind(d.exp_trials.cautious, d.exp_trials.confident)

d = exclude_participants(d, exp_trials)
d = spread_data(d)

d$pair = d$condition

plot_data = get_data_for_plotting(d)
plot = plot_condition(plot_data) + 
  geom_vline(xintercept = .60, lty=2, col="grey", size=1) +  
  theme(strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12),
        plot.background = element_rect(fill = "transparent", color = NA),
        legend.background =  element_rect(fill = "transparent")) +
  colscale(unique(plot_data$modal))
 
ggsave(plot, filename = "../plots/exp-1-ratings.png", width = 15, height = 12, units = "cm")
ggsave(plot, filename = "../plots/exp-1-ratings.pdf", width = 30, height = 12, units = "cm")

### AUC plots

auc_method = function(d) {
  model = lm(formula = rating_m ~ ns(percentage_blue, df = 4), data = d)
  
  pred = data.frame(0:1000)
  pred$percentage_blue = (0:1000)/10
  pred$rating = predict(model, pred)
  
  auc = AUC(x = pred$percentage_blue, y=pred$rating)
  return(auc)
}


auc_for_participants = function(d, method) {
  
  aucs = data.frame(list("workerid" = unique(d$workerid)))
  aucs$auc_might = 0
  aucs$auc_probably = 0
  
  
  i = 1
  
  for (wid in unique(d$workerid)) {
    d.might_ratings = d %>% 
      filter (workerid == wid) %>%
      filter (modal == "might") %>%
      group_by(workerid, percentage_blue) %>%
      summarise(rating_m = mean(rating))
    
    aucs$auc_might[i] = method(d.might_ratings)
    
    d.probably_ratings = d %>% 
      filter (workerid == wid) %>%
      filter (modal == "probably") %>%
      group_by(workerid, percentage_blue) %>%
      summarise(rating_m = mean(rating))
    
    aucs$auc_probably[i] = method(d.probably_ratings)
    
    i = i + 1
  }
  
  aucs$auc_diff = aucs$auc_might - aucs$auc_probably
  
  return(aucs)
}

#AUCs for cuatious speaker condition
aucs.cautious = auc_for_participants(d %>% filter(condition == "cautious speaker"), method=auc_method)
#AUCs for confident speaker condition
aucs.confident = auc_for_participants(d %>% filter(condition == "confident speaker"), method=auc_method)

aucs.cautious$cond = "cautious speaker"
aucs.confident$cond = "confident speaker"

aucs.all = rbind(aucs.cautious, aucs.confident)
aucs.all = aucs.all %>% 
  group_by(cond) %>% 
  summarise(auc_diff_m = mean(auc_diff), 
            ci_high = ci.high(auc_diff), 
            ci_low = ci.low(auc_diff))

auc_plot.1 =  aucs.all %>%
  ggplot(aes(x=0, y=auc_diff_m, color=cond)) +
  geom_errorbar(aes(ymin=auc_diff_m-ci_low, ymax=auc_diff_m+ci_high), width=.1) +
  geom_point() +
  xlab("") +
  ylab("AUC difference (might ratings - probably ratings)") +
  theme(text = element_text(size=12),
        axis.ticks.x=element_blank(), 
        axis.text.x=element_blank(),
        panel.grid.minor=element_blank(), 
        plot.background=element_blank(),
        legend.position = "bottom") +
  guides(col=guide_legend(title="Condition")) +
  xlim(-.2, .2) +
  ylim(-8,28)

auc_legend = extract_legend(auc_plot.1)



### correlations


compute_correlation_for_model = function(model_type, exp_data, model_path_suffix="") {
  hdi_data.cautious = read.csv(paste("../../../models/2_adaptation_model/bayesian-runs", model_path_suffix, "/", model_type, "/cautious/hdi_samples.csv", sep="")) %>% mutate(condition = "cautious speaker")
  hdi_data.confident = read.csv(paste("../../../models/2_adaptation_model/bayesian-runs", model_path_suffix, "/", model_type, "/confident/hdi_samples.csv", sep=""))  %>% mutate(condition = "confident speaker")
  
  r2_cautious = post_adaptation_correlation(hdi_data.cautious, exp_data %>% filter(condition =="cautious speaker"))
  r2_confident = post_adaptation_correlation(hdi_data.confident, exp_data %>% filter(condition =="confident speaker"))
  
  r2_all = post_adaptation_correlation(rbind(hdi_data.cautious, hdi_data.confident), exp_data)
  cor_row = data.frame(model=model_type, r2_cautious = r2_cautious, r2_confident=r2_confident, r2_all=r2_all)
  return(cor_row)
}



#c1 = compute_correlation_for_model("theta-cost-rat", d)
c1 = compute_correlation_for_model("theta-cost", d)
c2 = compute_correlation_for_model("cost", d)
c3 = compute_correlation_for_model("theta", d)
c4 = compute_correlation_for_model("prior", d)

#c5 = compute_correlation_for_model("theta-rat", d)
#c6 = compute_correlation_for_model("cost-rat", d)

rbind(c1,c2,c3,c4)






##########
# Model visualizations
##########

hdi_data.distr= read.csv(paste("../../../models/1_threshold_modals/visualizations/distribution-thresholds/hdi_samples.csv", sep=""))
hdi_data.point= read.csv(paste("../../../models/1_threshold_modals/visualizations/pointwise-thresholds/hdi_samples.csv", sep=""))

hdi_data.distr$condition = "distributional thresholds"
hdi_data.point$condition = "point estimate thresholds"

hdi_data.all = rbind(hdi_data.distr, hdi_data.point)
hdi_data.all$condition = factor(hdi_data.all$condition, levels=c("point estimate thresholds", "distributional thresholds"), ordered = T)
hdi_data.all$rating_pred = hdi_data.all$rating_pred * 100
hdi_data.all$modal = factor(hdi_data.all$modal, levels = modals[modals %in% unique(hdi_data.all$modal)], labels = modals_labels[modals %in% unique(hdi_data.all$modal)], ordered=T)
viz_plot = hdi_data.all %>%  
  group_by(condition, modal, percentage_blue) %>%
  summarize(rating_pred_m = mean(rating_pred))  %>%
  ggplot(aes(x=percentage_blue/100, col=modal, y=rating_pred_m, group=interaction(modal,condition))) +
  geom_line(size=0.5) + 
  colscale(unique(hdi_data.all$modal)) + 
  facet_wrap(~condition) +
  theme(legend.position = "bottom", legend.box = "vertical") +
  theme(strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12),
        plot.background = element_rect(fill = "transparent", color = NA),
        legend.background =  element_rect(fill = "transparent")
       ) +
  guides(col=guide_legend(title="Expression", nrow = 1, override.aes = list(alpha = 1, fill="transparent"))) + 
  ylab("predicted rating") +
  xlab("event probability")

ggsave(viz_plot, filename = "../plots/model-visualization-predictions.png", width=10, height=7.2,  units="cm")
ggsave(viz_plot, filename = "../plots/model-visualization-predictions.pdf", width = 30, height = 12, units = "cm")

mle_params_json = read_lines("../../../models/1_threshold_modals/visualizations/distribution-thresholds/samples.json")
mle_params = jsonlite::fromJSON(mle_params_json, flatten=TRUE)

beta_density = data.table()

beta_modals_sim = c("bare", "might", "probably", "bare_not")

for (modal in beta_modals_sim) {
  alpha_param_name = paste("alpha", modal, sep="_")
  beta_param_name = paste("beta", modal, sep="_")
  
  alpha_param = mle_params[1,alpha_param_name]
  beta_param = mle_params[1,beta_param_name]
  
  x = seq(0.001,0.999,.001)
  y = dbeta(x, alpha_param, beta_param)
  y = y / (max(y))
  
  beta_density = rbind(beta_density, data.frame(x = x, y = y, modal = gsub("_", " ", modal), condition="distributional thresholds"))

}

mle_params_json = read_lines("../../../models/1_threshold_modals/visualizations/pointwise-thresholds/samples.json")
mle_params = jsonlite::fromJSON(mle_params_json, flatten=TRUE)

for (modal in beta_modals_sim) {
  alpha_param_name = paste("alpha", modal, sep="_")
  beta_param_name = paste("beta", modal, sep="_")
  
  alpha_param = mle_params[1,alpha_param_name]
  beta_param = mle_params[1,beta_param_name]
  
  x = seq(0.001,0.999,.001)
  y = dbeta(x, alpha_param, beta_param)
  y = y / (max(y))
  y = round(y)
  
  beta_density = rbind(beta_density, data.frame(x = x, y = y, modal = gsub("_", " ", modal), condition="point estimate thresholds"))
  
}


beta_density$modal = factor(beta_density$modal, levels = modals_labels, ordered=T)
beta_density$condition = factor(beta_density$condition, levels=c("point estimate thresholds", "distributional thresholds"), ordered = T)

threshold_distrs = beta_density %>% 
  ggplot(aes(x=x, y=y, col=modal)) + 
  geom_line() + 
  facet_wrap(~condition) +
  xlab("threshold") +
  ylab("density") +
  colscale(unique(beta_density$modal)) +
  theme(strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12),
        plot.background = element_rect(fill = "transparent", color = NA),
        legend.background =  element_rect(fill = "transparent")
  ) +
    theme(legend.position = "none") 

ggsave(threshold_distrs, filename = "../plots/model-visualization-distributions.png", width = 10, height = 5.7, units = "cm")
ggsave(threshold_distrs, filename = "../plots/model-visualization-distributions.pdf", width = 30, height = 10, units = "cm")


##########
# Speaker adaptation model results
##########

mle_params = read.csv("../../../models/2_adaptation_model/bayesian-runs/theta-cost/cautious/mle_params.csv")


beta_density = data.table()

for (modal in beta_modals) {
  if (modal == "other") {
    next
  }
  alpha_param_name = paste("alpha", modal, sep="_")
  beta_param_name = paste("beta", modal, sep="_")
  
  alpha_param = mle_params[1,alpha_param_name]
  beta_param = mle_params[1,beta_param_name]
  
  x = seq(0.001,0.999,.001)
  y = dbeta(x, alpha_param, beta_param)
  #y = y / (max(y))
  
  beta_density = rbind(beta_density, data.frame(x = x, y = y, modal = gsub("_", " ", modal), condition="cautious speaker"))
}


mle_params = read.csv("../../../models/2_adaptation_model/bayesian-runs/theta-cost/confident/mle_params.csv")



for (modal in beta_modals) {
  if (modal == "other") {
    next
  }
  alpha_param_name = paste("alpha", modal, sep="_")
  beta_param_name = paste("beta", modal, sep="_")
  
  alpha_param = mle_params[1,alpha_param_name]
  beta_param = mle_params[1,beta_param_name]
  
  x = seq(0.001,0.999,.001)
  y = dbeta(x, alpha_param, beta_param)
  #y = y / (max(y))
  
  beta_density = rbind(beta_density, data.frame(x = x, y = y, modal = gsub("_", " ", modal), condition="confident speaker"))
}

beta_density$modal = factor(beta_density$modal, levels = modals_labels, ordered=T)

mle_params = read.csv("../../../models/1_threshold_modals/runs/threshold-model-expected/mle_params.csv")

for (modal in beta_modals) {
  if (modal == "other") {
    next
  }
  alpha_param_name = paste("alpha", modal, sep="_")
  beta_param_name = paste("beta", modal, sep="_")
  
  alpha_param = mle_params[1,alpha_param_name]
  beta_param = mle_params[1,beta_param_name]
  
  x = seq(0.001,0.999,.001)
  y = dbeta(x, alpha_param, beta_param)
  #y = y / (max(y))
  
  beta_density = rbind(beta_density, data.frame(x = x, y = y, modal = gsub("_", " ", modal), condition="prior"))
}

threshold_distrs = ggplot(beta_density, aes(x=x, y=y, col=condition)) + 
  geom_line() + 
  facet_wrap(~modal, ncol = 4, scales = "free_y") + 
  xlab("threshold") +
  ylab("density") +
  theme(strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12),
        legend.position = "bottom") +
  guides(col=guide_legend(title="Condition", nrow = 1)) +
  cond_colscale
  
ggsave(threshold_distrs, filename = "../plots/adaptation-posterior-thresholds.pdf", width = 30, height = 12, units = "cm")


mle_params = read.csv("../../../models/2_adaptation_model/bayesian-runs/theta-cost/cautious/mle_params.csv") 
mle_params = rbind(mle_params, read.csv("../../../models/2_adaptation_model//bayesian-runs/theta-cost/confident/mle_params.csv"))
mle_params = rbind(mle_params, read.csv("../../../models/1_threshold_modals/runs/threshold-model-expected/mle_params.csv") )

mle_params[3,"cost_might"] = 1.0
mle_params[3,"cost_probably"] = 1.0


mle_params$condition = c("cautious speaker", "confident speaker", "prior")
mle_params = mle_params %>% gather(key="Parameter", value="value", -condition)

cost_plot = mle_params %>% 
  filter(grepl("cost_", Parameter)) %>%
  mutate(Parameter = factor(gsub("cost_", "", Parameter), levels=modals, labels= modals_labels, ordered=TRUE)) %>%
  ggplot(aes(fill=condition, color=condition, y=log(value), x=Parameter)) +
    geom_bar(stat="identity", position = "dodge") +
    xlab("") + 
    ylab("log cost") +
  theme(strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12),
        legend.position = "bottom") +
  guides(fill=guide_legend(title="Condition", nrow = 1, override.aes = list(col="#999999", size=0.1)), col= "none", pch="none") +
  cond_colscale +
  cond_colscale_fill

ggsave(cost_plot, filename = "../plots/adaptation-posterior-costs.pdf", width = 15, height = 12, units = "cm")


hdi_data.cautious= read.csv(paste("../../../models/2_adaptation_model/bayesian-runs/theta-cost/cautious/hdi_samples.csv", sep=""))
hdi_data.confident = read.csv(paste("../../../models/2_adaptation_model/bayesian-runs/theta-cost/confident/hdi_samples.csv", sep=""))
hdi_data.prior = read.csv(paste("../../../models/1_threshold_modals/runs/threshold-model-expected//hdi_samples.csv", sep=""))
hdi_data.prior = hdi_data.prior %>% filter(cond == "might-probably") %>% filter(run < 1000)

hdi_data.cautious$condition = "cautious speaker"
hdi_data.confident$condition = "confident speaker"
hdi_data.prior$condition = "prior"
hdi_data.all = rbind(hdi_data.cautious, hdi_data.confident)
hdi_data.all$condition = factor(hdi_data.all$condition, levels=c("cautious speaker", "prior", "confident speaker"), ordered = T)
hdi_data.all$rating_pred = hdi_data.all$rating_pred * 100
hdi_data.all$modal = factor(hdi_data.all$modal, levels = modals, labels = modals_labels, ordered=T)
hdi_data.all$src = factor("model prediction", levels=c("model prediction", "experimental result"), ordered=T)
posterior_plot = hdi_data.all %>% 
  ggplot(aes(x=percentage_blue, col=modal, y=rating_pred, group=interaction(run,modal,condition), lty=src)) +
  geom_line(alpha=.01) + 
  geom_line(aes(x=percentage_blue, y=rating_pred_m, group=modal), size=1, data = hdi_data.all %>% 
              group_by(condition, modal, percentage_blue, src) %>%
              summarize(rating_pred_m = mean(rating_pred))) + 
  colscale(unique(hdi_data.all$modal)) + facet_wrap(~condition) +
  geom_vline(xintercept = 60, lty=2, col="grey", size=1) +
  theme(legend.position = "bottom", legend.box = "vertical") +
  theme(strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12)
  ) +
  guides(col=guide_legend(title="Expression", nrow = 1, override.aes = list(alpha = 1)), 
  lty=guide_legend(title="", nrow = 1, override.aes = list(alpha = 1, size=0.5), order = 2)) +
  ylab("predicted rating") +
  xlab("event probability") +
  geom_line(aes(x=percentage_blue, y=rating_m, group=modal), data=plot_data %>% rename(condition = pair) %>% mutate(src="experimental result")) +
  scale_linetype_manual(values=c("solid", "dashed"), labels=c("model prediction", "experimental result"), drop=F)

ggsave(posterior_plot, filename = "../plots/adaptation-posterior-predictions.png", width = 15, height = 12, units = "cm")
ggsave(posterior_plot, filename = "../plots/adaptation-posterior-predictions.pdf", width = 30, height = 12, units = "cm")



#############
# Experiment 2 
#############
d.cautious = read.csv("../../../experiments/5_adaptation_balanced/data/5_adaptation_balanced-might-trials.csv")
d.confident = read.csv("../../../experiments/5_adaptation_balanced/data/5_adaptation_balanced-probably-trials.csv")

# re-number participants in confident speaker condition
d.confident$workerid = d.confident$workerid + max(d.cautious$workerid) + 1
d.cautious$condition = "cautious speaker"
d.confident$condition = "confident speaker"

d.rep = rbind(d.cautious, d.confident)
d.rep = remove_quotes(d.rep)

d.exp_trials.cautious = read.csv("../../../experiments/5_adaptation_balanced/data/5_adaptation_balanced-might-exp_trials.csv")
d.exp_trials.confident = read.csv("../../../experiments/5_adaptation_balanced/data/5_adaptation_balanced-probably-exp_trials.csv")

d.exp_trials.confident$workerid = d.exp_trials.confident$workerid + max(d.exp_trials.cautious$workerid) + 1

exp_trials = rbind(d.exp_trials.cautious, d.exp_trials.confident)

d.rep = exclude_participants(d.rep, exp_trials)
d.rep = spread_data(d.rep)

d.rep$pair = d.rep$condition

fname = paste("../../../experiments/0_pre_test/data/0_pre_test-cond", 5 , "-trials.csv", sep="")
d.prior = read.csv(fname)
d.prior = remove_quotes(d.prior)
d.prior = spread_data(d.prior)

d.prior$pair = "Experiment 1"
d.prior = d.prior %>% mutate(condition = "prior", speaker_cond="c", catch_trial_answer_correct = -1, post_exposure = 0, catch_trial = 0)

d.rep = rbind(d.rep, d.prior)

d.rep$pair = factor(d.rep$pair, levels = c("Experiment 1", "cautious speaker", "confident speaker"), ordered = T)

plot_data = get_data_for_plotting(d.rep)
plot = plot_condition(plot_data) + 
  geom_vline(xintercept = .60, lty=2, col="grey", size=1) +
  theme(strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12)) +
  colscale(unique(plot_data$modal))

ggsave(plot, filename = "../plots/exp-1-replication-ratings.pdf", width = 30, height = 12, units = "cm")

#AUCs for cuatious speaker condition
aucs.cautious = auc_for_participants(d.rep %>% filter(condition == "cautious speaker"), method=auc_method)
#AUCs for confident speaker condition
aucs.confident = auc_for_participants(d.rep %>% filter(condition == "confident speaker"), method=auc_method)

aucs.cautious$cond = "cautious speaker"
aucs.confident$cond = "confident speaker"

aucs.all = rbind(aucs.cautious, aucs.confident)
aucs.all = aucs.all %>% 
  group_by(cond) %>% 
  summarise(auc_diff_m = mean(auc_diff), 
            ci_high = ci.high(auc_diff), 
            ci_low = ci.low(auc_diff))

auc_plot.2 =  aucs.all %>%
  ggplot(aes(x=0, y=auc_diff_m, color=cond)) +
  geom_errorbar(aes(ymin=auc_diff_m-ci_low, ymax=auc_diff_m+ci_high), width=.1) +
  geom_point() +
  xlab("") +
  ylab("AUC difference (might ratings - probably ratings)") +
  theme(text = element_text(size=12),
        axis.ticks.x=element_blank(), 
        axis.text.x=element_blank(),
        panel.grid.minor=element_blank(), 
        plot.background=element_blank(),
        legend.position = "bottom") +
  guides(col=guide_legend(title="Condition")) +
  xlim(-.2, .2) +
  ylim(-8,28)


g = arrangeGrob(auc_plot.1 + theme(legend.position = "none"), auc_plot.2 + theme(legend.position = "none"), ncol=2, left="AUC difference (might ratings - probably ratings)")
auc_plots = grid.arrange(g, auc_legend, heights=c(12,2))

ggsave(auc_plots, filename = "../plots/exp-1-aucs.pdf",  width=20, height=12, units = "cm")

ggsave(auc_plot.2, filename = "../plots/exp-1-auc.pdf",  width=12, height=12, units = "cm")
ggsave(auc_plot.1, filename = "../plots/exp-1-auc-orig.pdf",  width=12, height=12, units = "cm")


#c1 = compute_correlation_for_model("theta-cost-rat", d.rep, model_path_suffix = "-balanced")
c1 = compute_correlation_for_model("theta-cost", d.rep, model_path_suffix = "-balanced")
c2 = compute_correlation_for_model("cost", d.rep, model_path_suffix = "-balanced")
c3 = compute_correlation_for_model("theta", d.rep, model_path_suffix = "-balanced")
c4 = compute_correlation_for_model("prior", d.rep, model_path_suffix = "-balanced")

#c5 = compute_correlation_for_model("theta-rat", d.rep, model_path_suffix = "-balanced")
#c6 = compute_correlation_for_model("cost-rat", d.rep, model_path_suffix = "-balanced")

rbind(c1,c2,c3,c4)

hdi_data.cautious= read.csv(paste("../../../models/2_adaptation_model/bayesian-runs-balanced/theta-cost/cautious/hdi_samples.csv", sep=""))
hdi_data.confident = read.csv(paste("../../../models/2_adaptation_model/bayesian-runs-balanced/theta-cost/confident/hdi_samples.csv", sep=""))
#hdi_data.prior = read.csv(paste("../../../models/1_threshold_modals/runs/threshold-model-expected//hdi_samples.csv", sep=""))
#hdi_data.prior = hdi_data.prior %>% filter(cond == "might-probably") %>% filter(run < 1000)

hdi_data.cautious$condition = "cautious speaker"
hdi_data.confident$condition = "confident speaker"
#hdi_data.prior$condition = "prior"
hdi_data.all = rbind(hdi_data.cautious, hdi_data.confident)
hdi_data.all$condition = factor(hdi_data.all$condition, levels=c("cautious speaker", "prior", "confident speaker"), ordered = T)
hdi_data.all$rating_pred = hdi_data.all$rating_pred * 100
hdi_data.all$modal = factor(hdi_data.all$modal, levels = modals, labels = modals_labels, ordered=T)
hdi_data.all$src = factor("model prediction", levels=c("model prediction", "experimental result"), ordered=T)
posterior_plot = hdi_data.all %>% 
  ggplot(aes(x=percentage_blue, col=modal, y=rating_pred, group=interaction(run,modal,condition), lty=src)) +
  geom_line(alpha=.01) + 
  geom_line(aes(x=percentage_blue, y=rating_pred_m, group=modal), size=1, data = hdi_data.all %>% 
              group_by(condition, modal, percentage_blue, src) %>%
              summarize(rating_pred_m = mean(rating_pred))) + 
  colscale(unique(hdi_data.all$modal)) + facet_wrap(~condition) +
  geom_vline(xintercept = 60, lty=2, col="grey", size=1) +
  theme(legend.position = "bottom", legend.box = "vertical") +
  theme(strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12),
        plot.background = element_rect(fill = "transparent", color = NA),
        legend.background =  element_rect(fill = "transparent")
  ) +
  guides(col=guide_legend(title="Expression", nrow = 1, override.aes = list(alpha = 1)), 
         lty=guide_legend(title="", nrow = 1, override.aes = list(alpha = 1, size=0.5), order = 2)) +
  ylab("predicted rating") +
  xlab("event probability") +
  geom_line(aes(x=percentage_blue, y=rating_m, group=modal), data=plot_data %>% filter(pair != "Experiment 1") %>% rename(condition = pair) %>% mutate(src="experimental result")) +
  scale_linetype_manual(values=c("solid", "dashed"), labels=c("model prediction", "experimental result"), drop=F)

ggsave(posterior_plot, filename = "../plots/adaptation-posterior-predictions-replication.pdf", width = 30, height = 12, units = "cm")


mle_params = read.csv("../../../models/2_adaptation_model/bayesian-runs-balanced/theta-cost/cautious/mle_params.csv")

beta_density = data.table()

for (modal in beta_modals) {
  if (modal == "other") {
    next
  }
  alpha_param_name = paste("alpha", modal, sep="_")
  beta_param_name = paste("beta", modal, sep="_")
  
  alpha_param = mle_params[1,alpha_param_name]
  beta_param = mle_params[1,beta_param_name]
  
  x = seq(.001,0.999,.001)
  y = dbeta(x, alpha_param, beta_param)
  #y = y / (max(y))
  
  beta_density = rbind(beta_density, data.frame(x = x, y = y, modal = gsub("_", " ", modal), condition="cautious speaker"))
}


mle_params = read.csv("../../../models/2_adaptation_model/bayesian-runs-balanced/theta-cost/confident/mle_params.csv")


for (modal in beta_modals) {
  if (modal == "other") {
    next
  }
  alpha_param_name = paste("alpha", modal, sep="_")
  beta_param_name = paste("beta", modal, sep="_")
  
  alpha_param = mle_params[1,alpha_param_name]
  beta_param = mle_params[1,beta_param_name]
  
  x = seq(.001,0.999,.001)
  y = dbeta(x, alpha_param, beta_param)
  #y = y / (max(y))
  
  beta_density = rbind(beta_density, data.frame(x = x, y = y, modal = gsub("_", " ", modal), condition="confident speaker"))
}

beta_density$modal = factor(beta_density$modal, levels = modals_labels, ordered=T)

mle_params = read.csv("../../../models/1_threshold_modals/runs/threshold-model-expected/mle_params.csv")

for (modal in beta_modals) {
  if (modal == "other") {
    next
  }
  alpha_param_name = paste("alpha", modal, sep="_")
  beta_param_name = paste("beta", modal, sep="_")
  
  alpha_param = mle_params[1,alpha_param_name]
  beta_param = mle_params[1,beta_param_name]
  
  x = seq(.001,0.999,.001)
  y = dbeta(x, alpha_param, beta_param)
  #y = y / (max(y))
  
  beta_density = rbind(beta_density, data.frame(x = x, y = y, modal = gsub("_", " ", modal), condition="prior"))
}

threshold_distrs = ggplot(beta_density, aes(x=x, y=y, col=condition)) + 
  geom_line() + 
  facet_wrap(~modal, ncol = 4, scales = "free_y") + 
  xlab("threshold") +
  ylab("density") +
  theme(strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12),
        legend.position = "bottom") +
  guides(col=guide_legend(title="Condition", nrow = 1)) +
  cond_colscale

ggsave(threshold_distrs, filename = "../plots/adaptation-posterior-thresholds-replication.pdf", width = 30, height = 12, units = "cm")



mle_params = read.csv("../../../models/2_adaptation_model/bayesian-runs-balanced/theta-cost/cautious/mle_params.csv") 
mle_params = rbind(mle_params, read.csv("../../../models/2_adaptation_model//bayesian-runs-balanced/theta-cost/confident/mle_params.csv"))
mle_params = rbind(mle_params, read.csv("../../../models/1_threshold_modals/runs/threshold-model-expected/mle_params.csv") )

mle_params[3,"cost_might"] = 1.0
mle_params[3,"cost_probably"] = 1.0


mle_params$condition = c("cautious speaker", "confident speaker", "prior")
mle_params = mle_params %>% gather(key="Parameter", value="value", -condition)

cost_plot = mle_params %>% 
  filter(grepl("cost_", Parameter)) %>%
  mutate(Parameter = factor(gsub("cost_", "", Parameter), levels=modals, labels= modals_labels, ordered=TRUE)) %>%
  ggplot(aes(fill=condition, color=condition, y=log(value), x=Parameter)) +
  geom_bar(stat="identity", position = "dodge") +
  xlab("") + 
  ylab("log cost") +
  theme(strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12),
        legend.position = "bottom") +
  guides(fill=guide_legend(title="Condition", nrow = 1, override.aes = list(col="#999999", size=0.1)), col= "none", pch="none") +
  cond_colscale +
  cond_colscale_fill

ggsave(cost_plot, filename = "../plots/adaptation-posterior-costs-replication.pdf", width = 15, height = 12, units = "cm")



#### 
# Experiment 3
####

d.cautious = read.csv("../../../experiments/12_comprehension_coins_balanced/data/12_comprehension_coins_balanced-might-trials.csv")
d.confident = read.csv("../../../experiments/12_comprehension_coins_balanced/data/12_comprehension_coins_balanced-probably-trials.csv")
# re-number participants in confident speaker condition
d.confident$workerid = d.confident$workerid + max(d.cautious$workerid) + 1
d.cautious$condition = "cautious speaker"
d.confident$condition = "confident speaker"

d.comp = rbind(d.cautious, d.confident)
d.comp = remove_quotes(d.comp)
d.comp$catch_trial_answer_correct = -1

d.exp_trials.cautious = read.csv("../../../experiments/12_comprehension_coins_balanced/data/12_comprehension_coins_balanced-might-exp_trials.csv")
d.exp_trials.confident = read.csv("../../../experiments/12_comprehension_coins_balanced/data/12_comprehension_coins_balanced-probably-exp_trials.csv")

d.exp_trials.confident$workerid = d.exp_trials.confident$workerid + max(d.exp_trials.cautious$workerid) + 1

exp_trials = rbind(d.exp_trials.cautious, d.exp_trials.confident)

d.comp = exclude_participants(trials = (d.comp %>% mutate(catch_trial = 0)), exp_trials = exp_trials, cutoff = 4)
d.comp[d.comp$color=="orange", ]$percentage_blue = 100 - d.comp[d.comp$color=="orange", ]$percentage_blue

d.comp = d.comp %>% group_by(workerid, modal, color) %>% mutate(rating_norm = rating / sum(rating)) %>% ungroup()

comp.plot_data = d.comp %>% group_by(percentage_blue, modal, condition) %>% 
  summarize(rating_norm_mu = mean(rating_norm), 
            rating_norm_ci_low=ci.low(rating_norm), 
            rating_norm_ci_high=ci.high(rating_norm)) 

comp.plot = comp.plot_data %>% 
  ggplot(aes(x=percentage_blue, y=rating_norm_mu, col=condition)) + 
  geom_line(size=1) + 
  facet_wrap(~modal) +
  xlab("event probabilty") +
  ylab("mean normalized rating") +
  guides(col=guide_legend(title="", nrow = 1)) + 
  theme(legend.position="bottom", 
        strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12)) + 
  geom_errorbar(aes(ymin=rating_norm_mu - rating_norm_ci_low, ymax=rating_norm_mu + rating_norm_ci_high), width=5, size=1)

ggsave(comp.plot, file="../plots/exp-2-ratings.pdf", width = 30, height = 12, units = "cm")

comp.plot_condition = comp.plot_data %>% 
  ggplot(aes(x=percentage_blue, y=rating_norm_mu, col=modal)) + 
  geom_line(size=1) + 
  facet_wrap(~condition) +
  xlab("event probabilty") +
  ylab("mean normalized rating") +
  guides(col=guide_legend(title="Expression", nrow = 1)) + 
  geom_vline(xintercept = 60, lty=2, col="grey", size=1) +
  theme(legend.position="bottom", 
        legend.box = "vertical",
        strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12)) + 
  colscale(unique(comp.plot_data$modal)) +
  geom_errorbar(aes(ymin=rating_norm_mu - rating_norm_ci_low, ymax=rating_norm_mu + rating_norm_ci_high), width=5, size=1)

ggsave(comp.plot_condition, file="../plots/exp-2-condition-ratings.png", width = 15, height = 12, units = "cm")

#####
# comprehension model
#####

compute_correlation_for_comp_model = function(model_type, exp_data, model_path_suffix="") {
  
  exp_data = exp_data %>% mutate(rating = rating_norm)
  
  hdi_data.cautious = read.csv(paste("../../../models/3_comprehension_model/bayesian-runs", model_path_suffix, "/", model_type, "/cautious/hdi_samples.csv", sep="")) %>% mutate(condition = "cautious speaker")
  hdi_data.confident = read.csv(paste("../../../models/3_comprehension_model/bayesian-runs", model_path_suffix, "/", model_type, "/confident/hdi_samples.csv", sep=""))  %>% mutate(condition = "confident speaker")
  
  r2_cautious = post_adaptation_correlation(hdi_data.cautious, exp_data %>% filter(condition =="cautious speaker"))
  r2_confident = post_adaptation_correlation(hdi_data.confident, exp_data %>% filter(condition =="confident speaker"))
  
  r2_all = post_adaptation_correlation(rbind(hdi_data.cautious, hdi_data.confident), exp_data)
  cor_row = data.frame(model=model_type, r2_cautious = r2_cautious, r2_confident=r2_confident, r2_all=r2_all)
  return(cor_row)
}

c1 = compute_correlation_for_comp_model("theta-cost", d.comp, model_path_suffix = "-balanced")
c2 = compute_correlation_for_comp_model("cost", d.comp, model_path_suffix = "-balanced")
c3 = compute_correlation_for_comp_model("theta", d.comp, model_path_suffix = "-balanced")
c4 = compute_correlation_for_comp_model("prior", d.comp, model_path_suffix = "-balanced")

rbind(c1,c2,c3, c4)

hdi_data.cautious= read.csv(paste("../../../models/3_comprehension_model/bayesian-runs-balanced/theta-cost/cautious/hdi_samples.csv", sep=""))
hdi_data.confident = read.csv(paste("../../../models/3_comprehension_model/bayesian-runs-balanced/theta-cost/confident/hdi_samples.csv", sep=""))

hdi_data.cautious$condition = "cautious speaker"
hdi_data.confident$condition = "confident speaker"
hdi_data.all = rbind(hdi_data.cautious, hdi_data.confident)
hdi_data.all$condition = factor(hdi_data.all$condition, levels=c("cautious speaker", "prior", "confident speaker"), ordered = T)
hdi_data.all$modal = factor(hdi_data.all$modal, levels = modals, labels = modals_labels, ordered=T)
hdi_data.all$src = factor("model prediction", levels=c("model prediction", "experimental result"), ordered=T)
posterior_plot = hdi_data.all %>% 
    ggplot(aes(x=percentage_blue, col=condition, y=rating_pred, group=interaction(src,run,modal,condition))) +
    geom_line(aes(x=percentage_blue, y=rating_pred_m, group=condition), size=1, data = hdi_data.all %>% 
                               group_by(condition, modal, percentage_blue, src) %>%
                               summarize(rating_pred_m = mean(rating_pred))) + 
    facet_wrap(~modal) +
    theme(legend.position = "bottom", legend.box = "vertical") +
    theme(strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12)) + 
    guides(col=guide_legend(title="", nrow = 1, override.aes = list(alpha = 1))
                     ) +
    ylab("predicted rating") +
    xlab("event probability")


posterior_plot_combined = hdi_data.all %>% 
  ggplot(aes(x=percentage_blue, col=modal, y=rating_pred, lty=src, group=interaction(src,run,modal,condition))) +
  geom_line(alpha=.01) + 
  geom_line(aes(x=percentage_blue, y=rating_pred_m, group=modal), size=1, data = hdi_data.all %>% 
              group_by(condition, modal, percentage_blue, src) %>%
              summarize(rating_pred_m = mean(rating_pred))) + 
  facet_wrap(~condition) +
  theme(legend.position = "bottom", legend.box = "vertical") +
  theme(strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12)) + 
  colscale(unique(hdi_data.all$modal)) + 
  guides(col=guide_legend(title="Expression", nrow = 1, override.aes = list(alpha = 1)),
         lty=guide_legend(title="", nrow = 1, override.aes = list(size = 0.5))) +
  ylab("predicted rating") +
  xlab("event probability") + 
  geom_line(aes(x=percentage_blue, y=rating_norm_mu, group=interaction(src,modal,condition)), data= comp.plot_data %>% mutate(src="experimental result")) +
  scale_linetype_manual(values=c("solid", "dashed"), labels=c("model prediction", "experimental result"), drop=F)


ggsave(posterior_plot, file="../plots/adaptation-posterior-comp.pdf", width = 30, height = 12, units = "cm")
ggsave(posterior_plot_combined, file="../plots/adaptation-posterior-comp-data.png", width = 15, height = 12, units = "cm")
ggsave(posterior_plot_combined, file="../plots/adaptation-posterior-comp-data.pdf", width = 30, height = 12, units = "cm")


####
# Original comprehension experiment
####

d.cautious = read.csv("../../../experiments/2_comprehension/data/2_comprehension-might-trials.csv")
d.confident = read.csv("../../../experiments/2_comprehension/data/2_comprehension-probably-trials.csv")
# re-number participants in confident speaker condition
d.confident$workerid = d.confident$workerid + max(d.cautious$workerid) + 1
d.cautious$condition = "cautious speaker"
d.confident$condition = "confident speaker"

d.comp = rbind(d.cautious, d.confident)
d.comp = remove_quotes(d.comp)
d.comp$catch_trial_answer_correct = -1

d.exp_trials.cautious = read.csv("../../../experiments/2_comprehension/data/2_comprehension-might-exp_trials.csv")
d.exp_trials.confident = read.csv("../../../experiments/2_comprehension/data/2_comprehension-probably-exp_trials.csv")

d.exp_trials.confident$workerid = d.exp_trials.confident$workerid + max(d.exp_trials.cautious$workerid) + 1

exp_trials = rbind(d.exp_trials.cautious, d.exp_trials.confident)

d.comp = exclude_participants(trials = (d.comp %>% mutate(catch_trial = 0)), exp_trials = exp_trials, cutoff = 3)
d.comp[d.comp$color=="orange", ]$percentage_blue = 100 - d.comp[d.comp$color=="orange", ]$percentage_blue

d.comp = d.comp %>% group_by(workerid, modal, color) %>% mutate(rating_norm = rating / sum(rating)) %>% ungroup()

comp.plot_data = d.comp %>% group_by(percentage_blue, modal, condition) %>% 
  summarize(rating_norm_mu = mean(rating_norm), 
            rating_norm_ci_low=ci.low(rating_norm), 
            rating_norm_ci_high=ci.high(rating_norm)) 

comp.plot = comp.plot_data %>% 
  ggplot(aes(x=percentage_blue, y=rating_norm_mu, col=condition)) + 
  geom_line(size=1) + 
  facet_wrap(~modal) +
  xlab("event probabilty") +
  ylab("mean normalized rating") +
  guides(col=guide_legend(title="", nrow = 1)) + 
  theme(legend.position="bottom", 
        strip.text.x = element_text(size = 14), 
        legend.text=element_text(size=14), 
        legend.title = element_text(size=14),
        axis.title = element_text(size=14),
        axis.text = element_text(size=12)) + 
  geom_errorbar(aes(ymin=rating_norm_mu - rating_norm_ci_low, ymax=rating_norm_mu + rating_norm_ci_high), width=5, size=1)

ggsave(comp.plot, file="../plots/exp-2-ratings-orig.pdf", width = 30, height = 12, units = "cm")

