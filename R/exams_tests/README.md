# PDF to MCQ Generator with Moodle Export

This toolset automatically generates multiple choice questions (MCQs) from PDF presentations using ChatGPT and exports them to Moodle XML format.

## Features

- Extract content from PDF presentations page by page
- Generate multiple choice questions **in Czech language** using ChatGPT via the ellmer package
- Configurable difficulty levels and question parameters
- Ensures correct answers are similar length to distractors (avoids "longest answer" heuristic)
- Export to Moodle-compatible XML format for easy import
- **No penalty for wrong answers** (penalty set to 0 in Moodle XML)
- Process multiple PDFs in batch
- Save intermediate results for resumption

## Prerequisites

Install required R packages:

```r
install.packages(c("ellmer", "pdftools", "magick", "xml2", "jsonlite"))
```

Set up your OpenAI API key:

```r
# Option 1: Set environment variable
Sys.setenv(OPENAI_API_KEY = "your-api-key-here")

# Option 2: Add to .Renviron file
# OPENAI_API_KEY=your-api-key-here
```

## Directory Structure

```
vspj_stat_course/
├── pdf/                          # Place your PDF files here
├── R/exams_tests/
│   ├── generate_mcq_from_pdf.R  # Core MCQ generation functions
│   ├── export_to_moodle.R       # Moodle XML export functions
│   ├── process_all_pdfs.R       # Main processing script
│   └── README.md                # This file
└── moodle_xml/                  # Output directory (auto-created)
    ├── mcq_*.xml                # Moodle XML files
    └── intermediate_results/    # Saved intermediate results
```

## Usage

### Basic Usage

1. Place your PDF files in the `pdf/` directory
2. Run the processing script:

```r
source("R/exams_tests/process_all_pdfs.R")

# Process all PDFs with default settings
results <- process_all_pdfs()
```

This will:
- Process all PDFs in the `pdf/` directory
- Generate 3 MCQs per page at medium difficulty
- Create 4 answer options per question
- Export to `moodle_xml/` directory
- Save intermediate results

### Advanced Usage

#### Custom Settings

```r
# Process with custom parameters
results <- process_all_pdfs(
  pdf_dir = "pdf",                  # Input directory
  output_dir = "moodle_xml",        # Output directory
  difficulty = "hard",              # easy, medium, or hard
  n_questions = 5,                  # Questions per page
  n_options = 5,                    # Answer options per question
  api_key = "your-key"              # Optional: API key
)
```

#### Process Specific Pages

```r
# Process only first 5 pages of each PDF
results <- process_all_pdfs(pages_to_process = 1:5)

# Process specific pages
results <- process_all_pdfs(pages_to_process = c(1, 3, 5, 10))
```

#### Process Single PDF

```r
source("R/exams_tests/generate_mcq_from_pdf.R")

# Process one PDF
questions <- generate_mcq_from_pdf(
  pdf_path = "pdf/lecture1.pdf",
  difficulty = "medium",
  n_questions = 3
)

# Export to Moodle
source("R/exams_tests/export_to_moodle.R")
export_to_moodle_xml(
  questions_list = questions,
  output_file = "moodle_xml/lecture1.xml",
  category = "Lecture 1"
)
```

#### Process Single Page

```r
source("R/exams_tests/generate_mcq_from_pdf.R")

# Generate MCQs from one page
page_questions <- generate_mcq_from_page(
  pdf_path = "pdf/lecture1.pdf",
  page_number = 5,
  difficulty = "easy",
  n_questions = 2
)
```

### Resume from Interrupted Processing

If processing was interrupted, you can resume from saved intermediate results:

```r
# Resume from intermediate results
results <- resume_from_intermediate(
  intermediate_dir = "moodle_xml/intermediate_results",
  output_dir = "moodle_xml"
)
```

## Output

### Moodle XML Files

Each PDF generates a separate XML file: `moodle_xml/mcq_<pdf_name>.xml`

These files can be directly imported into Moodle:
1. Go to your Moodle course
2. Navigate to Question bank
3. Choose "Import"
4. Select "Moodle XML format"
5. Upload the generated XML file

### Intermediate Results

Intermediate results are saved as RDS files in `moodle_xml/intermediate_results/`. These contain the raw question data and can be:
- Reloaded for inspection
- Re-exported to XML with different settings
- Used for resuming interrupted processing

### Complete Results

All questions are saved to `moodle_xml/all_questions_complete.rds` for later analysis or reprocessing.

## Customization

### Difficulty Levels

The `difficulty` parameter affects how ChatGPT generates questions:
- `"easy"`: Basic recall and understanding
- `"medium"`: Application and analysis (default)
- `"hard"`: Advanced synthesis and evaluation

### Question Quality

The system automatically instructs ChatGPT to:
- Make correct answers similar length to distractors
- Create plausible but clearly incorrect distractors
- Focus on key concepts, not trivial details
- Provide explanations for correct answers

## Troubleshooting

### No PDF files found
- Ensure PDF files are in the correct directory
- Check that files have `.pdf` extension

### API errors
- Verify your OpenAI API key is set correctly
- Check your API quota/billing
- The script includes 1-second delays between pages to avoid rate limiting

### JSON parsing errors
- Some responses may fail to parse; these are logged as warnings
- Raw responses are saved for manual review
- Try adjusting the difficulty or n_questions parameters

### Out of memory
- Process fewer pages at a time using `pages_to_process`
- Process PDFs individually rather than in batch

## Examples

### Example 1: Quick Test

```r
# Test with first page of first PDF
source("R/exams_tests/generate_mcq_from_pdf.R")

pdf_files <- list.files("pdf", pattern = "\\.pdf$", full.names = TRUE)
test_result <- generate_mcq_from_page(
  pdf_path = pdf_files[1],
  page_number = 1,
  difficulty = "easy",
  n_questions = 2
)

print(test_result)
```

### Example 2: Process Entire Course

```r
# Process all lectures with high difficulty
results <- process_all_pdfs(
  pdf_dir = "pdf",
  difficulty = "hard",
  n_questions = 5,
  n_options = 5
)

# Review results
summary_df <- data.frame(
  pdf = names(results),
  n_pages = sapply(results, length)
)
print(summary_df)
```

### Example 3: Manual Review Workflow

```r
# 1. Generate questions
results <- process_all_pdfs(save_intermediate = TRUE)

# 2. Review intermediate results
questions <- readRDS("moodle_xml/intermediate_results/lecture1_questions.rds")

# 3. Manually edit if needed
# ... edit questions ...

# 4. Re-export to XML
export_to_moodle_xml(
  questions_list = questions,
  output_file = "moodle_xml/mcq_lecture1_revised.xml",
  category = "Lecture 1 - Revised"
)
```

## Notes

- Processing time depends on PDF length and API response time (~2-5 seconds per page)
- Costs depend on your OpenAI API pricing and content length
- Always review generated questions before using in actual exams
- The system uses GPT-4o for best quality results
