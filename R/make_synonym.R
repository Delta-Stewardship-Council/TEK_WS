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

# reorder
make_key_w_count %>%
  arrange(desc(n))

# remove non words manually
clean_key <- make_key_w_count %>%
  arrange(desc(n)) %>%
  filter(word != "al", word != "http", word !="berkes", word !="id",
         word !="eg", word !="de", word !="supra", word !="s", word !="pp",
         word !="tion", word !="page", word !="eds", word !="ing")

# May need python installed to run the code below
# make synonyms packages
library(quanteda)
library(spacyr)
#Sys.setenv(RETICULATE_PYTHON = "~/Users/aangel/AppData/Local/Programs/R/R-4.2.3/library")
library(reticulate)

# troubleshooting issue below - will remove if python installation resolves, lines 42-45
use_condaenv("r-reticulate")
Sys.which("python")
Sys.which("conda")
spacy_download_langmodel("en_core_web_lg", conda = "auto")

# make synonyms - lemmatization (this may expedite the process of grouping together inflected forms of the same word; see https://stackoverflow.com/questions/61257802/r-text-mining-grouping-similar-words-using-stemdocuments-in-tm-package)
sp <- spacy_parse(tidy_stop_num_words$word, lemma = TRUE)

words_tok <- as.tokens(tidy_stop_num_words$word) %>%
  tokens(remove_punct = TRUE) # create tokens

# define equivalencies for word variants
syn <- dictionary(list(
  agency = c("agency", "agencies"),
  colonial = c("colonial", "colonialism"),
  community = c("community", "communities"),
  cultural = c("cultural", "culture", "cultures"),
  ecosystem = c("ecosystem", "ecosystems"),
  environment = c("environment", "environmental"),
  food = c("food", "foods"),
  government = c("governments", "government"),
  indigenous = c("indigenous", "native", "tribes", "indian", "indians"), #tribal?
  people = c("people", "human", "humans"),
  relationship = c("relationship", "relationships"),
  science = c("science", "scientific"),
  study = c("study", "studies"),
  tradition = c("traditions", "traditional"),
  women = c("woman", "womans")
    ))
#!!! I used clean_key to create the dictionary above. Some words for discussion below.
#!!! nation & society? governance with government group? legal and law?

# Once the syn dictionary is finalized
make_syn <- tokens_lookup(words_tok, dictionary = syn, exclusive = FALSE, capkeys = FALSE)

