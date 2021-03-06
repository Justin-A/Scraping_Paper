web_scraping <- function(working_directory, name, number){
  
  ##########
  ## CVPR ##
  ##########
  
  if(name == "CVPR"){
    setwd(working_directory)
    if(!require("RCurl")) install.packages("RCurl") ; library(RCurl)
    if(!require("XML")) install.packages("XML") ; library(XML)
    
    # Setting URL
    url <- "http://openaccess.thecvf.com/CVPR2017.py"
    html <- getURL(url)
    html.parsed <- htmlParse(html)
    
    # Paper Name
    CVPR_Paper_Name <- xpathSApply(doc = html.parsed, path = "//dt/a", fun = xmlValue)
    CVPR_Paper_Name <- gsub(pattern = "[[:punct:]]", replacement = " ", CVPR_Paper_Name)
    save(CVPR_Paper_Name, file = "CVPR_Paper_Name.RData")
    print("######################################")
    print("### Scrapped All CVPR Paper Name: ####")
    print("######################################")
    print(CVPR_Paper_Name[1:10])
    
    # Writer
    CVPR_Writer <- xpathSApply(doc = html.parsed, path = "//div/dl/dd", fun = xmlValue)
    CVPR_Writer <- CVPR_Writer[seq(1, length(CVPR_Writer), 2)]
    CVPR_Writer <- gsub(pattern = "\n", replacement = "", x = CVPR_Writer)
    CVPR_Writer <- strsplit(x = CVPR_Writer, split = ",")
    save(CVPR_Writer, file = "CVPR_Writer.RData")
    print("######################################")
    print("########## CVPR Writer is: ###########")
    print("######################################")
    print(CVPR_Writer[1:10])
    
    # Paper Contents
    CVPR_Paper <- xpathSApply(doc = html.parsed, path = "//dd/a[1]", fun = xmlAttrs, "href")
    CVPR_URL <- paste0("http://openaccess.thecvf.com/", CVPR_Paper)
    
    # Download PDF
    print("######################################")
    print(paste0("##### ", "Start ", number," Paper(s) download", " ####"))
    print("######################################")
    setwd("../CVPR")
    if(number == "all"){
      number = length(CVPR_Paper_Name)}
    for (i in (1:number)){
      download.file(url = CVPR_URL[i], destfile = paste0(i, "_", CVPR_Paper_Name[i], "_", "CVPR_Paper", ".pdf"))}
    
    # Read PDF
    if(!require("pdftools")) install.packages("pdftools") ; library(pdftools)
    CVPR_Paper_Contents = NULL
    for (i in c(1:length(dir()))){
      pdf_file = pdf_text(paste0(i, "_", CVPR_Paper_Name[i], "_", "CVPR_Paper", ".pdf"))
      pdf_file2 = unlist(strsplit(pdf_file, "\n"))
      CVPR_Paper_Contents = append(CVPR_Paper_Contents, pdf_file2)}
    
    # Remove Digit, Punctuation, Blank and integrate Upper & Lower case
    CVPR_Paper_Contents <- gsub(pattern = "[[:digit:]]", replacement = "", CVPR_Paper_Contents)
    CVPR_Paper_Contents <- gsub(pattern = "[[:punct:]]", replacement = "", CVPR_Paper_Contents)
    CVPR_Paper_Contents <- gsub(pattern = "  ", replacement = "", CVPR_Paper_Contents)
    if(!require("stringr")) install.packages("stringr") ; library(stringr)
    CVPR_Paper_Contents <- str_trim(string = CVPR_Paper_Contents, side = "both")
    CVPR_Paper_Contents <- tolower(CVPR_Paper_Contents)
    
    # Concat
    for (i in (1:length(CVPR_Paper_Contents))){
      temp = paste(CVPR_Paper_Contents[i], CVPR_Paper_Contents[i + 1])
      CVPR_Paper_Contents[i+1] = temp}
    
    # Remove Stopwords
    if(!require("tm")) install.packages("tm") ; library(tm)
    corpus <- VCorpus(VectorSource(temp)) # Corpus in memory
    CVPR_Paper_Contents <- tm_map(corpus, removeWords, stopwords(kind = "en")) # remove stopwords [type = "English"]
    CVPR_Paper_Contents <- as.character(CVPR_Paper_Contents[[1]])
    setwd("../Project")
    save(CVPR_Paper_Contents, file = "CVPR_Paper_Contents.RData")
    
    print("######################################")
    print("Word Frequency before remove stopwords")
    print("######################################")
    CVPR_Word_Before <- sort(table(strsplit(x = temp, split = " ")), decreasing = TRUE)
    print(CVPR_Word_Before[1:20])
    save(CVPR_Word_Before, file = "CVPR_Word_Before.RData")
    print("######################################")
    print("Word Frequency after remove stopwords")
    print("######################################")
    CVPR_Word_After <- sort(table(strsplit(CVPR_Paper_Contents, split = " ")), decreasing = TRUE)
    print(CVPR_Word_After[1:20])
    save(CVPR_Word_After, file = "CVPR_Word_After.RData")
    print("###########################################")
    print("Draw Wordcloud in Plots (Removed stopwords)")
    print("###########################################")
    if(!require("wordcloud")) install.packages("wordcloud") ; library(wordcloud)
    wordcloud(CVPR_Paper_Contents, min.freq = 40, random.order = FALSE, random.color = TRUE)
  }
  
  ##########
  ## NIPS ##
  ##########
  
  if(name == "NIPS"){
    setwd(working_directory)
    if(!require("RCurl")) install.packages("RCurl") ; library(RCurl)
    if(!require("XML")) install.packages("XML") ; library(XML)
    
    # Setting URL
    url <- "http://papers.nips.cc/book/advances-in-neural-information-processing-systems-30-2017"
    html <- getURL(url)
    html.parsed <- htmlParse(html)
    
    # Paper Name
    NIPS_Paper_Name <- xpathSApply(doc = html.parsed, path = "//div/ul/li/a[1]", fun = xmlValue)
    NIPS_Paper_Name <- gsub(pattern = "[[:punct:]]", replacement = " ", NIPS_Paper_Name)
    save(NIPS_Paper_Name, file = "NIPS_Paper_Name.RData")
    print("######################################")
    print("### Scrapped All NIPS Paper Name: ####")
    print("######################################")
    print(NIPS_Paper_Name[1:10])
    
    # Writer
    NIPS_Writer <- xpathSApply(doc = html.parsed, path = "//div/ul/li", fun = xmlValue)
    NIPS_Writer <- substr(x = NIPS_Writer, start = nchar(NIPS_Paper_Name) + 2, stop = nchar(NIPS_Writer))
    NIPS_Writer <- strsplit(x = NIPS_Writer, split = ", ")
    save(NIPS_Writer, file = "NIPS_Writer.RData")
    print("######################################")
    print("########## NIPS Writer is: ###########")
    print("######################################")
    print(NIPS_Writer[1:10])
    
    # Paper Contents
    NIPS_Paper <- xpathSApply(doc = html.parsed, path = "//div/ul/li/a[1]", fun = xmlAttrs, "href")
    NIPS_URL <- paste0("http://papers.nips.cc/", NIPS_Paper, ".pdf")
    
    # Download PDF
    print("######################################")
    print(paste0("##### ", "Start ", number," Paper(s) download", " ####"))
    print("######################################")
    setwd("../NIPS")
    if(number == "all"){
      number = length(NIPS_Paper_Name)}
    for (i in (1:number)){
      download.file(url = NIPS_URL[i], destfile = paste0(i, "_", NIPS_Paper_Name[i], "_", "NIPS_Paper", ".pdf"))}
    
    # Read PDF
    if(!require("pdftools")) install.packages("pdftools") ; library(pdftools)
    NIPS_Paper_Contents = NULL
    for (i in c(1:length(dir()))){
      pdf_file = pdf_text(paste0(i, "_", NIPS_Paper_Name[i], "_", "NIPS_Paper", ".pdf"))
      pdf_file2 = unlist(strsplit(pdf_file, "\n"))
      NIPS_Paper_Contents = append(NIPS_Paper_Contents, pdf_file2)}
    
    # Remove Digit, Punctuation, Blank and integrate Upper & Lower case
    NIPS_Paper_Contents <- gsub(pattern = "[[:digit:]]", replacement = "", NIPS_Paper_Contents)
    NIPS_Paper_Contents <- gsub(pattern = "[[:punct:]]", replacement = "", NIPS_Paper_Contents)
    NIPS_Paper_Contents <- gsub(pattern = "  ", replacement = "", NIPS_Paper_Contents)
    if(!require("stringr")) install.packages("stringr") ; library(stringr)
    NIPS_Paper_Contents <- str_trim(string = NIPS_Paper_Contents, side = "both")
    NIPS_Paper_Contents <- tolower(NIPS_Paper_Contents)
    
    # Concat
    for (i in (1:length(NIPS_Paper_Contents))){
      temp = paste(NIPS_Paper_Contents[i], NIPS_Paper_Contents[i + 1])
      NIPS_Paper_Contents[i + 1] = temp}
    
    # Remove Stopwords
    if(!require("tm")) install.packages("tm") ; library(tm)
    corpus <- VCorpus(VectorSource(temp)) # Corpus in memory
    NIPS_Paper_Contents <- tm_map(corpus, removeWords, stopwords(kind = "en")) # remove stopwords [type = "English"]
    NIPS_Paper_Contents <- as.character(NIPS_Paper_Contents[[1]])
    setwd("../Project")
    save(NIPS_Paper_Contents, file = "NIPS_Paper_Contents.RData")
    
    print("######################################")
    print("Word Frequency before remove stopwords")
    print("######################################")
    NIPS_Word_Before <- sort(table(strsplit(x = temp, split = " ")), decreasing = TRUE)
    print(NIPS_Word_Before[1:20])
    save(NIPS_Word_Before, file = "NIPS_Word_Before.RData")
    print("######################################")
    print("Word Frequency after remove stopwords")
    print("######################################")
    NIPS_Word_After <- sort(table(strsplit(NIPS_Paper_Contents, split = " ")), decreasing = TRUE)
    print(NIPS_Word_After[1:20])
    save(NIPS_Word_After, file = "NIPS_Word_After.RData")
    print("###########################################")
    print("Draw Wordcloud in Plots (Removed stopwords)")
    print("###########################################")
    if(!require("wordcloud")) install.packages("wordcloud") ; library(wordcloud)
    wordcloud(NIPS_Paper_Contents, min.freq = 40, random.order = FALSE, random.color = TRUE)
  }
  
  ##########
  ## ICML ##
  ##########
  
  if(name == "ICML"){
    setwd(working_directory)
    if(!require("RCurl")) install.packages("RCurl") ; library(RCurl)
    if(!require("XML")) install.packages("XML") ; library(XML)
    
    # Setting URL
    url <- "http://proceedings.mlr.press/v70/"
    html <- getURL(url)
    html.parsed <- htmlParse(html)
    
    # Paper Name
    ICML_Paper_Name <- xpathSApply(doc = html.parsed, path = "//div/div/div/p[1]", fun = xmlValue)
    ICML_Paper_Name <- ICML_Paper_Name[-1]
    ICML_Paper_Name <- gsub(pattern = "[[:punct:]]", replacement = " ", ICML_Paper_Name)
    save(ICML_Paper_Name, file = "ICML_Paper_Name.RData")
    print("######################################")
    print("### Scrapped All ICML Paper Name: ####")
    print("######################################")
    print(ICML_Paper_Name[1:10])
    
    # Writer
    ICML_Writer <- xpathSApply(doc = html.parsed, path = "//div/div/div/p/span[1]", fun = xmlValue)
    ICML_Writer <- gsub(pattern = "\n", replacement = "", x = ICML_Writer)
    ICML_Writer <- gsub(pattern = "  ", replacement = "", x = ICML_Writer)
    ICML_Writer <- strsplit(x = ICML_Writer, split = ",             ")
    save(ICML_Writer, file = "ICML_Writer.RData")
    print("######################################")
    print("########## ICML Writer is: ###########")
    print("######################################")
    print(ICML_Writer[1:10])
    
    # Paper Contents
    ICML_Paper <- xpathSApply(doc = html.parsed, path = "//div/div/div/p[3]/a[2]", fun = xmlAttrs, "href")
    ICML_URL <- NULL
    for (i in (1:(length(ICML_Paper) / 3))){
      ICML_URL[i] <- ICML_Paper[3 * i - 2]}
    
    # Download PDF
    print("######################################")
    print(paste0("##### ", "Start ", number," Paper(s) download", " ####"))
    print("######################################")
    setwd("../ICML")
    if(number == "all"){
      number = length(ICML_Paper_Name)}
    for (i in (1:number)){
      download.file(url = ICML_URL[i], destfile = paste0(i, "_", ICML_Paper_Name[i], "_", "ICML_Paper", ".pdf"))}
    
    # Read PDF
    if(!require("pdftools")) install.packages("pdftools") ; library(pdftools)
    ICML_Paper_Contents = NULL
    for (i in c(1:length(dir()))){
      pdf_file = pdf_text(paste0(i, "_", ICML_Paper_Name[i], "_", "ICML_Paper", ".pdf"))
      pdf_file2 = unlist(strsplit(pdf_file, "\n"))
      ICML_Paper_Contents = append(ICML_Paper_Contents, pdf_file2)}
    
    # Remove Digit, Punctuation, Blank and integrate Upper & Lower case
    ICML_Paper_Contents <- gsub(pattern = "[[:digit:]]", replacement = "", ICML_Paper_Contents)
    ICML_Paper_Contents <- gsub(pattern = "[[:punct:]]", replacement = "", ICML_Paper_Contents)
    ICML_Paper_Contents <- gsub(pattern = "  ", replacement = "", ICML_Paper_Contents)
    if(!require("stringr")) install.packages("stringr") ; library(stringr)
    ICML_Paper_Contents <- str_trim(string = ICML_Paper_Contents, side = "both")
    ICML_Paper_Contents <- tolower(ICML_Paper_Contents)
    
    # Concat
    for (i in (1:length(ICML_Paper_Contents))){
      temp = paste(ICML_Paper_Contents[i], ICML_Paper_Contents[i + 1])
      ICML_Paper_Contents[i + 1] = temp}
    
    # Remove Stopwords
    if(!require("tm")) install.packages("tm") ; library(tm)
    corpus <- VCorpus(VectorSource(temp)) # Corpus in memory
    ICML_Paper_Contents <- tm_map(corpus, removeWords, stopwords(kind = "en")) # remove stopwords [type = "English"]
    ICML_Paper_Contents <- as.character(ICML_Paper_Contents[[1]])
    setwd("../Project")
    save(ICML_Paper_Contents, file = "ICML_Paper_Contents.RData")
    
    print("######################################")
    print("Word Frequency before remove stopwords")
    print("######################################")
    ICML_Word_Before <- sort(table(strsplit(x = temp, split = " ")), decreasing = TRUE)
    print(ICML_Word_Before[1:20])
    save(ICML_Word_Before, file = "ICML_Word_Before.RData")
    print("######################################")
    print("Word Frequency after remove stopwords")
    print("######################################")
    ICML_Word_After <- sort(table(strsplit(ICML_Paper_Contents, split = " ")), decreasing = TRUE)
    print(ICML_Word_After[1:20])
    save(ICML_Word_After, file = "ICML_Word_After.RData")
    print("###########################################")
    print("Draw Wordcloud in Plots (Removed stopwords)")
    print("###########################################")
    if(!require("wordcloud")) install.packages("wordcloud") ; library(wordcloud)
    wordcloud(ICML_Paper_Contents, min.freq = 40, random.order = FALSE, random.color = TRUE)
  }
}

