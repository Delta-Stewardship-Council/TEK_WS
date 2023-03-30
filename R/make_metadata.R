# add pdf meta data to text data

# library
library(readxl)

# load data
text_data <- read.csv("Data/clean_text_data.csv")
head(text_data)
str(text_data)

Reading_group_schedule <- read_excel("Data/00_Final lit review/00_Reading group schedule.xlsx", sheet = "Index")
View(Reading_group_schedule)

# remove reader
index <- Reading_group_schedule[,-1]

# fix column names
colnames(index) <- c("pdf", "Reading_ID", "Indigenous_authorship", "Geographic_info", "Actors-Tribes", "Actors-Universities","Actors-Agencies", "Actors-Industry", "Actors-NGO/CBO", "Actors-Other", "Applications-Restoration", "Applications-CC", "Applications-Traditional_use_ecocultural_restoration","Applications-Watermgmt", "Applications-Biodiversity_conservation","Applications-Forestry","Applications-Other", "Findings","Points","Definitions","Characteristics", "Interweaving-Similarities and differences","Interweaving-Approaches","Interweaving-Challenges or barriers", "Interweaving-Solutions", "Interweaving-Benefits","Interweaving-Drawbacks", "Interweaving-Outcomes","Governance", "Significance-Council",
"Significance-agency","Significance-Tribal")

# remove extra header row
index <- index[-1,]

# replace NA with zero
str(index)

index[] <- lapply(index, function(x) {
  is.na(levels(x)) <- levels(x) == "NA"
  x
})

index[is.na(index)] <- "0"

# replace x with 1
index[index=="x"] <- "1"
index[index=="X"] <- "1"

# still needs year, geography, authorship and matching IDs
doc_id <- unique(text_data[,1]) # need pdf names in index to match with document IDs from text data

