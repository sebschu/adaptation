#!/bin/bash

Rscript ../analysis/merge_results.R 5_adaptation_balanced-cond0-trials-round1.csv f 5_adaptation_balanced-cond0-trials-round2.csv f 5_adaptation_balanced-cond0-trials-round3.csv f 5_adaptation_balanced-cond2-trials-round2.csv m 5_adaptation_balanced-cond2-trials-round1.csv m 5_adaptation_balanced-cond2-trials-round3.csv m > 5_adaptation_balanced-probably-trials.csv 
Rscript ../analysis/merge_results.R 5_adaptation_balanced-cond1-trials-round1.csv f 5_adaptation_balanced-cond1-trials-round2.csv f 5_adaptation_balanced-cond1-trials-round3.csv f 5_adaptation_balanced-cond3-trials-round2.csv m 5_adaptation_balanced-cond3-trials-round1.csv m 5_adaptation_balanced-cond3-trials-round3.csv m > 5_adaptation_balanced-might-trials.csv 
Rscript ../analysis/merge_results.R 5_adaptation_balanced-cond0-exp_trials-round1.csv f 5_adaptation_balanced-cond0-exp_trials-round2.csv f 5_adaptation_balanced-cond0-exp_trials-round3.csv f 5_adaptation_balanced-cond2-exp_trials-round2.csv m 5_adaptation_balanced-cond2-exp_trials-round1.csv m 5_adaptation_balanced-cond2-exp_trials-round3.csv m > 5_adaptation_balanced-probably-exp_trials.csv 
Rscript ../analysis/merge_results.R 5_adaptation_balanced-cond1-exp_trials-round1.csv f 5_adaptation_balanced-cond1-exp_trials-round2.csv f 5_adaptation_balanced-cond1-exp_trials-round3.csv f 5_adaptation_balanced-cond3-exp_trials-round2.csv m 5_adaptation_balanced-cond3-exp_trials-round1.csv m 5_adaptation_balanced-cond3-exp_trials-round3.csv m > 5_adaptation_balanced-might-exp_trials.csv 

