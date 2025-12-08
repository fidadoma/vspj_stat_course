# Master script to generate all datasets

# Install required packages if needed
required_packages <- c("dplyr")
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org")
    library(pkg, character.only = TRUE)
  }
}

cat(paste(rep("=", 70), collapse = ""), "\n")
cat("Generating all datasets\n")
cat(paste(rep("=", 70), collapse = ""), "\n\n")

# Run each generation script
cat("\n### Dataset 1: Employee Satisfaction ###\n")
source("R/exams/generate_dataset_1_employee.R")

cat("\n### Dataset 2: Patient Recovery ###\n")
source("R/exams/generate_dataset_2_patient.R")

cat("\n### Dataset 3: Student Performance ###\n")
source("R/exams/generate_dataset_3_student.R")

cat("\n### Dataset 4: Consumer Behavior ###\n")
source("R/exams/generate_dataset_4_consumer.R")

cat("\n", paste(rep("=", 70), collapse = ""), "\n")
cat("All datasets generated successfully!\n")
cat("Files saved in R/exams/ directory\n")
cat(paste(rep("=", 70), collapse = ""), "\n")
