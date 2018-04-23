#!/bin/bash

Rscript ../../analysis/merge_results.R ../pilot/2_comprehension-cond0-trials.csv f ../pilot/2_comprehension-cond2-trials.csv m ../pilot3/2_comprehension-cond0-trials.csv f ../pilot3/2_comprehension-cond2-trials.csv m > 2_comprehension-probably-trials.csv 
Rscript ../../analysis/merge_results.R ../pilot/2_comprehension-cond1-trials.csv f ../pilot/2_comprehension-cond3-trials.csv m ../pilot3/2_comprehension-cond1-trials.csv f ../pilot3/2_comprehension-cond3-trials.csv m > 2_comprehension-might-trials.csv 
Rscript ../../analysis/merge_results.R ../pilot/2_comprehension-cond0-exp_trials.csv f ../pilot/2_comprehension-cond2-exp_trials.csv m ../pilot3/2_comprehension-cond0-exp_trials.csv f ../pilot3/2_comprehension-cond2-exp_trials.csv m> 2_comprehension-probably-exp_trials.csv 
Rscript ../../analysis/merge_results.R ../pilot/2_comprehension-cond1-exp_trials.csv f ../pilot/2_comprehension-cond3-exp_trials.csv m ../pilot3/2_comprehension-cond1-exp_trials.csv f ../pilot3/2_comprehension-cond3-exp_trials.csv m> 2_comprehension-might-exp_trials.csv 

