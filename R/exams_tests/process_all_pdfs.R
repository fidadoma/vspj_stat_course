# Process All PDFs and Generate MCQs
# This is the main script to process all PDFs in a directory

source("R/exams_tests/generate_mcq_from_pdf.R")
source("R/exams_tests/export_to_moodle.R")

#' Process all PDFs in a directory and export to Moodle XML
#'
#' @param pdf_dir Directory containing PDF files (default: "R/exams_tests/pdf")
#' @param output_dir Directory to save Moodle XML files (default: "moodle_xml")
#' @param difficulty Difficulty level for questions (default: "medium")
#' @param n_questions Number of questions per page (default: 3)
#' @param n_options Number of answer options per question (default: 4)
#' @param pages_to_process NULL for all pages, or a vector of page numbers to process
#' @param api_key OpenAI API key (will use OPENAI_API_KEY env var if NULL)
#' @param save_intermediate Whether to save intermediate results as RDS files (default: TRUE)
#' @return A list containing all generated questions organized by PDF
process_all_pdfs <- function(pdf_dir = "R/exams_tests/pdf",
                             output_dir = "moodle_xml",
                             difficulty = "medium",
                             n_questions = 3,
                             n_options = 4,
                             pages_to_process = NULL,
                             api_key = NULL,
                             save_intermediate = TRUE) {

  # Check if PDF directory exists
  if (!dir.exists(pdf_dir)) {
    stop("PDF directory does not exist: ", pdf_dir)
  }

  # Get all PDF files
  pdf_files <- list.files(pdf_dir, pattern = "\\.pdf$", full.names = TRUE, ignore.case = TRUE)

  if (length(pdf_files) == 0) {
    stop("No PDF files found in directory: ", pdf_dir)
  }

  message(sprintf("Found %d PDF files to process", length(pdf_files)))

  # Create output directories
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  if (save_intermediate) {
    intermediate_dir <- file.path(output_dir, "intermediate_results")
    if (!dir.exists(intermediate_dir)) {
      dir.create(intermediate_dir, recursive = TRUE)
    }
  }

  # Process each PDF
  all_questions_by_pdf <- list()

  for (pdf_file in pdf_files) {
    pdf_name <- basename(pdf_file)
    message(sprintf("\n=== Processing: %s ===", pdf_name))

    # Generate MCQs for this PDF
    questions <- tryCatch({
      generate_mcq_from_pdf(
        pdf_path = pdf_file,
        pages = pages_to_process,
        difficulty = difficulty,
        n_questions = n_questions,
        n_options = n_options,
        api_key = api_key
      )
    }, error = function(e) {
      warning(sprintf("Error processing %s: %s", pdf_name, e$message))
      NULL
    })

    if (!is.null(questions) && length(questions) > 0) {
      all_questions_by_pdf[[pdf_name]] <- questions

      # Save intermediate results
      if (save_intermediate) {
        rds_file <- file.path(
          intermediate_dir,
          paste0(tools::file_path_sans_ext(pdf_name), "_questions.rds")
        )
        saveRDS(questions, rds_file)
        message(sprintf("Saved intermediate results to: %s", rds_file))
      }
    }
  }

  # Export all to Moodle XML
  if (length(all_questions_by_pdf) > 0) {
    message("\n=== Exporting to Moodle XML ===")
    export_all_to_moodle(
      questions_by_pdf = all_questions_by_pdf,
      output_dir = output_dir,
      prefix = "mcq_"
    )

    # Also save the complete results as RDS
    complete_results_file <- file.path(output_dir, "all_questions_complete.rds")
    saveRDS(all_questions_by_pdf, complete_results_file)
    message(sprintf("Saved complete results to: %s", complete_results_file))

  } else {
    warning("No questions were generated from any PDF files")
  }

  message("\n=== Processing complete ===")

  invisible(all_questions_by_pdf)
}


#' Resume processing from saved intermediate results
#'
#' @param intermediate_dir Directory containing intermediate RDS files
#' @param output_dir Directory to save Moodle XML files
#' @return A list containing all questions organized by PDF
resume_from_intermediate <- function(intermediate_dir = "moodle_xml/intermediate_results",
                                     output_dir = "moodle_xml") {

  if (!dir.exists(intermediate_dir)) {
    stop("Intermediate directory does not exist: ", intermediate_dir)
  }

  # Get all RDS files
  rds_files <- list.files(intermediate_dir, pattern = "_questions\\.rds$", full.names = TRUE)

  if (length(rds_files) == 0) {
    stop("No intermediate result files found in: ", intermediate_dir)
  }

  message(sprintf("Found %d intermediate result files", length(rds_files)))

  # Load all questions
  all_questions_by_pdf <- list()

  for (rds_file in rds_files) {
    pdf_name <- gsub("_questions\\.rds$", ".pdf", basename(rds_file))
    questions <- readRDS(rds_file)
    all_questions_by_pdf[[pdf_name]] <- questions
    message(sprintf("Loaded: %s", pdf_name))
  }

  # Export to Moodle XML
  message("\n=== Exporting to Moodle XML ===")
  export_all_to_moodle(
    questions_by_pdf = all_questions_by_pdf,
    output_dir = output_dir,
    prefix = "mcq_"
  )

  invisible(all_questions_by_pdf)
}


# Example usage (commented out):
#
# # Process all PDFs with default settings
# results <- process_all_pdfs()
#
# # Process with custom settings
# results <- process_all_pdfs(
#   pdf_dir = "pdf",
#   output_dir = "moodle_xml",
#   difficulty = "hard",
#   n_questions = 5,
#   n_options = 5,
#   api_key = "your-api-key-here"
# )
#
# # Process only first 3 pages of each PDF
# results <- process_all_pdfs(pages_to_process = 1:3)
#
# # Resume from saved intermediate results
# results <- resume_from_intermediate()