wd <- "~/Desktop/Sample/Project" ; setwd(wd)

web_scraping(working_directory = wd, name = "CVPR", number = 5)
web_scraping(working_directory = wd, name = "NIPS", number = 5)
web_scraping(working_directory = wd, name = "ICML", number = 5)

rm(list=ls())
wd <- "~/Desktop/Justin/2018-2/Data_Analytics/Project/" ; setwd(wd)

load("CVPR_Paper_Contents.RData") ; CVPR_Paper_Contents
load("CVPR_Paper_Name.RData") ; CVPR_Paper_Name
load("CVPR_Writer.RData") ; CVPR_Writer
load("CVPR_Word_Before.RData") ; CVPR_Word_Before
load("CVPR_Word_After.RData") ; CVPR_Word_After

load("NIPS_Paper_Contents.RData") ; NIPS_Paper_Contents
load("NIPS_Paper_Name.RData") ; NIPS_Paper_Name
load("NIPS_Writer.RData") ; NIPS_Writer
load("NIPS_Word_Before.RData") ; NIPS_Word_Before
load("NIPS_Word_After.RData") ; NIPS_Word_After

load("ICML_Paper_Contents.RData") ; ICML_Paper_Contents
load("ICML_Paper_Name.RData") ; ICML_Paper_Name
load("ICML_Writer.RData") ; ICML_Writer
load("ICML_Word_Before.RData") ; ICML_Word_Before
load("ICML_Word_After.RData") ; ICML_Word_After

