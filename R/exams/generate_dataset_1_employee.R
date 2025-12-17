# Simple Direct Simulation - Dataset 1: Employee Satisfaction and Performance

library(dplyr)
set.seed(2024)

# Sample size
n <- 250

# Root nodes - demographics
vek <- round(rnorm(n, mean = 38, sd = 10))
vek <- pmax(22, pmin(65, vek))

vzdelani_num <- sample(1:4, n, replace = TRUE, prob = c(0.20, 0.35, 0.35, 0.10))
oddeleni_num <- sample(1:5, n, replace = TRUE, prob = c(0.25, 0.20, 0.15, 0.20, 0.20))
typ_uvazku_num <- sample(1:3, n, replace = TRUE, prob = c(0.70, 0.20, 0.10))

# Years of experience (depends on age)
roky_praxe <- -5 + vek * 0.5 + rnorm(n, sd = 3)
roky_praxe <- round(pmax(0, pmin(40, roky_praxe)), 1)

# Salary (depends on education, experience, department)
plat <- 25000 + vzdelani_num * 15000 + roky_praxe * 800 + oddeleni_num * 5000 + rnorm(n, sd = 8000)
plat <- round(pmax(25000, pmin(120000, plat)), -2)

# Remote work (depends on department)
prace_na_dalku_prob <- plogis(-2 + oddeleni_num * 0.8)
prace_na_dalku_num <- rbinom(n, 1, prace_na_dalku_prob)

# Training rating
hodnoceni_skoleni <- sample(1:5, n, replace = TRUE, prob = c(0.05, 0.15, 0.30, 0.35, 0.15))

# Job satisfaction (depends on salary, remote work, training)
spokojenost_prace_raw <- 1 + plat * 0.00002 + prace_na_dalku_num * 0.5 + hodnoceni_skoleni * 0.3 + rnorm(n, sd = 1)
spokojenost_prace <- round(pmax(1, pmin(5, spokojenost_prace_raw)))

# Work-life balance (depends on remote work and contract type)
work_life_balance_raw <- 2 + prace_na_dalku_num * 0.8 + typ_uvazku_num * 0.3 + rnorm(n, sd = 0.8)
work_life_balance <- round(pmax(1, pmin(5, work_life_balance_raw)))

# Stress level (depends on work-life balance and department)
uroven_stresu_raw <- 4 - work_life_balance_raw * 0.5 + oddeleni_num * 0.2 + rnorm(n, sd = 0.7)
uroven_stresu <- round(pmax(1, pmin(5, uroven_stresu_raw)))

# Sick days (depends on stress and age)
nemocenske_dny_raw <- -2 + uroven_stresu_raw * 2 + vek * 0.1 + rnorm(n, sd = 3)
nemocenske_dny <- round(pmax(0, pmin(30, nemocenske_dny_raw)))

# Performance score (depends on satisfaction, training, department as confounder)
vykon_skore <- 40 + spokojenost_prace_raw * 8 + hodnoceni_skoleni * 5 + oddeleni_num * 2 + rnorm(n, sd = 8)
vykon_skore <- round(pmax(35, pmin(98, vykon_skore)), 1)

# Overtime hours (depends on department and performance)
prectasy_hodiny <- 5 + oddeleni_num * 3 + vykon_skore * 0.15 + rnorm(n, sd = 8)
prectasy_hodiny <- round(pmax(0, pmin(60, prectasy_hodiny)), 1)

# Create dataframe with Czech labels
employee_data <- data.frame(
  vek = vek,
  vzdelani = factor(vzdelani_num, levels = 1:4,
                    labels = c("Střední škola", "Bakalář", "Magistr", "PhD")),
  oddeleni = factor(oddeleni_num, levels = 1:5,
                    labels = c("IT", "Prodej", "HR", "Finance", "Provoz")),
  typ_uvazku = factor(typ_uvazku_num, levels = 1:3,
                      labels = c("Plný úvazek", "Částečný úvazek", "Kontrakt")),
  prace_na_dalku = factor(prace_na_dalku_num, levels = 0:1,
                          labels = c("Ne", "Ano")),
  roky_praxe = roky_praxe,
  plat = plat,
  spokojenost_prace = spokojenost_prace,
  work_life_balance = work_life_balance,
  uroven_stresu = uroven_stresu,
  hodnoceni_skoleni = hodnoceni_skoleni,
  vykon_skore = vykon_skore,
  nemocenske_dny = nemocenske_dny,
  prectasy_hodiny = prectasy_hodiny
)

# Save Czech version
write.csv(employee_data, "R/exams/dataset_1_employee_satisfaction.csv",
          row.names = FALSE, fileEncoding = "UTF-8")

# Create English version
employee_data_en <- employee_data %>%
  rename(
    age = vek,
    education = vzdelani,
    department = oddeleni,
    employment_type = typ_uvazku,
    remote_work = prace_na_dalku,
    years_experience = roky_praxe,
    salary = plat,
    job_satisfaction = spokojenost_prace,
    stress_level = uroven_stresu,
    training_rating = hodnoceni_skoleni,
    performance_score = vykon_skore,
    sick_days = nemocenske_dny,
    overtime_hours = prectasy_hodiny
  ) %>%
  mutate(
    education = recode(education,
                       "Střední škola" = "High School",
                       "Bakalář" = "Bachelor",
                       "Magistr" = "Master"),
    department = recode(department,
                        "Prodej" = "Sales",
                        "Provoz" = "Operations"),
    employment_type = recode(employment_type,
                             "Plný úvazek" = "Full-time",
                             "Částečný úvazek" = "Part-time",
                             "Kontrakt" = "Contract"),
    remote_work = recode(remote_work,
                         "Ne" = "No",
                         "Ano" = "Yes")
  )

write.csv(employee_data_en, "R/exams/dataset_1_employee_satisfaction_EN.csv",
          row.names = FALSE)

cat("Dataset 1 (Employee Satisfaction) generated successfully!\n")
cat("Sample size:", nrow(employee_data), "\n\n")
print(summary(employee_data))
