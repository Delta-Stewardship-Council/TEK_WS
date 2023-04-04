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

index_id <- index[,c(1:2)] # only has 90, was expecting 98

# Armstrong 2018 is missing (from our pdfs)
# Fernandez is 2017 in one and 2018 in the other
# there are two Gomez-Baggethun et al. 2013 with different Reading_IDs (in index)
# Hoagland is 2018 in one and 2017 in the other
# Parsons et al. 2020 in one and 2021 in the other
# Reading_IDs (missing from index) for 2004_Moller_et_Al co-management.pdf, 2006 Adelzadeh Thesis Co-management.pdf, 2008_Adeel et al_review traditional water management drylands.pdf, 2010_Donohue_et_al co-management.pdf, 2010_Lertzman.pdf, 2011_Stumpff co-management.pdf, 2018_Middleton-Manning_et_al.pdf, 2020_EmanuelandWilkens co-management.pdf, 2022_Ramos.pdf

Reading_ID <- c(11,15,49,22,84,23,3,4,9,16,45,47,5,6,58,12,65,NA,24,10,NA,25,62,17,NA,69,71,26,52,18,NA,NA,1,NA,27,41,31,72,7,63,20,46,40,74,78,73,75,8,79,59,19,42,76,80,85,66,28, 86,81,33,34,29,57,53,77,64,67,NA,48,30,68,37,55,90,2,88,87,NA,13,82,43,60,83,35,36,89,70,56,32,38,54,NA,39,61,50,44,51,21)

new_IDS <- data.frame(doc_id, Reading_ID)

# checks
check_IDs <- merge(index_id, new_IDS, by = "Reading_ID", all = TRUE)