########################################################################################################
############################################# Visualization ############################################
########################################################################################################

###########################################
# Paper Name - Word Frequency & WordCloud #
###########################################
Name_Frequency <- function(x){
  data <- gsub(pattern = "[[:digit:]]", replacement = "", x = x)
  data <- gsub(pattern = "[[:punct:]]", replacement = "", x = data)
  data <- tolower(data)
  for (i in (1:length(data))){
    temp = paste(data[i], data[i + 1])
    data[i+1] = temp}
  if(!require("tm")) install.packages("tm") ; library(tm)
  corpus <- VCorpus(VectorSource(temp)) # Corpus in memory
  result <- tm_map(corpus, removeWords, stopwords(kind = "en")) # remove stopwords [type = "English"]
  result <- as.character(result[[1]])
  return(result)
}

# CVPR
result <- Name_Frequency(CVPR_Paper_Name)
sort(table(strsplit(x = result, split = " ")), decreasing = TRUE)[1:20]
if(!require("wordcloud2")) install.packages("wordcloud2") ; library(wordcloud2)
letterCloud(table(strsplit(x = result, split = " ")), word = "CVPR", size = 20, color = 'random-light', backgroundColor = 'White')

# NIPS
result <- Name_Frequency(NIPS_Paper_Name)
sort(table(strsplit(x = result, split = " ")), decreasing = TRUE)[1:20]
letterCloud(table(strsplit(x = result, split = " ")), word = "NIPS", size = 20, color = 'random-light', backgroundColor = 'White')

