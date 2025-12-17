# Calculate answers for ADDITIONAL questions (17-25) - Dataset 1

library(dplyr)
library(tidyr)

# Read data
data <- read.csv("R/exams/dataset_1_employee_satisfaction_EN.csv", stringsAsFactors = TRUE)

cat("=== ADDITIONAL QUESTIONS (17-25) - ANSWER KEY ===\n\n")

# ========================================
# QUESTION 17: Normality test (Shapiro-Wilk)
# ========================================
cat("Q17: Shapiro-Wilk Test - Normality of Performance Score\n")
cat("--------------------------------------------------------\n")

shapiro_result <- shapiro.test(data$performance_score)
cat(sprintf("W = %.4f\n", shapiro_result$statistic))
cat(sprintf("p-value = %.4f\n", shapiro_result$p.value))

if (shapiro_result$p.value > 0.05) {
  cat("Conclusion: Data ARE normally distributed (p > 0.05)\n")
} else {
  cat("Conclusion: Data are NOT normally distributed (p < 0.05)\n")
}

# Also test for salary
shapiro_salary <- shapiro.test(data$salary)
cat(sprintf("\nSalary: W = %.4f, p = %.4f\n", shapiro_salary$statistic, shapiro_salary$p.value))

cat("\n")

# ========================================
# QUESTION 18: Levene's test for homogeneity of variance
# ========================================
cat("Q18: Levene's Test - Homogeneity of Variance\n")
cat("---------------------------------------------\n")

# For performance_score by department
# Using car package if available, otherwise approximate
if (require("car", quietly = TRUE)) {
  levene_result <- car::leveneTest(performance_score ~ department, data = data)
  cat(sprintf("F(%.0f, %.0f) = %.3f\n",
              levene_result$Df[1], levene_result$Df[2], levene_result$`F value`[1]))
  cat(sprintf("p-value = %.3f\n", levene_result$`Pr(>F)`[1]))

  if (levene_result$`Pr(>F)`[1] > 0.05) {
    cat("Conclusion: Variances ARE homogeneous (p > 0.05)\n")
  } else {
    cat("Conclusion: Variances are NOT homogeneous (p < 0.05)\n")
  }
} else {
  cat("Note: car package not available, using approximate values\n")
  # Approximate calculation
  group_vars <- data %>%
    group_by(department) %>%
    summarise(variance = var(performance_score))
  cat("Group variances:\n")
  print(group_vars)
}

cat("\n")

# ========================================
# QUESTION 19: Paired comparison within groups
# ========================================
cat("Q19: Comparing Two Continuous Variables (paired structure)\n")
cat("------------------------------------------------------------\n")

# Compare overtime_hours between high and low performers
data_q19 <- data %>%
  mutate(performance_group = ifelse(performance_score > median(performance_score),
                                   "High", "Low"))

overtime_stats <- data_q19 %>%
  group_by(performance_group) %>%
  summarise(mean_overtime = mean(overtime_hours),
            sd_overtime = sd(overtime_hours),
            n = n())

cat("Overtime hours by performance group:\n")
print(overtime_stats)

t_test_q19 <- t.test(overtime_hours ~ performance_group, data = data_q19)
cat(sprintf("\nt(%.1f) = %.2f, p = %.3f\n",
            t_test_q19$parameter, t_test_q19$statistic, t_test_q19$p.value))

cat("\n")

# ========================================
# QUESTION 20: Multiple comparisons with Bonferroni
# ========================================
cat("Q20: Multiple Comparisons - Work-Life Balance by Education\n")
cat("-----------------------------------------------------------\n")

anova_q20 <- aov(work_life_balance ~ education, data = data)
anova_summary_q20 <- summary(anova_q20)

cat(sprintf("ANOVA: F(%.0f, %.0f) = %.2f, p = %.3f\n",
            anova_summary_q20[[1]]$Df[1],
            anova_summary_q20[[1]]$Df[2],
            anova_summary_q20[[1]]$`F value`[1],
            anova_summary_q20[[1]]$`Pr(>F)`[1]))

# Pairwise t-tests with Bonferroni
pairwise_q20 <- pairwise.t.test(data$work_life_balance, data$education,
                                p.adjust.method = "bonferroni")
