#!/bin/bash
set -e
INPUT_FILE=$1
if [[ $INPUT_FILE = "" ]]; then
  echo No input file specified. 
  exit 1
fi
if [ ! -f "$INPUT_FILE" ]; then
  echo Input file $INPUT_FILE does not exist or is not a regular file. 
  exit 1
fi
TARGET_DIRECTORY=$2
if [[ $TARGET_DIRECTORY = "" ]]; then
  echo No target directory specified. 
  exit 1
fi
if [ ! -d $TARGET_DIRECTORY ]; then
  echo Target directory $TARGET_DIRECTORY does not exist or is not a directory. 
  exit 1
fi
INPUT_FILE_TYPE=${INPUT_FILE##*.}
INPUT_FILE_YEAR_AND_MONTH=$(date -r "$INPUT_FILE" +%Y-%m)
INPUT_FILE_TIMESTAMP=$(date -r "$INPUT_FILE" +%Y-%m-%d_%H-%M-%S)
if [ -f "$TARGET_DIRECTORY"/"$INPUT_FILE_YEAR_AND_MONTH" ]; then
  echo Dated target directory $TARGET_DIRECTORY/$INPUT_FILE_YEAR_AND_MONTH cannot be created, it already exists as a regular file. 
  exit 1
fi
if [ ! -d "$TARGET_DIRECTORY"/"$INPUT_FILE_YEAR_AND_MONTH" ]; then
  mkdir "$TARGET_DIRECTORY"/"$INPUT_FILE_YEAR_AND_MONTH"
  chown www-data:www-data "$TARGET_DIRECTORY"/"$INPUT_FILE_YEAR_AND_MONTH"
fi
HASH=$(cat "$INPUT_FILE" | md5sum | cut -d ' ' -f 1 | cut -c1-8)
cp -p "$INPUT_FILE" "$TARGET_DIRECTORY"/"$INPUT_FILE_YEAR_AND_MONTH"/"$INPUT_FILE_TIMESTAMP"_"$HASH"."$INPUT_FILE_TYPE"
echo "$INPUT_FILE_YEAR_AND_MONTH"/"$INPUT_FILE_TIMESTAMP"_"$HASH"."$INPUT_FILE_TYPE"
rm "$INPUT_FILE"
