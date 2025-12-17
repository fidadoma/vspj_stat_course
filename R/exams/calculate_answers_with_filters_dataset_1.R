# Calculate answers for Dataset 1 including FILTERED analyses

library(dplyr)
library(tidyr)

# Read data
data <- read.csv("R/exams/dataset_1_employee_satisfaction_EN.csv", stringsAsFactors = TRUE)

cat("=== DATASET 1: WITH FILTERS - ANSWER KEY ===\n\n")

# ========================================
# FILTER QUESTION 1: T-test excluding Contract workers
# ========================================
cat("FILTER Q1: T-test - Full-time vs Part-time ONLY (exclude Contract)\n")
cat("-------------------------------------------------------------------\n")

data_filtered_1 <- data %>%
  filter(employment_type %in% c("Full-time", "Part-time"))

t_result_filt1 <- t.test(performance_score ~ employment_type, data = data_filtered_1)
means_by_type <- data_filtered_1 %>%
  group_by(employment_type) %>%
  summarise(mean_perf = mean(performance_score), n = n())

cat(sprintf("N after filter: %d (removed %d Contract workers)\n",
            nrow(data_filtered_1), sum(data$employment_type == "Contract")))
cat(sprintf("Full-time: n = %d, Mean = %.2f\n",
            means_by_type$n[1], means_by_type$mean_perf[1]))
cat(sprintf("Part-time: n = %d, Mean = %.2f\n",
            means_by_type$n[2], means_by_type$mean_perf[2]))
cat(sprintf("t-statistic: %.2f\n", t_result_filt1$statistic))
cat(sprintf("df: %.1f\n", t_result_filt1$parameter))
cat(sprintf("p-value: %.3f\n", t_result_filt1$p.value))

if (t_result_filt1$p.value < 0.05) {
  cat("Result: significant\n")
} else {
  cat("Result: not significant\n")
}

cat("\n")

# ========================================
# FILTER QUESTION 2: ANOVA excluding HR and Operations
# ========================================
cat("FILTER Q2: ANOVA - Salary by Department (IT, Sales, Finance ONLY)\n")
cat("-------------------------------------------------------------------\n")

data_filtered_2 <- data %>%
  filter(department %in% c("IT", "Sales", "Finance"))

# Re-level to drop unused levels
data_filtered_2$department <- droplevels(data_filtered_2$department)

anova_result_filt2 <- aov(salary ~ department, data = data_filtered_2)
anova_summary_filt2 <- summary(anova_result_filt2)

means_by_dept <- data_filtered_2 %>%
  group_by(department) %>%
  summarise(mean_sal = mean(salary), n = n())

cat(sprintf("N after filter: %d (excluded HR and Operations)\n", nrow(data_filtered_2)))
print(means_by_dept)
cat(sprintf("\nF-statistic: %.2f\n", anova_summary_filt2[[1]]$`F value`[1]))
cat(sprintf("df between: %.0f\n", anova_summary_filt2[[1]]$Df[1]))
cat(sprintf("df within: %.0f\n", anova_summary_filt2[[1]]$Df[2]))
cat(sprintf("p-value: %.3f\n", anova_summary_filt2[[1]]$`Pr(>F)`[1]))

if (anova_summary_filt2[[1]]$`Pr(>F)`[1] < 0.05) {
  cat("Conclusion: Difference exists\n")
} else {
  cat("Conclusion: No significant difference\n")
}

# Post-hoc
tukey_filt2 <- TukeyHSD(anova_result_filt2)
tukey_df_filt2 <- as.data.frame(tukey_filt2$department)
tukey_df_filt2$comparison <- rownames(tukey_df_filt2)
max_diff_row_filt2 <- tukey_df_filt2[which.max(abs(tukey_df_filt2$diff)), ]
cat(sprintf("Largest difference (Tukey): %s (diff = %.0f CZK)\n",
            max_diff_row_filt2$comparison, max_diff_row_filt2$diff))

cat("\n")

