suppressPackageStartupMessages({
  library(dplyr)
  library(stringr)
  library(glue)
  library(purrr)
  library(fs)
})

# ---- config helpers ---------------------------------------------------------

qmd_dir <- function() fs::path("R", "generating_materials", "qmds")
html_dir <- function() fs::path("docs") # GitHub Pages-friendly

dir_prep <- function() {
  fs::dir_create(qmd_dir())
  fs::dir_create(html_dir())
}

# ---- filename & prompt ------------------------------------------------------

make_filename <- function(text) {
  text <- iconv(text, from = "UTF-8", to = "ASCII//TRANSLIT")
  text <- gsub("[^a-zA-Z0-9 ]", "", text)
  text <- tolower(text)
  gsub(" +", "_", text)
}

# Your system prompt (kept identical to your script).
build_system_prompt <- function() {
  glue(
    'Dostaneš na vstupu otázku ze statistiky. Vytvoř pro ní studijní materiál pro studenty vysoké školy (studenti nejsou nejbystřejší, takže hodně vysvětluj). Lepší je, aby to bylo delší, ale více vysvětlené. U otázky uveď příklady z běžného života, kde si to můžeou představit. 
Používej hezké formátování. Výstup ulož jako quarto qmd soubor, aby z toho pak šel udělat snadno quarto web. 
Udělej to jako self-contained html. Nic nevysvětluj, vrať jen qmd. Přidej toto do yaml hlavičky:
author: Filip Děchtěrenko
date: "{{< meta date >}}"
execute:
  warning: false
  message: false
  cache: false
format:
  html:
    toc: true
    code-fold: true
    code-summary: "Show the code"
    embed-resources: true
editor: source'
  )
}

# ---- OpenAI wrapper (ellmer::chat_openai) -----------------------------------
# We create a fresh chat client inside the function to avoid serialization issues in targets.

get_chat_client <- function() {
  ellmer::chat_openai(
    model = "gpt-4o",
    system_prompt = build_system_prompt()
  )
}

# ---- QMD creation from a single question ------------------------------------

write_qmd_from_prompt <- function(question_text) {
  dir_prep()

  chat <- get_chat_client()
  q_response <- chat$chat(question_text)

  # normalize possible fenced YAML to a bare YAML header
  q_response <- q_response |>
    str_replace("```yaml", "") |>
    str_replace("```", "")

  fname <- paste0(make_filename(question_text), ".qmd")
  out <- fs::path(qmd_dir(), fname)

  writeLines(q_response, out)
  out
}

# ---- Render a single QMD to HTML into docs/ ---------------------------------

render_qmd <- function(qmd_file) {
  stopifnot(requireNamespace("quarto", quietly = TRUE))
  stopifnot(requireNamespace("withr", quietly = TRUE))
  stopifnot(requireNamespace("here", quietly = TRUE))
  fs::dir_create(html_dir())

  qbin <- tryCatch(quarto::quarto_path(), error = function(e) NA_character_)
  if (is.na(qbin) || !fs::file_exists(qbin)) stop("Quarto CLI not found.")

  qmd_abs <- fs::path_abs(qmd_file)
  out_dir <- fs::path_abs(html_dir())
  out_nm <- fs::path_ext_set(fs::path_file(qmd_file), "html")
  src_wd <- fs::path_dir(qmd_abs)

  args <- c(
    "render",
    shQuote(qmd_abs),
    "--to",
    "html",
    "--output",
    shQuote(out_nm), # filename only
    "--output-dir",
    shQuote(out_dir) # Quarto will nest by source dir
  )

  tf_out <- tempfile(fileext = ".out")
  tf_err <- tempfile(fileext = ".err")

  status <- withr::with_dir(
    src_wd,
    system2(qbin, args, stdout = tf_out, stderr = tf_err, wait = TRUE)
  )

  # Quarto nests by relative path under the project root.
  # Compute that nested path and check both locations.
  proj_root <- fs::path_abs(here::here())
  rel_srcdir <- fs::path_rel(src_wd, start = proj_root) # e.g., "R/generating_materials/qmds"
  nested_out <- fs::path(out_dir, rel_srcdir, out_nm) # docs/R/generating_materials/qmds/file.html
  flat_out <- fs::path(out_dir, out_nm) # docs/file.html (what you originally expected)

  out_path <- if (fs::file_exists(nested_out)) nested_out else flat_out

  if (!fs::file_exists(out_path) || isTRUE(status != 0)) {
    out_log <- if (fs::file_exists(tf_out))
      paste(readLines(tf_out, warn = FALSE), collapse = "\n") else ""
    err_log <- if (fs::file_exists(tf_err))
      paste(readLines(tf_err, warn = FALSE), collapse = "\n") else ""
    stop(
      "Expected output not found after render: ",
      out_path,
      "\n",
      "Quarto render failed.\n",
      "Command: ",
      qbin,
      " ",
      paste(args, collapse = " "),
      "\n",
      "Working dir: ",
      src_wd,
      "\n\n",
      "STDOUT:\n",
      out_log,
      "\n\n",
      "STDERR:\n",
      err_log,
      "\n"
    )
  }

  # If you want to FLATTEN into docs/ root, uncomment:
  if (fs::path_dir(out_path) != out_dir) {
    fs::dir_create(out_dir)
    fs::file_copy(out_path, flat_out, overwrite = TRUE)
    out_path <- flat_out
  }

  out_path
}

# ---- Make a simple index.html (links to all HTMLs in docs/) -----------------

make_index <- function(root = html_dir(), out = fs::path(root, "index.html")) {
  htmls <- fs::dir_ls(root, glob = "*.html", recurse = TRUE)
  htmls <- htmls[fs::path_file(htmls) != "index.html"]
  if (!length(htmls)) stop("No HTML files found in: ", root)

  get_title <- function(path) {
    x <- tryCatch(
      readLines(path, warn = FALSE, n = 200),
      error = function(e) ""
    )
    m <- regmatches(
      x,
      regexpr("(?i)(?<=<title>).*?(?=</title>)", x, perl = TRUE)
    )
    t <- m[nzchar(m)][1]
    if (is.na(t) || !nzchar(t)) fs::path_file(path) else t
  }

  rel <- function(p) fs::path_rel(p, start = root)

  df <- tibble(
    href = vapply(htmls, rel, character(1)),
    title = vapply(htmls, get_title, character(1))
  ) |>
    arrange(tolower(title))

  page <- c(
    "<!doctype html>",
    "<meta charset='utf-8'><meta name='viewport' content='width=device-width, initial-scale=1'>",
    "<title>Index</title>",
    "<style>body{font:16px/1.5 system-ui, sans-serif; max-width:800px; margin:3rem auto; padding:0 1rem}",
    "ul{list-style:none;padding:0} li{margin:.4rem 0} a{text-decoration:none} a:hover{text-decoration:underline}</style>",
    "<h1>Index</h1>",
    "<ul>",
    sprintf("<li><a href='%s'>%s</a></li>", df$href, df$title),
    "</ul>"
  )

  fs::dir_create(fs::path_dir(out))
  writeLines(page, out)
  out
}
