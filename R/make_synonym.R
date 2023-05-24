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


make_key_w_count <- merge(make_key, word_count, by = "word", all = TRUE)
head(make_key_w_count)

# reorder
make_key_w_count %>%
  arrange(desc(n))
sum(make_key_w_count$n)

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
library(reticulate)

# ensure python & anaconda programs are installed before running the code below
Sys.which("python")
Sys.which("conda")

# for more informaton on creating & activating the spacy_condaenv, see amatsuo's comment 2/5/19 https://github.com/quanteda/spacyr/issues/156
spacy_download_langmodel("en_core_web_lg", envname = "spacy_condaenv",conda = "auto")

# make synonyms - lemmatization (this may expedite the process of grouping together inflected forms of the same word; see https://stackoverflow.com/questions/61257802/r-text-mining-grouping-similar-words-using-stemdocuments-in-tm-package)
#library(textstem) #another method
#lemma <- lemmatize_words(make_key_w_count$word)

sp <- spacy_parse(make_key_w_count$word, lemma = TRUE, entity = F)

# get count of all words for each lemma
lemma <- lemma %>%
  group_by(lemma) %>%
  count(lemma, sort = T)
#!!! lemmatization resulted in a dramatic reduction in the list of words

#check to make sure there was no word loss
sum(lemma$n)

# check some synonyms noted previously
lemma %>%
  filter(lemma == "relate")

sp %>%
  filter(lemma == "et")

# define equivalencies for word variants
syn <- dictionary(list(
  #agency = c("agency", "agencies"),
  colonial = c("colonial", "colonialism"),
  community = c("community", "communities"),
  #cultural = c("cultural", "culture", "cultures"), #plural is removed, ADJ vs Noun is not
  #ecosystem = c("ecosystem", "ecosystems"),
  environment = c("environment", "environmental"),
  #food = c("food", "foods"),
  #government = c("governments", "government"),
  indigenous = c("indigenous", "native", "tribes", "indian"), #tribal? #native/natives ADJ vs Noun was combined
  people = c("people", "human"),
  #relationship = c("relationship", "relationships"),
  science = c("science", "scientific"),
  #study = c("study", "studies"),
  tradition = c("traditions", "traditional"),
  women = c("woman", "womans")
    ))
#!!! I used clean_key to create the dictionary above. Some words for discussion below.
#!!! nation & society? governance with government group? legal and law?

# Once the syn dictionary is finalized
make_syn <- tokens_lookup(words_tok, dictionary = syn, exclusive = FALSE, capkeys = FALSE)

