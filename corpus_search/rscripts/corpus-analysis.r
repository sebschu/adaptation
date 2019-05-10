library(tidyverse)

theme_set(theme_bw(18))
source("helpers.r")

d = read_tsv(file="../data/swbd.tab")

d %>%
  count(Expression) %>%
  arrange(n)

View(d %>%
  filter(Expression == "definitely") %>%
  select(Context,Sentence))

View(d %>%
       filter(Expression == "certainly") %>%
       select(Context,Sentence))
