# QC stem words
# add synonyms to simplify analyses

# library
library(dplyr)

# load data
text_data <- read.csv("Data/clean_text_data.csv")
head(text_data)
str(text_data)

# remove pdfs without metadata (not read by group)
meta_data <- read.csv("Data/clean_meta_data.csv")
head(meta_data)
str(meta_data)

ID <- meta_data[,c(1,33)]
reduce_by_ID <- merge(ID, text_data, by = "doc_id", all = TRUE)
reduce_by_ID <- na.omit(reduce_by_ID)

# simplify to unique pairings of words and stems
make_key <- unique(reduce_by_ID[,c(3,4)])
head(make_key)

# add frequency of words in data
word_count <- reduce_by_ID %>%
  count(word)

make_key_w_count <- merge(make_key, word_count, by = "word", all = TRUE)
head(make_key_w_count)
