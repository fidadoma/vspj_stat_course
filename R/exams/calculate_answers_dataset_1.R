# Calculate answers for Dataset 1 questions

library(dplyr)
library(tidyr)

# Read data
data <- read.csv("R/exams/dataset_1_employee_satisfaction_EN.csv", stringsAsFactors = TRUE)

cat("=== DATASET 1: EMPLOYEE SATISFACTION - ANSWER KEY ===\n\n")

# ========================================
# QUESTION 1: Descriptive Statistics & Visualization
# ========================================
cat("QUESTION 1: Descriptive Statistics of Salary\n")
cat("---------------------------------------------\n")

salary_stats <- data %>%
  summarise(
    mean_salary = mean(salary),
    median_salary = median(salary),
    sd_salary = sd(salary),
    q1_salary = quantile(salary, 0.25),
    q3_salary = quantile(salary, 0.75)
  )

cat(sprintf("Mean salary: %.0f CZK\n", salary_stats$mean_salary))
cat(sprintf("Median salary: %.0f CZK\n", salary_stats$median_salary))
cat(sprintf("SD salary: %.0f CZK\n", salary_stats$sd_salary))
cat(sprintf("Q3 salary: %.0f CZK\n", salary_stats$q3_salary))

# Determine if distribution is skewed
if (salary_stats$mean_salary > salary_stats$median_salary) {
  skew <- "pravostranně zešikmené"
  skew_en <- "right-skewed"
} else if (salary_stats$mean_salary < salary_stats$median_salary) {
  skew <- "levostranně zešikmené"
  skew_en <- "left-skewed"
} else {
  skew <- "symetrické"
  skew_en <- "symmetric"
}
cat(sprintf("Distribution shape: %s\n", skew_en))

cat("\n")

# ========================================
# QUESTION 2: T-test - Remote work vs Salary
# ========================================
cat("QUESTION 2: T-test - Remote Work and Salary\n")
cat("---------------------------------------------\n")

t_result <- t.test(salary ~ remote_work, data = data)
means_by_remote <- data %>%
  group_by(remote_work) %>%
  summarise(mean_sal = mean(salary))

cat(sprintf("t-statistic: %.2f\n", t_result$statistic))
cat(sprintf("df: %.1f\n", t_result$parameter))
cat(sprintf("p-value: %.3f\n", t_result$p.value))
cat(sprintf("Mean salary (No remote): %.0f\n", means_by_remote$mean_sal[means_by_remote$remote_work == "No"]))
cat(sprintf("Mean salary (Yes remote): %.0f\n", means_by_remote$mean_sal[means_by_remote$remote_work == "Yes"]))

if (t_result$p.value < 0.05) {
  significance <- "významný"
  significance_en <- "significant"
} else {
  significance <- "nevýznamný"
  significance_en <- "not significant"
}
cat(sprintf("Result: %s\n", significance_en))

# Cohen's d
pooled_sd <- sqrt(((sum(data$remote_work == "No") - 1) * sd(data$salary[data$remote_work == "No"])^2 +
                   (sum(data$remote_work == "Yes") - 1) * sd(data$salary[data$remote_work == "Yes"])^2) /
                   (nrow(data) - 2))
cohens_d <- abs(diff(means_by_remote$mean_sal)) / pooled_sd
cat(sprintf("Cohen's d: %.2f\n", cohens_d))

cat("\n")

# ========================================
# QUESTION 3: ANOVA - Performance by Department
# ========================================
cat("QUESTION 3: ANOVA - Performance Score by Department\n")
cat("-----------------------------------------------------\n")

anova_result <- aov(performance_score ~ department, data = data)
anova_summary <- summary(anova_result)

cat(sprintf("F-statistic: %.2f\n", anova_summary[[1]]$`F value`[1]))
cat(sprintf("df between: %.0f\n", anova_summary[[1]]$Df[1]))
cat(sprintf("df within: %.0f\n", anova_summary[[1]]$Df[2]))
cat(sprintf("p-value: %.3f\n", anova_summary[[1]]$`Pr(>F)`[1]))

