#!/bin/bash

Rscript ../analysis/merge_results.R 1_adaptation-cond0-trials-round1.csv f 1_adaptation-cond0-trials-round2.csv f 1_adaptation-cond0-trials-round3.csv f 1_adaptation-cond2-trials-round1.csv m 1_adaptation-cond2-trials-round2.csv  m 1_adaptation-cond2-trials-round3.csv  m > 1_adaptation-probably-trials.csv 
Rscript ../analysis/merge_results.R 1_adaptation-cond1-trials-round1.csv f 1_adaptation-cond1-trials-round2.csv f 1_adaptation-cond1-trials-round3.csv f 1_adaptation-cond3-trials-round1.csv m 1_adaptation-cond3-trials-round2.csv  m 1_adaptation-cond3-trials-round3.csv  m > 1_adaptation-might-trials.csv 
Rscript ../analysis/merge_results.R 1_adaptation-cond0-exp_trials-round1.csv f 1_adaptation-cond0-exp_trials-round2.csv f 1_adaptation-cond0-exp_trials-round3.csv f 1_adaptation-cond2-exp_trials-round1.csv m 1_adaptation-cond2-exp_trials-round2.csv  m 1_adaptation-cond2-exp_trials-round3.csv  m > 1_adaptation-probably-exp_trials.csv 
Rscript ../analysis/merge_results.R 1_adaptation-cond1-exp_trials-round1.csv f 1_adaptation-cond1-exp_trials-round2.csv f 1_adaptation-cond1-exp_trials-round3.csv f 1_adaptation-cond3-exp_trials-round1.csv m 1_adaptation-cond3-exp_trials-round2.csv  m 1_adaptation-cond3-exp_trials-round3.csv  m > 1_adaptation-might-exp_trials.csv 

