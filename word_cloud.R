# install.packages("gutenbergr")
# install.packages("wordcloud2")
library(gutenbergr)
library(tidyverse)
library(tidytext)
library(wordcloud2)

# get Edgar Allen Poe texts
poe_works <- gutenberg_works(str_detect(author, "Poe"))

poe_text <- gutenberg_download(25525)

poe_text_strip <- poe_text[607:nrow(poe_text),]

# tidy the data
poe_tidy <- poe_text_strip %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stop_words, by = "word")

# count words
poe_count <- poe_tidy %>% 
  count(word, sort = TRUE)

# word cloud
wordcloud2(poe_count, color = "random-dark", shape = "pentagon", size = 0.6)


# bar plot
poe_count %>% 
  slice_head(n = 20) %>% 
  mutate(word = fct_reorder(word, n)) %>% 
  ggplot(aes(x = word, y = n)) +
  geom_col(fill = "black") +
  coord_flip() +
  labs(y = "Frequency",
       title = "Top 20 most common words in the works of Edgar Allen Poe") +
  theme_bw() +
  theme(axis.title.y = element_blank())

