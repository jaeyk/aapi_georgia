################ AAAJ ################

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

################ AAAF ################

parse_pdf <- function(pdf_num) {
  
  # assign file name
  # pdf_num <- 12
  file_name <- pdf_files[pdf_num]
  
  message("file name:", file_name)
  
  # read pdf file 
  test <- pdf_text(pdf_files[pdf_num])
  
  # turn the pdf file into split lines 
  line_text <- test %>%
    str_split("\n") %>%
    unlist() %>%
    str_trim() 
  
  # discard the empty elements 
  line_text <- line_text[line_text != ""]
  
  if (str_detect(line_text, "Subject ") %>% sum() == 1) {
  
  # extract the meta data 
  subject <- line_text[str_starts(line_text, "Subject ")]
  date <- line_text[str_starts(line_text, "Date ")]
  
  # extract the text
  text <- line_text[which(str_starts(line_text, "Date "))+1:length(line_text)]
  
  # discard the empty elements
  text <- text[!is.na(text)]
  
  # paste the character elements 
  text <- paste(text, collapse = " ")
  
  # file type = eml
  message("eml file")
  
  # put them together as a df object
  df <- data.frame(subject = subject, 
                   date = date, 
                   text = text)
  
  }
  
  else {
    
    # extract the meta data 
    subject <- line_text[str_starts(line_text, "AAAF Monthly ")]
    date <- line_text[str_starts(line_text, "Team AAAF ")]
    
    # extract the text
    text <- line_text[which(str_starts(line_text, "Date "))+1:length(line_text)]
    
    # discard the empty elements
    text <- text[!is.na(text)]
    
    # paste the character elements 
    text <- paste(text, collapse = " ") 
    
    # file type = pdf 
    message("pdf file")
    
    # put them together as a df object
    df <- data.frame(subject = subject, 
                     date = date, 
                     text = text)
    
    }
  
  # message the process
  message("parsing pdf file number ", pdf_num)
  
  # output
  return(df)
}

############### Misc ###############

cal_dist <- function(doc_num) {

  if (dupes$subject[doc_num] == dupes$subject[doc_num + 1]) {
    
    dist <- parse_number(as.character(dupes$date[doc_num] - dupes$date[doc_num + 1])) 
    
  } else { 
    
    dist <- NA 
    
  }
  
  out <- data.frame(doc_num = doc_num,
                    dist = abs(dist),
                    date = dupes$date[doc_num],
                    source = dupes$source[doc_num])
  
  return(out)

}

getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

############### Text analysis ###############

clean_text <- function(full_text) {
  
  vec <- tolower(full_text) %>%
    # Remove all non-alpha characters
    # gsub("[^[:alpha:]]", " ", .) %>%
    replace_contraction() %>%
    replace_number() %>%
    replace_emoticon() %>%
    replace_white() %>%
    replace_hash() %>%
    replace_incomplete() %>%
    #hunspell::hunspell_suggest() %>%
    #filter_row() %>%
    add_missing_endmark() %>%
    add_comma_space() %>%
    replace_non_ascii() %>%
    # Remove all non-alpha characters
    gsub("[^[:alpha:]]", " ", .) %>%
    removePunctuation() %>%
    # remove 1-2 letter words
    str_replace_all("\\b\\w{1,2}\\b", "") %>%
    # remove excess white space
    str_replace_all("^ +| +$|( ) +", "\\1")
    
  vec <- textstem::lemmatize_strings(vec)
  
  vec <- tm::removeWords(vec, words = c(stopwords::stopwords(source = "snowball")))
  
  vec <- textclean::replace_white(vec)
  
  #vec <- textclean::replace_number(vec)
  
  vec <- str_trim(vec)
  
  return(vec)
  
}

# Time index  

date2index <- function(df){
  
  # Convert date into integer 
  
  index <- as.integer(gsub("-", "", docvars(df)$date))
  
  # Replace elements in the numeric vector with the new list of the character vector 
  
  char_index <- as.character(index)
  
  # Condition 
  given <- sort(unique(index)) %>% as.character()
  
  # For loop 
  for (i in seq(1:length(unique(index)))){
    
    char_index[char_index == given[i]] = paste(i)
    
    message(paste("replaced", i))
    
  }
  
  # Check 
  # unique(char_index) %>% as.numeric() %>% sort()
  
  docvars(df, "index") <- char_index %>% as.integer()
  
  docvars(df) <- docvars(df) %>%
    arrange(index)
  
  docvars(df)
}

visualize_diag <- function(sparse_matrix, many_models){
  
  k_result <- many_models %>%
    mutate(exclusivity = purrr::map(topic_model, exclusivity),
           semantic_coherence = purrr::map(topic_model, semanticCoherence, sparse_matrix))
  
  
  k_result %>%
    transmute(K,
              "Exclusivity" = map_dbl(exclusivity, mean),
              "Semantic coherence" = map_dbl(semantic_coherence, mean)) %>%
    pivot_longer(cols = c("Exclusivity", "Semantic coherence"),
                 names_to = "Metric",
                 values_to = "Value") %>%
    ggplot(aes(K, Value, color = Metric)) +
    geom_line(size = 1.5, show.legend = FALSE) +
    labs(x = "K (number of topics)",
         y = NULL) +   
    facet_wrap(~Metric, scales = "free_y") +
    theme_bw()
  
}
