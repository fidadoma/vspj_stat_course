# Calculate answers for Dataset 3: Student Performance
# 18 comprehensive questions

library(dplyr)
library(tidyr)

# Read data
data <- read.csv("R/exams/dataset_3_student_performance_EN.csv", stringsAsFactors = TRUE)

cat("=== DATASET 3: STUDENT PERFORMANCE - ANSWER KEY ===\n")
cat("Total N =", nrow(data), "\n\n")

# ========================================
# Q1: Descriptive Statistics - GPA
# ========================================
cat("Q1: Descriptive Statistics - GPA (Grade Point Average)\n")
cat("------------------------------------------------------\n")

gpa_stats <- data %>%
  summarise(
    mean = mean(gpa),
    median = median(gpa),
    sd = sd(gpa),
    q1 = quantile(gpa, 0.25),
    q3 = quantile(gpa, 0.75),
    min = min(gpa),
    max = max(gpa)
  )

print(gpa_stats)
cat("\n")

# ========================================
# Q2: T-test - GPA by Part-time Job
# ========================================
cat("Q2: T-test - GPA by Part-time Job Status\n")
cat("-----------------------------------------\n")

t_result_q2 <- t.test(gpa ~ part_time_job, data = data)
means_q2 <- data %>%
  group_by(part_time_job) %>%
  summarise(m = mean(gpa), n = n())

print(means_q2)
cat(sprintf("t(%.1f) = %.2f, p = %.3f\n",
            t_result_q2$parameter, t_result_q2$statistic, t_result_q2$p.value))

# Cohen's d
pooled_sd_q2 <- sqrt(((means_q2$n[1]-1)*sd(data$gpa[data$part_time_job=="No"])^2 +
                      (means_q2$n[2]-1)*sd(data$gpa[data$part_time_job=="Yes"])^2) /
                      (sum(means_q2$n)-2))
cohens_d_q2 <- abs(diff(means_q2$m)) / pooled_sd_q2
cat(sprintf("Cohen's d = %.3f\n", cohens_d_q2))
cat("\n")

# ========================================
# Q3: ANOVA - Exam Score by Study Program
# ========================================
cat("Q3: ANOVA - Exam Score by Study Program\n")
cat("----------------------------------------\n")

anova_q3 <- aov(exam_score ~ study_program, data = data)
anova_sum_q3 <- summary(anova_q3)

cat(sprintf("F(%.0f, %.0f) = %.2f, p = %.3f\n",
            anova_sum_q3[[1]]$Df[1], anova_sum_q3[[1]]$Df[2],
            anova_sum_q3[[1]]$`F value`[1], anova_sum_q3[[1]]$`Pr(>F)`[1]))

# Post-hoc
tukey_q3 <- TukeyHSD(anova_q3)
tukey_df_q3 <- as.data.frame(tukey_q3$study_program)
tukey_df_q3$comparison <- rownames(tukey_df_q3)
max_diff_q3 <- tukey_df_q3[which.max(abs(tukey_df_q3$diff)), ]
cat(sprintf("Largest difference: %s (%.2f points)\n",
            max_diff_q3$comparison, max_diff_q3$diff))

# Eta-squared
ss_between_q3 <- anova_sum_q3[[1]]$`Sum Sq`[1]
ss_total_q3 <- sum(anova_sum_q3[[1]]$`Sum Sq`)
eta_sq_q3 <- ss_between_q3 / ss_total_q3
cat(sprintf("η² = %.3f\n", eta_sq_q3))
cat("\n")

# ========================================
# Q4: Correlation - Study Hours and Exam Score
# ========================================
cat("Q4: Spearman Correlation - Study Hours × Exam Score\n")
cat("----------------------------------------------------\n")

cor_q4 <- cor.test(data$study_hours_category, data$exam_score, method = "spearman")
cat(sprintf("Spearman ρ = %.3f, p = %.4f\n",
            cor_q4$estimate, cor_q4$p.value))
cat("\n")

# ========================================
# Q5: Simple Regression - Exam Score ~ Motivation
# ========================================
cat("Q5: Simple Regression - Exam Score ~ Motivation Level\n")
cat("------------------------------------------------------\n")

lm_q5 <- lm(exam_score ~ motivation_level, data = data)
lm_sum_q5 <- summary(lm_q5)

