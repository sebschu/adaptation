#!/bin/bash

for i in $(seq 15 20)
do
  Rscript ../analysis/merge_results.R 0_pre_test-cond${i}-trials-round1.csv 0_pre_test-cond${i}-trials-round2.csv 0_pre_test-cond${i}-trials-round3.csv > 0_pre_test-cond${i}-trials.csv
done