# ICML
result <- Name_Frequency(ICML_Paper_Name)
sort(table(strsplit(x = result, split = " ")), decreasing = TRUE)[1:20]
letterCloud(table(strsplit(x = result, split = " ")), word = "ICML", size = 20, color = 'random-light', backgroundColor = 'White')

# ALL
all <- paste(Name_Frequency(CVPR_Paper_Name), Name_Frequency(NIPS_Paper_Name), Name_Frequency(ICML_Paper_Name))
sort(table(strsplit(x = all, split = " ")), decreasing = TRUE)[1:20]
letterCloud(table(strsplit(x = all, split = " ")), word = "PAPER", size = 20, color = 'random-light', backgroundColor = 'White')

####################
# Writer Frequency #
####################

# CVPR
colors<- c("red", "yellow", "green", "violet", 
           "orange", "blue", "pink", "cyan", "darkblue", "purple")
data <- data.frame(sort(table(unlist(CVPR_Writer)), decreasing = TRUE)[1:10]) ; data
barplot(data$Freq, names.arg = data$Var1, xlab = "Writer", ylab = "Frequency", main = "Top 10 Writer in CVPR", border = "black", col = colors)

# NIPS
data <- data.frame(sort(table(unlist(NIPS_Writer)), decreasing = TRUE)[1:10]) ; data
barplot(data$Freq, names.arg = data$Var1, xlab = "Writer", ylab = "Frequency", main = "Top 10 Writer in NIPS", border = "black", col = colors)

