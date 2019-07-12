import json
import os
import glob
import numpy as np

def parse_dir_name(dir_name):
  parts = dir_name.strip("/").split("_")
  return [float(p.split("-")[1]) for p in parts]

models = {"prior": [], "cost": [], "theta": [], "theta-cost": []}

cost_marginals = {}
theta_mu_marginals = {}
theta_nu_marginals = {}

max_likelihood = -10000000
max_likelihood_params = ""

max_likelihood_cost = -10000000
max_likelihood_params_cost = ""
max_likelihood_theta = -10000000
max_likelihood_params_theta = ""


for d in glob.glob('mu-*'):
  mu, nu, cost = parse_dir_name(d)
  
  with open(os.path.join(d, "cautious/likelihood"), "r") as lklhd_f:
    likelihood1 = float(lklhd_f.readline().strip())
    
  with open(os.path.join(d, "confident/likelihood"), "r") as lklhd_f:
    likelihood2 = float(lklhd_f.readline().strip())
  
  likelihood = likelihood1 + likelihood2
  
  if likelihood > max_likelihood:
    max_likelihood = likelihood
    max_likelihood_params = d
  
  if mu == 0 and cost == 0:
    models["prior"].append(likelihood)
  elif mu == 0 and cost > 0:
    if likelihood > max_likelihood_cost:
      max_likelihood_cost = likelihood
      max_likelihood_params_cost = d
    models["cost"].append(likelihood)
  elif mu > 0 and cost == 0:
    if likelihood > max_likelihood_theta:
      max_likelihood_theta = likelihood
      max_likelihood_params_theta = d
    models["theta"].append(likelihood)
  else:
    models["theta-cost"].append(likelihood)
    
  
  if mu not in theta_mu_marginals:
    theta_mu_marginals[mu] = []
  theta_mu_marginals[mu].append(likelihood)  

  if nu not in theta_nu_marginals:
    theta_nu_marginals[nu] = []
  theta_nu_marginals[nu].append(likelihood)  
  
  if cost not in cost_marginals:
    cost_marginals[cost] = []
  cost_marginals[cost].append(likelihood)
  
#  with open(os.path.join(d, "cautious/likelihood"), "r") as lklhd_f:
#    likelihood1 = float(lklhd_f.readline().strip())
#    
#  with open(os.path.join(d, "confident/likelihood"), "r") as lklhd_f:
#    likelihood2 = float(lklhd_f.readline().strip())
#  
#  likelihood = likelihood1 + likelihood2
#  
#
#  theta_mu_marginals[mu].append(likelihood)  
#  theta_nu_marginals[nu].append(likelihood)  
#  cost_marginals[cost].append(likelihood)
  
  
print("MLE parameters")  
print(max_likelihood_params, max_likelihood)
print(max_likelihood_params_cost, max_likelihood_cost)
print(max_likelihood_params_theta, max_likelihood_theta)
print("-" * 80)
print("mu")


for key in theta_mu_marginals:
  a = np.array(theta_mu_marginals[key])
  theta_mu_marginals[key] = np.logaddexp.reduce(a)

theta_mu_denom_array = np.array([float(x) for x in theta_mu_marginals.values()])
theta_mu_denom = np.logaddexp.reduce(theta_mu_denom_array)
for key in sorted(theta_mu_marginals.keys(), key=float):
  print(key, theta_mu_marginals[key] - theta_mu_denom)

print("-" * 80)
print("nu")

for key in theta_nu_marginals:
  a = np.array(theta_nu_marginals[key])
  theta_nu_marginals[key] = np.logaddexp.reduce(a)

theta_nu_denom_array = np.array([float(x) for x in theta_nu_marginals.values()])
theta_nu_denom = np.logaddexp.reduce(theta_nu_denom_array)
for key in sorted(theta_nu_marginals.keys(), key=float):
  print(key, theta_nu_marginals[key] - theta_nu_denom)

print("-" * 80)
print("costs")

for key in cost_marginals:
  a = np.array(cost_marginals[key])
  cost_marginals[key] = np.logaddexp.reduce(a)

cost_denom_array = np.array([float(x) for x in cost_marginals.values()])
cost_denom = np.logaddexp.reduce(cost_denom_array)
for key in sorted(cost_marginals.keys(), key=float):
  print(key, cost_marginals[key] - cost_denom)
print("-" * 80)
print("models")

model_likelihoods = {}  

for key in models:
  a = np.array(models[key])
  model_likelihoods[key] = np.logaddexp.reduce(a) - np.log(len(a))


denom_array = np.array([float(x) for x in model_likelihoods.values()])
denom = np.logaddexp.reduce(denom_array)

print(model_likelihoods)

for key in model_likelihoods:
  print(key, model_likelihoods[key] - denom)
    

