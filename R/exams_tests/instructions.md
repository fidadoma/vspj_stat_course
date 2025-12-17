## Instructions

I have a directory pdf full of presentations. I need to create multiple choice items.
This can be done using chatgpt. 
I am using ellmer for that (see https://ellmer.tidyverse.org for examples)

I need to ask chatgpt via api for each presentation in the pdf directory to create multiple choice items. To make it more adjustable, 
I need a function that uploads one page from pdf, then asks chatgpt to create multiple choice items for that page. I will process the bad ones later.
specify difficulty as parameter for chatgpt. Also specify that the correct answer needs to be about the ame length as distractors, sometimes ,the correct answer is the longest and this is a simple heuristic.

After such function exists, write script that for all pdfs create multiple choice items for each page in each pdf. 
I will be importing them to moodle, so convert it to moodle xml format.