cat(sprintf("Intercept = %.2f\n", coef(lm_q5)[1]))
cat(sprintf("Slope = %.2f\n", coef(lm_q5)[2]))
cat(sprintf("R² = %.3f\n", lm_sum_q5$r.squared))
cat(sprintf("p-value = %.4f\n", lm_sum_q5$coefficients[2,4]))
cat("\n")

# ========================================
# Q6: Multiple Regression - GPA
# ========================================
cat("Q6: Multiple Regression - GPA\n")
cat("------------------------------\n")

lm_q6 <- lm(gpa ~ motivation_level + attendance_rate + study_program, data = data)
lm_sum_q6 <- summary(lm_q6)

cat(sprintf("R² = %.3f, Adj R² = %.3f\n",
            lm_sum_q6$r.squared, lm_sum_q6$adj.r.squared))
cat("\nCoefficients:\n")
print(lm_sum_q6$coefficients[,c(1,4)])
cat("\n")

# ========================================
# Q7: Chi-square - Study Method × Accommodation
# ========================================
cat("Q7: Chi-square - Study Method × Accommodation\n")
cat("----------------------------------------------\n")

chi_q7 <- chisq.test(table(data$study_method, data$accommodation))
cat(sprintf("χ²(%.0f) = %.2f, p = %.3f\n",
            chi_q7$parameter, chi_q7$statistic, chi_q7$p.value))

n_q7 <- nrow(data)
min_dim_q7 <- min(length(unique(data$study_method)), length(unique(data$accommodation))) - 1
cramers_v_q7 <- sqrt(chi_q7$statistic / (n_q7 * min_dim_q7))
cat(sprintf("Cramer's V = %.3f\n", cramers_v_q7))
cat("\n")

# ========================================
# Q8: Correlation - Stress and Sleep
# ========================================
cat("Q8: Pearson Correlation - Stress Index × Sleep Hours\n")
cat("-----------------------------------------------------\n")

cor_q8 <- cor.test(data$stress_index, data$sleep_hours_avg)
cat(sprintf("Pearson r = %.3f, p = %.4f\n",
            cor_q8$estimate, cor_q8$p.value))
cat("\n")

# ========================================
# Q9: Shapiro-Wilk - Normality of Exam Scores
# ========================================
cat("Q9: Shapiro-Wilk Test - Exam Score Normality\n")
cat("---------------------------------------------\n")

shapiro_q9 <- shapiro.test(data$exam_score)
cat(sprintf("W = %.4f, p = %.4f\n", shapiro_q9$statistic, shapiro_q9$p.value))
cat("\n")

# ========================================
# Q10: Mediator Analysis - Sleep mediates Job → GPA
# ========================================
cat("Q10: Mediator Analysis - Sleep Hours as Mediator\n")
cat("------------------------------------------------\n")

# Direct effect: part_time_job → gpa
cor_direct <- cor.test(as.numeric(data$part_time_job == "Yes"), data$gpa)
cat(sprintf("Direct correlation (Job × GPA): r = %.3f, p = %.4f\n",
            cor_direct$estimate, cor_direct$p.value))

# Partial correlation controlling for sleep
job_numeric <- as.numeric(data$part_time_job == "Yes")
resid_job <- residuals(lm(job_numeric ~ sleep_hours_avg, data = data))
resid_gpa <- residuals(lm(gpa ~ sleep_hours_avg, data = data))
cor_partial <- cor(resid_job, resid_gpa)
cat(sprintf("Partial correlation (controlling Sleep): r = %.3f\n", cor_partial))

# Job → Sleep
cor_mediator <- cor.test(job_numeric, data$sleep_hours_avg)
cat(sprintf("Job × Sleep: r = %.3f, p = %.4f\n",
            cor_mediator$estimate, cor_mediator$p.value))
cat("\n")

# ========================================
# Q11: FILTER - T-test for Traditional vs Online only
# ========================================
cat("Q11: FILTER - T-test (Traditional vs Online students only)\n")
cat("-----------------------------------------------------------\n")

data_q11 <- data %>% filter(study_method %in% c("Traditional", "Online"))
data_q11$study_method <- droplevels(data_q11$study_method)

t_q11 <- t.test(exam_score ~ study_method, data = data_q11)
cat(sprintf("N after filter: %d\n", nrow(data_q11)))
cat(sprintf("t(%.1f) = %.2f, p = %.3f\n",
            t_q11$parameter, t_q11$statistic, t_q11$p.value))
cat("\n")

