
setwd("~/Dropbox/Uni/RA/adaptation/adaptation/models/1_threshold_modals/param-estimation-output/")

library(rwebppl)
library(dplyr)
library(tidyverse)


convertData = function(output_file) {

output_string <- paste(readLines(output_file, warn = F),
                       collapse = "\n")
if (output_string != "") {
  output <- jsonlite::fromJSON(output_string, flatten = TRUE)
  if (!is.null(names(output))) {
    return(tidy_output(output, chains = 1,
                       chain = 1))
  }
}
}

is_mcmc <- function(output) {
  ((names(output)[1] == "score") & 
     all(grepl("value", names(output)[2:length(names(output))])))
}

is_rejection <- function(output) {
  all(grepl("value", names(output)))
}

is_sampleList <- function(output) {
  is_mcmc(output) || is_rejection(output)
}

is_probTable <- function(output){
  all(names(output) %in% c("probs", "support"))
}

isOptimizeParams <- function(output){
  (all(c("dims", "length") %in% names(output[[1]])) &&
     all(c("dims", "length") %in% names(output[[length(output)]])))
}

# Try to use inference_opts to determine # samples; otherwise use size of list
countSamples <- function(output, inference_opts) {
  if(!(is.null(inference_opts[["samples"]]))) {
    return(inference_opts[["samples"]])
  } else if (!(is.null(inference_opts[["particles"]]))) {
    return(inference_opts[["particles"]])
  } else {
    return(nrow(output))
  }
}

tidy_probTable <- function(output) {
  if (class(output$support) == "data.frame") {
    support <- output$support
  } else {
    support <- data.frame(support = output$support)
  }
  return(cbind(support, data.frame(prob = output$probs)))
}

tidy_sampleList <- function(output, chains, chain, inference_opts) {
  names(output) <- gsub("value.", "", names(output))
  num_samples <- countSamples(output, inference_opts)
  # as of webppl v0.9.6, samples come out in the order they were collected
  output$Iteration <- 1:num_samples 
  ggmcmc_samples <- tidyr::gather_(
    output, key_col = "Parameter", value_col = "value",
    gather_cols = names(output)[names(output) != "Iteration"],
    factor_key = TRUE
  )
  ggmcmc_samples$Chain <- chain
  ggmcmc_samples <- ggmcmc_samples[,c("Iteration", "Chain", "Parameter", "value")] # reorder columns
  attr(ggmcmc_samples, "nChains") <- chains
  attr(ggmcmc_samples, "nParameters") <- ncol(output) - 1
  attr(ggmcmc_samples, "nIterations") <- num_samples
  attr(ggmcmc_samples, "nBurnin") <- ifelse(is.null(inference_opts[["burn"]]), 0, inference_opts[["burn"]])
  attr(ggmcmc_samples, "nThin") <- ifelse(is.null(inference_opts[["thin"]]), 1, inference_opts[["thin"]])
  attr(ggmcmc_samples, "description") <- ifelse(is.null(inference_opts[["method"]]), "", inference_opts[["method"]])
  return(ggmcmc_samples)
}

tidy_output <- function(output, chains = NULL, chain = NULL, inference_opts = NULL) {
  if (is_probTable(output)) {
    return(tidy_probTable(output))
  } else if (is_sampleList(output)) {
    # Drop redundant score column, if it exists
    if ("score" %in% names(output)) { 
      output <- output[, names(output) != 'score', drop = F]
    } 
    return(tidy_sampleList(output, chains, chain, inference_opts))
  } else {
    return(output)
  }
}


estimate_mode <- function(x) {
  d <- density(x)
  d$x[which.max(d$y)]
}

outputfile = "../param-estimation-output-20k/output_all_run1.json"

params = convertData(outputfile) %>% 
 # filter(Iteration == max(.$Iteration))
  filter(Iteration > 7500)
  
#for (i in seq(2,3)) {
#  outputfile = paste("../param-estimation-output-20k/output_all_run", i, ".json", sep="")
#  params2 = convertData(outputfile)  %>% 
#    filter(Iteration > 7500)
#  params = rbind(params, params2)
#}

final_params = params %>% group_by(Parameter) %>% summarise(med=median(value), mu = mean(value), mode = estimate_mode(value), low=quantile(value, 0.025), high=quantile(value, 0.975), var=var(value))

beta_params = params %>% filter(., grepl("cost|rat", Parameter) == FALSE)
final_beta_params =  final_params %>% filter(., grepl("cost|rat", Parameter) == FALSE)


cost_params = params %>% filter(., grepl("cost", Parameter))
final_cost_params =  final_params %>% filter(., grepl("cost", Parameter))



#
ggplot(beta_params, aes(x=value)) + geom_histogram(bins=40) + facet_wrap(~Parameter) + geom_vline(aes(xintercept=med, color="red"), data=final_beta_params)
#
#ggplot(cost_params, aes(x=value)) + geom_histogram(bins=10) + facet_wrap(~Parameter) + geom_vline(aes(xintercept=mode, color="red"), data=final_cost_params)
#ggplot(params %>% filter(., grepl("rat_alpha", Parameter)) , aes(x=value)) + geom_histogram(bins=10) + geom_vline(aes(xintercept=mode, color="red"), data=final_params %>% filter(., grepl("rat_alpha", Parameter)))

final_params_med = final_params[,1:2] %>% spread(., key=Parameter, value = med, drop = TRUE)

write.csv(x = final_params_med, file = "../param-estimation-output-20k/params_all.csv")


for (cond in seq(0, 14)) {
  outputfile =  paste("../param-estimation-output-20k/output_no_cond_", cond, "_run1.json", sep="")
  
  params = convertData(outputfile) %>% 
    # filter(Iteration == max(.$Iteration))
    filter(Iteration > 7500)
  
  #for (i in seq(2,3)) {
  #  outputfile = paste("../param-estimation-output-20k/output_no_cond_", cond, "_run", i, ".json", sep="")
  #  params2 = convertData(outputfile)  %>% 
  #    filter(Iteration > 7500)
  #  params = rbind(params, params2)
  #}
  
  final_params = params %>% group_by(Parameter) %>% summarise(med=median(value), mu = mean(value), mode = estimate_mode(value))
  
  beta_params = params %>% filter(., grepl("cost|rat", Parameter) == FALSE)
  final_beta_params =  final_params %>% filter(., grepl("cost|rat", Parameter) == FALSE)
  
  
  cost_params = params %>% filter(., grepl("cost", Parameter))
  final_cost_params =  final_params %>% filter(., grepl("cost", Parameter))
  
  
  
  #ggplot(beta_params, aes(x=value)) + geom_histogram(bins=15) + facet_wrap(~Parameter) + geom_vline(aes(xintercept=med, color="red"), data=final_beta_params)
  #
  #ggplot(cost_params, aes(x=value)) + geom_histogram(bins=10) + facet_wrap(~Parameter) + geom_vline(aes(xintercept=med, color="red"), data=final_cost_params)
  #
  #ggplot(params %>% filter(., grepl("rat_alpha", Parameter)) , aes(x=value)) + geom_histogram(bins=10) + geom_vline(aes(xintercept=med, color="red"), data=final_params %>% filter(., grepl("rat_alpha", Parameter)))
  
  final_params_med = final_params[,1:2] %>% spread(., key=Parameter, value = med, drop = TRUE)
  
  write.csv(x = final_params_med, file = paste("../param-estimation-output-20k/params_no_cond_", cond, ".csv", sep=""))
}


