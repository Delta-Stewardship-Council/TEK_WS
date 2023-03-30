# QC stem words
# add synonyms to simplify analyses
# library
library(dplyr)

# load data
text_data <- read.csv("Data/clean_text_data.csv")
head(text_data)
str(text_data)

# simplify to unique pairings of words and stems
make_key <- unique(text_data[,c(2,3)])
head(make_key)

# add frequency of words in data
word_count <- text_data %>%
  count(word)

make_key_w_count <- merge(make_key, word_count, by = "word", all = TRUE)
head(make_key_w_count)
