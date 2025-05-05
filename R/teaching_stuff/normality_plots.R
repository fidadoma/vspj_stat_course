rm(list = ls())
library(tidyverse)
library(here)
library(qqplotr)
library(patchwork)
theme_set(theme_classic(16))
set.seed(18972)

x <- runif(50, 15, 25)
y <- rnorm(50, 20, 2)
y2 <- rnorm(200, 20, 2)

df <- tibble(x)

df %>% ggplot(aes(x = x)) + geom_histogram() + theme(aspect.ratio = 1) + ylab("Počet") + xlab("Počet bodů v testu")

p2 <- df %>% ggplot(aes(sample = x))  +
  stat_qq_line() +
  stat_qq_point() +
  labs(x = "Teoretické kvantily", y = "Kvanitily dat")
  
df <- tibble(y)

df %>% ggplot(aes(x = y)) + geom_histogram() + theme(aspect.ratio = 1) + ylab("Počet") + xlab("Počet bodů v testu")

p1 <- df %>% ggplot(aes(sample = y))  +
  stat_qq_line() +
  stat_qq_point() +
  labs(x = "Teoretické kvantily", y = "Kvanitily dat")


df <- tibble(y2)

df %>% ggplot(aes(x = y2)) + geom_histogram() + theme(aspect.ratio = 1) + ylab("Počet") + xlab("Počet bodů v testu")

p3 <- df %>% ggplot(aes(sample = y2))  +
  stat_qq_line() +
  stat_qq_point() +
  labs(x = "Teoretické kvantily", y = "Kvanitily dat")

p1 + p2 +p3
