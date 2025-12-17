# Generate Multiple Choice Questions from PDF using ChatGPT
# This script uses the ellmer package to interact with ChatGPT API
# and pdftools to extract PDF pages

library(ellmer)
library(pdftools)

#' Generate MCQ from a single PDF page
#'
#' @param pdf_path Path to the PDF file
#' @param page_number The page number to process (1-indexed)
#' @param difficulty Difficulty level for the questions (e.g., "easy", "medium", "hard")
#' @param n_questions Number of multiple choice questions to generate (default: 3)
#' @param n_options Number of answer options per question (default: 4)
#' @param api_key OpenAI API key (optional, will use OPENAI_API_KEY env var if not provided)
#' @return A list containing the generated questions
generate_mcq_from_page <- function(
  pdf_path,
  page_number,
  difficulty = "medium",
  n_questions = 3,
  n_options = 4,
  api_key = NULL
) {
  # Validate inputs
  if (!file.exists(pdf_path)) {
    stop("PDF file does not exist: ", pdf_path)
  }

  # Get total number of pages
  pdf_info <- pdf_info(pdf_path)
  if (page_number > pdf_info$pages || page_number < 1) {
    stop("Invalid page number. PDF has ", pdf_info$pages, " pages.")
  }

  # Extract text from the specific page
  page_text <- pdf_text(pdf_path)[page_number]

  # Create the prompt for ChatGPT
  prompt <- sprintf(
    "IMPORTANT: Generate all questions, answers, and explanations in CZECH language (česky).

Based on the content from this presentation slide, create %d multiple choice questions at %s difficulty level.

For each question:
1. Create %d answer options (1 correct answer and %d distractors)
2. IMPORTANT: Make sure the correct answer is approximately the same length as the distractors. Do not make the correct answer noticeably longer than the incorrect options.
3. Make the distractors plausible but clearly incorrect
4. Focus on key concepts and understanding, not trivial details
5. Write everything in Czech language (česky)

Format your response as valid JSON with the following structure:
{
  \"questions\": [
    {
      \"question\": \"Text otázky v češtině\",
      \"options\": [
        {\"text\": \"Možnost A v češtině\", \"correct\": true},
        {\"text\": \"Možnost B v češtině\", \"correct\": false},
        {\"text\": \"Možnost C v češtině\", \"correct\": false},
        {\"text\": \"Možnost D v češtině\", \"correct\": false}
      ],
      \"explanation\": \"Stručné vysvětlení správné odpovědi v češtině\"
    }
  ]
}

Page content:
%s",
    n_questions,
    difficulty,
    n_options,
    n_options - 1,
    page_text
  )

  # Initialize chat with ellmer
  if (!is.null(api_key)) {
    Sys.setenv(OPENAI_API_KEY = api_key)
  }

  chat <- chat_openai(
    system_prompt = "You are an expert educator creating high-quality multiple choice questions from educational content. Always respond with valid JSON as requested. IMPORTANT: Generate all content in Czech language (česky) unless otherwise specified.",
    model = "gpt-4o"
  )

  # Send the prompt
  response <- chat$chat(prompt)

  # Clean the response - remove markdown code blocks if present
  cleaned_response <- response
  # Remove ```json and ``` markers
  cleaned_response <- gsub("^```json\\s*", "", cleaned_response)
  cleaned_response <- gsub("^```\\s*", "", cleaned_response)
  cleaned_response <- gsub("```\\s*$", "", cleaned_response)
  cleaned_response <- trimws(cleaned_response)

  # Parse the JSON response
  result <- tryCatch(
    {
      jsonlite::fromJSON(cleaned_response)
    },
    error = function(e) {
      # If JSON parsing fails, return raw response
      warning("Failed to parse JSON response. Returning raw text.")
      list(raw_response = response, error = e$message)
    }
  )

  # Add metadata
  result$metadata <- list(
    pdf_file = basename(pdf_path),
    page_number = page_number,
    difficulty = difficulty,
    timestamp = Sys.time()
  )

  return(result)
}


#' Generate MCQs from multiple pages of a PDF
#'
#' @param pdf_path Path to the PDF file
#' @param pages Vector of page numbers to process (default: all pages)
#' @param difficulty Difficulty level for the questions
#' @param n_questions Number of questions per page
#' @param n_options Number of options per question
#' @param api_key OpenAI API key
#' @return A list containing all generated questions
generate_mcq_from_pdf <- function(
  pdf_path,
  pages = NULL,
  difficulty = "medium",
  n_questions = 3,
  n_options = 4,
  api_key = NULL
) {
  # Get total pages if not specified
  if (is.null(pages)) {
    pdf_info <- pdf_info(pdf_path)
    pages <- 1:pdf_info$pages
  }

  message(sprintf(
    "Processing %d pages from %s",
    length(pages),
    basename(pdf_path)
  ))

  all_questions <- list()

  for (page in pages) {
    message(sprintf("Processing page %d...", page))

    result <- tryCatch(
      {
        generate_mcq_from_page(
          pdf_path = pdf_path,
          page_number = page,
          difficulty = difficulty,
          n_questions = n_questions,
          n_options = n_options,
          api_key = api_key
        )
      },
      error = function(e) {
        warning(sprintf("Error processing page %d: %s", page, e$message))
        NULL
      }
    )

    if (!is.null(result)) {
      all_questions[[length(all_questions) + 1]] <- result
    }

    # Add a small delay to avoid rate limiting
    Sys.sleep(1)
  }

  return(all_questions)
}
