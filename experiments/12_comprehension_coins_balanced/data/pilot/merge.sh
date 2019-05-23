#!/bin/bash

Rscript ../../analysis/merge_results.R 12_comprehension_coins_balanced-cond0-trials.csv f 12_comprehension_coins_balanced-cond2-trials.csv m > 12_comprehension_coins_balanced-probably-trials.csv 
Rscript ../../analysis/merge_results.R 12_comprehension_coins_balanced-cond1-trials.csv f 12_comprehension_coins_balanced-cond3-trials.csv m > 12_comprehension_coins_balanced-might-trials.csv 
Rscript ../../analysis/merge_results.R 12_comprehension_coins_balanced-cond0-exp_trials.csv f 12_comprehension_coins_balanced-cond2-exp_trials.csv m > 12_comprehension_coins_balanced-probably-exp_trials.csv 
Rscript ../../analysis/merge_results.R 12_comprehension_coins_balanced-cond1-exp_trials.csv f 12_comprehension_coins_balanced-cond3-exp_trials.csv m > 12_comprehension_coins_balanced-might-exp_trials.csv 

