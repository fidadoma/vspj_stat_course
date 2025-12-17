# Export MCQ to Moodle XML format
# This script converts generated MCQs to Moodle-compatible XML

library(xml2)
library(magrittr)

#' Convert a single MCQ to Moodle XML format
#'
#' @param question A question object with structure: list(question, options, explanation)
#' @param category Category name for the question in Moodle
#' @return An xml_node object
mcq_to_moodle_xml <- function(question, category = "Generated Questions") {

  # Create question node
  q_node <- xml_new_root("question", type = "multichoice")

  # Add name (using first 50 chars of question as identifier)
  name_text <- substr(gsub("[^[:alnum:] ]", "", question$question), 1, 50)
  name_node <- xml_add_child(q_node, "name")
  xml_add_child(name_node, "text", name_text)

  # Add question text with CDATA
  questiontext_node <- xml_add_child(q_node, "questiontext", format = "html")
  text_node <- xml_add_child(questiontext_node, "text")
  # Add CDATA section
  cdata_content <- xml_new_document() %>% xml_add_child("dummy")
  xml_add_child(cdata_content, xml_cdata(question$question))
  xml_add_child(text_node, xml_contents(cdata_content)[[1]])

  # Add general feedback (explanation) with CDATA
  generalfeedback_node <- xml_add_child(q_node, "generalfeedback", format = "html")
  if (!is.null(question$explanation) && nzchar(question$explanation)) {
    feedback_text_node <- xml_add_child(generalfeedback_node, "text")
    cdata_feedback <- xml_new_document() %>% xml_add_child("dummy")
    xml_add_child(cdata_feedback, xml_cdata(question$explanation))
    xml_add_child(feedback_text_node, xml_contents(cdata_feedback)[[1]])
  } else {
    xml_add_child(generalfeedback_node, "text", "")
  }

  # Add default values
  xml_add_child(q_node, "defaultgrade", "1.0000000")
  xml_add_child(q_node, "penalty", "0")  # No penalty for wrong answers
  xml_add_child(q_node, "hidden", "0")
  xml_add_child(q_node, "single", "true")  # Single answer
  xml_add_child(q_node, "shuffleanswers", "true")
  xml_add_child(q_node, "answernumbering", "abc")

  # Add answer options
  # Handle both data frame and list formats for options
  options_data <- question$options

  if (is.data.frame(options_data)) {
    # Options is a data frame
    for (i in 1:nrow(options_data)) {
      fraction <- if (options_data$correct[i]) "100" else "0"

      answer_node <- xml_add_child(q_node, "answer", fraction = fraction, format = "html")
      answer_text_node <- xml_add_child(answer_node, "text")
      # Add CDATA for answer text
      cdata_answer <- xml_new_document() %>% xml_add_child("dummy")
      xml_add_child(cdata_answer, xml_cdata(options_data$text[i]))
      xml_add_child(answer_text_node, xml_contents(cdata_answer)[[1]])

      # Add feedback (empty for now)
      feedback_node <- xml_add_child(answer_node, "feedback", format = "html")
      xml_add_child(feedback_node, "text", "")
    }
  } else {
    # Options is a list
    for (i in seq_along(options_data)) {
      option <- options_data[[i]]
      fraction <- if (option$correct) "100" else "0"

      answer_node <- xml_add_child(q_node, "answer", fraction = fraction, format = "html")
      answer_text_node <- xml_add_child(answer_node, "text")
      # Add CDATA for answer text
      cdata_answer <- xml_new_document() %>% xml_add_child("dummy")
      xml_add_child(cdata_answer, xml_cdata(option$text))
      xml_add_child(answer_text_node, xml_contents(cdata_answer)[[1]])

      # Add feedback (empty for now)
      feedback_node <- xml_add_child(answer_node, "feedback", format = "html")
      xml_add_child(feedback_node, "text", "")
    }
  }

  return(q_node)
}


#' Convert list of MCQs to Moodle XML format
#'
#' @param questions_list List of question results from generate_mcq_from_pdf
#' @param output_file Path to save the XML file
#' @param category Category name for the questions in Moodle
#' @return Invisibly returns the XML document
export_to_moodle_xml <- function(questions_list,
                                 output_file,
                                 category = "Generated Questions") {

  # Create root quiz element
  quiz <- xml_new_root("quiz")

  # Add category
  category_node <- xml_add_child(quiz, "question", type = "category")
  cat_node <- xml_add_child(category_node, "category")
  xml_add_child(cat_node, "text", paste0("$course$/", category))

  # Process each page result
  for (page_result in questions_list) {
    # Skip if there's an error in the result
    if (!is.null(page_result$error)) {
      warning("Skipping result with error: ", page_result$error)
      next
    }

    # Check if questions exist
    if (!is.null(page_result$questions)) {
      questions <- page_result$questions

      # Handle both data frame and list formats
      if (is.data.frame(questions)) {
        for (i in 1:nrow(questions)) {
          q <- list(
            question = questions$question[i],
            options = questions$options[[i]],
            explanation = questions$explanation[i]
          )
          q_xml <- mcq_to_moodle_xml(q, category)
          xml_add_child(quiz, q_xml)
        }
      } else if (is.list(questions)) {
        for (q in questions) {
          q_xml <- mcq_to_moodle_xml(q, category)
          xml_add_child(quiz, q_xml)
        }
      }
    }
  }

  # Write to file
  write_xml(quiz, output_file, options = "format")

  message(sprintf("Moodle XML exported to: %s", output_file))

  invisible(quiz)
}


#' Export multiple PDFs worth of questions to separate XML files
#'
#' @param questions_by_pdf Named list where names are PDF names and values are question lists
#' @param output_dir Directory to save XML files
#' @param prefix Prefix for output filenames
#' @return Invisibly returns a vector of output file paths
export_all_to_moodle <- function(questions_by_pdf,
                                 output_dir = "moodle_xml",
                                 prefix = "mcq_") {

  # Create output directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  output_files <- character()

  for (pdf_name in names(questions_by_pdf)) {
    # Create safe filename
    safe_name <- gsub("[^[:alnum:]_-]", "_", tools::file_path_sans_ext(pdf_name))
    output_file <- file.path(output_dir, paste0(prefix, safe_name, ".xml"))

    # Get category from PDF name
    category <- tools::file_path_sans_ext(pdf_name)

    # Export
    export_to_moodle_xml(
      questions_list = questions_by_pdf[[pdf_name]],
      output_file = output_file,
      category = category
    )

    output_files <- c(output_files, output_file)
  }

  message(sprintf("Exported %d XML files to %s", length(output_files), output_dir))

  invisible(output_files)
}
