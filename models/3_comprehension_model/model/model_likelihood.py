import numpy as np
from scipy.stats import beta, uniform, bernoulli, norm
import time, json
import sys
import os
import argparse
import copy
import csv
import glob

OUTPUT_COLS = [0, 2, 5, 8, 10, 12, 15, 18, 20]


from threshold_model import ThresholdModel

class ModelLikelihood(ThresholdModel):
  def __init__(self, config, output_path, run, filenames=None):
    super().__init__(config, output_path, run)
    self.filenames = filenames
    self.load_mcmc_samples()
  
  def load_mcmc_samples(self):
    self.mcmc_samples = []
    if self.filenames is None:
      samples_file_path = os.path.join(self.output_path, "samples.json")
      self.mcmc_samples = json.load(open(samples_file_path, "r"))
    else:
      for samples_file_path in glob.glob(os.path.join(self.output_path, self.filenames)):
         self.mcmc_samples.extend(json.load(open(samples_file_path, "r")))
      
  
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
  
  def compute_likelihood(self, costs, rat_alpha, theta_alphas, theta_betas, utt_other_prob, noise_strength):
    listener_probs =  self.listener_dist(costs, -1, -1, rat_alpha, theta_alphas, theta_betas, utt_other_prob, noise_strength)[:, OUTPUT_COLS]
    listener_probs = np.log(listener_probs / np.reshape(np.sum(listener_probs, axis=1), (len(self.expressions) + 1, 1)))
    sample_likelihood = np.sum(np.multiply(self.data, listener_probs))
    return sample_likelihood
    
  def load_data(self):
    raw_data = json.load(open(self.config["data_path"], "r"))
    count_arrays = np.zeros((len(self.expressions) + 1, self.probabilities_len))
    for d in raw_data:
      col_idx = self.prob2idx[d["percentage_blue"]]
      row_idx = self.expressions2idx[d["modal"]]
      count_arrays[row_idx, col_idx] += 1
    return count_arrays[:, OUTPUT_COLS]
  
  
  def generate_hdi_samples(self):
    
    likelihood = 0
    theta_alphas, theta_betas, costs, rat_alpha, utt_other_prob, noise_strength = self.get_params(self.mcmc_samples[0])
    first_likelihood = self.compute_likelihood(costs, rat_alpha, theta_alphas, theta_betas, utt_other_prob, noise_strength)
        
    for it, sample in enumerate(self.mcmc_samples):
      theta_alphas, theta_betas, costs, rat_alpha, utt_other_prob, noise_strength = self.get_params(sample)
      if it > 0:
        likelihood = np.logaddexp(self.compute_likelihood(costs, rat_alpha, theta_alphas, theta_betas, utt_other_prob, noise_strength) - first_likelihood, likelihood)
      else:
        likelihood = self.compute_likelihood(costs, rat_alpha, theta_alphas, theta_betas, utt_other_prob, noise_strength) - first_likelihood
                  
      if it > 0 and it % 100 == 0:
        print("Iteration: ", it)
      
      if it > 0 and it % 20000 == 0:
        self.speaker_matrix_cache.clear()
        self.theta_prior_cache.clear()
    likelihood += first_likelihood - np.log(len(self.mcmc_samples))
    with open(os.path.join(self.output_path, "likelihood"), "w") as out_f:
      print(likelihood, file=out_f)
    
def main():
  parser = argparse.ArgumentParser()
  parser.add_argument("--out_dir", required=True)
  parser.add_argument("--filenames", required=False)
  args = parser.parse_args()
  
  out_dir = args.out_dir
  config_file_path = os.path.join(out_dir, "config.json")
  config = json.load(open(config_file_path, "r"))
  
  model = ModelLikelihood(config, out_dir, "", filenames=args.filenames)
  model.generate_hdi_samples()

        
if __name__ == '__main__':
  main()
  