# Simulation Script - Dataset 3: Student Academic Performance
# Using simDAG package

library(simDAG)
library(dplyr)
library(tidyr)

set.seed(2024)

# Sample size
n <- 280

# Create DAG structure with causal relationships
dag <- empty_dag() +

  # Root nodes
  node("vek", type = "rnorm", mean = 21, sd = 2) +
  node("studijni_program_num", type = "rcategorical",
       probs = c(0.25, 0.25, 0.15, 0.15, 0.20)) +  # Ekonomie, Inženýrství, Medicína, Umění, Vědy
  node("ubytovani_num", type = "rcategorical",
       probs = c(0.30, 0.35, 0.35)) +  # Kolej, Doma, Nájem
  node("metoda_studia_num", type = "rcategorical",
       probs = c(0.60, 0.20, 0.20)) +  # Tradiční, Online, Hybridní

  # Part-time job (depends on accommodation)
  node("brigada_num", type = "binomial",
       formula = ~ -0.5 + ubytovani_num * 0.3) +

  # Sleep hours (depends on part-time job and study program)
  node("hodiny_spanku", type = "gaussian",
       formula = ~ 8 - brigada_num * 1.5 - studijni_program_num * 0.2,
       error = 0.8) +

  # Course difficulty perception (depends on program)
  node("obtiznost_kurzu", type = "rcategorical",
       formula = ~ studijni_program_num * 0.3,
       probs = c(0.05, 0.15, 0.40, 0.30, 0.10),
       labels = 1:5) +

  # Motivation level (independent, slight program effect)
  node("uroven_motivace_raw", type = "gaussian",
       formula = ~ 3 + studijni_program_num * 0.15,
       error = 1) +

  # Study hours category (depends on motivation)
  node("kategorie_hodin_studia_raw", type = "gaussian",
       formula = ~ 1 + uroven_motivace_raw * 0.5 - brigada_num * 0.5,
       error = 0.6) +

  # Attendance rate (depends on motivation and study method)
  node("mira_dochazky_raw", type = "gaussian",
       formula = ~ 2 + uroven_motivace_raw * 0.3 + metoda_studia_num * 0.2,
       error = 0.6) +

  # Library visits (depends on study hours and program)
  node("navstevy_knihovny", type = "gaussian",
       formula = ~ 2 + kategorie_hodin_studia_raw * 3 + studijni_program_num * 0.5,
       error = 4) +

  # Stress index (depends on difficulty, sleep, part-time job)
  node("index_stresu", type = "gaussian",
       formula = ~ 30 + obtiznost_kurzu * 8 - hodiny_spanku * 4 + brigada_num * 15,
       error = 10) +

  # Exam score (depends on study hours - main causal effect)
  node("skore_zkousky", type = "gaussian",
       formula = ~ 50 + kategorie_hodin_studia_raw * 10 + uroven_motivace_raw * 3 +
                   mira_dochazky_raw * 4,
       error = 8) +

  # Assignment score (similar to exam but slightly different)
  node("skore_projektu", type = "gaussian",
       formula = ~ 55 + kategorie_hodin_studia_raw * 8 + uroven_motivace_raw * 4 +
                   navstevy_knihovny * 0.5,
       error = 7) +

  # GPA (depends on sleep hours via part-time job, study program as backdoor)
  node("prumer", type = "gaussian",
       formula = ~ 1.5 + hodiny_spanku * 0.2 + kategorie_hodin_studia_raw * 0.15 +
                   studijni_program_num * 0.1 + uroven_motivace_raw * 0.15,
       error = 0.3)

# Simulate data
sim_data <- sim_from_dag(dag, n_sim = n)

# Post-process data
student_data <- sim_data %>%
  mutate(
    # Constrain variables
    vek = pmax(19, pmin(28, round(vek))),
    hodiny_spanku = pmax(4, pmin(9, round(hodiny_spanku, 1))),
    navstevy_knihovny = pmax(0, pmin(25, round(navstevy_knihovny))),
    index_stresu = pmax(20, pmin(95, round(index_stresu, 1))),
    skore_zkousky = pmax(45, pmin(98, round(skore_zkousky, 1))),
    skore_projektu = pmax(50, pmin(100, round(skore_projektu, 1))),
    prumer = pmax(1.5, pmin(4.0, round(prumer, 2))),

    # Convert to ordinal scales
    uroven_motivace = pmax(1, pmin(5, round(uroven_motivace_raw))),
    kategorie_hodin_studia = pmax(1, pmin(4, round(kategorie_hodin_studia_raw))),
    mira_dochazky = pmax(1, pmin(4, round(mira_dochazky_raw))),

    # Convert to categorical labels
    studijni_program = factor(studijni_program_num,
                             levels = 1:5,
                             labels = c("Ekonomie", "Inženýrství", "Medicína",
                                       "Umění", "Přírodní vědy")),

    ubytovani = factor(ubytovani_num,
                      levels = 1:3,
                      labels = c("Kolej", "Doma s rodiči", "Nájem")),

    brigada = factor(brigada_num,
                    levels = 0:1,
                    labels = c("Ne", "Ano")),

    metoda_studia = factor(metoda_studia_num,
                          levels = 1:3,
                          labels = c("Tradiční", "Online", "Hybridní"))
  ) %>%
  select(vek, studijni_program, ubytovani, brigada, metoda_studia,
         kategorie_hodin_studia, uroven_motivace, obtiznost_kurzu, mira_dochazky,
         prumer, skore_zkousky, skore_projektu, navstevy_knihovny,
         hodiny_spanku, index_stresu)

# Save dataset
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
cat("Sample size:", nrow(student_data), "\n")
cat("\nSummary statistics:\n")
print(summary(student_data))
