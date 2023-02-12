FROM ubuntu

RUN apt-get update && apt-get install -y docker.io inotify-tools lsof screen ocrmypdf tesseract-ocr-deu pdftk poppler-utils libtool libleptonica-dev zlib1g-dev make build-essential && git clone https://github.com/agl/jbig2enc && cd jbig2enc && ./autogen.sh && ./configure && make && make install && cd - && rm -Rf jbig2enc

COPY *.sh /

RUN mkdir /input
RUN mkdir /nextcloud_root 

COPY entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
