library(tidyverse)
library(patchwork)
theme_set(theme_classic(16))

set.seed(5954)
n <- 100

generate_correlated_data <- function(n,r) {
  MASS::mvrnorm(n=n, mu=c(0, 0), Sigma=matrix(c(1, r, r, 1), nrow=2), empirical=TRUE)
}

r <- 0.1
df <- generate_correlated_data(n,r) 
colnames(df) <- c("x","y")


p1 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("Korelace = %.2f",r))

r <- 0.3
df <- generate_correlated_data(n,r) 
colnames(df) <- c("x","y")


p2 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("Korelace = %.2f",r))

r <- 0.5
df <- generate_correlated_data(n,r) 
colnames(df) <- c("x","y")


p3 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("Korelace = %.2f",r))

r <- 0.7
df <- generate_correlated_data(n,r) 
colnames(df) <- c("x","y")


p4 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("Korelace = %.2f",r))

r <- 0.9
df <- generate_correlated_data(n,r) 
colnames(df) <- c("x","y")


p5 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("Korelace = %.2f",r))

r <- 1
df <- generate_correlated_data(n,r) 
colnames(df) <- c("x","y")


p6 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("Korelace = %.2f",r))

p1 + p2 + p3 + p4 + p5 + p6



r <- 0.6
df <- generate_correlated_data(n,r) 
colnames(df) <- c("x","y")


p1 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("Korelace = %.2f",r))

r <- -0.6
df <- generate_correlated_data(n,r) 
colnames(df) <- c("x","y")


p2 <- df %>% as_tibble() %>% 
  ggplot(aes(x,y)) + 
  geom_point() + 
  theme(aspect.ratio = 1) + 
  ggtitle(sprintf("Korelace = %.2f",r))

p1 + p2