# ========================================
# Q12: FILTER - Correlation for students with job
# ========================================
cat("Q12: FILTER - Correlation for Students with Part-time Job\n")
cat("----------------------------------------------------------\n")

data_q12 <- data %>% filter(part_time_job == "Yes")
cor_q12 <- cor.test(data_q12$stress_index, data_q12$gpa)
cat(sprintf("N after filter: %d\n", nrow(data_q12)))
cat(sprintf("Pearson r = %.3f, p = %.4f\n",
            cor_q12$estimate, cor_q12$p.value))
cat("\n")

# ========================================
# Q13: Mann-Whitney - Library Visits by Accommodation
# ========================================
cat("Q13: Mann-Whitney - Library Visits (Dorm vs Home)\n")
cat("--------------------------------------------------\n")

data_q13 <- data %>% filter(accommodation %in% c("Dorm", "Home"))
mann_q13 <- wilcox.test(library_visits_per_month ~ accommodation, data = data_q13)
medians_q13 <- data_q13 %>%
  group_by(accommodation) %>%
  summarise(median = median(library_visits_per_month))

cat(sprintf("N after filter: %d\n", nrow(data_q13)))
cat(sprintf("W = %.1f, p = %.3f\n", mann_q13$statistic, mann_q13$p.value))
print(medians_q13)
cat("\n")

# ========================================
# Q14: Contingency Table - Study Program × Part-time Job
# ========================================
cat("Q14: Contingency Table - Study Program × Part-time Job\n")
cat("-------------------------------------------------------\n")

cont_q14 <- table(data$study_program, data$part_time_job)
cat("Observed frequencies:\n")
print(cont_q14)

chi_q14 <- chisq.test(cont_q14)
cat(sprintf("\nχ²(%.0f) = %.2f, p = %.3f\n",
            chi_q14$parameter, chi_q14$statistic, chi_q14$p.value))
cat("\n")

# ========================================
# Q15: Effect Size - Study Program on Exam Score
# ========================================
cat("Q15: Effect Size - Study Program on Exam Score\n")
cat("-----------------------------------------------\n")

# Already calculated in Q3
cat(sprintf("η² = %.3f\n", eta_sq_q3))
cat(sprintf("This is a %s effect\n",
            ifelse(eta_sq_q3 < 0.06, "small",
                   ifelse(eta_sq_q3 < 0.14, "medium", "large"))))
cat("\n")

# ========================================
# Q16: Stratified Analysis - Exam Score by Attendance
# ========================================
cat("Q16: Stratified Analysis - Exam Score by Attendance Rate\n")
cat("---------------------------------------------------------\n")

score_by_attend <- data %>%
  group_by(attendance_rate) %>%
  summarise(
    mean_score = mean(exam_score),
    sd_score = sd(exam_score),
    n = n()
  ) %>%
  arrange(desc(mean_score))

print(score_by_attend)
cat("\n")

# ========================================
# Q17: Pre-Post Concept - Assignment vs Exam
# ========================================
cat("Q17: Comparing Assignment and Exam Scores\n")
cat("------------------------------------------\n")

mean_assign <- mean(data$assignment_score)
mean_exam <- mean(data$exam_score)
diff_mean <- mean_assign - mean_exam

cat(sprintf("Mean Assignment Score: %.2f\n", mean_assign))
cat(sprintf("Mean Exam Score: %.2f\n", mean_exam))
cat(sprintf("Mean difference: %.2f points\n", diff_mean))

# Paired t-test (conceptual)
t_paired <- t.test(data$assignment_score, data$exam_score, paired = TRUE)
cat(sprintf("t(%.0f) = %.2f, p = %.4f\n",
            t_paired$parameter, t_paired$statistic, t_paired$p.value))
cat("\n")

# ========================================
# Q18: Levene's Test - Homogeneity of Variance
# ========================================
cat("Q18: Levene's Test - Homogeneity of Variance\n")
cat("---------------------------------------------\n")

if (require("car", quietly = TRUE)) {
  levene_q18 <- car::leveneTest(exam_score ~ study_program, data = data)
  cat(sprintf("F(%.0f, %.0f) = %.3f, p = %.3f\n",
              levene_q18$Df[1], levene_q18$Df[2],
              levene_q18$`F value`[1], levene_q18$`Pr(>F)`[1]))
} else {
  cat("car package not available\n")
}

cat("\n=== END OF DATASET 3 ===\n")
