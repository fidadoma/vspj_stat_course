#!/usr/bin/env Rscript
# Regenerate XML files from intermediate RDS files

source('R/exams_tests/export_to_moodle.R')

cat('=== Regenerating XML files from intermediate results ===\n\n')

# Get all RDS files
rds_files <- list.files('moodle_xml/intermediate_results',
                        pattern = '_questions.rds$',
                        full.names = TRUE)

if (length(rds_files) == 0) {
  stop("No intermediate RDS files found!")
}

cat(sprintf("Found %d RDS files\n\n", length(rds_files)))

# Create output directory
output_dir <- 'moodle_xml'

# Process each RDS file
all_questions_by_pdf <- list()

for (rds_file in rds_files) {
  pdf_name <- gsub("_questions.rds$", ".pdf", basename(rds_file))
  cat(sprintf("Loading: %s\n", pdf_name))

  questions <- readRDS(rds_file)
  all_questions_by_pdf[[pdf_name]] <- questions
}

cat('\n=== Exporting to Moodle XML ===\n')

# Export all to Moodle XML
export_all_to_moodle(
  questions_by_pdf = all_questions_by_pdf,
  output_dir = output_dir,
  prefix = 'mcq_'
)

cat('\n✓ XML files regenerated successfully!\n')
cat('\nTo merge them into one file, run:\n')
cat('  source("R/exams_tests/merge_moodle_xml.R"); merge_moodle_xml()\n')
