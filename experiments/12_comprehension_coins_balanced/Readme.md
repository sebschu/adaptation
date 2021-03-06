# Comprehension experiment

We have two conditions (probably-biased and might-biased) with a male and female speaker.

## Participants

MTurk participants with US IP addresses and >95% approval. For each condition, we run 40 participants. Within each condition, 20 participants see the male speaker and 20 participants see the female speaker.


## Exclusion criteria

We exclude participants who provide the wrong answer to more than 2 of the 6 catch trials.

## Procedure

See the following web-based experiments: 

- Probably-biased condition, female speaker:
   
   https://stanford.edu/~sebschu/experiments/12_comprehension_coins_balanced/experiment-cond-0.html
- Might-biased condition, female speaker:
   
   https://stanford.edu/~sebschu/experiments/12_comprehension_coins_balanced/experiment-cond-1.html
- Probably-biased condition, male speaker:
   
   https://stanford.edu/~sebschu/experiments/12_comprehension_coins_balanced/experiment-cond-2.html
- Might-biased condition, male speaker:
   
   https://stanford.edu/~sebschu/experiments/12_comprehension_coins_balanced/experiment-cond-3.html

## Predictions

Based on participants' distributionns of coins, we compute the expected value of the distribution of the likelhood of the event happening after hearing an uncertainty expressions, i.e., E[P(event happening) | uncertainty expression].

We predict that

* E[P(event happening) | might] will be lower in the probably-biased condition than in the might-biased condition
* E[P(event happening) | probably] will be lower in the probably-biased condition than in the might-biased condition


## Analysis

See [analysis/analysis.Rmd](analysis/analysis.Rmd) for the exact analysis procedures.

## Previous experiments

This experiment is a modified version of two previous experiments. This experiment differs in how participants provide ratings. In previous versions, participants used sliders to rate likely interpretations; in this version, participants rate different intepretations by distributing 10 coins.

See [2_comprehension](../2_comprehension) and [6_comprehension_balanced](../6_comprehension_balanced) in this repositiory for more information about the previous experiments.
