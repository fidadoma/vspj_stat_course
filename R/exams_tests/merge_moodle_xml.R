#!/usr/bin/env Rscript
# Merge all Moodle XML files into one

library(xml2)

#' Merge multiple Moodle XML files into one
#'
#' @param xml_dir Directory containing XML files
#' @param output_file Path to the merged output file
#' @param pattern Pattern to match XML files (default: "^mcq_.*\\.xml$")
#' @return Invisibly returns the merged XML document
merge_moodle_xml <- function(xml_dir = "moodle_xml",
                             output_file = "moodle_xml/all_questions_merged.xml",
                             pattern = "^mcq_.*\\.xml$") {

  # Get all XML files
  xml_files <- list.files(xml_dir, pattern = pattern, full.names = TRUE)

  if (length(xml_files) == 0) {
    stop("No XML files found matching pattern: ", pattern)
  }

  cat(sprintf("Found %d XML files to merge\n", length(xml_files)))

  # Create root quiz element
  merged_quiz <- xml_new_root("quiz")

  # Add a general category for all questions
  category_node <- xml_add_child(merged_quiz, "question", type = "category")
  cat_node <- xml_add_child(category_node, "category")
  xml_add_child(cat_node, "text", "$course$/All Statistics Questions")

  # Process each XML file
  total_questions <- 0

  for (xml_file in xml_files) {
    cat(sprintf("Processing: %s\n", basename(xml_file)))

    # Read the XML file
    doc <- read_xml(xml_file)

    # Get all question nodes (skip category questions)
    questions <- xml_find_all(doc, "//question[@type='multichoice']")

    cat(sprintf("  - Found %d questions\n", length(questions)))

    # Add each question to merged document
    for (question in questions) {
      xml_add_child(merged_quiz, question)
      total_questions <- total_questions + 1
    }
  }

  cat(sprintf("\nTotal questions in merged file: %d\n", total_questions))

  # Write merged file
  write_xml(merged_quiz, output_file, options = "format")

  cat(sprintf("\n✓ Merged XML saved to: %s\n", output_file))

  # Get file size
  file_size <- file.info(output_file)$size / 1024
  cat(sprintf("File size: %.1f KB\n", file_size))

  invisible(merged_quiz)
}

# Run if executed as script
if (!interactive()) {
  merge_moodle_xml()
}
