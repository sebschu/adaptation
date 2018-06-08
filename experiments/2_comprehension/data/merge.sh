#!/bin/bash

Rscript ../analysis/merge_results.R 2_comprehension-cond0-trials-round1.csv f 2_comprehension-cond0-trials-round2.csv f 2_comprehension-cond0-trials-round3.csv f 2_comprehension-cond2-trials-round1.csv m 2_comprehension-cond2-trials-round2.csv  m 2_comprehension-cond2-trials-round3.csv  m > 2_comprehension-probably-trials.csv 
Rscript ../analysis/merge_results.R 2_comprehension-cond1-trials-round1.csv f 2_comprehension-cond1-trials-round2.csv f 2_comprehension-cond1-trials-round3.csv f 2_comprehension-cond3-trials-round1.csv m 2_comprehension-cond3-trials-round2.csv  m 2_comprehension-cond3-trials-round3.csv  m > 2_comprehension-might-trials.csv 
Rscript ../analysis/merge_results.R 2_comprehension-cond0-exp_trials-round1.csv f 2_comprehension-cond0-exp_trials-round2.csv f 2_comprehension-cond0-exp_trials-round3.csv f 2_comprehension-cond2-exp_trials-round1.csv m 2_comprehension-cond2-exp_trials-round2.csv  m 2_comprehension-cond2-exp_trials-round3.csv  m > 2_comprehension-probably-exp_trials.csv 
Rscript ../analysis/merge_results.R 2_comprehension-cond1-exp_trials-round1.csv f 2_comprehension-cond1-exp_trials-round2.csv f 2_comprehension-cond1-exp_trials-round3.csv f 2_comprehension-cond3-exp_trials-round1.csv m 2_comprehension-cond3-exp_trials-round2.csv  m 2_comprehension-cond3-exp_trials-round3.csv  m > 2_comprehension-might-exp_trials.csv 

