#!/bin/bash

Rscript ../analysis/merge_results.R 5_adaptation_balanced-cond0-trials.csv f 5_adaptation_balanced-cond2-trials.csv m > 5_adaptation_balanced-probably-trials.csv 
Rscript ../analysis/merge_results.R 5_adaptation_balanced-cond1-trials.csv f 5_adaptation_balanced-cond3-trials.csv m > 5_adaptation_balanced-might-trials.csv 
Rscript ../analysis/merge_results.R 5_adaptation_balanced-cond0-exp_trials.csv f 5_adaptation_balanced-cond2-exp_trials.csv m > 5_adaptation_balanced-probably-exp_trials.csv 
Rscript ../analysis/merge_results.R 5_adaptation_balanced-cond1-exp_trials.csv f 5_adaptation_balanced-cond3-exp_trials.csv m > 5_adaptation_balanced-might-exp_trials.csv 

