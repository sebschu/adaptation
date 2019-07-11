import json
import os


def update_config(config, theta_mu_sd, theta_nu_scale, cost_sd):
  for utt in config["utterances"]:
    utt["prior"]["mu_sd"] = theta_mu_sd
    utt["prior"]["cost_sd"] = cost_sd
  
  config["theta_nu_scale"] = theta_nu_scale
  
  config["proposal_widths"]["theta_mu"] =  theta_mu_sd / 20.0
  config["proposal_widths"]["theta_nu"] =  theta_nu_scale / 20.0
  config["proposal_widths"]["cost"] =  cost_sd / 20.0
  
  return config
    

config_template_cautious = json.load(open("template_cautious.json", "r"))
config_template_confident = json.load(open("template_confident.json", "r"))



theta_mu_sds = [0, .025, .05, 0.075, .1, .125, .15, .175, .2]
theta_nu_scales = [0, .5, 1, 1.5, 2.5, 3.5]
#cost_sds = [0, .1, .3, .5, .7, .9, 1.1, 1.3, 1.5]
cost_sds = [ 1.1, 1.3, 1.5]


for tms in theta_mu_sds:
  if tms > 0:
    theta_nu_scales2 = theta_nu_scales[1:]
  else:
    theta_nu_scales2 = [0]  
  
  for tns in theta_nu_scales2:
      for cs in cost_sds:
        config_cautious = update_config(config_template_cautious, tms, tns, cs)
        config_confident = update_config(config_template_confident, tms, tns, cs)
        dirname = "mu-{}_nu-{}_cost-{}".format(tms, tns, cs)
        os.mkdir(dirname)
        os.mkdir(dirname + "/cautious")
        os.mkdir(dirname + "/confident")
        json.dump(config_cautious, open(dirname + "/cautious/config.json", "w"), indent=2)
        json.dump(config_confident, open(dirname + "/confident/config.json", "w"), indent=2)
        
