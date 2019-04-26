# tika-server Docker Image

This is the git repo of very small docker images (< 190MB) for [Apache Tika server](https://tika.apache.org). 

It is built on Alpine Linux image with OpenJDK 8 runtime environment. The current installed Tika Server version is 1.20. Docker image tag should match the installed Tika version.

Since Tika release 1.7 you can use the Tesseract OCR parser within Tika. This Docker image has the following Tesseract OCR languages pre-installed:

* English
* French
* German
* Spanish

## Usage

Run the container:

    docker run -d -p 9998:9998 tongwang/tika-server

A small number of environment variables are used by this image:

* TIKA_JAVA_OPTS: JVM options for Tika server
* TIKA_SPAWN_CHILD: set this environment variable if you want to start tika-server in a child process
* TIKA_CHILD_JAVA_OPTS: JVM options for the child process if TIKA_SPAWN_CHILD is set

For example to start tika-server in a child process with max heap size set to 1G, run this:

    docker run -e "TIKA_SPAWN_CHILD=1" -e "TIKA_CHILD_JAVA_OPTS=-JXmx1g" -d -p 9998:9998 tongwang/tika-server


For more info on Apache Tika Server, go to the [Apache Tika Server documentation](http://wiki.apache.org/tika/TikaJAXRS).
