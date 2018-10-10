#!/bin/bash

Rscript ../analysis/merge_results.R 6_comprehension_balanced-cond0-trials.csv f 6_comprehension_balanced-cond2-trials.csv m > 6_comprehension_balanced-probably-trials.csv 
Rscript ../analysis/merge_results.R 6_comprehension_balanced-cond1-trials.csv f 6_comprehension_balanced-cond3-trials.csv m > 6_comprehension_balanced-might-trials.csv 
Rscript ../analysis/merge_results.R 6_comprehension_balanced-cond0-exp_trials.csv f 6_comprehension_balanced-cond2-exp_trials.csv m > 6_comprehension_balanced-probably-exp_trials.csv 
Rscript ../analysis/merge_results.R 6_comprehension_balanced-cond1-exp_trials.csv f 6_comprehension_balanced-cond3-exp_trials.csv m > 6_comprehension_balanced-might-exp_trials.csv 

