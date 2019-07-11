# Script to estimate parameter distributions based on output from
# Python model

library(rwebppl)
library(dplyr)
library(tidyverse)
library(truncnorm)
library(ggmcmc)


## helper functions

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

## reparameterize model based o 

reparam = function(d) {
  modals = c("bare", "could", "looks_like", "might", "probably", "think", "bare_not")

  for (modal in modals) {
    alpha_param_name = paste("alpha_", modal, sep="")
    beta_param_name = paste("beta_", modal, sep="")
    mu_param_name = paste("mu_", modal, sep="")
    var_param_name = paste("var_", modal, sep="")
    nu_param_name = paste("nu_", modal, sep="")
    
        
    alpha = d[, alpha_param_name]
    beta = d[, beta_param_name]
    
    mu =  alpha / (alpha + beta)
    var = alpha * beta / ((alpha + beta)^2 * (alpha + beta + 1))
    nu = alpha + beta
    
    
    d[, mu_param_name] = mu
    d[, var_param_name] = var
    d[, nu_param_name] = nu
  }
  return(d)
}

write_adaptation_mle = function(root_dir, model) {
  d = convertData(paste(root_dir, "/", model, "/cautious/run1_output.json", sep=""))
  d = reparam(d)
  c1 = tidy_sampleList(d, 2, 1, list())
  
  d = convertData(paste(root_dir, "/", model, "/cautious/run2_output.json", sep=""))
  d = reparam(d)
  c2 = tidy_sampleList(d, 2, 1, list())
  mcmc_samples = rbind(c1,c2)
  
  final_params_all = mcmc_samples %>% group_by(Parameter) %>% summarise(med=median(value), mu = mean(value), low=quantile(value, 0.025), high=quantile(value, 0.975), sd_all=sd(value))
  final_params_mu = final_params_all %>% select(Parameter, mu) %>% spread(key=Parameter, value=mu)
  write.csv(x = final_params_mu, file = paste(root_dir, "/", model, "/cautious/mle_params.csv", sep=""))
  
  
  d = convertData(paste(root_dir, "/", model, "/confident/run1_output.json", sep=""))
  d = reparam(d)
  c1 = tidy_sampleList(d, 2, 1, list())
  
  d = convertData(paste(root_dir, "/", model, "/confident/run2_output.json", sep=""))
  d = reparam(d)
  c2 = tidy_sampleList(d, 2, 1, list())
  mcmc_samples = rbind(c1,c2)
  
  final_params_all = mcmc_samples %>% group_by(Parameter) %>% summarise(med=median(value), mu = mean(value), low=quantile(value, 0.025), high=quantile(value, 0.975), sd_all=sd(value))
  final_params_mu = final_params_all %>% select(Parameter, mu) %>% spread(key=Parameter, value=mu)
  write.csv(x = final_params_mu, file = paste(root_dir, "/", model, "/confident/mle_params.csv", sep=""))
  
}

setwd("/Users/sebschu/Dropbox/Uni/RA/adaptation/adaptation/models/")


#################################################
# Analyze the output of the norming study model
#################################################
d = convertData("./1_threshold_modals/runs/threshold-model-expected/run1_output.json")
d = reparam(d)
c1 = tidy_sampleList(d, 4, 1, list())

d = convertData("./1_threshold_modals/runs/threshold-model-expected/run2_output.json")
d = reparam(d)
c2 = tidy_sampleList(d, 4, 2, list())

d = convertData("./models/1_threshold_modals/runs/threshold-model-expected/run3_output.json")
d = reparam(d)
c3 = tidy_sampleList(d, 4, 3, list())

d = convertData("./models/1_threshold_modals/runs/threshold-model-expected/run4_output.json")
d = reparam(d)
c4 = tidy_sampleList(d, 4, 4, list())

mcmc_samples = rbind(c1,c2,c3,c4)

# Check for convergence

ggs_Rhat(mcmc_samples)

final_params_all = mcmc_samples %>% 
  group_by(Parameter) %>% 
  summarise(med=median(value), 
            mu = mean(value), 
            low=quantile(value, 0.025), 
            high=quantile(value, 0.975), 
            sd_all=sd(value))
final_params_mu = final_params_all %>% 
  select(Parameter, mu) %>% 
  spread(key=Parameter, value=mu)

write.csv(x = final_params_mu, 
          file = "./1_threshold_modals/runs/threshold-model-expected/mle_params.csv")



### adaptation


write_adaptation_mle("./2_adaptation_model/bayesian-runs/", "theta-cost")
write_adaptation_mle("./2_adaptation_model/bayesian-runs/", "theta")
write_adaptation_mle("./2_adaptation_model/bayesian-runs/", "cost")

write_adaptation_mle("./2_adaptation_model/bayesian-runs-balanced/", "theta-cost")
write_adaptation_mle("./2_adaptation_model/bayesian-runs-balanced/", "theta")
write_adaptation_mle("./2_adaptation_model/bayesian-runs-balanced/", "cost")






