# clarify data upload code
# clean text data and write final raw text data for analysis

# library
library(pdftools)
library(readtext)
library(tidytext)
library(dplyr)
library(ggplot2)
library(tm)

# upload pdf
dir <- "Data/00_Final lit review" # names location of pdf files
files <- list.files(dir, pattern = "*.pdf$", full.names = TRUE) # creates vector of pdf file names

# get data (in Plain Text UTF-8)
tidy_pdf <- readtext(files)

# make text data
tidy_words <- tidy_pdf %>%
  unnest_tokens(word, text)

write.csv(tidy_words, "Data/raw_text_data.csv")

# clean text
# test
make_data
pdf_doc <- unique(tidy_pdf$doc_id) #99
tidy_doc <- unique(tidy_words$doc_id) #99

setdiff(pdf_doc, tidy_doc)

# remove stop words
tidy_stop_words <- tidy_words %>%
  anti_join(stop_words) # without stop words
# 594917 less words

# remove numbers and symbols
tidy_stop_num_words <- mutate(tidy_stop_words, word = gsub(x = word, pattern = "[0-9]+|[[:punct:]]|\\(.*\\)", replacement = ""))

tidy_stop_num_words <-  tidy_stop_num_words[!(is.na(tidy_stop_num_words$word) | tidy_stop_num_words$word ==""), ]

# check
check <- tidy_stop_num_words %>%
  count(word, sort = TRUE)

check  %>%
  filter(n > 1000) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col(fill = "darkred") +
  xlab(NULL) +
  ylab("Word Count") +
  coord_flip() +
  ggtitle("Word Usage") # looks good, but still has some weird stuff... "al" is 15th

# add root word
tidy_stop_num_words$stem <- stemDocument(tidy_stop_num_words$word)

check_stem <- tidy_stop_num_words %>%
  count(stem, sort = TRUE)

check_stem  %>%
  filter(n > 1000) %>%
  mutate(stem = reorder(stem, n)) %>%
  ggplot(aes(stem, n)) +
  geom_col(fill = "darkred") +
  xlab(NULL) +
  ylab("Stem word Count") +
  coord_flip() +
  ggtitle("Stem word Usage") #


# remove remaining unique text
unique_text <- check_stem %>%
  filter(n > 10) # loose 24944

# as of 3/30/23 discussion, we are going to keep unique words for now, but may not be part of the synonym work and analyses

write.csv(tidy_stop_num_words, "Data/clean_text_data.csv", row.names = FALSE)


# 4/13/23 updated clean text test & remove stop words annotated text

