# tika-server Docker Image

This is the git repo of a simple docker image for [Apache Tika server](https://tika.apache.org). 

It is built on Debian bullseye image with the latest jre runtime environment. The current installed Tika Server version is 2.4.1. Docker image tag should match the installed Tika version.

A healthcheck is enabled to remove orphaned tmp files and make sure /tmp have enough space.

## Usage

Run the container:

    docker run -d -p 9998:9998 tongwang/tika-server

A [standard configuration file](https://cwiki.apache.org/confluence/display/TIKA/TikaServer+in+Tika+2.x) is placed at /etc/tika/tika-config.xml, which you may overwrite with your own configuration. Assuming your co

    docker run -v /path/to/your/config_file:/etc/tika/tika-config.xml -d -p 9998:9998 tongwang/tika-server:2.4.1.0

A small number of environment variables are used by this image:

* TMP_FILE_EXPIRE_MIN: any tmp file in /tmp expires and is removed after this number of minutes. Default: 15
* TMP_WATERMARK: pass healthcheck if the percentage of disk usage of /tmp is above this watermark. Defailt: 80

For more info on Apache Tika Server, go to the [Apache Tika Server documentation](https://cwiki.apache.org/confluence/display/TIKA/TikaServer).
