rm(list = ls())
library(tidyverse)
library(here)
theme_set(theme_classic(16))


x <- rbinom(10000, 20, 0.5)
df <- tibble(x = x)
df_norm_approx <- tibble(x=min(x):max(x), y=dnorm(x, 20*0.5, sqrt(20*0.5*0.5)))

df %>% 
  ggplot(aes(x)) +
  geom_histogram(bins = 18)


df %>% 
  ggplot(aes(x)) +
  geom_histogram(bins = 18,aes(y=..count../sum(..count..))) + 
  theme(aspect.ratio = 1) +
  geom_path(data = df_norm_approx, aes(x,y), col = "red")
