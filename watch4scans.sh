#!/bin/bash
set -e
function log { echo "$(date) | $@"; }
function processFile {
  TARGET=$1
  FILENAME=$2
  if [[ "$FILENAME" = .* ]] || [[ "$FILENAME" = *.tmp ]]; then
    log "Skipping hidden or temporary file $FILENAME"
  else 
    log "Processing $FILENAME..."
    sleep 1
    if [ ! -f "$TARGET/$FILENAME" ]; then
      echo "File $FILENAME does not exist, moving on."
      return
    fi
    sleep 5
    while [ $(($(date +%s)-$(date -r "$TARGET"/"$FILENAME" +%s))) -le 10 ] || [[ $(lsof -t "$TARGET"/"$FILENAME" 2>&1 || true) != "" ]]; do
      log "$FILENAME is currently in use, waiting a few seconds"
      sleep 5
    done
    log "Waiting for a bit"
    sleep 5
    ocrmypdf --deskew --rotate-pages --rotate-pages-threshold 4 --force-ocr -l deu "$TARGET/$FILENAME" "$TARGET/.ocred-$FILENAME"
    ./remove-blank-pages.sh "$TARGET/.ocred-$FILENAME" "$TARGET/.blank-pages-removed-$FILENAME"
    ./mv2nextcloud.sh "$TARGET/.blank-pages-removed-$FILENAME"
    log "Processed $FILENAME, removing source file"
    rm -f "$TARGET/$FILENAME"
  fi
}
TARGET=${1}
if [ -z $TARGET ]; then
  log Please specify a directory to watch.
  exit 1
fi
log "Checking for leftover files. "
for f in "$TARGET"/*; do
  if [ -f "$f" ]; then
    FILENAME=$(basename "$f")
    processFile "$TARGET" "$FILENAME"
  fi
done
log Watching target directory $TARGET
inotifywait -m -e create -e moved_to --format "%f" $TARGET \
 | while read FILENAME
    do
      processFile "$TARGET" "$FILENAME"
    done
