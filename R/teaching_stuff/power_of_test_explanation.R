rm(list = ls())
library(tidyverse)
library(here)
library(qqplotr)
library(patchwork)
theme_set(theme_classic(16))
set.seed(18972)

x0 <- seq(-10,80,by=0.01)
g1 <- dnorm(x0, mean = 20, sd = 5)
g2 <- dnorm(x0, mean = 30, sd = 5)

df <- tibble(x = c(x0,x0), 
             hustota = c(g1,g2), skupina = c(rep("skupina 1", length(x0)), rep("skupina 2", length(x0))))

df %>% filter(skupina == "skupina 1") %>% 
  ggplot(aes(x = x, y =hustota)) + geom_path() + 
  theme(aspect.ratio = 1) + 
  xlim(-5,45)

df %>% filter(skupina == "skupina 1") %>% 
  ggplot(aes(x = x, y =hustota)) + geom_path() + 
  theme(aspect.ratio = 1) + 
  xlim(-5,45) + 
  geom_vline(xintercept = c(qnorm(c(0.025,0.975),mean = 20, sd = 5)))
df %>% 
  ggplot(aes(x = x, y =hustota, col = skupina)) + geom_path() + 
  theme(aspect.ratio = 1) + 
  theme(legend.position = "none") +
  xlim(-5,55) 

df %>% 
  ggplot(aes(x = x, y =hustota, col = skupina)) + geom_path() + 
  theme(aspect.ratio = 1) + 
  theme(legend.position = "none") +
  geom_vline(xintercept = c(qnorm(c(0.975),mean = 20, sd = 5)))+
  xlim(-5,55) 

df %>% 
  ggplot(aes(x = x, y =hustota, col = skupina)) + geom_path() + 
  theme(aspect.ratio = 1) + 
  theme(legend.position = "none") +
  geom_vline(xintercept = 24.9)+
  xlim(-5,55) 

qnorm(0.975,mean = 20, sd = 5)
