# Zeppelin 0.8.0-SNAPSHOT
[![](https://images.microbadger.com/badges/image/vpetkov/zeppelin-0.8.0.svg)](https://microbadger.com/images/vpetkov/zeppelin-0.8.0 "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/vpetkov/zeppelin-0.8.0.svg)](https://microbadger.com/images/vpetkov/zeppelin-0.8.0 "Get your own version badge on microbadger.com")

Basic and *unofficial* [Docker](https://www.docker.com/what-docker) image for the development version of [Apache Zeppelin](http://zeppelin.apache.org), based on [Debian Stretch](https://wiki.debian.org/DebianStretch) and [OpenJDK 8](http://openjdk.java.net).



                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o Zeppelin  __/
             \    \         __/
              \____\_______/

# Overview

Dockerized single-host Zeppelin.

# Exposed ports

- 8080 - Zeppelin web application port
- 8443 - Zeppelin web application secure port


# Volumes

The folling volumes can be mounted on host machine to provide data inside the container:
- /opt/zeppelin/conf
- /opt/zeppelin/logs
- /opt/zeppelin/notebook


# Official Zeppelin Documentation:

- [Overview](http://zeppelin.apache.org/docs/0.8.0-SNAPSHOT/)
- [Quick Start](http://zeppelin.apache.org/docs/0.8.0-SNAPSHOT/quickstart/install.html)
- [Interpreters](http://zeppelin.apache.org/docs/0.8.0-SNAPSHOT/usage/interpreter/overview.html)
- [Wiki](https://cwiki.apache.org/confluence/display/ZEPPELIN/Zeppelin+Home)


# Pre-Requisites
At least Docker 17.05 (Docker or Docker for Mac/Windows) is required as the build uses a multi-stage build.

# How to use from Docker CLI

1. Start a (Docker Quickstart) Terminal
2. Run command  `docker run -d -p 8080:8080 vpetkov/zeppelin`
4. Connect to Zeppelin from your favorite browser, e.g. ` http://localhost:8080/#/`

# Enjoy! :)