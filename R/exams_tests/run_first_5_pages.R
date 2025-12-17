#!/usr/bin/env Rscript
# Process first 5 pages of all PDFs

source('R/exams_tests/process_all_pdfs.R')

cat('\n')
cat('========================================\n')
cat('  Zpracování prvních 5 stránek\n')
cat('========================================\n\n')

# Check if API key is set
if (Sys.getenv("OPENAI_API_KEY") == "") {
  cat('CHYBA: OPENAI_API_KEY není nastavený!\n')
  cat('Nastav ho pomocí:\n')
  cat('  Sys.setenv(OPENAI_API_KEY = "your-api-key-here")\n\n')
  quit(status = 1)
}

cat('Konfigurace:\n')
cat('  Vstupní složka: R/exams_tests/pdf\n')
cat('  Výstupní složka: moodle_xml\n')
cat('  Obtížnost: medium\n')
cat('  Otázek na stránku: 3\n')
cat('  Možností na otázku: 4\n')
cat('  Stránky: První 5 z každého PDF\n')
cat('  Jazyk: Čeština\n')
cat('  Penalizace: 0\n\n')

# Count PDFs
pdf_files <- list.files('R/exams_tests/pdf', pattern = '.pdf$')
cat('Nalezeno', length(pdf_files), 'PDF souborů\n')
cat('Odhadovaný čas:', round(length(pdf_files) * 5 * 1.5 / 60, 1), 'minut\n\n')

cat('=== Začínám zpracování ===\n\n')

start_time <- Sys.time()

# Process first 5 pages of all PDFs
results <- process_all_pdfs(
  pdf_dir = 'R/exams_tests/pdf',
  output_dir = 'moodle_xml',
  difficulty = 'medium',
  n_questions = 3,
  n_options = 4,
  pages_to_process = 1:5,
  save_intermediate = TRUE
)

end_time <- Sys.time()
elapsed <- as.numeric(difftime(end_time, start_time, units = "mins"))

cat('\n')
cat('========================================\n')
cat('  Zpracování dokončeno!\n')
cat('========================================\n\n')

cat('Shrnutí:\n')
cat('  PDF zpracováno:', length(results), '\n')
cat('  Čas zpracování:', round(elapsed, 1), 'minut\n')

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

cat('  Celkem vygenerováno otázek:', total_questions, '\n')
cat('\nVýstupní soubory:\n')
xml_files <- list.files('moodle_xml', pattern = '^mcq_.*\\.xml$')
for (f in xml_files) {
  cat('  -', f, '\n')
}

cat('\nSoubory můžeš nyní importovat do Moodle!\n')
cat('Umístění: moodle_xml/\n\n')
