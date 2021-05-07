# install.packages("tidyverse")
library(tidyverse)
library(tidytext)

# lyrics
candle_lyrics <- "[Verse 1]\nInnocence is a light beam, you're doing your thing\nWith your arm out your window up Highway 9\nWhen it's too much to handle, burn me a candle\nIf you don't have a candle, let me burn on your mind\n[Verse 2]\nThe song of the sirens caught up with me downwind\nMy nose started bleeding by the second note\nHeaven is a motel with a telephone seashell\nWell, check-out's at eleven, and don't ask for more time\n[Chorus]\nWell, did your eyes change? I remember them blue\nOr were they always hazel?\nStill the same face with a line or two\nThe same love I always knew\n[Verse 3]\nI try not to call, but I think I'm being followed\nIt's been about an hour or so\nI hate for you to hear me scared, otherwise, I'm well\nI guess you're still the first place I go\n[Chorus]\nDid your eyes change? I remember them blue\nOr were they always hazel?\nStill the same face with a line or two\nThe same love I always knew\n[Instrumental Break]\n[Chorus]\nDid your eyes change? I remember them blue\nOr were they always hazel?\nStill the same face with a line or two\nThe same love I always knew"


# split by lines
candle_lyrics %>% 
  str_split("\\n") %>% 
  unlist() %>% 
  str_remove("\\[\\D+\\d\\]") %>% 
  str_remove("\\[\\D+") %>% 
  na_if("") %>% 
  na.omit()

# alternative, more succinct
candle_df <- candle_lyrics %>%
  str_split("\n") %>%
  unlist() %>%
  str_remove("\\[.*\\]") %>% 
  stringi::stri_remove_empty() %>% 
  enframe(name = "line_number", value = "line")

# get words
candle_tidy_df <- candle_df %>% 
  unnest_tokens(output = word, 
                input = line, 
                token = "words") %>% 
  anti_join(stop_words, by = "word")


# plot word frequencies
candle_tidy_df %>% 
  count(word, sort = TRUE) %>% 
  mutate(word = reorder(word, n)) %>% 
  filter(n > 1) %>% 
  ggplot(aes(x = n, y = word)) +
  geom_col() +
  labs(y = NULL)



