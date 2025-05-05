library(tidyverse)
library(patchwork)
theme_set(theme_classic(16))

set.seed(55954)
n <- 100


r <- 0.1
df <- generate_correlated_data(n,r) %>% as_tibble()
colnames(df) <- c("x","y")
rho <- cor(df$x,df$y, method = "spearman")

p1 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("r = %.2f, r_sp = %.2f", r, rho))

r <- 0.3
df <- generate_correlated_data(n,r) %>% as_tibble()
colnames(df) <- c("x","y")
rho <- cor(df$x,df$y, method = "spearman")

p2 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("r = %.2f, r_sp = %.2f", r, rho))

r <- 0.5

df <- generate_correlated_data(n,r) %>% as_tibble()
colnames(df) <- c("x","y")
rho <- cor(df$x,df$y, method = "spearman")

p3 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("r = %.2f, r_sp = %.2f", r, rho))

r <- 0.7
df <- generate_correlated_data(n,r) %>% as_tibble()
colnames(df) <- c("x","y")
rho <- cor(df$x,df$y, method = "spearman")

p4 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("r = %.2f, r_sp = %.2f", r, rho))

r <- 0.9
df <- generate_correlated_data(n,r) %>% as_tibble()
colnames(df) <- c("x","y")
rho <- cor(df$x,df$y, method = "spearman")

p5 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("r = %.2f, r_sp = %.2f", r, rho))

r <- 1
df <- generate_correlated_data(n,r) %>% as_tibble()
colnames(df) <- c("x","y")
rho <- cor(df$x,df$y, method = "spearman")

p6 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("r = %.2f, r_sp = %.2f", r, rho))

p1 + p2 + p3 + p4 + p5 + p6

set.seed(459)
n <- 15
r <- 0.7
df <- generate_correlated_data(n,r) %>% as_tibble()
colnames(df) <- c("x","y")
df$x[1] <- -4
df$y[1] <- 3
rho <- cor(df$x,df$y, method = "spearman")
rx <- cor(df$x,df$y)

px <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("r = %.2f, r_sp = %.2f", rx, rho))
px
