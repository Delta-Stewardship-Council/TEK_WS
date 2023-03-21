# clarify data upload code
# clean text data and write final raw text data for analysis

# library
library(pdftools)
library(readtext)
library(tidytext)
library(dplyr)

# upload pdf
dir <- "Data/00_Final lit review" # names location of pdf files
files <- list.files(dir, pattern = "*.pdf$", full.names = TRUE) # creates vector of pdf file names

# get data (in Plain Text UTF-8)
tidy_pdf <- readtext(files)

# make text data
tidy_words <- tidy_pdf %>%
  unnest_tokens(word, text)

# clean text
# test
pdf_doc <- unique(tidy_pdf$doc_id) #98
tidy_doc <- unique(tidy_words$doc_id) #94
setdiff(pdf_doc, tidy_doc)
