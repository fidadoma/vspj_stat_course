# Master script to run all dataset simulations

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Install simDAG if needed
if (!require("simDAG")) {
  install.packages("simDAG")
}

# Install other required packages if needed
required_packages <- c("dplyr", "tidyr")
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
  }
}

cat(rep("=", 70), "\n")
cat("Running all dataset simulations\n")
cat(rep("=", 70), "\n\n")

# Run each simulation script
cat("\n### Dataset 1: Employee Satisfaction ###\n")
source("R/exams/simulate_dataset_1_employee.R")

cat("\n### Dataset 2: Patient Recovery ###\n")
source("R/exams/simulate_dataset_2_patient.R")

cat("\n### Dataset 3: Student Performance ###\n")
source("R/exams/simulate_dataset_3_student.R")

cat("\n### Dataset 4: Consumer Behavior ###\n")
source("R/exams/simulate_dataset_4_consumer.R")

cat(rep("=", 70), "\n")
cat("All datasets generated successfully!\n")
cat("Files saved in R/exams/ directory\n")
cat(rep("=", 70), "\n")
