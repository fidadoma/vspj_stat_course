#!/usr/bin/env Rscript
# Test batch processing with multiple PDFs

source('R/exams_tests/process_all_pdfs.R')

cat('=== Testing Batch Processing ===\n\n')

# Process first page of all PDFs
results <- process_all_pdfs(
  pdf_dir = 'R/exams_tests/pdf',
  output_dir = 'moodle_xml',
  difficulty = 'medium',
  n_questions = 2,  # Only 2 questions per page for testing
  n_options = 4,
  pages_to_process = 1,  # Only first page of each PDF
  save_intermediate = TRUE
)

cat('\n=== Processing Complete ===\n')
cat('Generated XML files:\n')
xml_files <- list.files('moodle_xml', pattern = '.xml$')
for (f in xml_files) {
  cat(' -', f, '\n')
}

cat('\nTotal PDFs processed:', length(results), '\n')
cat('Total XML files created:', length(xml_files), '\n')
