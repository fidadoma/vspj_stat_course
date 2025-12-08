# Dataset 1: Employee Satisfaction - COMPLETE (25 Questions)

## ✅ STATUS: READY FOR MOODLE IMPORT

---

## 📊 ALL 25 QUESTIONS OVERVIEW

### PART A: Basic Analyses (Q1-10)
1. Descriptive statistics & distribution shape
2. T-test: Remote work → Salary (with Cohen's d)
3. ANOVA: Performance by department (with eta-squared, Tukey)
4. Correlation: Salary × Years experience (Pearson)
5. Simple regression: Performance ~ Satisfaction
6. Multiple regression: Performance ~ Multiple predictors
7. Chi-square: Department × Remote work (with Cramer's V)
8. Spearman correlation: Stress × Sick days
9. Contingency tables & frequencies
10. Confounder analysis (DAG/causal inference)

### PART B: Filter-Based Questions (Q11-16)
11. **FILTER** T-test: Full-time vs Part-time ONLY (exclude Contract)
12. **FILTER** ANOVA: IT, Sales, Finance ONLY
13. **FILTER** Correlation: Master & PhD ONLY
14. **FILTER** Chi-square: Exclude PhD
15. **FILTER** Regression: Age ≥ 35 ONLY
16. **FILTER** ANOVA Combined: Remote=Yes AND Full-time

### PART C: Advanced Topics (Q17-25)
17. Shapiro-Wilk test (normality assumption)
18. Levene's test (homogeneity of variance)
19. Median split analysis (High vs Low performers)
20. Multiple comparisons with Bonferroni correction
21. Contingency table with row percentages
22. **FILTER** Model comparison (All data vs Full-time only)
23. Mann-Whitney U test (non-parametric alternative)
24. Stratified analysis (correlation by department)
25. Effect size comparison (Cohen's d, η², Cramer's V)

---

## 📈 STATISTICAL COVERAGE

| Statistical Method | Count | Questions |
|-------------------|-------|-----------|
| Descriptive statistics | 3 | Q1, Q9, Q21 |
| T-test (parametric) | 3 | Q2, Q11, Q19 |
| Mann-Whitney U (non-parametric) | 1 | Q23 |
| ANOVA | 4 | Q3, Q12, Q16, Q20 |
| Pearson correlation | 3 | Q4, Q13, Q24 |
| Spearman correlation | 1 | Q8 |
| Simple regression | 2 | Q5, Q15 |
| Multiple regression | 2 | Q6, Q22 |
| Chi-square test | 2 | Q7, Q14 |
| Test assumptions | 2 | Q17 (normality), Q18 (homogeneity) |
| Effect sizes | 2 | Throughout + Q25 |
| Causal inference | 1 | Q10 |
| Multiple comparisons | 1 | Q20 |

---

## 🎯 PEDAGOGICAL THEMES

### Data Manipulation Skills:
- ✅ Filters (simple, combined, numeric)
- ✅ Creating new variables (median split)
- ✅ Stratified analysis
- ✅ Row/column percentages

### Statistical Concepts:
- ✅ Parametric vs non-parametric tests
- ✅ Test assumptions and their importance
- ✅ Statistical vs practical significance
- ✅ Effect sizes and interpretation
- ✅ Multiple comparison corrections
- ✅ Confounders and causal inference

### Jamovi Skills:
- ✅ Descriptive statistics
- ✅ All major tests (t, ANOVA, correlation, regression, chi-square)
- ✅ Data filtering
- ✅ Assumption checking
- ✅ Post-hoc tests
- ✅ Effect size calculations

---

## 📁 FILES FOR DATASET 1

### Data Files:
- `dataset_1_employee_satisfaction.csv` (Czech, N=250)
- `dataset_1_employee_satisfaction_EN.csv` (English, N=250)
- `codebook_1_employee_satisfaction.md` (Detailed Czech codebook)

### Question Files:
- `moodle_questions_dataset_1_complete.xml` (Q1-16)
- `moodle_questions_dataset_1_FULL_25.xml` (Q17-25)
- **TO MERGE:** Combine both files for complete set of 25 questions

### Calculation Scripts:
- `calculate_answers_dataset_1.R` (Q1-10)
- `calculate_answers_with_filters_dataset_1.R` (Q11-16)
- `calculate_additional_answers_dataset_1.R` (Q17-25)

### Documentation:
- `SUMMARY_dataset_1.md` (Q1-16 summary)
- `FINAL_SUMMARY_Dataset1.md` (This file - all 25 questions)
- `README_project_status.md` (Overall project status)

---

## 🔧 HOW TO IMPORT TO MOODLE

### Option 1: Import Both Files Separately
1. Import `moodle_questions_dataset_1_complete.xml` (16 questions)
2. Import `moodle_questions_dataset_1_FULL_25.xml` (9 questions)
3. Total: 25 questions in category "Dataset1_Zamestnanci"

### Option 2: Merge Files (Recommended)
Create one XML file combining:
- XML header (from first file)
- All 25 `<question>` blocks
- Closing `</quiz>` tag

---

## 📊 DATASET 1 CHARACTERISTICS

### Variables (14 total):
- **Ordinal (4)**: job_satisfaction, work_life_balance, stress_level, training_rating
- **Nominal (4)**: department, employment_type, education, remote_work
- **Numeric (6)**: age, salary, years_experience, performance_score, sick_days, overtime_hours

### Causal Structure (DAG):
- salary ← education + years_experience
- performance_score ← job_satisfaction + training_rating
- sick_days ← stress_level
- **Confounder**: department (for salary → performance)

### Sample Size: N = 250

---

## ✅ QUALITY CHECKLIST

- ✅ All 25 questions created
- ✅ All penalties set to 0
- ✅ All answers calculated from real data
- ✅ Appropriate tolerances for numeric answers
- ✅ Feedback includes Jamovi instructions
- ✅ Filters clearly explained in question text
- ✅ Multiple question types (MC + numeric)
- ✅ Covers all major statistical topics
- ✅ Czech language throughout
- ✅ Ready for testing

---

## 📝 NEXT: DATASETS 2, 3, 4

Following the same structure for each:
- **Dataset 2**: Patient Recovery (Healthcare context)
- **Dataset 3**: Student Performance (Education context)
- **Dataset 4**: Consumer Behavior (Marketing context)

Each will have ~20-25 questions covering similar topics adapted to their context.

---

**Date**: 2025-12-07
**Status**: Dataset 1 COMPLETE (25/25 questions)
**Ready for**: Moodle import and testing
