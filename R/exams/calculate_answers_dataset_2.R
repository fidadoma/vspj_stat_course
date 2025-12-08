# Calculate answers for Dataset 2: Patient Recovery
# 20 comprehensive questions

library(dplyr)
library(tidyr)

# Read data
data <- read.csv("R/exams/dataset_2_patient_recovery_EN.csv", stringsAsFactors = TRUE)

cat("=== DATASET 2: PATIENT RECOVERY - ANSWER KEY ===\n")
cat("Total N =", nrow(data), "\n\n")

# ========================================
# Q1: Descriptive Statistics - Recovery Time
# ========================================
cat("Q1: Descriptive Statistics - Recovery Time\n")
cat("-------------------------------------------\n")

recovery_stats <- data %>%
  summarise(
    mean = mean(recovery_time_weeks),
    median = median(recovery_time_weeks),
    sd = sd(recovery_time_weeks),
    q1 = quantile(recovery_time_weeks, 0.25),
    q3 = quantile(recovery_time_weeks, 0.75),
    min = min(recovery_time_weeks),
    max = max(recovery_time_weeks)
  )

print(recovery_stats)
cat("\n")

# ========================================
# Q2: T-test - Recovery by Smoking Status
# ========================================
cat("Q2: T-test - Current vs Never smokers (FILTER!)\n")
cat("------------------------------------------------\n")

data_q2 <- data %>% filter(smoking_status %in% c("Never", "Current"))
data_q2$smoking_status <- droplevels(data_q2$smoking_status)

t_result_q2 <- t.test(recovery_time_weeks ~ smoking_status, data = data_q2)
means_q2 <- data_q2 %>%
  group_by(smoking_status) %>%
  summarise(m = mean(recovery_time_weeks), n = n())

cat(sprintf("N after filter: %d (excluded %d Former smokers)\n",
            nrow(data_q2), sum(data$smoking_status == "Former")))
print(means_q2)
cat(sprintf("t(%.1f) = %.2f, p = %.3f\n",
            t_result_q2$parameter, t_result_q2$statistic, t_result_q2$p.value))

# Cohen's d
pooled_sd_q2 <- sqrt(((means_q2$n[1]-1)*sd(data_q2$recovery_time_weeks[data_q2$smoking_status=="Current"])^2 +
                      (means_q2$n[2]-1)*sd(data_q2$recovery_time_weeks[data_q2$smoking_status=="Never"])^2) /
                      (sum(means_q2$n)-2))
cohens_d_q2 <- abs(diff(means_q2$m)) / pooled_sd_q2
cat(sprintf("Cohen's d = %.3f\n", cohens_d_q2))
cat("\n")

# ========================================
# Q3: ANOVA - Recovery by Procedure Type
# ========================================
cat("Q3: ANOVA - Recovery Time by Procedure Type\n")
cat("---------------------------------------------\n")

anova_q3 <- aov(recovery_time_weeks ~ procedure_type, data = data)
anova_sum_q3 <- summary(anova_q3)

cat(sprintf("F(%.0f, %.0f) = %.2f, p = %.3f\n",
            anova_sum_q3[[1]]$Df[1], anova_sum_q3[[1]]$Df[2],
            anova_sum_q3[[1]]$`F value`[1], anova_sum_q3[[1]]$`Pr(>F)`[1]))

# Post-hoc
tukey_q3 <- TukeyHSD(anova_q3)
tukey_df_q3 <- as.data.frame(tukey_q3$procedure_type)
tukey_df_q3$comparison <- rownames(tukey_df_q3)
max_diff_q3 <- tukey_df_q3[which.max(abs(tukey_df_q3$diff)), ]
cat(sprintf("Largest difference: %s (%.2f weeks)\n",
            max_diff_q3$comparison, max_diff_q3$diff))

# Eta-squared
ss_between_q3 <- anova_sum_q3[[1]]$`Sum Sq`[1]
ss_total_q3 <- sum(anova_sum_q3[[1]]$`Sum Sq`)
eta_sq_q3 <- ss_between_q3 / ss_total_q3
cat(sprintf("η² = %.3f\n", eta_sq_q3))
cat("\n")

# ========================================
# Q4: Correlation - Age and Comorbidity
# ========================================
cat("Q4: Correlation - Age × Comorbidity Index\n")
cat("------------------------------------------\n")

cor_q4 <- cor.test(data$age, data$comorbidity_index, method = "spearman")
cat(sprintf("Spearman ρ = %.3f, p = %.4f\n",
            cor_q4$estimate, cor_q4$p.value))
cat("\n")

# ========================================
# Q5: Simple Regression - Recovery ~ Comorbidity
# ========================================
cat("Q5: Simple Regression - Recovery ~ Comorbidity\n")
cat("-----------------------------------------------\n")

lm_q5 <- lm(recovery_time_weeks ~ comorbidity_index, data = data)
lm_sum_q5 <- summary(lm_q5)

