#!/bin/bash

[ $# -eq 2 ] || { echo >&2 "This script requires exactly two arguments. Use it as follows: ./remove-blank-pages input-with-blank-pages.pdf output-without-blank-pages.pdf. Aborting."; exit 1; }
command -v gs >/dev/null 2>&1 || { echo >&2 "This script requires ghostscript but it's not installed.  Aborting."; exit 1; }
command -v pdftk >/dev/null 2>&1 || { echo >&2 "This script requires pdftk but it's not installed.  Aborting."; exit 1; }

emptyPages=$(gs -o - -sDEVICE=inkcov $1 | grep -B 1 "^ 0.000[0-9][0-9]  0.000[0-9][0-9]  0.000[0-9][0-9]  0.000[0-9][0-9]" | grep 'Page' | awk '{print $2}')
numPages=$(pdfinfo $1 | grep Pages | awk '{print $2}')
nonEmptyPages=()
echo This pdf has $numPages pages
echo These pages are empty: $emptyPages

for i in `seq 1 $numPages`; do
	if ! [[ $emptyPages =~ (^|[[:space:]])$i($|[[:space:]]) ]]
  	then
        	nonEmptyPages+=$(echo $i' ') 
	fi
done

echo These pages are not empty: $nonEmptyPages

pdftk $1 cat $(echo $nonEmptyPages) output $2
