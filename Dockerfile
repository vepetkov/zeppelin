################################################################################
### STAGE 1: Build Zeppelin from Source ###
FROM maven:3.5-jdk-8 as builder

MAINTAINER Ventsislav Petkov <ventsi84@gmail.com>

ARG BRANCH="branch-0.8"
ARG SCALA_VER="2.11"
ARG SPARK_VER="2.2"

ENV ZEPPELIN_VERSION="0.8.0-SNAPSHOT" \
    ZEPPELIN_SRC="/usr/src/zeppelin"

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
	&& apt-get update && apt-get install -y --no-install-recommends \
		git \
		nodejs \
		python3 python3-setuptools \
        r-base-dev r-cran-evaluate \
	&& rm -rf /var/lib/apt/lists/* \
    && mkdir -p $ZEPPELIN_SRC \
    && git clone --branch $BRANCH https://github.com/apache/zeppelin.git $ZEPPELIN_SRC

WORKDIR $ZEPPELIN_SRC

# update all pom.xml to use the selected scala version
RUN ./dev/change_scala_version.sh $SCALA_VER 

# install bower dependencies
RUN npm install -g bower  \
	&& cd zeppelin-web \
    && bower install --config.interactive=false --allow-root --quiet \
    && cd ..

# get all the MVN dependencies out of the way 
# RUN mvn verify clean -DskipTests -Dcheckstyle.skip --fail-never
 
# build zeppelin with all interpreters and include Apache Spark & Python support
RUN mvn package -DskipTests -Dcheckstyle.skip \
	-Pscala-$SCALA_VER -Pspark-$SPARK_VER -Pr -Phelium-dev -Pexamples -Pbuild-distr


################################################################################
### STAGE 2: Create the Runtime Container ###
FROM openjdk:8

MAINTAINER Ventsislav Petkov <ventsi84@gmail.com>

LABEL eu.vpetkov.zeppelin.docker=true
ARG COMMIT_ID=unknown
LABEL eu.vpetkov.zeppelin.git.id=$COMMIT_ID
ARG BUILD_NUMBER=-1
LABEL eu.vpetkov.zeppelin.build.number=$BUILD_NUMBER

ENV ZEPPELIN_VERSION="0.8.0-SNAPSHOT" \
	ZEPPELIN_SRC="/usr/src/zeppelin" \
	ZEPPELIN_HOME="/opt/zeppelin" \
	ZEPPELIN_CONF_DIR="/opt/zeppelin/conf" \
	ZEPPELIN_PORT=8080 \
	ZEPPELIN_SSL_PORT=8443

EXPOSE $ZEPPELIN_PORT $ZEPPELIN_SSL_PORT

VOLUME $ZEPPELIN_CONF_DIR \
       $ZEPPELIN_HOME/logs \
       $ZEPPELIN_HOME/notebook

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
	&& apt-get update && apt-get install -y --no-install-recommends \
		curl \
        jq \
		nodejs \
		python3 python3-setuptools \
        r-base-dev r-cran-evaluate \
	&& rm -rf /var/lib/apt/lists/* \
    && npm install -g yarn

WORKDIR $ZEPPELIN_HOME

COPY --from=builder ${ZEPPELIN_SRC}/zeppelin-distribution/target/zeppelin-${ZEPPELIN_VERSION}.tar.gz $ZEPPELIN_HOME

RUN tar --strip-components=1 -xzvf zeppelin-${ZEPPELIN_VERSION}.tar.gz \
    && rm zeppelin-${ZEPPELIN_VERSION}.tar.gz

CMD ./bin/zeppelin.sh run