cat(sprintf("Intercept = %.2f\n", coef(lm_q5)[1]))
cat(sprintf("Slope = %.2f\n", coef(lm_q5)[2]))
cat(sprintf("R² = %.3f\n", lm_sum_q5$r.squared))
cat(sprintf("p-value = %.4f\n", lm_sum_q5$coefficients[2,4]))
cat("\n")

# ========================================
# Q6: Multiple Regression
# ========================================
cat("Q6: Multiple Regression - Recovery Time\n")
cat("----------------------------------------\n")

lm_q6 <- lm(recovery_time_weeks ~ age + comorbidity_index + procedure_type, data = data)
lm_sum_q6 <- summary(lm_q6)

cat(sprintf("R² = %.3f, Adj R² = %.3f\n",
            lm_sum_q6$r.squared, lm_sum_q6$adj.r.squared))
cat("\nCoefficients:\n")
print(lm_sum_q6$coefficients[,c(1,4)])
cat("\n")

# ========================================
# Q7: Chi-square - Insurance × Procedure
# ========================================
cat("Q7: Chi-square - Insurance Type × Procedure\n")
cat("--------------------------------------------\n")

chi_q7 <- chisq.test(table(data$insurance_type, data$procedure_type))
cat(sprintf("χ²(%.0f) = %.2f, p = %.3f\n",
            chi_q7$parameter, chi_q7$statistic, chi_q7$p.value))

n_q7 <- nrow(data)
min_dim_q7 <- min(length(unique(data$insurance_type)), length(unique(data$procedure_type))) - 1
cramers_v_q7 <- sqrt(chi_q7$statistic / (n_q7 * min_dim_q7))
cat(sprintf("Cramer's V = %.3f\n", cramers_v_q7))
cat("\n")

# ========================================
# Q8: Spearman - Pain and Mobility
# ========================================
cat("Q8: Spearman Correlation - Pain × Mobility\n")
cat("-------------------------------------------\n")

cor_q8 <- cor.test(data$pain_level, data$mobility_score, method = "spearman")
cat(sprintf("Spearman ρ = %.3f, p = %.4f\n",
            cor_q8$estimate, cor_q8$p.value))
cat("\n")

# ========================================
# Q9: Shapiro-Wilk - Normality of BMI
# ========================================
cat("Q9: Shapiro-Wilk Test - BMI Normality\n")
cat("--------------------------------------\n")

shapiro_q9 <- shapiro.test(data$bmi)
cat(sprintf("W = %.4f, p = %.4f\n", shapiro_q9$statistic, shapiro_q9$p.value))
cat("\n")

# ========================================
# Q10: Collider Analysis (DAG - BMI)
# ========================================
cat("Q10: Collider Analysis - BMI as Collider\n")
cat("-----------------------------------------\n")

# Simple correlation age × recovery
cor_simple <- cor(data$age, data$recovery_time_weeks)
cat(sprintf("Correlation age × recovery (simple): r = %.3f\n", cor_simple))

# Partial correlation controlling for BMI
# Using residuals method
resid_age <- residuals(lm(age ~ bmi, data = data))
resid_recovery <- residuals(lm(recovery_time_weeks ~ bmi, data = data))
cor_partial <- cor(resid_age, resid_recovery)
cat(sprintf("Correlation age × recovery (controlling BMI): r = %.3f\n", cor_partial))

cat("\n")

# ========================================
# Q11: FILTER - ANOVA for Hip and Knee only
# ========================================
cat("Q11: FILTER - ANOVA (Hip and Knee procedures only)\n")
cat("---------------------------------------------------\n")

data_q11 <- data %>% filter(procedure_type %in% c("Hip", "Knee"))
data_q11$procedure_type <- droplevels(data_q11$procedure_type)

t_q11 <- t.test(days_hospitalized ~ procedure_type, data = data_q11)
cat(sprintf("N after filter: %d\n", nrow(data_q11)))
cat(sprintf("t(%.1f) = %.2f, p = %.3f\n",
            t_q11$parameter, t_q11$statistic, t_q11$p.value))
cat("\n")

# ========================================
# Q12: FILTER - Correlation for elderly (age >= 65)
# ========================================
cat("Q12: FILTER - Correlation for elderly (age >= 65)\n")
cat("--------------------------------------------------\n")

data_q12 <- data %>% filter(age >= 65)
cor_q12 <- cor.test(data_q12$pre_surgery_score, data_q12$post_surgery_score)
cat(sprintf("N after filter: %d\n", nrow(data_q12)))
cat(sprintf("Pearson r = %.3f, p = %.4f\n",
            cor_q12$estimate, cor_q12$p.value))
cat("\n")

# ========================================
# Q13: Mann-Whitney - Days by Ward
# ========================================
cat("Q13: Mann-Whitney - Days Hospitalized by Ward (A vs D)\n")
cat("-------------------------------------------------------\n")

data_q13 <- data %>% filter(hospital_ward %in% c("A", "D"))
mann_q13 <- wilcox.test(days_hospitalized ~ hospital_ward, data = data_q13)
medians_q13 <- data_q13 %>%
  group_by(hospital_ward) %>%
  summarise(median = median(days_hospitalized))

