# Simple Direct Simulation - Dataset 2: Patient Recovery

library(dplyr)
set.seed(2024)

# Sample size
n <- 300

# Root nodes
vek <- round(rnorm(n, mean = 62, sd = 12))
vek <- pmax(35, pmin(85, vek))

kouření_num <- sample(1:3, n, replace = TRUE, prob = c(0.45, 0.35, 0.20))
typ_zakroku_num <- sample(1:4, n, replace = TRUE, prob = c(0.35, 0.30, 0.20, 0.15))
nemocnicni_oddeleni_num <- sample(1:4, n, replace = TRUE, prob = c(0.25, 0.25, 0.25, 0.25))
typ_pojisteni_num <- sample(1:3, n, replace = TRUE, prob = c(0.60, 0.25, 0.15))

# Pre-surgery score (depends on age and procedure)
skore_pred_operaci <- 50 - vek * 0.3 - typ_zakroku_num * 2 + rnorm(n, sd = 8)
skore_pred_operaci <- round(pmax(20, pmin(60, skore_pred_operaci)), 1)

# Comorbidity index (depends on age and smoking)
index_komorbidity_raw <- -1 + vek * 0.04 + kouření_num * 0.4 + rnorm(n, sd = 0.6)
index_komorbidity <- round(pmax(0, pmin(3, index_komorbidity_raw)))

# BMI - collider (depends on comorbidity and age)
bmi <- 22 + vek * 0.08 + index_komorbidity_raw * 2 + rnorm(n, sd = 3)
bmi <- round(pmax(18, pmin(42, bmi)), 1)

# Days hospitalized (depends on comorbidity, procedure, age)
dny_hospitalizace <- 3 + index_komorbidity_raw * 2 + typ_zakroku_num * 1.5 + vek * 0.08 + rnorm(n, sd = 2.5)
dny_hospitalizace <- round(pmax(2, pmin(21, dny_hospitalizace)))

# Recovery time (depends on comorbidity, procedure as confounder, age, pre-surgery score)
cas_zotaveni <- 8 + index_komorbidity_raw * 3 + typ_zakroku_num * 2 + vek * 0.1 - skore_pred_operaci * 0.05 + rnorm(n, sd = 3)
cas_zotaveni <- round(pmax(4, pmin(26, cas_zotaveni)), 1)

# Medication cost (depends on comorbidity, procedure, hospitalization)
cena_medikace <- 5000 + index_komorbidity_raw * 3000 + typ_zakroku_num * 4000 + dny_hospitalizace * 800 + rnorm(n, sd = 5000)
cena_medikace <- round(pmax(2000, pmin(35000, cena_medikace)), -2)

# Post-surgery score (depends on pre-surgery score, recovery time, insurance)
skore_po_operaci <- 60 + skore_pred_operaci * 0.5 - cas_zotaveni * 0.8 + typ_pojisteni_num * 2 + rnorm(n, sd = 8)
skore_po_operaci <- round(pmax(50, pmin(98, skore_po_operaci)), 1)

# Pain level (depends on recovery time and comorbidity)
uroven_bolesti_raw <- 8 - cas_zotaveni * 0.15 + index_komorbidity_raw * 1.2 + rnorm(n, sd = 1.5)
uroven_bolesti <- round(pmax(1, pmin(10, uroven_bolesti_raw)))

# Mobility score (depends on recovery and post-surgery score)
skore_mobility_raw <- 2 - cas_zotaveni * 0.08 + skore_po_operaci * 0.03 + rnorm(n, sd = 0.8)
skore_mobility <- round(pmax(1, pmin(5, skore_mobility_raw)))

# Treatment satisfaction (depends on pain, mobility, post-surgery score)
spokojenost_lecba_raw <- 2 + skore_po_operaci * 0.02 - uroven_bolesti_raw * 0.2 + skore_mobility_raw * 0.3 + rnorm(n, sd = 0.8)
spokojenost_lecba <- round(pmax(1, pmin(5, spokojenost_lecba_raw)))

# Create dataframe with Czech labels
patient_data <- data.frame(
  vek = vek,
  bmi = bmi,
  kouření = factor(kouření_num, levels = 1:3,
                   labels = c("Nikdy", "Bývalý kuřák", "Současný kuřák")),
  typ_zakroku = factor(typ_zakroku_num, levels = 1:4,
                       labels = c("Koleno", "Kyčel", "Páteř", "Rameno")),
  nemocnicni_oddeleni = factor(nemocnicni_oddeleni_num, levels = 1:4,
                                labels = c("A", "B", "C", "D")),
  typ_pojisteni = factor(typ_pojisteni_num, levels = 1:3,
                         labels = c("Veřejné", "Soukromé", "Smíšené")),
  index_komorbidity = index_komorbidity,
  skore_pred_operaci = skore_pred_operaci,
  dny_hospitalizace = dny_hospitalizace,
  cas_zotaveni = cas_zotaveni,
  cena_medikace = cena_medikace,
  skore_po_operaci = skore_po_operaci,
  uroven_bolesti = uroven_bolesti,
  skore_mobility = skore_mobility,
  spokojenost_lecba = spokojenost_lecba
)

# Save Czech version
write.csv(patient_data, "R/exams/dataset_2_patient_recovery.csv",
          row.names = FALSE, fileEncoding = "UTF-8")

# English version
patient_data_en <- patient_data %>%
  rename(
    age = vek,
    smoking_status = kouření,
    procedure_type = typ_zakroku,
    hospital_ward = nemocnicni_oddeleni,
    insurance_type = typ_pojisteni,
    comorbidity_index = index_komorbidity,
    pre_surgery_score = skore_pred_operaci,
    days_hospitalized = dny_hospitalizace,
    recovery_time_weeks = cas_zotaveni,
    medication_cost = cena_medikace,
    post_surgery_score = skore_po_operaci,
    pain_level = uroven_bolesti,
    mobility_score = skore_mobility,
    treatment_satisfaction = spokojenost_lecba
  ) %>%
  mutate(
    smoking_status = recode(smoking_status,
                            "Nikdy" = "Never",
                            "Bývalý kuřák" = "Former",
                            "Současný kuřák" = "Current"),
    procedure_type = recode(procedure_type,
                            "Koleno" = "Knee",
                            "Kyčel" = "Hip",
                            "Páteř" = "Spine",
                            "Rameno" = "Shoulder"),
    insurance_type = recode(insurance_type,
                            "Veřejné" = "Public",
                            "Soukromé" = "Private",
                            "Smíšené" = "Mixed")
  )

write.csv(patient_data_en, "R/exams/dataset_2_patient_recovery_EN.csv",
          row.names = FALSE)

cat("Dataset 2 (Patient Recovery) generated successfully!\n")
cat("Sample size:", nrow(patient_data), "\n\n")
print(summary(patient_data))
