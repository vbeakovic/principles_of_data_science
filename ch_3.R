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

