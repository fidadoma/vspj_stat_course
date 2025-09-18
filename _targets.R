# _targets.R
library(targets)
library(tarchetypes)

# Packages that functions rely on:
tar_option_set(
  packages = c(
    "dplyr",
    "readr",
    "googlesheets4",
    "stringr",
    "glue",
    "purrr",
    "fs",
    "quarto",
    "ellmer",
    "withr",
    "here"
  )
)

# If your Google Sheet is public, you can deauth; otherwise ensure OAuth is set up.
googlesheets4::gs4_deauth()

# ---- CONFIG -----------------------------------------------------------------
SHEET_URL <- "https://docs.google.com/spreadsheets/d/1wYAsc5R6yTmNfMY2ZO72dYL5MWuxHoNcZTKxFpBu-jA"
N_ROWS <- 5 # take first 5 questions (change as you like)

# Source helper functions
tar_source("R/automatic_scripts/functions.R")

list(
  # 1) Read the sheet
  tar_target(
    questions_raw,
    googlesheets4::read_sheet(SHEET_URL)
  ),

  # 2) Extract just the vector of question texts (a *target* to branch over)
  tar_target(
    question_texts,
    questions_raw |>
      dplyr::slice_head(n = N_ROWS) |>
      dplyr::pull(question_text)
  ),

  # 3) (Optional) create a simple 1:1 branching target for readability
  tar_target(
    qtext,
    question_texts,
    pattern = map(question_texts),
    iteration = "vector"
  ),

  # 4) Write each QMD (branching over qtext)
  tar_target(
    qmd_file,
    write_qmd_from_prompt(qtext),
    pattern = map(qtext),
    format = "file"
  ),

  # 5) Render each QMD to HTML in docs/ (branching over qmd_file)
  tar_target(
    html_file,
    render_qmd(qmd_file),
    pattern = map(qmd_file),
    format = "file"
  ),

  # 6) Build docs/index.html *after* all HTMLs exist
  tar_target(
    index_file,
    {
      html_file
      make_index()
    }, # reference html_file to enforce dependency
    format = "file"
  )
)
