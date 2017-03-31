library(tidytext)
library(dplyr)
library(stringr)
library(tidyr)

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
