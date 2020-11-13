rm(list = ls())
library(tidyverse)
library(patchwork)
library(here)
library(papaja)
theme_set(theme_classic(12))


format_ttest<-function(tt) {
  sprintf("t(%d) = %.2f, p = %.3f", tt$parameter, tt$statistic, tt$p.value)
}


set.seed(946)

n <- 10
y1 <- rnorm(n,100,15)
y2 <- rnorm(n,110,15)


tt <- t.test(y~x, df, var.equal = T)

df <- tibble(y = c(y1,y2), x = c(rep("group1",n), rep("group2",n)))
p1 <- df %>% ggplot(aes(x=x,y)) + stat_summary(fun.data = "mean_cl_boot") + 
  geom_point(alpha =0.2, position = position_jitter(0.2))+
  theme(aspect.ratio =1) + 
  ggtitle(t.test(y~x, df, var.equal = T) %>% format_ttest(),
          subtitle = sprintf("n=%d",n))

n <- 30
y1 <- rnorm(n,100,15)
y2 <- rnorm(n,110,15)


tt <- t.test(y~x, df, var.equal = T)

df <- tibble(y = c(y1,y2), x = c(rep("group1",n), rep("group2",n)))
p2 <- df %>% ggplot(aes(x=x,y)) + stat_summary(fun.data = "mean_cl_boot") + 
  geom_point(alpha =0.2, position = position_jitter(0.2))+
  theme(aspect.ratio =1) + 
  ggtitle(t.test(y~x, df, var.equal = T) %>% format_ttest(),
          subtitle = sprintf("n=%d",n))

n <- 1000
y1 <- rnorm(n,100,15)
y2 <- rnorm(n,110,15)


tt <- t.test(y~x, df, var.equal = T)

df <- tibble(y = c(y1,y2), x = c(rep("group1",n), rep("group2",n)))
p3 <- df %>% ggplot(aes(x=x,y)) + stat_summary(fun.data = "mean_cl_boot") + 
  geom_point(alpha =0.2, position = position_jitter(0.2))+
  theme(aspect.ratio =1) + 
  ggtitle(t.test(y~x, df, var.equal = T) %>% format_ttest(),
          subtitle = sprintf("n=%d",n))

p1 + p2 +p3


set.seed(947)

n <- 10
y1 <- rnorm(n,100,15)
y2 <- rnorm(n,101,15)


tt <- t.test(y~x, df, var.equal = T)

df <- tibble(y = c(y1,y2), x = c(rep("group1",n), rep("group2",n)))
p1 <- df %>% ggplot(aes(x=x,y)) + stat_summary(fun.data = "mean_cl_boot") + 
  geom_point(alpha =0.2, position = position_jitter(0.2))+
  theme(aspect.ratio =1) + 
  ggtitle(t.test(y~x, df, var.equal = T) %>% format_ttest(),
          subtitle = sprintf("n=%d",n))

n <- 30
y1 <- rnorm(n,100,15)
y2 <- rnorm(n,101,15)


tt <- t.test(y~x, df, var.equal = T)

df <- tibble(y = c(y1,y2), x = c(rep("group1",n), rep("group2",n)))
p2 <- df %>% ggplot(aes(x=x,y)) + stat_summary(fun.data = "mean_cl_boot") + 
  geom_point(alpha =0.2, position = position_jitter(0.2))+
  theme(aspect.ratio =1) + 
  ggtitle(t.test(y~x, df, var.equal = T) %>% format_ttest(),
          subtitle = sprintf("n=%d",n))

n <- 5000
y1 <- rnorm(n,100,15)
y2 <- rnorm(n,101,15)


tt <- t.test(y~x, df, var.equal = T)
cd <- effsize::cohen.d(y~x, df, var.equal = T)
df <- tibble(y = c(y1,y2), x = c(rep("group1",n), rep("group2",n)))
p3 <- df %>% ggplot(aes(x=x,y)) +
  geom_point(alpha =0.1, position = position_jitter(0.2))+
  stat_summary(fun.data = "mean_cl_boot", col = "red") + 
  theme(aspect.ratio =1) + 
  ggtitle(t.test(y~x, df, var.equal = T) %>% format_ttest(),
          subtitle = sprintf("n=%d",n))

p1 + p2 + p3
