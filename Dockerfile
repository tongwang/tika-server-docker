FROM alpine:latest
MAINTAINER tong.wang.70@gmail.com

ENV TIKA_VERSION 1.20
ENV TIKA_SERVER_URL https://www.apache.org/dist/tika/tika-server-$TIKA_VERSION.jar

RUN apk add \
    --update \
    --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    bash \
    openjdk8-jre \
    gnupg \
    curl \
    tesseract-ocr tesseract-ocr-data-ita \
    tesseract-ocr-data-fra tesseract-ocr-data-spa tesseract-ocr-data-deu

RUN curl -sSL https://people.apache.org/keys/group/tika.asc -o /tmp/tika.asc
RUN gpg --import /tmp/tika.asc
RUN curl -sSL "$TIKA_SERVER_URL.asc" -o /tmp/tika-server.jar.asc
RUN NEAREST_TIKA_SERVER_URL=$(curl -sSL http://www.apache.org/dyn/closer.cgi/${TIKA_SERVER_URL#https://www.apache.org/dist/}\?asjson\=1 \
		| awk '/"path_info": / { pi=$2; }; /"preferred":/ { pref=$2; }; END { print pref " " pi; };' \
		| sed -r -e 's/^"//; s/",$//; s/" "//') \
	&& echo "Nearest mirror: $NEAREST_TIKA_SERVER_URL" \
	&& curl -sSL "$NEAREST_TIKA_SERVER_URL" -o /tika-server.jar

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY bin/tika-server /usr/local/bin/tika-server

EXPOSE 9998
ENTRYPOINT tika-server

