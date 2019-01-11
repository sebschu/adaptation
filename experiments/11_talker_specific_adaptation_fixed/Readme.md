# Speaker-specific adaptation experiment

Each participant sees two speakers: a male and a female speaker. One of them is the "confident" speaker and the other one is the "cautious" speaker. After exposure to both speakers, participants rate how likely they think it is that each of the speakers would use the different uncertainty expressions in 

## Controls

We assign 13 (1/8 of all participants) to all possible combinations of these three variables.

- whether the "cautious" or "confident" exposure phase is presented first
- whether the male or the female speaker is the "confident" speaker
- whether the test blocks ("cautious" and "confident") are presented in the same order as in the exposure phase or the opposite order.

We do not expect any of these variables to have an effect on participant's ratings.

## Participants

MTurk participants with US IP addresses and >95% approval. In total, we collect data from 104 participants.

## Exclusion criteria

We exclude participants who provide the wrong answer to more than 25% of the catch trials (i.e., participants who provide the correct answer to less than 11/14 catch trials.)

We further exclude participants who seem to provide random ratings independent of the scene that they are seeing. We quantify this by computing the mean rating for each utterance across all trials for each participant and computing the correlation between a participant's actual ratings and their mean rating. A high correlation is unexpected and indicates that a participant chose ratings at random. We therefore also exclude the data from participants for whom this correlation is larger than 0.75.

## Procedure

See the following web-based experiments: 

- "cautious" first, "confident" speaker is male, test phase order the same as exposure phase order
  https://stanford.edu/~sebschu/experiments/11_talker_specific_adaptation_fixed/experiment-cond-0.html
- "cautious" first, "confident" speaker is female, test phase order the same as exposure phase order
  https://stanford.edu/~sebschu/experiments/11_talker_specific_adaptation_fixed/experiment-cond-1.html
- "confident" first, "confident" speaker is male, test phase order the same as exposure phase order
  https://stanford.edu/~sebschu/experiments/11_talker_specific_adaptation_fixed/experiment-cond-2.html
- "confident" first, "confident" speaker is female, test phase order the same as exposure phase order
  https://stanford.edu/~sebschu/experiments/11_talker_specific_adaptation_fixed/experiment-cond-3.html
- "cautious" first, "confident" speaker is male, test phase order the same as exposure phase order
  https://stanford.edu/~sebschu/experiments/11_talker_specific_adaptation_fixed/experiment-cond-4.html
- "cautious" first, "confident" speaker is female, test phase order is the reverse of exposure phase order  
  https://stanford.edu/~sebschu/experiments/11_talker_specific_adaptation_fixed/experiment-cond-5.html
- "confident" first, "confident" speaker is male, test phase order is the reverse of exposure phase order
  https://stanford.edu/~sebschu/experiments/11_talker_specific_adaptation_fixed/experiment-cond-6.html
- "confident" first, "confident" speaker is female, test phase order is the reverse of exposure phase order
  https://stanford.edu/~sebschu/experiments/11_talker_specific_adaptation_fixed/experiment-cond-7.html


## Predictions

We predict that the difference in AUC between the might ratings and the probably ratings will be significantly higher when participants are providing ratings for the "confident" speaker than when they are providing ratings for the "cautious" speaker.
  
## Analysis

See [analysis/analysis.Rmd](analysis/analysis.Rmd) for the exact analysis procedures.

## Pilots

We conducted one pilot experiment with students in a class that we taught. The experiment did not lead to significant results and as a result, we modified the manipulation and changed the random order of trials into a block design. The experiment as well as the results can be found [here](../7_adaptation_ling_145).

We further ran another version of this experiment which contained a bug (both speakers were either the "confident" speaker or the "cautious" speaker). The code and results of the faulty experiment can be found [here](../10_talker_specific_adaptation)
