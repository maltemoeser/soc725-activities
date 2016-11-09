#!/usr/local/bin/python

# This script extracts the ngrams you are interested from the
# first version of the Google Ngram Datasets.
#
# 1. Download all 1-gram csv files for version 20090715
#    from https://storage.googleapis.com/books/ngrams/books/datasetsv2.html
# 2. Unzip and concat the files: cat googlebooks-eng-all-1gram-20090715-* > 2009-1gram.csv

ngrams = ["1880", "1910", "1950"]
ngrams = [x + "\t" for x in ngrams]

with open("data/2009-1gram.csv") as f:
    with open("data/results.csv", "a") as r:
        for line in f:
            if any([line[:len(x)] == x for x in ngrams]):
                r.write(line)
