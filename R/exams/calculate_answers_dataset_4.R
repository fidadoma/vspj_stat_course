# Calculate answers for Dataset 4: Consumer Behavior
# 18 comprehensive questions

library(dplyr)
library(tidyr)

# Read data
data <- read.csv("R/exams/dataset_4_consumer_behavior_EN.csv", stringsAsFactors = TRUE)

cat("=== DATASET 4: CONSUMER BEHAVIOR - ANSWER KEY ===\n")
cat("Total N =", nrow(data), "\n\n")

# ========================================
# Q1: Descriptive Statistics - Purchase Amount
# ========================================
cat("Q1: Descriptive Statistics - Purchase Amount\n")
cat("---------------------------------------------\n")

purchase_stats <- data %>%
  summarise(
    mean = mean(purchase_amount),
    median = median(purchase_amount),
    sd = sd(purchase_amount),
    q1 = quantile(purchase_amount, 0.25),
    q3 = quantile(purchase_amount, 0.75),
    min = min(purchase_amount),
    max = max(purchase_amount)
  )

print(purchase_stats)
cat("\n")

# ========================================
# Q2: T-test - Purchase Amount by Customer Segment (Premium vs Budget)
# ========================================
cat("Q2: T-test - Purchase Amount (Premium vs Budget, FILTER!)\n")
cat("----------------------------------------------------------\n")

data_q2 <- data %>% filter(customer_segment %in% c("Premium", "Budget"))
data_q2$customer_segment <- droplevels(data_q2$customer_segment)

t_result_q2 <- t.test(purchase_amount ~ customer_segment, data = data_q2)
means_q2 <- data_q2 %>%
  group_by(customer_segment) %>%
  summarise(m = mean(purchase_amount), n = n())

cat(sprintf("N after filter: %d\n", nrow(data_q2)))
print(means_q2)
cat(sprintf("t(%.1f) = %.2f, p = %.3f\n",
            t_result_q2$parameter, t_result_q2$statistic, t_result_q2$p.value))

# Cohen's d
pooled_sd_q2 <- sqrt(((means_q2$n[1]-1)*sd(data_q2$purchase_amount[data_q2$customer_segment=="Budget"])^2 +
                      (means_q2$n[2]-1)*sd(data_q2$purchase_amount[data_q2$customer_segment=="Premium"])^2) /
                      (sum(means_q2$n)-2))
cohens_d_q2 <- abs(diff(means_q2$m)) / pooled_sd_q2
cat(sprintf("Cohen's d = %.3f\n", cohens_d_q2))
cat("\n")

# ========================================
# Q3: ANOVA - CLV by Product Category
# ========================================
cat("Q3: ANOVA - Customer Lifetime Value by Product Category\n")
cat("--------------------------------------------------------\n")

anova_q3 <- aov(customer_lifetime_value ~ product_category, data = data)
anova_sum_q3 <- summary(anova_q3)

cat(sprintf("F(%.0f, %.0f) = %.2f, p = %.3f\n",
            anova_sum_q3[[1]]$Df[1], anova_sum_q3[[1]]$Df[2],
            anova_sum_q3[[1]]$`F value`[1], anova_sum_q3[[1]]$`Pr(>F)`[1]))

# Post-hoc
tukey_q3 <- TukeyHSD(anova_q3)
tukey_df_q3 <- as.data.frame(tukey_q3$product_category)
tukey_df_q3$comparison <- rownames(tukey_df_q3)
max_diff_q3 <- tukey_df_q3[which.max(abs(tukey_df_q3$diff)), ]
cat(sprintf("Largest difference: %s (%.0f CZK)\n",
            max_diff_q3$comparison, max_diff_q3$diff))

# Eta-squared
ss_between_q3 <- anova_sum_q3[[1]]$`Sum Sq`[1]
ss_total_q3 <- sum(anova_sum_q3[[1]]$`Sum Sq`)
eta_sq_q3 <- ss_between_q3 / ss_total_q3
cat(sprintf("η² = %.3f\n", eta_sq_q3))
cat("\n")

# ========================================
# Q4: Spearman Correlation - Brand Loyalty and Purchase Frequency
# ========================================
cat("Q4: Spearman Correlation - Brand Loyalty × Purchase Frequency\n")
cat("--------------------------------------------------------------\n")

cor_q4 <- cor.test(data$brand_loyalty, data$purchase_frequency, method = "spearman")
cat(sprintf("Spearman ρ = %.3f, p = %.4f\n",
            cor_q4$estimate, cor_q4$p.value))
cat("\n")

