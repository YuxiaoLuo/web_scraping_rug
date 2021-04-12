## Scraping search results 
## school district rankings
## RUG meeting 4/9/2021

### We're scraping school district rankings and their names from search results on niche.com
### They're not in a table format- rather, there is a single entry per district with other information
### and not all districts that are on a page have a ranking


## Load in packages
library(tidyverse)
library(rvest)

# read in single web page so we can figure out which part of the page we need to scrape
schools_page <- read_html("https://www.niche.com/k12/search/best-school-districts/?page=0")

### Figure out how to isolate what we want so we can make a loop to retrieve this iteratively
### We want the header of the entry ("div.search-result-badge") to get the rank of the school
### We want the label of each entry's node ("aria-label") for the school name

# find the html nodes that we need. 
# This resulted from exploring the web page in Inspect Elements to isolate the html tags we're interested in
# We will use this later in a loop across search result pages
sch_list <- schools_page %>% 
  html_elements("div.search") %>% 
  html_elements("section.search-content") %>% 
  html_elements("div.search-results") %>% 
  html_elements("ol.search-results__list") %>% 
  html_elements("section.search-result") 

# function to get the school district rank information
# x is the list of nodes for each school district on the page ("sch_list" variable)
rank_search <- function(x) {
  # we need to go down one more level of structure. 
  card <- x %>% 
    html_element("div.card")
  # the result badge is the rank as a text string
  elem <- html_element(card, "div.search-result-badge")
  
  # convert to text
  rank <- html_text(elem)
  
  return(rank)
}


# function to get the name of the school district
# x is the list of nodes for each school district on the page ("sch_list" variable)
school_search <- function(x) {
  
  # get the school
  school <- x %>% 
    # this is the school attribute
    html_attr("aria-label")
  
  return(school)
}

# loop through the schools and perform each function.
# map_chr returns a character vector
ranks <- map_chr(sch_list, rank_search)
schools <- map_chr(sch_list, school_search)

# combine everything into a data frame. 
# Now we can throw this into a function to loop across results pages!
school_rank_df <- tibble(
  sch_rank = ranks,
  sch_name = schools
)

# put everything together to retrieve ranks and school names from the web page
# number = the page number of results to return
# the first page starts at 0
get_ranks_schools <- function(number) {
  # this is how we loop through pages. luckily the pages are sorted by number
  # You need to start at 0 to get the first page
  link <- paste0("https://www.niche.com/k12/search/best-school-districts/?page=", number)
  
  schools_page <- read_html(link)
  
  sch_list <- schools_page %>% 
    html_elements("div.search") %>% 
    html_elements("section.search-content") %>% 
    html_elements("div.search-results") %>% 
    html_elements("ol.search-results__list") %>% 
    html_elements("section.search-result") 
  
  ranks <- map_chr(sch_list, rank_search)
  schools <- map_chr(sch_list, school_search)
  
  # combine everything
  school_rank_df <- tibble(
    sch_rank = ranks,
    sch_name = schools
  )
  
  return(school_rank_df)
  
}


### Let's try it out!

# first five pages
page_numbers <- 0:5


# the website detects bots that try to scrape their data
# we need to implement a delay between calls, which we do with rate_delay
# need to play around with this so we don't get kicked off
# got booted off too many times when experimenting, so the delay likely needs to be long
rate <- rate_delay(60)
slow_get_ranks <- slowly(get_ranks_schools, rate = rate, quiet = FALSE)

all_schools_df <- map_df(0:4, slow_get_ranks)




