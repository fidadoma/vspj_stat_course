#!/usr/bin/env Rscript
# Process all PDFs and generate Moodle XML files
#
# Usage:
#   Rscript R/exams_tests/run_full_processing.R
#
# Or from R console:
#   source('R/exams_tests/run_full_processing.R')
#
# Configuration options (edit as needed):
# - difficulty: "easy", "medium", or "hard"
# - n_questions: number of questions per page
# - pages_to_process: NULL for all pages, or c(1, 2, 3) for specific pages

source('R/exams_tests/process_all_pdfs.R')

cat('\n')
cat('========================================\n')
cat('  PDF to MCQ Generator for Moodle\n')
cat('========================================\n\n')

# Check if API key is set
if (Sys.getenv("OPENAI_API_KEY") == "") {
  cat('ERROR: OPENAI_API_KEY environment variable is not set!\n')
  cat('Please set it before running:\n')
  cat('  Sys.setenv(OPENAI_API_KEY = "your-api-key-here")\n')
  cat('Or add it to your .Renviron file\n\n')
  quit(status = 1)
}

cat('Configuration:\n')
cat('  Input directory: R/exams_tests/pdf\n')
cat('  Output directory: moodle_xml\n')
cat('  Difficulty: medium\n')
cat('  Questions per page: 3\n')
cat('  Options per question: 4\n')
cat('  Pages: ALL\n\n')

# Count PDFs
pdf_files <- list.files('R/exams_tests/pdf', pattern = '.pdf$')
cat('Found', length(pdf_files), 'PDF files to process\n\n')

response <- readline(prompt = "Proceed with processing? (yes/no): ")
if (tolower(response) != "yes" && tolower(response) != "y") {
  cat('Processing cancelled.\n')
  quit()
}

cat('\n=== Starting Processing ===\n\n')

# Process all PDFs
results <- process_all_pdfs(
  pdf_dir = 'R/exams_tests/pdf',
  output_dir = 'moodle_xml',
  difficulty = 'medium',
  n_questions = 3,
  n_options = 4,
  pages_to_process = NULL,  # Process all pages
  save_intermediate = TRUE
)

cat('\n')
cat('========================================\n')
cat('  Processing Complete!\n')
cat('========================================\n\n')

cat('Summary:\n')
cat('  PDFs processed:', length(results), '\n')

# Count total questions
total_questions <- 0
for (pdf_name in names(results)) {
  for (page_result in results[[pdf_name]]) {
    if (!is.null(page_result$questions)) {
      if (is.data.frame(page_result$questions)) {
        total_questions <- total_questions + nrow(page_result$questions)
      } else {
        total_questions <- total_questions + length(page_result$questions)
      }
    }
  }
}

cat('  Total questions generated:', total_questions, '\n')
cat('\nOutput files:\n')
xml_files <- list.files('moodle_xml', pattern = '^mcq_.*\\.xml$')
for (f in xml_files) {
  cat('  -', f, '\n')
}

cat('\nYou can now import these XML files into Moodle!\n')
cat('Location: moodle_xml/\n\n')
