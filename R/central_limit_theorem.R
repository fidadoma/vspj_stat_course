rm(list = ls())
library(tidyverse)
library(here)
theme_set(theme_classic(16))
set.seed(1967)

x <- rbeta(100000,40,2)
Ex <- 40/(40+2)
df <- tibble(x = x)

df %>% ggplot(aes(x)) +
  geom_histogram(bins = 150,aes(y=..count../sum(..count..))) + 
  theme(aspect.ratio = 1) + 
  ylab("hustota")

set.seed(1964)
x <- rbeta(50,40,2)
df1 <- tibble(x = x)

df1 %>% ggplot(aes(x)) +
  geom_histogram(bins = 18,aes(y=..count../sum(..count..))) + 
  theme(aspect.ratio = 1) + 
  ylab("hustota")

set.seed(1962)
x <- rbeta(50,40,2)
df2 <- tibble(x = x)

df2 %>% ggplot(aes(x)) +
  geom_histogram(bins = 18,aes(y=..count../sum(..count..))) + 
  theme(aspect.ratio = 1) + 
  ylab("hustota")

set.seed(1960)
x <- rbeta(50,40,2)
df3 <- tibble(x = x)

df3 %>% ggplot(aes(x)) +
  geom_histogram(bins = 18,aes(y=..count../sum(..count..))) + 
  theme(aspect.ratio = 1) + 
  ylab("hustota")
mean(df3$x)

df_means <- tibble(mx = c(mean(df1$x),mean(df2$x),mean(df3$x)))
df_means_all <- df_means
set.seed(456)
for (i in 1:9997) {
  x <- rbeta(50,40,2)
  df_means_all <- rbind(df_means_all, tibble(mx = mean(x)))
}

df_means %>% ggplot(aes(mx)) +
  geom_bar() + 
  theme(aspect.ratio = 1) + 
  xlim(df_means_all$mx %>% range()) + 
  ylim(0,1000)

df_means_all %>% ggplot(aes(mx)) +
  geom_histogram() + 
  theme(aspect.ratio = 1) + 
  ylab("hustota")                  

                                      