# ========================================
# Q5: Simple Regression - Purchase Amount ~ Monthly Income
# ========================================
cat("Q5: Simple Regression - Purchase Amount ~ Monthly Income\n")
cat("---------------------------------------------------------\n")

lm_q5 <- lm(purchase_amount ~ monthly_income, data = data)
lm_sum_q5 <- summary(lm_q5)

cat(sprintf("Intercept = %.2f\n", coef(lm_q5)[1]))
cat(sprintf("Slope = %.4f\n", coef(lm_q5)[2]))
cat(sprintf("R² = %.3f\n", lm_sum_q5$r.squared))
cat(sprintf("p-value = %.4f\n", lm_sum_q5$coefficients[2,4]))
cat("\n")

# ========================================
# Q6: Multiple Regression - Customer Lifetime Value
# ========================================
cat("Q6: Multiple Regression - Customer Lifetime Value\n")
cat("--------------------------------------------------\n")

lm_q6 <- lm(customer_lifetime_value ~ monthly_income + brand_loyalty + product_category, data = data)
lm_sum_q6 <- summary(lm_q6)

cat(sprintf("R² = %.3f, Adj R² = %.3f\n",
            lm_sum_q6$r.squared, lm_sum_q6$adj.r.squared))
cat("\nCoefficients:\n")
print(lm_sum_q6$coefficients[,c(1,4)])
cat("\n")

# ========================================
# Q7: Chi-square - Payment Method × Customer Segment
# ========================================
cat("Q7: Chi-square - Payment Method × Customer Segment\n")
cat("---------------------------------------------------\n")

chi_q7 <- chisq.test(table(data$payment_method, data$customer_segment))
cat(sprintf("χ²(%.0f) = %.2f, p = %.3f\n",
            chi_q7$parameter, chi_q7$statistic, chi_q7$p.value))

n_q7 <- nrow(data)
min_dim_q7 <- min(length(unique(data$payment_method)), length(unique(data$customer_segment))) - 1
cramers_v_q7 <- sqrt(chi_q7$statistic / (n_q7 * min_dim_q7))
cat(sprintf("Cramer's V = %.3f\n", cramers_v_q7))
cat("\n")

# ========================================
# Q8: Correlation - Website Visits and Purchase Amount
# ========================================
cat("Q8: Pearson Correlation - Website Visits × Purchase Amount\n")
cat("-----------------------------------------------------------\n")

cor_q8 <- cor.test(data$website_visits_per_month, data$purchase_amount)
cat(sprintf("Pearson r = %.3f, p = %.4f\n",
            cor_q8$estimate, cor_q8$p.value))
cat("\n")

# ========================================
# Q9: Shapiro-Wilk - Normality of Monthly Income
# ========================================
cat("Q9: Shapiro-Wilk Test - Monthly Income Normality\n")
cat("------------------------------------------------\n")

shapiro_q9 <- shapiro.test(data$monthly_income)
cat(sprintf("W = %.4f, p = %.4f\n", shapiro_q9$statistic, shapiro_q9$p.value))
cat("\n")

# ========================================
# Q10: Mediator Analysis - Website Visits mediate Marketing → Purchase
# ========================================
cat("Q10: Mediator Analysis - Website Visits as Mediator\n")
cat("---------------------------------------------------\n")

# Create binary for marketing (Social vs None)
data_q10 <- data %>% filter(marketing_channel %in% c("Social", "None"))
marketing_binary <- as.numeric(data_q10$marketing_channel == "Social")

# Direct effect
cor_direct <- cor.test(marketing_binary, data_q10$purchase_amount)
cat(sprintf("Direct: Marketing × Purchase Amount: r = %.3f, p = %.4f\n",
            cor_direct$estimate, cor_direct$p.value))

# Partial correlation controlling for website visits
resid_marketing <- residuals(lm(marketing_binary ~ website_visits_per_month, data = data_q10))
resid_purchase <- residuals(lm(purchase_amount ~ website_visits_per_month, data = data_q10))
cor_partial <- cor(resid_marketing, resid_purchase)
cat(sprintf("Partial (controlling Website Visits): r = %.3f\n", cor_partial))

# Marketing → Website
cor_mediator <- cor.test(marketing_binary, data_q10$website_visits_per_month)
cat(sprintf("Marketing × Website Visits: r = %.3f, p = %.4f\n",
            cor_mediator$estimate, cor_mediator$p.value))
cat("\n")

# ========================================
# Q11: FILTER - T-test Card vs Online payment only
# ========================================
cat("Q11: FILTER - T-test (Card vs Online payment)\n")
cat("---------------------------------------------\n")

