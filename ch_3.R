library(jsonlite)
library(rjson)
library(dplyr)

# read in offical Yelp review set (available at https://www.yelp.com/dataset_challenge)
yelp_raw_data <- stream_in(file("yelp_academic_dataset_review.json"),pagesize = 10000)

# take a look at the data
head(yelp_raw_data)
tail(yelp_raw_data)

# take a look at the sructure
str(yelp_raw_data)

# find NA's
sum(is.na(yelp_raw_data))

summary(yelp_raw_data)

# check class of yelp_raw_data
class(yelp_raw_data)

# a single data frame column (a vector)
head(yelp_raw_data$business_id)
class(yelp_raw_data$business_id)

# exploring the business_id column
yelp_raw_data %>% select(business_id) %>% 
        summarise(count = n(), 
                  uni = length(unique(business_id)), 
                  top = names(table(yelp_raw_data$business_id)[which.max(table(yelp_raw_data$business_id))]),
                  freq = max(table(yelp_raw_data$business_id))
        )

# exploring the review_id column
yelp_raw_data %>% select(review_id) %>% 
        summarise(count = n(), 
                  uni = length(unique(review_id)), 
                  top = names(table(yelp_raw_data$review_id)[which.max(table(yelp_raw_data$review_id))]),
                  freq = max(table(yelp_raw_data$review_id))
        )

# exploring the text column
yelp_raw_data %>% select(text) %>% 
        summarise(count = n(), 
                  uni = length(unique(text)), 
                  top = names(table(yelp_raw_data$text)[which.max(table(yelp_raw_data$text))]),
                  freq = max(table(yelp_raw_data$text))
        )


# filter reviewes with same text
index <- names(which.max(table(yelp_raw_data$text)))

duplicate_text <- yelp_raw_data %>% 
                        filter(text == index)

duplicate <- yelp_raw_data %>% group_by(text) %>% 
        summarise(num = n()) %>% 
        arrange(desc(num)) %>% 
        filter(num > 1)
duplicate_texts <- unique(duplicate$text)
duplicate_texts_logical <- yelp_raw_data$text %in% duplicate_texts
sum(duplicate_texts_logical)
filtered_data_frame <- yelp_raw_data[duplicate_texts_logical, ]
