#!/bin/bash

Rscript ../analysis/merge_results.R 4_comprehension_pre_test-cond0-trials-round1.csv f 4_comprehension_pre_test-cond0-trials-round2.csv f 4_comprehension_pre_test-cond1-trials-round1.csv m 4_comprehension_pre_test-cond1-trials-round2.csv  m > 4_comprehension_pre_test-trials.csv 
Rscript ../analysis/merge_results.R 4_comprehension_pre_test-cond0-prod_trials-round1.csv f 4_comprehension_pre_test-cond0-prod_trials-round2.csv f 4_comprehension_pre_test-cond1-prod_trials-round1.csv m 4_comprehension_pre_test-cond1-prod_trials-round2.csv  m > 4_comprehension_pre_test-prod_trials.csv 

