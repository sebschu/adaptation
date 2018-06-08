#!/bin/bash

Rscript ../../analysis/merge_results.R 3_comprehension_prior-cond0-trials.csv f 3_comprehension_prior-cond2-trials.csv m > 3_comprehension_prior-probably-trials.csv 
Rscript ../../analysis/merge_results.R 3_comprehension_prior-cond1-trials.csv f 3_comprehension_prior-cond3-trials.csv m > 3_comprehension_prior-might-trials.csv 
Rscript ../../analysis/merge_results.R 3_comprehension_prior-cond0-exp_trials.csv f 3_comprehension_prior-cond2-exp_trials.csv m > 3_comprehension_prior-probably-exp_trials.csv 
Rscript ../../analysis/merge_results.R 3_comprehension_prior-cond1-exp_trials.csv f 3_comprehension_prior-cond3-exp_trials.csv m > 3_comprehension_prior-might-exp_trials.csv 