# ========================================
# FILTER QUESTION 3: Correlation for High Education only
# ========================================
cat("FILTER Q3: Correlation - Years Experience vs Salary (Master & PhD ONLY)\n")
cat("------------------------------------------------------------------------\n")

data_filtered_3 <- data %>%
  filter(education %in% c("Master", "PhD"))

cor_result_filt3 <- cor.test(data_filtered_3$years_experience,
                              data_filtered_3$salary,
                              method = "pearson")

cat(sprintf("N after filter: %d (Bachelor and High School excluded)\n", nrow(data_filtered_3)))
cat(sprintf("Pearson r: %.3f\n", cor_result_filt3$estimate))
cat(sprintf("p-value: %.4f\n", cor_result_filt3$p.value))
cat(sprintf("95%% CI: [%.3f, %.3f]\n",
            cor_result_filt3$conf.int[1], cor_result_filt3$conf.int[2]))

if (cor_result_filt3$p.value < 0.05) {
  cat("Result: significant\n")
} else {
  cat("Result: not significant\n")
}

cat("\n")

# ========================================
# FILTER QUESTION 4: Chi-square excluding one category
# ========================================
cat("FILTER Q4: Chi-square - Education × Remote Work (exclude PhD)\n")
cat("---------------------------------------------------------------\n")

data_filtered_4 <- data %>%
  filter(education != "PhD")

data_filtered_4$education <- droplevels(data_filtered_4$education)

chi_table_filt4 <- table(data_filtered_4$education, data_filtered_4$remote_work)
chi_result_filt4 <- chisq.test(chi_table_filt4)

cat(sprintf("N after filter: %d (PhD excluded, n=%d)\n",
            nrow(data_filtered_4), sum(data$education == "PhD")))
cat("Contingency table:\n")
print(chi_table_filt4)
cat(sprintf("\nχ²(%.0f) = %.2f, p = %.3f\n",
            chi_result_filt4$parameter,
            chi_result_filt4$statistic,
            chi_result_filt4$p.value))

if (chi_result_filt4$p.value < 0.05) {
  cat("Conclusion: Variables are dependent\n")
} else {
  cat("Conclusion: Variables are independent\n")
}

n_filt4 <- sum(chi_table_filt4)
min_dim_filt4 <- min(nrow(chi_table_filt4), ncol(chi_table_filt4)) - 1
cramers_v_filt4 <- sqrt(chi_result_filt4$statistic / (n_filt4 * min_dim_filt4))
cat(sprintf("Cramer's V: %.3f\n", cramers_v_filt4))

cat("\n")

# ========================================
# FILTER QUESTION 5: Regression with numeric filter
# ========================================
cat("FILTER Q5: Regression - Performance ~ Satisfaction (age ≥ 35 ONLY)\n")
cat("-------------------------------------------------------------------\n")

data_filtered_5 <- data %>%
  filter(age >= 35)

lm_filt5 <- lm(performance_score ~ job_satisfaction, data = data_filtered_5)
lm_summary_filt5 <- summary(lm_filt5)

cat(sprintf("N after filter: %d (age < 35 excluded, n=%d)\n",
            nrow(data_filtered_5), sum(data$age < 35)))
cat(sprintf("Intercept: %.2f\n", coef(lm_filt5)[1]))
cat(sprintf("Slope: %.2f\n", coef(lm_filt5)[2]))
cat(sprintf("R²: %.3f\n", lm_summary_filt5$r.squared))
cat(sprintf("F(%.0f, %.0f) = %.2f, p = %.4f\n",
            lm_summary_filt5$fstatistic[2],
            lm_summary_filt5$fstatistic[3],
            lm_summary_filt5$fstatistic[1],
            pf(lm_summary_filt5$fstatistic[1],
               lm_summary_filt5$fstatistic[2],
               lm_summary_filt5$fstatistic[3],
               lower.tail = FALSE)))

cat("\n")

# ========================================
# FILTER QUESTION 6: Multiple filters combined
# ========================================
cat("FILTER Q6: Complex Filter - Sick days by stress (Remote workers, Full-time ONLY)\n")
cat("---------------------------------------------------------------------------------\n")