# ICML
data <- data.frame(sort(table(unlist(strsplit(unlist(ICML_Writer), split = ", "))), decreasing = TRUE)[1:10]) ; data
barplot(data$Freq, names.arg = data$Var1, xlab = "Writer", ylab = "Frequency", main = "Top 10 Writer in ICML", border = "black", col = colors)

# ALL
all <- unlist(CVPR_Writer, NIPS_Writer, strsplit(unlist(ICML_Writer), split = ", "))
data <- data.frame(sort(table(all), decreasing = TRUE)[1:10]) ; data
barplot(data$Freq, names.arg = data$all, xlab = "Writer", ylab = "Frequency", main = "Top 10 Writer in 2017 Conference", border = "black", col = colors)

###############################################
# Paper Contents - Word Frequency & WordCloud #
###############################################
# CVPR
CVPR_Word_After[1:20]
letterCloud(CVPR_Word_After, word = "CVPR", size = 20, color = 'random-light', backgroundColor = 'black')

# NIPS
NIPS_Word_After[1:20]
letterCloud(NIPS_Word_After, word = "NIPS", size = 20, color = 'random-light', backgroundColor = 'black')

# ICML
ICML_Word_After[1:20]
letterCloud(ICML_Word_After, word = "ICML", size = 20, color = 'random-light', backgroundColor = 'black')

