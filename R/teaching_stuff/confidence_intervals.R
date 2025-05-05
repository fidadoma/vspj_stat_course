rm(list = ls())
library(tidyverse)
library(here)
theme_set(theme_classic(16))
set.seed(1972)

iris %>% 
  ggplot(aes(x=Species, y = Petal.Length)) + 
  stat_summary(fun.data = "mean_cl_boot") +
  theme(aspect.ratio = 1) + 
  ylab("Délka okvětních lístků")+ 
  xlab("Druh kosatace")
