##Get latest ONS HTML release------------------------------------------------

#Set up a function to neatly read the file in
read_release <- function(){
  #Read all HTML
  pg <- read_html("https://www.ons.gov.uk/peoplepopulationandcommunity/")
 
  ##Keep the text content only
  text_only <- html_text(html_nodes(pg,'p'))
  
  ##Search for term to identify sentence about period, sample, etc 
  text_only <- text_only[grepl("sample size|sampled", text_only)]

  ##Return as a list of sentences
  strsplit(text_only, "[.]")[[1]]
  
}

##Get latest ONS HTML release------------------------------------------------
#This produces a list
#Set up a function to neatly read the file in
read_dates <- function(){

  #Read all HTML
  pg <- read_html("https://www.ons.gov.uk/peoplepopulationandcommunity/")
  
  ##Keep the text content only
  text_only <- html_text(html_nodes(pg,'p'))
  
  ##Search for release date and next release, and bind into a list
  dates <- list(text_only[grepl("Release date", text_only)],
       text_only[grepl("Next release", text_only)])
  
  #Keep dates only
  lapply(dates, FUN = gsub, pattern = ".*: |\n", replacement = "")
  
}