data_filtered_6 <- data %>%
  filter(remote_work == "Yes" & employment_type == "Full-time")

# ANOVA: sick_days by stress_level
data_filtered_6$stress_level_cat <- as.factor(data_filtered_6$stress_level)
anova_filt6 <- aov(sick_days ~ stress_level_cat, data = data_filtered_6)
anova_summary_filt6 <- summary(anova_filt6)

means_stress <- data_filtered_6 %>%
  group_by(stress_level) %>%
  summarise(mean_sick = mean(sick_days), n = n()) %>%
  arrange(stress_level)

cat(sprintf("N after filter: %d (Remote=Yes AND Full-time)\n", nrow(data_filtered_6)))
cat(sprintf("Original N: %d\n", nrow(data)))
cat("\nMeans by stress level:\n")
print(means_stress)
cat(sprintf("\nF(%.0f, %.0f) = %.2f, p = %.3f\n",
            anova_summary_filt6[[1]]$Df[1],
            anova_summary_filt6[[1]]$Df[2],
            anova_summary_filt6[[1]]$`F value`[1],
            anova_summary_filt6[[1]]$`Pr(>F)`[1]))

if (anova_summary_filt6[[1]]$`Pr(>F)`[1] < 0.05) {
  cat("Conclusion: Stress level affects sick days (in filtered group)\n")
} else {
  cat("Conclusion: No significant effect\n")
}

# Eta-squared
ss_between_filt6 <- anova_summary_filt6[[1]]$`Sum Sq`[1]
ss_total_filt6 <- sum(anova_summary_filt6[[1]]$`Sum Sq`)
eta_squared_filt6 <- ss_between_filt6 / ss_total_filt6
cat(sprintf("η² = %.3f\n", eta_squared_filt6))

cat("\n")

# ========================================
# SUMMARY TABLE FOR QUICK REFERENCE
# ========================================
cat("=== QUICK REFERENCE SUMMARY ===\n")
cat("-------------------------------\n\n")

cat("FILTER Q1 (t-test, Full-time vs Part-time only):\n")
cat(sprintf("  t(%.1f) = %.2f, p = %.3f\n",
            t_result_filt1$parameter, t_result_filt1$statistic, t_result_filt1$p.value))

cat("\nFILTER Q2 (ANOVA, IT/Sales/Finance only):\n")
cat(sprintf("  F(%.0f, %.0f) = %.2f, p = %.3f\n",
            anova_summary_filt2[[1]]$Df[1], anova_summary_filt2[[1]]$Df[2],
            anova_summary_filt2[[1]]$`F value`[1], anova_summary_filt2[[1]]$`Pr(>F)`[1]))
cat(sprintf("  Largest diff: %s\n", max_diff_row_filt2$comparison))

cat("\nFILTER Q3 (Correlation, Master & PhD only):\n")
cat(sprintf("  r = %.3f, p = %.4f\n", cor_result_filt3$estimate, cor_result_filt3$p.value))

cat("\nFILTER Q4 (Chi-square, exclude PhD):\n")
cat(sprintf("  χ²(%.0f) = %.2f, p = %.3f, V = %.3f\n",
            chi_result_filt4$parameter, chi_result_filt4$statistic,
            chi_result_filt4$p.value, cramers_v_filt4))

cat("\nFILTER Q5 (Regression, age ≥ 35 only):\n")
cat(sprintf("  Slope = %.2f, R² = %.3f\n",
            coef(lm_filt5)[2], lm_summary_filt5$r.squared))

cat("\nFILTER Q6 (ANOVA, Remote=Yes & Full-time only):\n")
cat(sprintf("  F(%.0f, %.0f) = %.2f, p = %.3f, η² = %.3f\n",
            anova_summary_filt6[[1]]$Df[1], anova_summary_filt6[[1]]$Df[2],
            anova_summary_filt6[[1]]$`F value`[1],
            anova_summary_filt6[[1]]$`Pr(>F)`[1],
            eta_squared_filt6))

cat("\n=== END ===\n")
