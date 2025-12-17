#!/usr/bin/env Rscript
# Test workflow with one PDF and one page

source('R/exams_tests/process_all_pdfs.R')

# Test with just first page of one PDF
cat('Testing complete workflow with first page of one PDF...\n\n')

# Get first PDF
pdf_files <- list.files('R/exams_tests/pdf', pattern = '.pdf$', full.names = TRUE)
test_pdf <- pdf_files[1]

cat('Processing:', basename(test_pdf), '\n\n')

# Generate MCQs for first page only
questions <- generate_mcq_from_pdf(
  pdf_path = test_pdf,
  pages = 1,
  difficulty = 'medium',
  n_questions = 2
)

cat('\n✓ Questions generated\n')

# Create a list structure as expected by export function
questions_by_pdf <- list()
questions_by_pdf[[basename(test_pdf)]] <- questions

# Export to Moodle XML
export_all_to_moodle(
  questions_by_pdf = questions_by_pdf,
  output_dir = 'moodle_xml_test',
  prefix = 'test_'
)

cat('\n✓ Complete workflow successful!\n')
cat('\nChecking output files:\n')
print(list.files('moodle_xml_test', pattern = '.xml$'))
