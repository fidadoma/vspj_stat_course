library(tidyverse)
n <- 100
set.seed(5)

d <- 
  tibble(height    = rnorm(n, mean = 10, sd = 2),
         leg_prop  = runif(n, min = 0.4, max = 0.5)) %>% 
  mutate(leg_left  = leg_prop * height + rnorm(n, mean = 0, sd = 0.02),
         leg_right = leg_prop * height + rnorm(n, mean = 0, sd = 0.02))

d
