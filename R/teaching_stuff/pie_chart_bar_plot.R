library(tidyverse)

count.data <- data.frame(
  cestujici = c("1. trida", "2. trida", "3. trida", "Posadka"),
  n = c(325, 285, 706, 885),
  prop = c(14.8, 12.9, 32.1, 40.2)
)
count.data <- count.data %>%
  arrange(desc(cestujici)) %>%
  mutate(lab.ypos = cumsum(prop) - 0.5*prop) %>% 
  mutate(lab.ypos2 = 1:4)
count.data

mycols <- c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF")

ggplot(count.data, aes(x = "", y = prop, fill = cestujici)) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  coord_polar("y", start = 0)+
  geom_text(aes(y = lab.ypos, label = prop), color = "white")+
  scale_fill_manual(values = mycols) +
  theme_void(16)

ggplot(count.data, aes(x = cestujici, y = prop, fill = cestujici)) +
  geom_bar(stat = "identity", color = "white") +
  geom_text(aes(x = cestujici, y = 5,label = prop), color = "white")+
  scale_fill_manual(values = mycols)
  
