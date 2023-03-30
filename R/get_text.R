# create text data, prepare to use/test for tidytext package

# library
library(tidytext)
library(readtext)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(textdata)

# get data (in Plain Text UTF-8)
tidy_pdf <- readtext(files)

tidy_words <- tidy_pdf %>%
  unnest_tokens(word, text)

# try some stuff...(from https://kayleealexander.com/wp-content/uploads/2019/05/TIDY-TEXT-2019.pdf)
# Which words appear most frequently and how many times do they each appear?
quetion_1 <- tidy_words %>%
  count(word, sort = TRUE)

quetion_1 <- tidy_words %>%
  anti_join(stop_words) %>% # without stop words
  count(word, sort = TRUE)

# How many words appear more than 1000 times?
quetion_1 %>%
  filter(n > 1000) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col(fill = "darkred") +
  theme_fivethirtyeight() +
  xlab(NULL) +
  ylab("Word Count") +
  coord_flip() +
  ggtitle("Word Usage")

# What sentiment score is assigned to “fear”?
get_sentiments("nrc")
#nrc categorizes words as positive, negative, anger, anticipation, disgust, fear, joy, sadness, surprise and trust.
get_sentiments("bing")
#bing categorizes words as positive or negative.
get_sentiments("afinn")
#AFINN assigns words a numeric score between -5 and 5, where the negative scores indicate negative sentiment and positive scores indicate positive sentiment.

sentiment_bing <- quetion_1 %>%
  inner_join(get_sentiments("bing"))

sentiment_bing %>%
  filter(n > 100) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill=sentiment)) +
  theme_fivethirtyeight() +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  ylab("Word Count") +
  ggtitle("Word Usage", subtitle = "Sentiment Analysis Using
Bing et al.")

nrc_fear <- get_sentiments("nrc") %>%
  filter(sentiment == "fear")

fear_words <- quetion_1 %>%
  inner_join(nrc_fear)
