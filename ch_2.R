library(tidytext)
library(dplyr)
library(stringr)
library(tidyr)
library(readr)
library(RCurl)

#### Tweet analysis ###
tweet <- "This Wednesday morn , are you early to rise? Then look East. The Crescent Moon joins Venus
& Saturn. Afloat in the dawn skies."

tweet_df <- tibble(
        id = 1:length(tweet),
        text = tweet
)


uni_gram <- tweet_df %>%  unnest_tokens(word, text) %>% count(word, sort = TRUE)
bi_gram <- tweet_df %>% unnest_tokens(word, text, token = "ngrams", n = 2) %>% count(word, sort = TRUE)
question_mark <- tibble(
        word = "?",
        n = length(unlist(str_extract_all(tweet, pattern = "\\?")))
)
full_stop <- tibble(
        word = ".",
        n = length(unlist(str_extract_all(tweet, pattern = "\\.")))
)
coma <- tibble(
        word = ",",
        n = length(unlist(str_extract_all(tweet, pattern = "\\,")))
)

tweet_tokenized <- bind_rows(
        uni_gram,
        bi_gram,
        question_mark,
        full_stop,
        coma
) %>% arrange(desc(n)) %>% 
        spread(key = word, value = n)

tweet_tokenized$relative_length <- nchar(tweet) / 30
tweet_tokenized$topic <- "astronomy"

#### World alcohol consumption data ###
drinks <- read_csv("https://raw.githubusercontent.com/sinanuozdemir/principles_of_data_science/master/data/chapter_2/drinks.csv")
drinks <- drinks %>% mutate_if(is.character, as.factor)
# countries
drinks %>% 
        summarise(count = n(), 
                  uni = length(unique(levels(continent))), 
                  top = names(table(drinks$continent)[1]),
                  freq = table(drinks$continent)[1]
                  )
# beer servings
summary(drinks$beer_servings)
drinks %>% summarise(mean = mean(beer_servings), 
                     min = min(beer_servings), 
                     max = max(beer_servings)
                     ) 

# happiness
happiness <- c(5, 4, 3, 4, 5, 3, 2, 5, 3, 2, 1, 4, 5, 3, 4, 4, 5, 4, 2, 1, 4, 5,
               4, 3, 2, 4, 4, 5, 4, 3, 2, 1)

happiness <- sort(happiness) 
mean(happiness)
median(happiness)

# temperature of the fridge
temps <- c(31, 32, 32, 31, 28, 29, 31, 38, 32, 31, 30, 29, 30, 31, 26)

mean(temps)
median(temps)

# measures of variation
temps_mean <- temps %>% mean()
temps_diff <- temps - temps_mean
temps_diff_squared <- temps_diff^2
avg_temps_diff_squared <- temps_diff_squared %>% mean()
standard_deviation <- avg_temps_diff_squared %>% sqrt()


# geometric mean for ratio levels  variables
num_items <- length(temps)
product <- 1
for (i in seq_along(temps)) {
        product = product * temps[i]
}
geometric_mean <- product ^ (1 / num_items)
geometric_mean