if (anova_summary[[1]]$`Pr(>F)`[1] < 0.05) {
  anova_sig <- "existuje"
  anova_sig_en <- "exists"
} else {
  anova_sig <- "neexistuje"
  anova_sig_en <- "does not exist"
}
cat(sprintf("Conclusion: Difference %s\n", anova_sig_en))

# Post-hoc Tukey
tukey_result <- TukeyHSD(anova_result)
tukey_df <- as.data.frame(tukey_result$department)
tukey_df$comparison <- rownames(tukey_df)
max_diff_row <- tukey_df[which.max(abs(tukey_df$diff)), ]
cat(sprintf("Largest difference (Tukey): %s (diff = %.2f)\n",
            max_diff_row$comparison, max_diff_row$diff))

# Eta-squared
ss_between <- anova_summary[[1]]$`Sum Sq`[1]
ss_total <- sum(anova_summary[[1]]$`Sum Sq`)
eta_squared <- ss_between / ss_total
cat(sprintf("Eta-squared: %.3f\n", eta_squared))

cat("\n")

# ========================================
# QUESTION 4: Correlation Analysis
# ========================================
cat("QUESTION 4: Correlation - Salary and Experience\n")
cat("------------------------------------------------\n")

cor_result <- cor.test(data$salary, data$years_experience, method = "pearson")
cat(sprintf("Pearson r: %.3f\n", cor_result$estimate))
cat(sprintf("p-value: %.4f\n", cor_result$p.value))
cat(sprintf("95%% CI: [%.3f, %.3f]\n", cor_result$conf.int[1], cor_result$conf.int[2]))

if (cor_result$p.value < 0.05) {
  cor_sig <- "významná"
  cor_sig_en <- "significant"
} else {
  cor_sig <- "nevýznamná"
  cor_sig_en <- "not significant"
}
cat(sprintf("Result: %s\n", cor_sig_en))

# Interpret strength
r_abs <- abs(cor_result$estimate)
if (r_abs < 0.3) {
  strength <- "slabá"
  strength_en <- "weak"
} else if (r_abs < 0.7) {
  strength <- "střední"
  strength_en <- "moderate"
} else {
  strength <- "silná"
  strength_en <- "strong"
}
cat(sprintf("Strength: %s\n", strength_en))

cat("\n")

# ========================================
# QUESTION 5: Simple Linear Regression
# ========================================
cat("QUESTION 5: Simple Regression - Performance ~ Job Satisfaction\n")
cat("---------------------------------------------------------------\n")

lm_simple <- lm(performance_score ~ job_satisfaction, data = data)
lm_summary <- summary(lm_simple)

cat(sprintf("Intercept: %.2f\n", coef(lm_simple)[1]))
cat(sprintf("Slope (job_satisfaction): %.2f\n", coef(lm_simple)[2]))
cat(sprintf("R-squared: %.3f\n", lm_summary$r.squared))
cat(sprintf("Adjusted R-squared: %.3f\n", lm_summary$adj.r.squared))
cat(sprintf("F-statistic: %.2f\n", lm_summary$fstatistic[1]))
cat(sprintf("p-value: %.4f\n",
            pf(lm_summary$fstatistic[1], lm_summary$fstatistic[2],
               lm_summary$fstatistic[3], lower.tail = FALSE)))

if (lm_summary$coefficients[2, 4] < 0.05) {
  slope_sig <- "významný"
  slope_sig_en <- "significant"
} else {
  slope_sig <- "nevýznamný"
  slope_sig_en <- "not significant"
}
cat(sprintf("Slope significance: %s\n", slope_sig_en))

cat("\n")

# ========================================
# QUESTION 6: Multiple Regression
# ========================================
cat("QUESTION 6: Multiple Regression - Performance ~ Multiple Predictors\n")
cat("--------------------------------------------------------------------\n")

