# Comprehension experiment

We have two conditions (probably-biased and might-biased) with a male and female speaker.

## Participants

MTurk participants with US IP addresses and >95% approval. For each condition, we run 40 participants. Within each condition, 20 participants see the male speaker and 20 participants see the female speaker.


## Exclusion criteria

We exclude participants who provide the wrong answer to more than 2 of the 5 catch trials.

## Procedure

See the following web-based experiments: 

- Probably-biased condition, female speaker:
  https://stanford.edu/~sebschu/experiments/2_comprehension/experiment-cond-0.html
- Might-biased condition, female speaker:
  https://stanford.edu/~sebschu/experiments/2_comprehension/experiment-cond-1.html
- Probably-biased condition, male speaker:
  https://stanford.edu/~sebschu/experiments/2_comprehension/experiment-cond-2.html
- Might-biased condition, male speaker:
  https://stanford.edu/~sebschu/experiments/2_comprehension/experiment-cond-3.html

## Predictions

We predict that the difference in AUC between the might ratings and the probably ratings will be significantly higher in the might-biased condition than in the probably-based condition.

Based on participants' ratings, we compute the expected value of the distribution of the likelhood of the event happening after hearing an uncertainty expressions, i.e., E[P(event happening) | uncertainty expression].

We predict that

* E[P(event happening) | might] will be lower in the probably-biased condition than in the might-biased condition
* E[P(event happening) | probably] will be lower in the probably-biased condition than in the might-biased condition


## Analysis

See [analysis/analysis.Rmd](analysis/analysis.Rmd) for the exact analysis procedures.

