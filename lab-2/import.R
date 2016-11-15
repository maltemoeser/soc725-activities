# This import script allows you to download and import any version 2 Google ngram data file into R
require(data.table)
require(bit64)

# Construct the download URL for the ngram datasets
get_ngram_command <- function(n, ngram, lang) {
  paste("curl http://storage.googleapis.com/books/ngrams/books/googlebooks-", lang, "-all-", n, "gram-20120701-", ngram, ".gz | gunzip", sep = "")
}

# Download ngram data and import it into a data.table
get_ngram_data <- function(n, ngram, lang) {
  d <- fread(get_ngram_command(n, ngram, lang), sep = "\t", colClasses = c("character", "numeric", "numeric", "numeric"))
  setnames(d, c("ngram", "year", "match_count", "volume_count"))
  setkeyv(d, c("ngram", "year"))
  d
}

# Construct the download URL for the totals count
get_totals_url <- function(lang) {
  paste("http://storage.googleapis.com/books/ngrams/books/googlebooks-", lang, "-all-totalcounts-20120701.txt", sep = "")
}

# Download and import the totals count files
get_totals_data <- function(lang) {
  # temporary files, because we need to modify them first
  temp <- tempfile()
  fixed <- tempfile()
  
  download.file(get_totals_url(lang), temp)
  
  # this file has a weird structure which we need to fix before importing it
  d <- system(paste("tr '\t' '\n' <", temp, "| tail -n +2 >", fixed))
  # now import the fixed file
  d <- fread(fixed)
  setnames(d, c("year", "match_count", "page_count", "volume_count"))
  unlink(temp)
  unlink(fixed)
  d
}

# Subset the data to only contain the ngrams we are interested in
reduce_by_ngrams <- function(ds, grams) {
  ds[ngram %in% grams]
}

# Specify the languages we want
languages <- c("eng", "chi-sim", "fre", "ger", "heb", "ita", "rus", "spa")

# Load all ngram datasets
ngrams <- lapply(languages, function(l) {
  get_ngram_data(1, 1, l)
})
names(ngrams) <- languages

# Load total counts
counts <- lapply(languages, get_totals_data)
names(counts) <- languages

# Reduce the dataset to the ngrams you are interested in
# Here, we need all the years from 1850 to 2000 to plot the halflifes
ngrams <- lapply(ngrams, function(x) reduce_by_ngrams(x, 1800:1999))

save(ngrams, file = "ngrams.RData")
save(counts, file = "counts.RData")
