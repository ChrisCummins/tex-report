#!/bin/bash

echo -n "Title: "
read title

echo -n "Subtitle: "
read subtitle

echo -n "Author: "
read author

echo -n "Date: "
read date

echo -n "Maximum count: "
read wordcount

# Setup the title page
sed -i -r 's/%TITLE%/'"$title"'/' title.tex
sed -i -r 's/%SUBTITLE%/'"$subtitle"'/' title.tex
sed -i -r 's/%AUTHOR%/'"$author"'/' title.tex
sed -i -r 's/%DATE%/'"$date"'/' title.tex

# Set the wordcount
sed -i -r 's/^(target_wordcount=).*$/\1'"$wordcount"'/' .tex/wc.sh
