# add pdf meta data to text data

# library
library(readxl)

# load data
text_data <- read.csv("Data/clean_text_data.csv")
head(text_data)
str(text_data)

Reading_group_schedule <- read_excel("Data/00_Final lit review/00_Reading group schedule.xlsx", sheet = "Index")
View(Reading_group_schedule)

doc_id <- unique(text_data[,1]) # need pdfs in Reading_group_schedule to match with document IDs from text data

