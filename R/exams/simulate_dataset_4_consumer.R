# Simulation Script - Dataset 4: Consumer Behavior and Product Sales
# Using simDAG package

library(simDAG)
library(dplyr)
library(tidyr)

set.seed(2024)

# Sample size
n <- 320

# Create DAG structure with causal relationships
dag <- empty_dag() +

  # Root nodes
  node("vek", type = "rnorm", mean = 42, sd = 15) +
  node("mesicni_prijem", type = "rnorm", mean = 45000, sd = 25000) +
  node("kategorie_produktu_num", type = "rcategorical",
       probs = c(0.25, 0.30, 0.25, 0.20)) +  # Elektronika, Oblečení, Potraviny, Domácnost
  node("zpusob_platby_num", type = "rcategorical",
       probs = c(0.20, 0.50, 0.30)) +  # Hotovost, Karta, Online

  # Customer segment (depends on monthly income)
  node("segment_zakaznika_num", type = "rcategorical",
       formula = ~ mesicni_prijem * 0.00003,
       probs = c(0.30, 0.50, 0.20),
       labels = 1:3) +  # Rozpočtový, Standardní, Prémiový

  # Marketing channel (independent)
  node("marketingovy_kanal_num", type = "rcategorical",
       probs = c(0.30, 0.25, 0.20, 0.25)) +  # Sociální sítě, Email, TV, Žádný

  # Website visits (depends on marketing channel)
  node("navstevy_webu", type = "gaussian",
       formula = ~ 5 + marketingovy_kanal_num * 5 + vek * -0.1,
       error = 8) +

  # Time on website (depends on visits and product category)
  node("cas_na_webu", type = "gaussian",
       formula = ~ 5 + navstevy_webu * 0.5 + kategorie_produktu_num * 2,
       error = 6) +

  # Service quality (somewhat independent, slight category effect)
  node("kvalita_sluzeb_raw", type = "gaussian",
       formula = ~ 3.5 + segment_zakaznika_num * 0.3,
       error = 0.8) +

  # Product rating (depends on service quality and product category as confounder)
  node("hodnoceni_produktu_raw", type = "gaussian",
       formula = ~ 2 + kvalita_sluzeb_raw * 0.6 + kategorie_produktu_num * 0.2,
       error = 0.7) +

  # Brand loyalty (depends on customer segment)
  node("vernost_znacce_raw", type = "gaussian",
       formula = ~ 2 + segment_zakaznika_num * 0.6 + hodnoceni_produktu_raw * 0.4,
       error = 0.8) +

  # Purchase frequency (depends on loyalty and visits)
  node("frekvence_nakupu_raw", type = "gaussian",
       formula = ~ 1.5 + vernost_znacce_raw * 0.4 + navstevy_webu * 0.03,
       error = 0.6) +

  # Discount (depends on segment and loyalty)
  node("sleva_procenta", type = "gaussian",
       formula = ~ 5 + segment_zakaznika_num * -3 + vernost_znacce_raw * 2 +
                   frekvence_nakupu_raw * 2,
       error = 6) +

  # Purchase amount (depends on website visits, income, segment)
  node("castka_nakupu", type = "gaussian",
       formula = ~ 500 + navstevy_webu * 100 + mesicni_prijem * 0.03 +
                   segment_zakaznika_num * 1000 + kategorie_produktu_num * 800,
       error = 2000) +

  # Customer lifetime value (depends on purchase amount, frequency, loyalty)
  node("hodnota_zakaznika", type = "gaussian",
       formula = ~ castka_nakupu * 20 + frekvence_nakupu_raw * 30000 +
                   vernost_znacce_raw * 20000,
       error = 50000)

# Simulate data
sim_data <- sim_from_dag(dag, n_sim = n)