cat("\nPairwise comparisons (Bonferroni adjusted):\n")
print(pairwise_q20$p.value)

cat("\n")

# ========================================
# QUESTION 21: Contingency table with percentages
# ========================================
cat("Q21: Contingency Table Analysis - Department × Employment Type\n")
cat("---------------------------------------------------------------\n")

cont_table_q21 <- table(data$department, data$employment_type)
cat("Observed frequencies:\n")
print(cont_table_q21)

# Row percentages
row_pct <- prop.table(cont_table_q21, 1) * 100
cat("\nRow percentages (by department):\n")
print(round(row_pct, 1))

# Which department has highest % of full-time
full_time_pct <- row_pct[, "Full-time"]
highest_ft_dept <- names(which.max(full_time_pct))
cat(sprintf("\nDepartment with highest %% Full-time: %s (%.1f%%)\n",
            highest_ft_dept, max(full_time_pct)))

cat("\n")

# ========================================
# QUESTION 22: Filter + Multiple regression comparison
# ========================================
cat("Q22: Model Comparison - With and Without Filter\n")
cat("------------------------------------------------\n")

# Model 1: All data
lm_full <- lm(salary ~ years_experience + education + department, data = data)
r2_full <- summary(lm_full)$r.squared
adj_r2_full <- summary(lm_full)$adj.r.squared

cat(sprintf("Model (all data, N=%d):\n", nrow(data)))
cat(sprintf("  R² = %.3f, Adj R² = %.3f\n", r2_full, adj_r2_full))

# Model 2: Only Full-time employees
data_ft <- data %>% filter(employment_type == "Full-time")
lm_filtered <- lm(salary ~ years_experience + education + department, data = data_ft)
r2_filt <- summary(lm_filtered)$r.squared
adj_r2_filt <- summary(lm_filtered)$adj.r.squared

cat(sprintf("\nModel (Full-time only, N=%d):\n", nrow(data_ft)))
cat(sprintf("  R² = %.3f, Adj R² = %.3f\n", r2_filt, adj_r2_filt))

cat(sprintf("\nDifference in R²: %.3f\n", r2_filt - r2_full))

cat("\n")

# ========================================
# QUESTION 23: Non-parametric alternative (Mann-Whitney)
# ========================================
cat("Q23: Mann-Whitney U Test - Sick Days by Remote Work\n")
cat("----------------------------------------------------\n")

mann_whitney <- wilcox.test(sick_days ~ remote_work, data = data)
cat(sprintf("W = %.1f\n", mann_whitney$statistic))
cat(sprintf("p-value = %.3f\n", mann_whitney$p.value))

medians_q23 <- data %>%
  group_by(remote_work) %>%
  summarise(median_sick = median(sick_days))

cat("\nMedians by group:\n")
print(medians_q23)

if (mann_whitney$p.value < 0.05) {
  cat("\nConclusion: Distributions differ significantly\n")
} else {
  cat("\nConclusion: No significant difference in distributions\n")
}

cat("\n")

# ========================================
# QUESTION 24: Complex filter + stratified analysis
# ========================================
cat("Q24: Stratified Analysis - Correlation by Department\n")
cat("-----------------------------------------------------\n")

# Correlation between satisfaction and performance for each department
cor_by_dept <- data %>%
  group_by(department) %>%
  summarise(
    n = n(),
    correlation = cor(job_satisfaction, performance_score),
    p_value = cor.test(job_satisfaction, performance_score)$p.value
  ) %>%
  arrange(desc(abs(correlation)))

cat("Correlation (job_satisfaction × performance_score) by department:\n")
print(cor_by_dept, n = Inf)

strongest_dept <- cor_by_dept$department[1]
strongest_r <- cor_by_dept$correlation[1]
cat(sprintf("\nStrongest correlation in: %s (r = %.3f)\n", strongest_dept, strongest_r))

cat("\n")

# ========================================
# QUESTION 25: Effect size comparison
# ========================================
cat("Q25: Effect Size Comparison Across Multiple Tests\n")
cat("--------------------------------------------------\n")

# Cohen's d for t-test (remote work and salary)
t_result_q25 <- t.test(salary ~ remote_work, data = data)
means_q25 <- data %>%
  group_by(remote_work) %>%
  summarise(m = mean(salary), s = sd(salary), n = n())

