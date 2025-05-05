rm(list = ls())
library(tidyverse)
library(here)
theme_set(theme_classic(16))

basic <- read_tsv("data/imdb_basic.tsv")
rating <- read_tsv("data/imdb_ratings.tsv")
df <- basic %>% left_join(rating)

df %>% colnames()
df_2019 <- df %>% filter(startYear == 2019, titleType %in% c("movie", "tvMovie","tvSeries")) %>% 
  mutate(
typ = case_when(
  str_detect(genres,"Horror") ~ "Horror",
  str_detect(genres,"Action") ~ "Akční",
  str_detect(genres,"Drama") ~ "Drama",
  str_detect(genres,"Family") ~ "Rodinný",
  TRUE ~"něco jiného"
))
write_csv2(df_2019, path = "data/imdb.csv")
