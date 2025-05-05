library(tidyverse)
N <- 200
b_GP <- 1
b_GC <- 0
b_PC <- 1
b_U <- 2

set.seed(1)

U <- 2*rethinking::rbern(N, 0.5) - 1
G <- rnorm(N)
P <- rnorm(N, b_GP*G + b_U*U)
C <- rnorm(N, b_PC*P + b_GC*G + b_U*U)
df <- tibble(C,P,G,U)
