# Bit by Bit Activities
# http://www.bitbybitbook.com/en/observing-behavior/observing-activities/
# 2.7 a)
# 
# Make sure to set your working directory to the source file location

require(data.table)
require(bit64)

# Create the results.csv file using the python script extract-ngrams.py
years <- fread("data/results.csv")
setnames(years, c("ngram", "year", "match_count", "page_count", "volume_count"))
setkeyv(years, c("ngram", "year"))

total <- fread("data/googlebooks-eng-all-totalcounts-20090715.txt")
setnames(total, c("year", "match_count", "page_count", "volume_count"))

# We are only interested in the period from 1850-2000
xrange <- 1850:2000

y1880 <- years[ngram == "1880" & year %in% xrange]$match_count
y1910 <- years[ngram == "1910" & year %in% xrange]$match_count
y1950 <- years[ngram == "1950" & year %in% xrange]$match_count

freq <- total[year %in% xrange]$match_count

# Reproduce plot from the paper
plot(xrange, y1950/freq, col="red", type="l", lwd=2, xlab="Year", ylab="Frequency", main="We forget.")
lines(xrange, y1910/freq, col="green", lwd=2)
lines(xrange, y1880/freq, col="blue", lwd=2)
