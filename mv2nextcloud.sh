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
NEXTCLOUD_ROOT=/nextcloud_root
INBOX=$NEXTCLOUD_TARGET_DIR
TARGET_FILE=$(./mv2creationdate.sh "$INPUT_FILE" "$NEXTCLOUD_ROOT/$INBOX")
echo "Moved $INPUT_FILE to $INBOX/$TARGET_FILE"
chown www-data:www-data "$NEXTCLOUD_ROOT"/"$INBOX"/"$TARGET_FILE"
if [ -z "$NEXTCLOUD_OCC_COMMAND" ]; then 
  echo "Nextcloud OCC command not specified, skipping."
else
  $NEXTCLOUD_OCC_COMMAND files:scan -p "$INBOX"/"$TARGET_FILE"
fi
