rm(list = ls())
library(tidyverse)
library(here)
theme_set(theme_classic(16))

df <- read_csv("data/data_w_genres.csv")

df_folk <- df %>%
  filter(str_detect(genres, "indie folk")) %>% 
  mutate(zanr = "indie folk")

df_rocknroll <- df %>%
  filter(str_detect(genres, "rock-and-roll"))  %>% 
  mutate(zanr = "rock 'n roll")

df_rap <- df %>%
  filter(str_detect(genres, "hip hop")) %>% 
  mutate(zanr = "hip hop")

df <- rbind(df_folk, df_rocknroll, df_rap) %>% 
  mutate(duration_sec = round(duration_ms/1000)) %>% 
  select(zanr, umelec = artists, akusticnost = acousticness, tanecni_potencial = danceability, celkove_trvani_pisni_v_sekundach = duration_sec, instrumentalnost = instrumentalness, zivost = liveness, hlasitost = loudness, mnozstvi_mluveneho_slova = speechiness, popularita = popularity, pocet_pisni =  count)

write_csv2(df, path = "data/spotify.csv")
