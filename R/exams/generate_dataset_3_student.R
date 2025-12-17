# Simple Direct Simulation - Dataset 3: Student Academic Performance

library(dplyr)
set.seed(2024)

# Sample size
n <- 280

# Root nodes
vek <- round(rnorm(n, mean = 21, sd = 2))
vek <- pmax(19, pmin(28, vek))

studijni_program_num <- sample(1:5, n, replace = TRUE, prob = c(0.25, 0.25, 0.15, 0.15, 0.20))
ubytovani_num <- sample(1:3, n, replace = TRUE, prob = c(0.30, 0.35, 0.35))
metoda_studia_num <- sample(1:3, n, replace = TRUE, prob = c(0.60, 0.20, 0.20))

# Part-time job (depends on accommodation)
brigada_prob <- plogis(-0.5 + ubytovani_num * 0.3)
brigada_num <- rbinom(n, 1, brigada_prob)

# Sleep hours (depends on part-time job and program)
hodiny_spanku <- 8 - brigada_num * 1.5 - studijni_program_num * 0.2 + rnorm(n, sd = 0.8)
hodiny_spanku <- round(pmax(4, pmin(9, hodiny_spanku)), 1)

# Course difficulty
obtiznost_kurzu <- sample(1:5, n, replace = TRUE, prob = c(0.05, 0.15, 0.40, 0.30, 0.10))

# Motivation level (slight program effect)
uroven_motivace_raw <- 3 + studijni_program_num * 0.15 + rnorm(n, sd = 1)
uroven_motivace <- round(pmax(1, pmin(5, uroven_motivace_raw)))

# Study hours category (depends on motivation and part-time job)
kategorie_hodin_studia_raw <- 1 + uroven_motivace_raw * 0.5 - brigada_num * 0.5 + rnorm(n, sd = 0.6)
kategorie_hodin_studia <- round(pmax(1, pmin(4, kategorie_hodin_studia_raw)))

# Attendance rate (depends on motivation and study method)
mira_dochazky_raw <- 2 + uroven_motivace_raw * 0.3 + metoda_studia_num * 0.2 + rnorm(n, sd = 0.6)
mira_dochazky <- round(pmax(1, pmin(4, mira_dochazky_raw)))

# Library visits (depends on study hours and program)
navstevy_knihovny <- 2 + kategorie_hodin_studia_raw * 3 + studijni_program_num * 0.5 + rnorm(n, sd = 4)
navstevy_knihovny <- round(pmax(0, pmin(25, navstevy_knihovny)))

# Stress index (depends on difficulty, sleep, part-time job)
index_stresu <- 30 + obtiznost_kurzu * 8 - hodiny_spanku * 4 + brigada_num * 15 + rnorm(n, sd = 10)
index_stresu <- round(pmax(20, pmin(95, index_stresu)), 1)

# Exam score (depends on study hours - main causal effect)
skore_zkousky <- 50 + kategorie_hodin_studia_raw * 10 + uroven_motivace_raw * 3 + mira_dochazky_raw * 4 + rnorm(n, sd = 8)
skore_zkousky <- round(pmax(45, pmin(98, skore_zkousky)), 1)

# Assignment score (similar but different)
skore_projektu <- 55 + kategorie_hodin_studia_raw * 8 + uroven_motivace_raw * 4 + navstevy_knihovny * 0.5 + rnorm(n, sd = 7)
skore_projektu <- round(pmax(50, pmin(100, skore_projektu)), 1)

# GPA (depends on sleep hours, study hours, motivation, program as backdoor)
prumer <- 1.5 + hodiny_spanku * 0.2 + kategorie_hodin_studia_raw * 0.15 + studijni_program_num * 0.1 + uroven_motivace_raw * 0.15 + rnorm(n, sd = 0.3)
prumer <- round(pmax(1.5, pmin(4.0, prumer)), 2)

# Create dataframe with Czech labels
student_data <- data.frame(
  vek = vek,
  studijni_program = factor(studijni_program_num, levels = 1:5,
                            labels = c("Ekonomie", "Inženýrství", "Medicína", "Umění", "Přírodní vědy")),
  ubytovani = factor(ubytovani_num, levels = 1:3,
                     labels = c("Kolej", "Doma s rodiči", "Nájem")),
  brigada = factor(brigada_num, levels = 0:1,
                   labels = c("Ne", "Ano")),
  metoda_studia = factor(metoda_studia_num, levels = 1:3,
                         labels = c("Tradiční", "Online", "Hybridní")),
  kategorie_hodin_studia = kategorie_hodin_studia,
  uroven_motivace = uroven_motivace,
  obtiznost_kurzu = obtiznost_kurzu,
  mira_dochazky = mira_dochazky,
  prumer = prumer,
  skore_zkousky = skore_zkousky,
  skore_projektu = skore_projektu,
  navstevy_knihovny = navstevy_knihovny,
  hodiny_spanku = hodiny_spanku,
  index_stresu = index_stresu
)

# Save Czech version
write.csv(student_data, "R/exams/dataset_3_student_performance.csv",
          row.names = FALSE, fileEncoding = "UTF-8")

# English version
student_data_en <- student_data %>%
  rename(
    age = vek,
    study_program = studijni_program,
    accommodation = ubytovani,
    part_time_job = brigada,
    study_method = metoda_studia,
    study_hours_category = kategorie_hodin_studia,
    motivation_level = uroven_motivace,
    course_difficulty = obtiznost_kurzu,
    attendance_rate = mira_dochazky,
    gpa = prumer,
    exam_score = skore_zkousky,
    assignment_score = skore_projektu,
    library_visits_per_month = navstevy_knihovny,
    sleep_hours_avg = hodiny_spanku,
    stress_index = index_stresu
  ) %>%
  mutate(
    study_program = recode(study_program,
                           "Ekonomie" = "Economics",
                           "Inženýrství" = "Engineering",
                           "Medicína" = "Medicine",
                           "Umění" = "Arts",
                           "Přírodní vědy" = "Science"),
    accommodation = recode(accommodation,
                           "Kolej" = "Dorm",
                           "Doma s rodiči" = "Home",
                           "Nájem" = "Rental"),
    part_time_job = recode(part_time_job,
                           "Ne" = "No",
                           "Ano" = "Yes"),
    study_method = recode(study_method,
                          "Tradiční" = "Traditional",
                          "Online" = "Online",
                          "Hybridní" = "Hybrid")
  )

write.csv(student_data_en, "R/exams/dataset_3_student_performance_EN.csv",
          row.names = FALSE)

cat("Dataset 3 (Student Performance) generated successfully!\n")
cat("Sample size:", nrow(student_data), "\n\n")
print(summary(student_data))
