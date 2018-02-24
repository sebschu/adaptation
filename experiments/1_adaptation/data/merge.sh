#!/bin/bash

Rscript ../analysis/merge_results.R 1_adaptation-cond0-trials.csv f 1_adaptation-cond2-trials.csv m > 1_adaptation-probably-trials.csv 
Rscript ../analysis/merge_results.R 1_adaptation-cond1-trials.csv f 1_adaptation-cond3-trials.csv m > 1_adaptation-might-trials.csv 
Rscript ../analysis/merge_results.R 1_adaptation-cond0-exp_trials.csv f 1_adaptation-cond2-exp_trials.csv m > 1_adaptation-probably-exp_trials.csv 
Rscript ../analysis/merge_results.R 1_adaptation-cond1-exp_trials.csv f 1_adaptation-cond3-exp_trials.csv m > 1_adaptation-might-exp_trials.csv 

