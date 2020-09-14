library(tidyverse)
theme_set(theme_classic(16))

# n=20 ------------------------------------------------------------------

set.seed(193)
n <- 20
x <- rnorm(n, mean = 100,15)
x2 <- x; x2[1] <- 200
x3 <- x; x3[1] <- 500
x4 <- x; x4[1] <- 10000

df <- tibble(x)

df %>% 
  ggplot(aes(x = x)) + 
  geom_histogram() + 
  geom_vline(xintercept = mean(x), col = "blue", size = 1.5) +
  ggtitle(sprintf("Histogram z %d dat",n),subtitle = sprintf("Průměr: %.2f. Median: %.2f", mean(x),median(x)))

df %>% 
  ggplot(aes(x = x2)) + 
  geom_histogram() + 
  geom_vline(xintercept = mean(x), col = "blue", size = 1.5) +
  ggtitle(sprintf("Histogram z %d dat",n),subtitle = sprintf("Průměr: %.2f. Median: %.2f", mean(x2),median(x2)))


df %>% 
  ggplot(aes(x = x3)) + 
  geom_histogram() + 
  geom_vline(xintercept = mean(x), col = "blue", size = 1.5) +
  ggtitle(sprintf("Histogram z %d dat",n),subtitle = sprintf("Průměr: %.2f. Median: %.2f", mean(x3),median(x3)))

df %>% 
  ggplot(aes(x = x4)) + 
  geom_histogram() + 
  geom_vline(xintercept = mean(x), col = "blue", size = 1.5) +
  ggtitle(sprintf("Histogram z %d dat",n),subtitle = sprintf("Průměr: %.2f. Median: %.2f", mean(x4),median(x4)))


# n=2000 ------------------------------------------------------------------

set.seed(194)
n <- 2000
x <- rnorm(n, mean = 100,15)
x2 <- x; x2[1] <- 200
x3 <- x; x3[1] <- 500
x4 <- x; x4[1] <- 10000

df <- tibble(x)

df %>% 
  ggplot(aes(x = x)) + 
  geom_histogram() + 
  geom_vline(xintercept = mean(x), col = "blue", size = 1.5) +
  ggtitle(sprintf("Histogram z %d dat",n),subtitle = sprintf("Průměr: %.2f. Median: %.2f", mean(x),median(x)))

df %>% 
  ggplot(aes(x = x2)) + 
  geom_histogram() + 
  geom_vline(xintercept = mean(x), col = "blue", size = 1.5) +
  ggtitle(sprintf("Histogram z %d dat",n),subtitle = sprintf("Průměr: %.2f. Median: %.2f", mean(x2),median(x2)))


df %>% 
  ggplot(aes(x = x3)) + 
  geom_histogram() + 
  geom_vline(xintercept = mean(x), col = "blue", size = 1.5) +
  ggtitle(sprintf("Histogram z %d dat",n),subtitle = sprintf("Průměr: %.2f. Median: %.2f", mean(x3),median(x3)))

df %>% 
  ggplot(aes(x = x4)) + 
  geom_histogram() + 
  geom_vline(xintercept = mean(x), col = "blue", size = 1.5) +
  ggtitle(sprintf("Histogram z %d dat",n),subtitle = sprintf("Průměr: %.2f. Median: %.2f", mean(x4),median(x4)))
