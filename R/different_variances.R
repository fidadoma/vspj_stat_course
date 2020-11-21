rm(list = ls())
library(tidyverse)
library(here)
library(qqplotr)
library(patchwork)
theme_set(theme_classic(16))
set.seed(18972)

n <- 50

df <- tibble(IQ = c(rnorm(n,100,15 ),rnorm(n,100,2)),
             skupina = c(rep("skupina 1", n), rep("skupina 2", n)))

df %>% ggplot(aes(x=skupina, y = IQ)) + geom_point(position = position_jitter(0.2))
