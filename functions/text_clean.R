meta2content <- function(meta) {

  date_title <- meta %>%
    html_text()

  out <- date_title %>%
    stringr::str_split(" - ") %>%
    unlist()

  date <- out[1] %>% lubridate::mdy()
  title <- out[2]
  
  df <- data.frame(pub_date = date,
                   pub_title = title)
  
  return(df)
}

link2text <- function(link) {

  
  message(link)
  
  #link <- "https://us2.campaign-archive.com/?u=c07af679cb8d889c8f33cb996&id=f4ba67b48e"
  text <- link %>%
    read_html() %>%
    html_nodes(xpath = "//table[@class='mcnTextBlock']") %>%
    html_text(trim = T)
  
  if (is_empty(text)) {
    
    text <- link %>%
      read_html() %>%
      html_nodes(xpath = "//p") %>%
      html_text(trim = T)

    # remove the non-main texts 
    text <- text[nchar(text) > 300]
    
    # remove the org explanation
    text <- text[!startsWith(text, "About Asian Americans Advancing")]
    
    # combine these all 
    text <- paste(text, collapse = ' ')
    
    # remove the line breaks  
    text <- gsub("[\r\n]", "", text)
    text <- gsub("[\r\t]", "", text)
    
    # remove any special characters 
    text <- removePunctuation(text)
    
    df <- data.frame(url = link,
                     msg = text)
    
  } else {
    
  # remove the non-main texts 
  text <- text[nchar(text) > 300]
  
  # remove the org explanation
  text <- text[!startsWith(text, "About Asian Americans Advancing")]
  
  # combine these all 
  text <- paste(text, collapse = ' ')
  
  # remove the line breaks  
  text <- gsub("[\r\n]", "", text)
  text <- gsub("[\r\t]", "", text)
  
  # remove any special characters 
  text <- removePunctuation(text)
  
  df <- data.frame(url = link,
                   msg = text)
  
  }
  
  return(df)
  
}