FROM debian:bullseye
MAINTAINER tong.wang.70@gmail.com

ENV TIKA_VERSION 2.4.1

ENV NEAREST_TIKA_SERVER_URL="https://www.apache.org/dyn/closer.cgi?path=/tika/${TIKA_VERSION}/tika-server-standard-${TIKA_VERSION}.jar&action=download" \
    ARCHIVE_TIKA_SERVER_URL="https://archive.apache.org/dist/tika/${TIKA_VERSION}/tika-server-standard-${TIKA_VERSION}.jar" \
    DEFAULT_TIKA_SERVER_ASC_URL="https://downloads.apache.org/tika/${TIKA_VERSION}/tika-server-standard-${TIKA_VERSION}.jar.asc" \
    ARCHIVE_TIKA_SERVER_ASC_URL="https://archive.apache.org/dist/tika/${TIKA_VERSION}/tika-server-standard-${TIKA_VERSION}.jar.asc"

# Update packages and install tools
RUN apt-get update -qy && apt-get dist-upgrade -qy 

ENV LANG C.UTF-8

RUN apt-get install -qy --no-install-recommends wget gnupg2 \
    default-jre-headless && \
    apt-get -qqy autoremove && apt-get -qqy autoclean


RUN wget -t 10 --max-redirect 1 --retry-connrefused -qO- https://downloads.apache.org/tika/KEYS | gpg --import \
    && wget -t 10 --max-redirect 1 --retry-connrefused $NEAREST_TIKA_SERVER_URL -O /tika-server-standard-${TIKA_VERSION}.jar || rm /tika-server-standard-${TIKA_VERSION}.jar \
    && sh -c "[ -f /tika-server-standard-${TIKA_VERSION}.jar ]" || wget $ARCHIVE_TIKA_SERVER_URL -O /tika-server-standard-${TIKA_VERSION}.jar || rm /tika-server-standard-${TIKA_VERSION}.jar \
    && sh -c "[ -f /tika-server-standard-${TIKA_VERSION}.jar ]" || exit 1 \
    && wget -t 10 --max-redirect 1 --retry-connrefused $DEFAULT_TIKA_SERVER_ASC_URL -O /tika-server-standard-${TIKA_VERSION}.jar.asc  || rm /tika-server-standard-${TIKA_VERSION}.jar.asc \
    && sh -c "[ -f /tika-server-standard-${TIKA_VERSION}.jar.asc ]" || wget $ARCHIVE_TIKA_SERVER_ASC_URL -O /tika-server-standard-${TIKA_VERSION}.jar.asc || rm /tika-server-standard-${TIKA_VERSION}.jar.asc \
    && sh -c "[ -f /tika-server-standard-${TIKA_VERSION}.jar.asc ]" || exit 1;

RUN gpg --verify /tika-server-standard-${TIKA_VERSION}.jar.asc /tika-server-standard-${TIKA_VERSION}.jar

RUN apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY bin/tika-server /usr/local/bin/tika-server
COPY bin/healthcheck /usr/local/bin/healthcheck
COPY tika-config.xml /etc/tika/tika-config.xml

EXPOSE 9998
ENTRYPOINT tika-server

HEALTHCHECK CMD healthcheck