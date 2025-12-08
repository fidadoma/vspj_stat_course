# Simulation Script - Dataset 1: Employee Satisfaction and Performance
# Using simDAG package

library(simDAG)
library(dplyr)
library(tidyr)

set.seed(2024)

# Sample size
n <- 250

# Create DAG structure with causal relationships
dag <- empty_dag() +

  # Root nodes - demographics and baseline characteristics
  node("vek", type = "rnorm", mean = 38, sd = 10) +
  node("vzdelani_num", type = "rcategorical",
       probs = c(0.20, 0.35, 0.35, 0.10)) +  # 1=HS, 2=Bach, 3=Mag, 4=PhD
  node("oddeleni_num", type = "rcategorical",
       probs = c(0.25, 0.20, 0.15, 0.20, 0.20)) +  # 1=IT, 2=Prodej, 3=HR, 4=Finance, 5=Provoz
  node("typ_uvazku_num", type = "rcategorical",
       probs = c(0.70, 0.20, 0.10)) +  # 1=Plný, 2=Částečný, 3=Kontrakt

  # Years of experience (depends on age)
  node("roky_praxe", type = "gaussian",
       formula = ~ 1 - 5 + vek * 0.5,
       error = 3) +

  # Salary (depends on education, experience, and department)
  node("plat", type = "gaussian",
       formula = ~ 1 + 25000 + vzdelani_num * 15000 + roky_praxe * 800 +
                   oddeleni_num * 5000,
       error = 8000) +

  # Remote work (depends on department)
  node("prace_na_dalku_num", type = "binomial",
       formula = ~ 1 - 2 + oddeleni_num * 0.8) +

  # Training rating (somewhat independent, slight age effect)
  node("hodnoceni_skoleni", type = "rcategorical",
       probs = c(0.05, 0.15, 0.30, 0.35, 0.15),
       labels = 1:5) +

  # Job satisfaction (depends on salary, remote work, department)
  node("spokojenost_prace_raw", type = "gaussian",
       formula = ~ 1 + 1 + plat * 0.00002 + prace_na_dalku_num * 0.5 +
                   hodnoceni_skoleni * 0.3,
       error = 1) +

  # Work-life balance (depends on remote work and department)
  node("work_life_balance_raw", type = "gaussian",
       formula = ~ 1 + 2 + prace_na_dalku_num * 0.8 + typ_uvazku_num * 0.3,
       error = 0.8) +

  # Stress level (depends on department, work-life balance)
  node("uroven_stresu_raw", type = "gaussian",
       formula = ~ 1 + 4 - work_life_balance_raw * 0.5 + oddeleni_num * 0.2,
       error = 0.7) +

  # Sick days (depends on stress level)
  node("nemocenske_dny_raw", type = "gaussian",
       formula = ~ 1 - 2 + uroven_stresu_raw * 2 + vek * 0.1,
       error = 3) +

  # Performance score (depends on job satisfaction, training, and department as confounder)
  node("vykon_skore", type = "gaussian",
       formula = ~ 1 + 40 + spokojenost_prace_raw * 8 + hodnoceni_skoleni * 5 +
                   oddeleni_num * 2,
       error = 8) +

  # Overtime hours (depends on department and performance)
  node("prectasy_hodiny", type = "gaussian",
       formula = ~ 1 + 5 + oddeleni_num * 3 + vykon_skore * 0.15,
       error = 8)

# Simulate data
sim_data <- sim_from_dag(dag, n_sim = n)

# Post-process data to match codebook specifications
employee_data <- sim_data %>%
  mutate(
    # Ensure age is within range
    vek = pmax(22, pmin(65, round(vek))),

    # Round years of experience and constrain
    roky_praxe = pmax(0, pmin(40, round(roky_praxe, 1))),

    # Constrain salary
    plat = pmax(25000, pmin(120000, round(plat, -2))),

    # Convert ordinal variables to 1-5 scale
    spokojenost_prace = pmax(1, pmin(5, round(spokojenost_prace_raw))),
    work_life_balance = pmax(1, pmin(5, round(work_life_balance_raw))),
    uroven_stresu = pmax(1, pmin(5, round(uroven_stresu_raw))),

    # Sick days (discrete, non-negative)
    nemocenske_dny = pmax(0, pmin(30, round(nemocenske_dny_raw))),

    # Performance score
    vykon_skore = pmax(35, pmin(98, round(vykon_skore, 1))),

    # Overtime hours
    prectasy_hodiny = pmax(0, pmin(60, round(prectasy_hodiny, 1))),

    # Convert categorical variables to labels
    vzdelani = factor(vzdelani_num,
                     levels = 1:4,
                     labels = c("Střední škola", "Bakalář", "Magistr", "PhD")),

    oddeleni = factor(oddeleni_num,
                     levels = 1:5,
                     labels = c("IT", "Prodej", "HR", "Finance", "Provoz")),

    typ_uvazku = factor(typ_uvazku_num,
                       levels = 1:3,
                       labels = c("Plný úvazek", "Částečný úvazek", "Kontrakt")),

    prace_na_dalku = factor(prace_na_dalku_num,
                           levels = 0:1,
                           labels = c("Ne", "Ano"))
  ) %>%
  # Select final variables in order
  select(vek, vzdelani, oddeleni, typ_uvazku, prace_na_dalku,
         roky_praxe, plat, spokojenost_prace, work_life_balance,
         uroven_stresu, hodnoceni_skoleni, vykon_skore,
         nemocenske_dny, prectasy_hodiny)

# Save dataset
write.csv(employee_data, "R/exams/dataset_1_employee_satisfaction.csv",
          row.names = FALSE, fileEncoding = "UTF-8")

# Create English version for Jamovi compatibility
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
                      "Magistr" = "Master",
                      "PhD" = "PhD"),
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

# Print summary
cat("Dataset 1 (Employee Satisfaction) generated successfully!\n")
cat("Sample size:", nrow(employee_data), "\n")
cat("\nSummary statistics:\n")
print(summary(employee_data))
