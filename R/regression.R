library(tidyverse)
library(patchwork)
theme_set(theme_classic(16))


week_in_year <- c(7,18,25,13,14,24)
lazy_hours <- c(19,26,31,24,27,30)

df <- tibble(`týden v roce` = week_in_year,
             `počet prolelkovaných hodin` = lazy_hours)

df %>% 
  ggplot(aes(x =`týden v roce`,y = `počet prolelkovaných hodin`)) + 
  geom_point() + 
  theme(aspect.ratio = 1)


# regression SK student --------------------------------------------------------------

set.seed(816)

df <- readxl::read_excel("data/pocet-duchodcu-s-exekucni-srazkou-podle-kraju.xlsx")

df %>% 
  mutate(datum_str = as.character(datum)) %>% 
  filter(datum_str == "2020-06-30") %>% 
  ggplot(aes(x = `pocet_duchodcu`,
              y = `prumerna_vyse_duchodu`, 
             col = druh_duchodu)) +
  geom_point() + 
  theme(aspect.ratio = 1)

df_males_oldage_lastdata <- df %>% 
  mutate(datum_str = as.character(datum)) %>% 
  filter(datum_str == "2020-06-30", druh_duchodu_kod == "PK_OLDAGE_S8", pohlavi_kod == "M") 
lm1 <- lm(prumerna_vyse_duchodu~pocet_duchodcu, df_males_oldage_lastdata)
df_predict <- tibble(pocet_duchodcu = df_males_oldage_lastdata$pocet_duchodcu, 
                     prumerna_vyse_duchodu = lm1$fitted.values)

segments <- df_males_oldage_lastdata %>% left_join(df_predict %>% rename(prumerna_vyse_duchodu_end = prumerna_vyse_duchodu), by = "pocet_duchodcu")
lm1$coefficients[1]
df_males_oldage_lastdata %>% 
  ggplot(aes(x = `pocet_duchodcu`,
             y = `prumerna_vyse_duchodu` 
             )) +
  geom_point() + 
  theme(aspect.ratio = 1) + 
  xlab("Počet důchodců") +
  ylab("Průměrná výče důchodu") + 
  geom_smooth(method ="lm", se = F) + 
  geom_point(data = df_predict, col = "red") + 
  geom_segment(data = segments, aes(xend = pocet_duchodcu, yend = prumerna_vyse_duchodu_end))

df_males_oldage_lastdata %>% left_join(df_predict %>% rename(prumerna_vyse_duchodu_end = prumerna_vyse_duchodu), by = "pocet_duchodcu")