data_q11 <- data %>% filter(payment_method %in% c("Card", "Online"))
data_q11$payment_method <- droplevels(data_q11$payment_method)

t_q11 <- t.test(purchase_amount ~ payment_method, data = data_q11)
cat(sprintf("N after filter: %d\n", nrow(data_q11)))
cat(sprintf("t(%.1f) = %.2f, p = %.3f\n",
            t_q11$parameter, t_q11$statistic, t_q11$p.value))
cat("\n")

# ========================================
# Q12: FILTER - Correlation for Premium customers
# ========================================
cat("Q12: FILTER - Correlation for Premium Customers\n")
cat("------------------------------------------------\n")

data_q12 <- data %>% filter(customer_segment == "Premium")
cor_q12 <- cor.test(data_q12$service_quality, data_q12$brand_loyalty, method = "spearman")
cat(sprintf("N after filter: %d\n", nrow(data_q12)))
cat(sprintf("Spearman ρ = %.3f, p = %.4f\n",
            cor_q12$estimate, cor_q12$p.value))
cat("\n")

# ========================================
# Q13: Mann-Whitney - Time on Site by Segment
# ========================================
cat("Q13: Mann-Whitney - Time on Site (Premium vs Budget)\n")
cat("----------------------------------------------------\n")

data_q13 <- data %>% filter(customer_segment %in% c("Premium", "Budget"))
mann_q13 <- wilcox.test(time_on_site_minutes ~ customer_segment, data = data_q13)
medians_q13 <- data_q13 %>%
  group_by(customer_segment) %>%
  summarise(median = median(time_on_site_minutes))

cat(sprintf("N after filter: %d\n", nrow(data_q13)))
cat(sprintf("W = %.1f, p = %.3f\n", mann_q13$statistic, mann_q13$p.value))
print(medians_q13)
cat("\n")

# ========================================
# Q14: Contingency Table - Marketing Channel × Product Category
# ========================================
cat("Q14: Contingency Table - Marketing Channel × Product Category\n")
cat("--------------------------------------------------------------\n")

cont_q14 <- table(data$marketing_channel, data$product_category)
cat("Observed frequencies:\n")
print(cont_q14)

chi_q14 <- chisq.test(cont_q14)
cat(sprintf("\nχ²(%.0f) = %.2f, p = %.3f\n",
            chi_q14$parameter, chi_q14$statistic, chi_q14$p.value))
cat("\n")

# ========================================
# Q15: Effect Size - Product Category on CLV
# ========================================
cat("Q15: Effect Size - Product Category on CLV\n")
cat("-------------------------------------------\n")

# Already calculated in Q3
cat(sprintf("η² = %.3f\n", eta_sq_q3))
cat(sprintf("This is a %s effect\n",
            ifelse(eta_sq_q3 < 0.06, "small",
                   ifelse(eta_sq_q3 < 0.14, "medium", "large"))))
cat("\n")

# ========================================
# Q16: Stratified Analysis - Purchase Amount by Frequency
# ========================================
cat("Q16: Stratified Analysis - Purchase Amount by Frequency\n")
cat("--------------------------------------------------------\n")

amount_by_freq <- data %>%
  group_by(purchase_frequency) %>%
  summarise(
    mean_amount = mean(purchase_amount),
    sd_amount = sd(purchase_amount),
    n = n()
  ) %>%
  arrange(desc(mean_amount))

print(amount_by_freq)
cat("\n")

# ========================================
# Q17: Complex Filter - Premium + Electronics
# ========================================
cat("Q17: Complex Filter - Premium Customers + Electronics\n")
cat("------------------------------------------------------\n")

data_q17 <- data %>%
  filter(customer_segment == "Premium" & product_category == "Electronics")

cat(sprintf("N after filter: %d\n", nrow(data_q17)))
cat(sprintf("Mean purchase amount: %.0f CZK\n", mean(data_q17$purchase_amount)))
cat(sprintf("Mean CLV: %.0f CZK\n", mean(data_q17$customer_lifetime_value)))
cat("\n")

# ========================================
# Q18: Levene's Test
# ========================================
cat("Q18: Levene's Test - Homogeneity of Variance\n")
cat("---------------------------------------------\n")

if (require("car", quietly = TRUE)) {
  levene_q18 <- car::leveneTest(purchase_amount ~ customer_segment, data = data)
  cat(sprintf("F(%.0f, %.0f) = %.3f, p = %.3f\n",
              levene_q18$Df[1], levene_q18$Df[2],
              levene_q18$`F value`[1], levene_q18$`Pr(>F)`[1]))
} else {
  cat("car package not available\n")
}

cat("\n=== END OF DATASET 4 ===\n")
