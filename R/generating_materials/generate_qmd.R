library(googlesheets4)
library(tidyverse)
library(ellmer)
library(glue)
library(here)
library(purrr)

make_filename <- function(text) {
  # 1. Odstranění diakritiky (přes iconv)
  text <- iconv(text, from = "UTF-8", to = "ASCII//TRANSLIT")
  
  # 2. Odstranění speciálních znaků (např. otazník)
  text <- gsub("[^a-zA-Z0-9 ]", "", text)
  
  # 3. Převod na malá písmena
  text <- tolower(text)
  
  # 4. Nahrazení mezer podtržítky
  text <- gsub(" +", "_", text)
  
  return(text)
}

questions_data <- read_sheet("https://docs.google.com/spreadsheets/d/1wYAsc5R6yTmNfMY2ZO72dYL5MWuxHoNcZTKxFpBu-jA")


chat <- chat_openai(model = "gpt-4o",
                    system_prompt = "Dostaneš na vstupu otázku ze statistiky. Vytvoř pro ní studijní materiál pro studenty vysoké školy (studenti nejsou nejbystřejší, takže hodně vysvětluj). Lepší je, aby to bylo delší, ale více vysvětlené. U otázky uveď příklady z běžného života, kde si to můžeou představit. 
                    Používej hezké formátování. Výstup ulož jako quarto qmd soubor, aby z toho pak šel udělat snadno quarto web. 
                    Udělej to jako self-contained html. Nic nevysvětluj, vrať jen qmd. Přidej toto do yaml hlavičky:
                    author: Filip Děchtěrenko
                    date: \"`r Sys.Date()`\"
                    execute:
  warning: false
  message: false
  cache: false
format:
  html:
    toc: true
    code-fold: true
    code-summary: \"Show the code\"
    embed-resources: true
editor: source")

qmd_dir <- here("R/generating_materials/qmds")

questions_data <- questions_data %>% 
  slice_head(n = 5)

walk(questions_data$question_text, function(qtext) {
  # Získání odpovědi od chatu
  q_response <- chat$chat(qtext)
  
  # Úprava YAML hlavičky
  q_response <- q_response %>% 
    str_replace("```yaml", "---") %>% 
    str_replace("```", "")
  
  # Název souboru
  fname <- make_filename(qtext)
  
  # Uložení souboru
  writeLines(q_response, here(qmd_dir, glue("{fname}.qmd")))
})
