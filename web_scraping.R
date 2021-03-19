#### web scraping day 1

## load packages
library(tidyverse)
library(rvest)

### Lyrics, unstructured text

# load in page
genius_html <- read_html("https://genius.com/Buck-meek-candle-lyrics") 


# specific, not generalizable way to obtain text
lyrics_tag <- genius_html %>% 
  html_elements("p")

lyrics_text <- lyrics_tag[[1]] %>% 
  html_text()

# generalizable way
div_tag <- genius_html %>% 
  html_elements("div.lyrics")

div_paragraph <- div_tag %>% 
  html_element("p")

div_text <- div_paragraph %>% 
  html_text()

# combine everything
genius_lyrics <- genius_html %>% 
  html_elements("div.lyrics") %>% 
  html_element("p") %>% 
  html_text() 

genius_lyrics

### tables
imdb_html <- read_html("https://www.imdb.com/chart/tvmeter/?ref_=nv_tvv_mptv")

imdb_tag <- imdb_html %>% 
  html_element("div.lister")

imdb_table <- imdb_tag %>% 
  html_table()

# all in one go
imdb_html %>% 
  html_element("div.lister") %>% 
  html_table()








