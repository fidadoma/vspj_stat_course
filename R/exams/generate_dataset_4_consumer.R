# Simple Direct Simulation - Dataset 4: Consumer Behavior and Product Sales

library(dplyr)
set.seed(2024)

# Sample size
n <- 320

# Root nodes
vek <- round(rnorm(n, mean = 42, sd = 15))
vek <- pmax(18, pmin(75, vek))

mesicni_prijem <- rnorm(n, mean = 45000, sd = 25000)
mesicni_prijem <- round(pmax(15000, pmin(150000, mesicni_prijem)), -2)

kategorie_produktu_num <- sample(1:4, n, replace = TRUE, prob = c(0.25, 0.30, 0.25, 0.20))
zpusob_platby_num <- sample(1:3, n, replace = TRUE, prob = c(0.20, 0.50, 0.30))

# Customer segment (depends on monthly income)
segment_probs <- matrix(c(0.60, 0.30, 0.10,  # Low income
                          0.30, 0.50, 0.20,  # Medium income
                          0.10, 0.30, 0.60), # High income
                        nrow = 3, byrow = TRUE)

segment_zakaznika_num <- numeric(n)
for (i in 1:n) {
  income_category <- cut(mesicni_prijem[i],
                         breaks = c(0, 30000, 70000, Inf),
                         labels = FALSE)
  segment_zakaznika_num[i] <- sample(1:3, 1, prob = segment_probs[income_category, ])
}

# Marketing channel (independent)
marketingovy_kanal_num <- sample(1:4, n, replace = TRUE, prob = c(0.30, 0.25, 0.20, 0.25))

# Website visits (depends on marketing channel and age)
navstevy_webu <- 5 + marketingovy_kanal_num * 5 - vek * 0.1 + rnorm(n, sd = 8)
navstevy_webu <- round(pmax(0, pmin(50, navstevy_webu)))

# Time on website (depends on visits and product category)
cas_na_webu <- 5 + navstevy_webu * 0.5 + kategorie_produktu_num * 2 + rnorm(n, sd = 6)
cas_na_webu <- round(pmax(2, pmin(45, cas_na_webu)), 1)

# Service quality (slight segment effect)
kvalita_sluzeb_raw <- 3.5 + segment_zakaznika_num * 0.3 + rnorm(n, sd = 0.8)
kvalita_sluzeb <- round(pmax(1, pmin(5, kvalita_sluzeb_raw)))

# Product rating (depends on service quality and product category as confounder)
hodnoceni_produktu_raw <- 2 + kvalita_sluzeb_raw * 0.6 + kategorie_produktu_num * 0.2 + rnorm(n, sd = 0.7)
hodnoceni_produktu <- round(pmax(1, pmin(5, hodnoceni_produktu_raw)))

# Brand loyalty (depends on customer segment and product rating)
vernost_znacce_raw <- 2 + segment_zakaznika_num * 0.6 + hodnoceni_produktu_raw * 0.4 + rnorm(n, sd = 0.8)
vernost_znacce <- round(pmax(1, pmin(5, vernost_znacce_raw)))

# Purchase frequency (depends on loyalty and visits)
frekvence_nakupu_raw <- 1.5 + vernost_znacce_raw * 0.4 + navstevy_webu * 0.03 + rnorm(n, sd = 0.6)
frekvence_nakupu <- round(pmax(1, pmin(4, frekvence_nakupu_raw)))

# Discount (depends on segment and loyalty)
sleva_procenta <- 5 - segment_zakaznika_num * 3 + vernost_znacce_raw * 2 + frekvence_nakupu_raw * 2 + rnorm(n, sd = 6)
sleva_procenta <- round(pmax(0, pmin(40, sleva_procenta)), 1)

# Purchase amount (depends on website visits, income, segment, category)
castka_nakupu <- 500 + navstevy_webu * 100 + mesicni_prijem * 0.03 + segment_zakaznika_num * 1000 + kategorie_produktu_num * 800 + rnorm(n, sd = 2000)
castka_nakupu <- round(pmax(200, pmin(15000, castka_nakupu)), -1)

# Customer lifetime value (depends on purchase amount, frequency, loyalty)
hodnota_zakaznika <- castka_nakupu * 20 + frekvence_nakupu_raw * 30000 + vernost_znacce_raw * 20000 + rnorm(n, sd = 50000)
hodnota_zakaznika <- round(pmax(5000, pmin(500000, hodnota_zakaznika)), -3)

# Create dataframe with Czech labels
consumer_data <- data.frame(
  vek = vek,
  mesicni_prijem = mesicni_prijem,
  segment_zakaznika = factor(segment_zakaznika_num, levels = 1:3,
                             labels = c("Rozpočtový", "Standardní", "Prémiový")),
  kategorie_produktu = factor(kategorie_produktu_num, levels = 1:4,
                               labels = c("Elektronika", "Oblečení", "Potraviny", "Domácnost")),
  zpusob_platby = factor(zpusob_platby_num, levels = 1:3,
                         labels = c("Hotovost", "Karta", "Online platba")),
  marketingovy_kanal = factor(marketingovy_kanal_num, levels = 1:4,
                              labels = c("Sociální sítě", "Email", "TV reklama", "Žádný")),
  hodnoceni_produktu = hodnoceni_produktu,
  kvalita_sluzeb = kvalita_sluzeb,
  vernost_znacce = vernost_znacce,
  frekvence_nakupu = frekvence_nakupu,
  navstevy_webu = navstevy_webu,
  cas_na_webu = cas_na_webu,
  sleva_procenta = sleva_procenta,
  castka_nakupu = castka_nakupu,
  hodnota_zakaznika = hodnota_zakaznika
)

# Save Czech version
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
cat("Sample size:", nrow(consumer_data), "\n\n")
print(summary(consumer_data))