# ALL
all <- paste(CVPR_Paper_Contents, NIPS_Paper_Contents, ICML_Paper_Contents)
all <- Name_Frequency(all)
all <- sort(table(strsplit(x = all, split = " ")), decreasing = TRUE) ; all[1:20]
letterCloud(all, word = "Paper", size = 20, color = 'random-light', backgroundColor = 'black')

##################################################################################################
# Word Relationship
if(!require("statnet.common")) install.packages("statnet.common") ; library(statnet.common)
if(!require("qgraph")) install.packages("qgraph") ; library(qgraph)

# CVPR
corpus <- Corpus(VectorSource(CVPR_Paper_Contents))
tdm <- TermDocumentMatrix(corpus)
tdm.matrix <- as.matrix(tdm)
word.count <- rowSums(tdm.matrix)
word.order <- order(word.count, decreasing=TRUE)
freq.words <- tdm.matrix[word.order[1:20], ]
co.matrix <- freq.words %*% t(freq.words)
freq.words
qgraph(co.matrix, 
       layout = 'spring', 
       diag = FALSE, 
       vsize = 7, 
       label.prop = 0.5, 
       edge.labels = TRUE, 
       edge.label.cex = 0.3,
       theme = 'classic')

# NIPS
corpus <- Corpus(VectorSource(NIPS_Paper_Contents))
tdm <- TermDocumentMatrix(corpus)
tdm.matrix <- as.matrix(tdm)
word.count <- rowSums(tdm.matrix)
word.order <- order(word.count, decreasing=TRUE)
freq.words <- tdm.matrix[word.order[1:20], ]
co.matrix <- freq.words %*% t(freq.words)
freq.words
qgraph(co.matrix, 
       layout = 'spring', 
       diag = FALSE, 
       vsize = 7, 
       label.prop = 0.5, 
       edge.labels = TRUE, 
       edge.label.cex = 0.3,
       theme = 'Hollywood')

# ICML
corpus <- Corpus(VectorSource(ICML_Paper_Contents))
tdm <- TermDocumentMatrix(corpus)
tdm.matrix <- as.matrix(tdm)
word.count <- rowSums(tdm.matrix)
word.order <- order(word.count, decreasing=TRUE)
freq.words <- tdm.matrix[word.order[1:20], ]
co.matrix <- freq.words %*% t(freq.words)
freq.words
qgraph(co.matrix, 
       layout = 'spring', 
       diag = FALSE, 
       vsize = 7, 
       label.prop = 0.5, 
       edge.labels = TRUE, 
       edge.label.cex = 0.3,
       theme = 'gimme')

# ALL 
Contents <- paste(CVPR_Paper_Contents, NIPS_Paper_Contents, ICML_Paper_Contents)
corpus <- Corpus(VectorSource(Contents))
tdm <- TermDocumentMatrix(corpus)
tdm.matrix <- as.matrix(tdm)
word.count <- rowSums(tdm.matrix)
word.order <- order(word.count, decreasing=TRUE)
freq.words <- tdm.matrix[word.order[1:20], ]
co.matrix <- freq.words %*% t(freq.words)
freq.words
qgraph(co.matrix, 
       layout = 'spring', 
       diag = FALSE, 
       vsize = 7, 
       label.prop = 0.5, 
       edge.labels = TRUE, 
       edge.label.cex = 0.3,
       theme = 'TeamFortress')