# Post-process data
consumer_data <- sim_data %>%
  mutate(
    # Constrain variables
    vek = pmax(18, pmin(75, round(vek))),
    mesicni_prijem = pmax(15000, pmin(150000, round(mesicni_prijem, -2))),
    navstevy_webu = pmax(0, pmin(50, round(navstevy_webu))),
    cas_na_webu = pmax(2, pmin(45, round(cas_na_webu, 1))),
    sleva_procenta = pmax(0, pmin(40, round(sleva_procenta, 1))),
    castka_nakupu = pmax(200, pmin(15000, round(castka_nakupu, -1))),
    hodnota_zakaznika = pmax(5000, pmin(500000, round(hodnota_zakaznika, -3))),

    # Convert to ordinal scales
    hodnoceni_produktu = pmax(1, pmin(5, round(hodnoceni_produktu_raw))),
    kvalita_sluzeb = pmax(1, pmin(5, round(kvalita_sluzeb_raw))),
    vernost_znacce = pmax(1, pmin(5, round(vernost_znacce_raw))),
    frekvence_nakupu = pmax(1, pmin(4, round(frekvence_nakupu_raw))),

    # Convert to categorical labels
    segment_zakaznika = factor(segment_zakaznika_num,
                              levels = 1:3,
                              labels = c("Rozpočtový", "Standardní", "Prémiový")),

    kategorie_produktu = factor(kategorie_produktu_num,
                                levels = 1:4,
                                labels = c("Elektronika", "Oblečení",
                                          "Potraviny", "Domácnost")),

    zpusob_platby = factor(zpusob_platby_num,
                          levels = 1:3,
                          labels = c("Hotovost", "Karta", "Online platba")),

    marketingovy_kanal = factor(marketingovy_kanal_num,
                               levels = 1:4,
                               labels = c("Sociální sítě", "Email", "TV reklama", "Žádný"))
  ) %>%
  select(vek, mesicni_prijem, segment_zakaznika, kategorie_produktu,
         zpusob_platby, marketingovy_kanal, hodnoceni_produktu,
         kvalita_sluzeb, vernost_znacce, frekvence_nakupu,
         navstevy_webu, cas_na_webu, sleva_procenta, castka_nakupu,
         hodnota_zakaznika)

# Save dataset
write.csv(consumer_data, "R/exams/dataset_4_consumer_behavior.csv",
          row.names = FALSE, fileEncoding = "UTF-8")

# English version
consumer_data_en <- consumer_data %>%
  rename(
    age = vek,
    monthly_income = mesicni_prijem,
    customer_segment = segment_zakaznika,
    product_category = kategorie_produktu,
    payment_method = zpusob_platby,
    marketing_channel = marketingovy_kanal,
    product_rating = hodnoceni_produktu,
    service_quality = kvalita_sluzeb,
    brand_loyalty = vernost_znacce,
    purchase_frequency = frekvence_nakupu,
    website_visits_per_month = navstevy_webu,
    time_on_site_minutes = cas_na_webu,
    discount_received = sleva_procenta,
    purchase_amount = castka_nakupu,
    customer_lifetime_value = hodnota_zakaznika
  ) %>%
  mutate(
    customer_segment = recode(customer_segment,
                             "Rozpočtový" = "Budget",
                             "Standardní" = "Standard",
                             "Prémiový" = "Premium"),
    product_category = recode(product_category,
                             "Elektronika" = "Electronics",
                             "Oblečení" = "Clothing",
                             "Potraviny" = "Food",
                             "Domácnost" = "Home"),
    payment_method = recode(payment_method,
                           "Hotovost" = "Cash",
                           "Karta" = "Card",
                           "Online platba" = "Online"),
    marketing_channel = recode(marketing_channel,
                              "Sociální sítě" = "Social",
                              "Email" = "Email",
                              "TV reklama" = "TV",
                              "Žádný" = "None")
  )

write.csv(consumer_data_en, "R/exams/dataset_4_consumer_behavior_EN.csv",
          row.names = FALSE)

cat("Dataset 4 (Consumer Behavior) generated successfully!\n")
cat("Sample size:", nrow(consumer_data), "\n")
cat("\nSummary statistics:\n")
print(summary(consumer_data))
