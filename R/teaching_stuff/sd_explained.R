library(tidyverse)
theme_set(theme_classic(16))

set.seed(954)
n <- 15
x <- sample(1:50, n, replace = T)

df <- tibble(`id pozorování` = 1:n, x = x)

df %>% 
  ggplot(aes(x = `id pozorování`, y = x)) + 
  geom_point() + 
  theme(aspect.ratio = 1)

df %>% 
  ggplot(aes(x = `id pozorování`, y = x)) + 
  geom_point() + 
  theme(aspect.ratio = 1) +
  geom_hline(yintercept = mean(x))

df %>% 
  ggplot(aes(x = `id pozorování`, y = x)) + 
  geom_point() + 
  theme(aspect.ratio = 1) +
  geom_hline(yintercept = mean(x)) + 
  geom_segment(aes(xend = `id pozorování`, yend = mean(x)))

df %>% 
  mutate(x = x^2) %>% 
  ggplot(aes(x = `id pozorování`, y = x)) + 
  geom_point() + 
  theme(aspect.ratio = 1) +
  geom_hline(yintercept = 0) + 
  geom_segment(aes(xend = `id pozorování`, yend = 0)) + 
  ylab("(x-průměr)^2")
