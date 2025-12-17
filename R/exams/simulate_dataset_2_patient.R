# Simulation Script - Dataset 2: Patient Recovery
# Using simDAG package

library(simDAG)
library(dplyr)
library(tidyr)

set.seed(2024)

# Sample size
n <- 300

# Create DAG structure with causal relationships
dag <- empty_dag() +

  # Root nodes
  node("vek", type = "rnorm", mean = 62, sd = 12) +
  node("kouření_num", type = "rcategorical",
       probs = c(0.45, 0.35, 0.20)) +  # 1=Nikdy, 2=Bývalý, 3=Současný
  node("typ_zakroku_num", type = "rcategorical",
       probs = c(0.35, 0.30, 0.20, 0.15)) +  # 1=Koleno, 2=Kyčel, 3=Páteř, 4=Rameno
  node("nemocnicni_oddeleni_num", type = "rcategorical",
       probs = c(0.25, 0.25, 0.25, 0.25)) +  # A, B, C, D
  node("typ_pojisteni_num", type = "rcategorical",
       probs = c(0.60, 0.25, 0.15)) +  # 1=Veřejné, 2=Soukromé, 3=Smíšené

  # Pre-surgery score (depends on age and procedure type)
  node("skore_pred_operaci", type = "gaussian",
       formula = ~ 50 - vek * 0.3 - typ_zakroku_num * 2,
       error = 8) +

  # Comorbidity index (depends on age and smoking)
  node("index_komorbidity_raw", type = "gaussian",
       formula = ~ -1 + vek * 0.04 + kouření_num * 0.4,
       error = 0.6) +

  # BMI - collider (depends on comorbidity and age)
  node("bmi", type = "gaussian",
       formula = ~ 22 + vek * 0.08 + index_komorbidity_raw * 2,
       error = 3) +

  # Days hospitalized (depends on comorbidity, procedure type, age)
  node("dny_hospitalizace", type = "gaussian",
       formula = ~ 3 + index_komorbidity_raw * 2 + typ_zakroku_num * 1.5 +
                   vek * 0.08,
       error = 2.5) +

  # Recovery time (depends on comorbidity, procedure type as confounder, age)
  node("cas_zotaveni", type = "gaussian",
       formula = ~ 8 + index_komorbidity_raw * 3 + typ_zakroku_num * 2 +
                   vek * 0.1 + skore_pred_operaci * -0.05,
       error = 3) +

  # Medication cost (depends on comorbidity, procedure, hospitalization)
  node("cena_medikace", type = "gaussian",
       formula = ~ 5000 + index_komorbidity_raw * 3000 + typ_zakroku_num * 4000 +
                   dny_hospitalizace * 800,
       error = 5000) +

  # Post-surgery score (depends on pre-surgery score and recovery time)
  node("skore_po_operaci", type = "gaussian",
       formula = ~ 60 + skore_pred_operaci * 0.5 - cas_zotaveni * 0.8 +
                   typ_pojisteni_num * 2,
       error = 8) +

  # Pain level (depends on recovery time and comorbidity)
  node("uroven_bolesti_raw", type = "gaussian",
       formula = ~ 8 - cas_zotaveni * 0.15 + index_komorbidity_raw * 1.2,
       error = 1.5) +

  # Mobility score (depends on recovery and pain)
  node("skore_mobility_raw", type = "gaussian",
       formula = ~ 2 + cas_zotaveni * -0.08 + skore_po_operaci * 0.03,
       error = 0.8) +

  # Treatment satisfaction (depends on pain, mobility, post-surgery score)
  node("spokojenost_lecba_raw", type = "gaussian",
       formula = ~ 2 + skore_po_operaci * 0.02 - uroven_bolesti_raw * 0.2 +
                   skore_mobility_raw * 0.3,
       error = 0.8)

# Simulate data
sim_data <- sim_from_dag(dag, n_sim = n)

# Post-process data
patient_data <- sim_data %>%
  mutate(
    # Constrain continuous variables
    vek = pmax(35, pmin(85, round(vek))),
    bmi = pmax(18, pmin(42, round(bmi, 1))),
    dny_hospitalizace = pmax(2, pmin(21, round(dny_hospitalizace))),
    cas_zotaveni = pmax(4, pmin(26, round(cas_zotaveni, 1))),
    cena_medikace = pmax(2000, pmin(35000, round(cena_medikace, -2))),
    skore_pred_operaci = pmax(20, pmin(60, round(skore_pred_operaci, 1))),
    skore_po_operaci = pmax(50, pmin(98, round(skore_po_operaci, 1))),

    # Convert to ordinal scales
    index_komorbidity = pmax(0, pmin(3, round(index_komorbidity_raw))),
    uroven_bolesti = pmax(1, pmin(10, round(uroven_bolesti_raw))),
    skore_mobility = pmax(1, pmin(5, round(skore_mobility_raw))),
    spokojenost_lecba = pmax(1, pmin(5, round(spokojenost_lecba_raw))),

    # Convert to categorical labels
    kouření = factor(kouření_num,
                    levels = 1:3,
                    labels = c("Nikdy", "Bývalý kuřák", "Současný kuřák")),

    typ_zakroku = factor(typ_zakroku_num,
                        levels = 1:4,
                        labels = c("Koleno", "Kyčel", "Páteř", "Rameno")),

    nemocnicni_oddeleni = factor(nemocnicni_oddeleni_num,
                                 levels = 1:4,
                                 labels = c("A", "B", "C", "D")),

    typ_pojisteni = factor(typ_pojisteni_num,
                          levels = 1:3,
                          labels = c("Veřejné", "Soukromé", "Smíšené"))
  ) %>%
  select(vek, bmi, kouření, typ_zakroku, nemocnicni_oddeleni, typ_pojisteni,
         index_komorbidity, skore_pred_operaci, dny_hospitalizace,
         cas_zotaveni, cena_medikace, skore_po_operaci, uroven_bolesti,
         skore_mobility, spokojenost_lecba)

# Save dataset
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
cat("Sample size:", nrow(patient_data), "\n")
cat("\nSummary statistics:\n")
print(summary(patient_data))