lm_multiple <- lm(performance_score ~ job_satisfaction + training_rating + department, data = data)
lm_mult_summary <- summary(lm_multiple)

cat(sprintf("R-squared: %.3f\n", lm_mult_summary$r.squared))
cat(sprintf("Adjusted R-squared: %.3f\n", lm_mult_summary$adj.r.squared))

# Standardized coefficients
data_numeric <- data %>%
  mutate(dept_numeric = as.numeric(department))
lm_std <- lm(scale(performance_score) ~ scale(job_satisfaction) + scale(training_rating) + scale(dept_numeric),
             data = data_numeric)
std_coefs <- coef(lm_std)[-1]
names(std_coefs) <- c("job_satisfaction", "training_rating", "department")
max_predictor <- names(which.max(abs(std_coefs)))

cat(sprintf("Strongest predictor (standardized): %s (β = %.3f)\n",
            max_predictor, std_coefs[max_predictor]))

cat("\nCoefficients:\n")
print(lm_mult_summary$coefficients[, c(1, 4)])

cat("\n")

# ========================================
# QUESTION 7: Chi-square Test
# ========================================
cat("QUESTION 7: Chi-square - Department and Remote Work\n")
cat("-----------------------------------------------------\n")

chi_table <- table(data$department, data$remote_work)
chi_result <- chisq.test(chi_table)

cat(sprintf("Chi-square: %.2f\n", chi_result$statistic))
cat(sprintf("df: %.0f\n", chi_result$parameter))
cat(sprintf("p-value: %.3f\n", chi_result$p.value))

if (chi_result$p.value < 0.05) {
  chi_sig <- "závislé"
  chi_sig_en <- "dependent"
} else {
  chi_sig <- "nezávislé"
  chi_sig_en <- "independent"
}
cat(sprintf("Conclusion: Variables are %s\n", chi_sig_en))

# Cramer's V
n <- sum(chi_table)
min_dim <- min(nrow(chi_table), ncol(chi_table)) - 1
cramers_v <- sqrt(chi_result$statistic / (n * min_dim))
cat(sprintf("Cramer's V: %.3f\n", cramers_v))

cat("\n")

# ========================================
# QUESTION 8: Spearman Correlation (Ordinal)
# ========================================
cat("QUESTION 8: Spearman Correlation - Stress Level and Sick Days\n")
cat("--------------------------------------------------------------\n")

spearman_result <- cor.test(data$stress_level, data$sick_days, method = "spearman", exact = FALSE)
cat(sprintf("Spearman rho: %.3f\n", spearman_result$estimate))
cat(sprintf("p-value: %.4f\n", spearman_result$p.value))

if (spearman_result$p.value < 0.05) {
  spear_sig <- "významná"
  spear_sig_en <- "significant"
} else {
  spear_sig <- "nevýznamná"
  spear_sig_en <- "not significant"
}
cat(sprintf("Result: %s correlation\n", spear_sig_en))

cat("\n")

# ========================================
# ADDITIONAL STATISTICS
# ========================================
cat("ADDITIONAL STATISTICS\n")
cat("---------------------\n")

# Most common education level
edu_freq <- table(data$education)
most_common_edu <- names(which.max(edu_freq))
cat(sprintf("Most common education: %s (n = %d)\n", most_common_edu, max(edu_freq)))

# Department with highest median sick days
median_sick_by_dept <- data %>%
  group_by(department) %>%
  summarise(median_sick = median(sick_days)) %>%
  arrange(desc(median_sick))
cat(sprintf("Department with highest median sick days: %s (%.1f days)\n",
            median_sick_by_dept$department[1], median_sick_by_dept$median_sick[1]))

# Stress level SD
stress_sd <- sd(data$stress_level)
cat(sprintf("Stress level SD: %.3f\n", stress_sd))

cat("\n=== END OF ANSWER KEY ===\n")