pooled_sd_q25 <- sqrt(((means_q25$n[1]-1)*means_q25$s[1]^2 +
                       (means_q25$n[2]-1)*means_q25$s[2]^2) /
                       (sum(means_q25$n)-2))
cohens_d_q25 <- abs(diff(means_q25$m)) / pooled_sd_q25

cat(sprintf("T-test (remote_work × salary):\n"))
cat(sprintf("  Cohen's d = %.3f (%s effect)\n",
            cohens_d_q25,
            ifelse(cohens_d_q25 < 0.5, "small",
                   ifelse(cohens_d_q25 < 0.8, "medium", "large"))))

# Eta-squared for ANOVA (department and performance)
anova_q25 <- aov(performance_score ~ department, data = data)
ss_between_q25 <- summary(anova_q25)[[1]]$`Sum Sq`[1]
ss_total_q25 <- sum(summary(anova_q25)[[1]]$`Sum Sq`)
eta_sq_q25 <- ss_between_q25 / ss_total_q25

cat(sprintf("\nANOVA (department × performance_score):\n"))
cat(sprintf("  η² = %.3f (%s effect)\n",
            eta_sq_q25,
            ifelse(eta_sq_q25 < 0.06, "small",
                   ifelse(eta_sq_q25 < 0.14, "medium", "large"))))

# Cramer's V for chi-square (education and remote_work)
chi_q25 <- chisq.test(table(data$education, data$remote_work))
n_q25 <- nrow(data)
cramers_v_q25 <- sqrt(chi_q25$statistic / (n_q25 * 1))  # min(r-1, c-1) = 1

cat(sprintf("\nChi-square (education × remote_work):\n"))
cat(sprintf("  Cramer's V = %.3f (%s effect)\n",
            cramers_v_q25,
            ifelse(cramers_v_q25 < 0.3, "small",
                   ifelse(cramers_v_q25 < 0.5, "medium", "large"))))

cat(sprintf("\nLargest effect size: %s\n",
            ifelse(eta_sq_q25 > cohens_d_q25 && eta_sq_q25 > cramers_v_q25,
                   "ANOVA (department effect)",
                   ifelse(cohens_d_q25 > cramers_v_q25,
                          "T-test (remote work effect)",
                          "Chi-square (education effect)"))))

cat("\n")

# ========================================
# SUMMARY
# ========================================
cat("=== QUICK REFERENCE (Q17-Q25) ===\n")
cat("----------------------------------\n\n")

cat("Q17 (Shapiro-Wilk normality):\n")
cat(sprintf("  W = %.4f, p = %.4f\n", shapiro_result$statistic, shapiro_result$p.value))

cat("\nQ18 (Levene's homogeneity):\n")
cat("  [See detailed output above]\n")

cat("\nQ19 (Overtime by performance):\n")
cat(sprintf("  t(%.1f) = %.2f, p = %.3f\n", t_test_q19$parameter,
            t_test_q19$statistic, t_test_q19$p.value))

cat("\nQ20 (Work-life balance by education):\n")
cat(sprintf("  F(%.0f, %.0f) = %.2f, p = %.3f\n",
            anova_summary_q20[[1]]$Df[1], anova_summary_q20[[1]]$Df[2],
            anova_summary_q20[[1]]$`F value`[1], anova_summary_q20[[1]]$`Pr(>F)`[1]))

cat("\nQ21 (Department with highest % Full-time):\n")
cat(sprintf("  %s (%.1f%%)\n", highest_ft_dept, max(full_time_pct)))

cat("\nQ22 (Model comparison):\n")
cat(sprintf("  Full model R² = %.3f, Filtered R² = %.3f\n", r2_full, r2_filt))

cat("\nQ23 (Mann-Whitney U test):\n")
cat(sprintf("  W = %.1f, p = %.3f\n", mann_whitney$statistic, mann_whitney$p.value))

cat("\nQ24 (Stratified correlation):\n")
cat(sprintf("  Strongest in %s (r = %.3f)\n", strongest_dept, strongest_r))

cat("\nQ25 (Effect sizes):\n")
cat(sprintf("  Cohen's d = %.3f, η² = %.3f, Cramer's V = %.3f\n",
            cohens_d_q25, eta_sq_q25, cramers_v_q25))

cat("\n=== END ===\n")