cat(sprintf("N after filter: %d\n", nrow(data_q13)))
cat(sprintf("W = %.1f, p = %.3f\n", mann_q13$statistic, mann_q13$p.value))
print(medians_q13)
cat("\n")

# ========================================
# Q14: Contingency Table - Smoking × Comorbidity
# ========================================
cat("Q14: Contingency Table - Smoking Status × Comorbidity\n")
cat("------------------------------------------------------\n")

cont_q14 <- table(data$smoking_status, data$comorbidity_index)
cat("Observed frequencies:\n")
print(cont_q14)

chi_q14 <- chisq.test(cont_q14)
cat(sprintf("\nχ²(%.0f) = %.2f, p = %.3f\n",
            chi_q14$parameter, chi_q14$statistic, chi_q14$p.value))
cat("\n")

# ========================================
# Q15: Effect Size Comparison
# ========================================
cat("Q15: Effect Size - Procedure Type on Recovery\n")
cat("----------------------------------------------\n")

# Already calculated in Q3
cat(sprintf("η² = %.3f\n", eta_sq_q3))
cat(sprintf("This is a %s effect\n",
            ifelse(eta_sq_q3 < 0.06, "small",
                   ifelse(eta_sq_q3 < 0.14, "medium", "large"))))
cat("\n")

# ========================================
# Q16: Regression Comparison with/without Filter
# ========================================
cat("Q16: Model Comparison - Public Insurance Only\n")
cat("----------------------------------------------\n")

# All data
lm_q16_all <- lm(medication_cost ~ comorbidity_index + days_hospitalized, data = data)
r2_all_q16 <- summary(lm_q16_all)$r.squared

# Public insurance only
data_q16 <- data %>% filter(insurance_type == "Public")
lm_q16_filt <- lm(medication_cost ~ comorbidity_index + days_hospitalized, data = data_q16)
r2_filt_q16 <- summary(lm_q16_filt)$r.squared

cat(sprintf("All data (N=%d): R² = %.3f\n", nrow(data), r2_all_q16))
cat(sprintf("Public only (N=%d): R² = %.3f\n", nrow(data_q16), r2_filt_q16))
cat(sprintf("Difference: %.3f\n", r2_filt_q16 - r2_all_q16))
cat("\n")

# ========================================
# Q17: Stratified Analysis - Treatment Satisfaction
# ========================================
cat("Q17: Stratified Analysis - Satisfaction by Procedure\n")
cat("-----------------------------------------------------\n")

sat_by_proc <- data %>%
  group_by(procedure_type) %>%
  summarise(
    mean_sat = mean(treatment_satisfaction),
    sd_sat = sd(treatment_satisfaction),
    n = n()
  ) %>%
  arrange(desc(mean_sat))

print(sat_by_proc)
cat("\n")

# ========================================
# Q18: Pre-Post Comparison (paired concept)
# ========================================
cat("Q18: Pre vs Post Surgery Scores (mean difference)\n")
cat("--------------------------------------------------\n")

mean_pre <- mean(data$pre_surgery_score)
mean_post <- mean(data$post_surgery_score)
diff_mean <- mean_post - mean_pre

cat(sprintf("Mean Pre-surgery: %.2f\n", mean_pre))
cat(sprintf("Mean Post-surgery: %.2f\n", mean_post))
cat(sprintf("Mean improvement: %.2f points\n", diff_mean))

# Paired t-test (conceptual - treating as paired)
t_paired <- t.test(data$post_surgery_score, data$pre_surgery_score, paired = TRUE)
cat(sprintf("t(%.0f) = %.2f, p = %.4f\n",
            t_paired$parameter, t_paired$statistic, t_paired$p.value))
cat("\n")

# ========================================
# Q19: Multiple Filter - Complex query
# ========================================
cat("Q19: Complex Filter - Public Insurance + Spine Procedure\n")
cat("---------------------------------------------------------\n")

data_q19 <- data %>%
  filter(insurance_type == "Public" & procedure_type == "Spine")

cat(sprintf("N after filter: %d\n", nrow(data_q19)))
cat(sprintf("Mean recovery time: %.2f weeks\n", mean(data_q19$recovery_time_weeks)))
cat(sprintf("Mean cost: %.0f CZK\n", mean(data_q19$medication_cost)))
cat("\n")

# ========================================
# Q20: Levene's Test
# ========================================
cat("Q20: Levene's Test - Homogeneity of Variance\n")
cat("---------------------------------------------\n")

if (require("car", quietly = TRUE)) {
  levene_q20 <- car::leveneTest(recovery_time_weeks ~ procedure_type, data = data)
  cat(sprintf("F(%.0f, %.0f) = %.3f, p = %.3f\n",
              levene_q20$Df[1], levene_q20$Df[2],
              levene_q20$`F value`[1], levene_q20$`Pr(>F)`[1]))
} else {
  cat("car package not available\n")
}

cat("\n=== END OF DATASET 2 ===\n")
