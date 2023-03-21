# read pdf documents

# libraries
library(pdftools)
library(tm)

dir <- "Data/00_Final lit review" # names location of pdf files
files <- list.files(dir, pattern = "*.pdf$", full.names = TRUE) # creates vector of pdf file names
saveRDS(files, file = "list-of-pdfs.rds")

optnions <- lapply(files, pdf_text) # loads files
lapply(optnions, length) # check number of pdf and pages

pdfdatabase <- Corpus(URISource(files), readerControl = list(reader = readPDF)) # creates pdf database

# term document matrix
# only words that appear at least 3 times
optnions_tdm <- TermDocumentMatrix(pdfdatabase, control = list(removePunctuation = TRUE,
                                                               stopwords = TRUE,
                                                               tolower = TRUE,
                                                               stemming = FALSE,
                                                               removeNumbers = TRUE,
                                                               bounds = list(global = c(3, Inf))))
inspect(optnions_tdm[1:10,]) # by document
findFreqTerms(optnions_tdm, lowfreq = 150, highfreq = Inf) # across all documents
