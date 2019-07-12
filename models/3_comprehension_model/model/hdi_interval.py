import numpy as np
from scipy.stats import beta, uniform, bernoulli, norm
import time, json
import sys
import os
import argparse
import copy
import csv
import glob

from threshold_model import ThresholdModel

class HDISampler(ThresholdModel):
  def __init__(self, config, output_path, run, filenames=None):
    super().__init__(config, output_path, run)
    self.filenames = filenames
    self.load_mcmc_samples()
      
  def load_data(self):
    data = {"conditions": self.config["conditions"]}
    return data
  
  def load_mcmc_samples(self):
    self.mcmc_samples = []
    if self.filenames is None:
      samples_file_path = os.path.join(self.output_path, "samples.json")
      self.mcmc_samples = json.load(open(samples_file_path, "r"))
    else:
      for samples_file_path in glob.glob(os.path.join(self.output_path, self.filenames)):
         self.mcmc_samples.extend(json.load(open(samples_file_path, "r")))
    
    n_samples = self.config["hdi_estimation_samples"]
    self.mcmc_samples = np.random.choice(self.mcmc_samples, size=n_samples, replace=False)

  
  def get_params(self, sample):
      rat_alpha = sample["rat_alpha"]
      utt_other_prob = sample["utt_other_prob"]
      noise_strength = sample["noise_strength"]
      costs = []
      theta_alphas = []
      theta_betas = []
      for i, utt in enumerate(self.config["utterances"]):
        theta_alphas.append(sample["alpha_" + utt["form"]])
        theta_betas.append(sample["beta_" + utt["form"]]) 
        costs.append(sample["cost_" + utt["form"]])
      return (theta_alphas, theta_betas, costs, rat_alpha, utt_other_prob, noise_strength)
  
  def generate_hdi_samples(self):
    fieldnames = ['modal', 'percentage_blue', 'cond', 'rating_pred', 'run']
    output_file_name = os.path.join(self.output_path, "hdi_samples.csv")
    writer = csv.DictWriter(open(output_file_name, "w"), fieldnames=fieldnames)
    writer.writeheader()
    
    #we only consider the outputs that correspond to gumball machines in the expreiment
    output_cols = [0, 2, 5, 8, 10, 12, 15, 18, 20]
    
    for it, sample in enumerate(self.mcmc_samples):
      theta_alphas, theta_betas, costs, rat_alpha, utt_other_prob, noise_strength = self.get_params(sample)
      for cond in self.data["conditions"]:
        expr_1, expr_2 = cond.split("-")
        listener_probs =  self.listener_dist(costs, -1, -1, rat_alpha, theta_alphas, theta_betas, utt_other_prob, noise_strength)[:, output_cols]
        listener_probs = listener_probs / np.reshape(np.sum(listener_probs, axis=1), (len(self.expressions) + 1, 1))
        for i in range(len(output_cols)):
          for j, utt in enumerate([expr_1, expr_2, "bare"]):
            utt_idx = self.expressions2idx[utt]
            hdi_sample = {"modal": utt, "percentage_blue": output_cols[i] * 5, "cond": cond, "rating_pred": listener_probs[utt_idx, i], "run": it}
            writer.writerow(hdi_sample)
      
      if it > 0 and it % 100 == 0:
        print("Iteration: ", it)
        
      
      if it > 0 and it % 20000 == 0:
        self.speaker_matrix_cache.clear()
        self.theta_prior_cache.clear()


def main():
  parser = argparse.ArgumentParser()
  parser.add_argument("--out_dir", required=True)
  parser.add_argument("--filenames", required=False)
  args = parser.parse_args()
  
  out_dir = args.out_dir
  config_file_path = os.path.join(out_dir, "config.json")
  config = json.load(open(config_file_path, "r"))
  
  model = HDISampler(config, out_dir, "", filenames=args.filenames)
  model.generate_hdi_samples()

        
if __name__ == '__main__':
  main()
  