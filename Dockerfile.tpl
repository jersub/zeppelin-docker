FROM {{ BASE_IMAGE }}
MAINTAINER Jeremy SUBTIL <jeremy.subtil@gmail.com>

ENV ZEPPELIN_VERSION {{ VERSION }}
ENV ZEPPELIN_HOME /opt/zeppelin
ENV ZEPPELIN_CONF_DIR ${ZEPPELIN_HOME}/conf
ENV ZEPPELIN_LOG_DIR ${ZEPPELIN_HOME}/logs
ENV ZEPPELIN_NOTEBOOK_DIR ${ZEPPELIN_HOME}/notebook

ENV SPARK_VERSION {{ SPARK_VERSION }}
ENV HADOOP_VERSION {{ HADOOP_VERSION }}

# Useful for building Maven-based apps
ENV MAVEN_VERSION 3.2.5
ENV M2_HOME /opt/apache-maven
RUN \
  mkdir -p $M2_HOME && \
  curl -L http://www.pirbot.com/mirrors/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz | tar xz --strip=1 -C $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH

RUN apt-get update && apt-get -y install bzip2 && apt-get clean

RUN useradd -d $ZEPPELIN_HOME -m -s /bin/bash zeppelin

WORKDIR $ZEPPELIN_HOME

# By default, root isn't allowed to run bower
USER zeppelin

RUN curl -L https://github.com/apache/incubator-zeppelin/archive/${ZEPPELIN_VERSION}.tar.gz | tar xz --strip=1 -C $ZEPPELIN_HOME
RUN mvn clean package -DskipTests -Pspark-$(echo $SPARK_VERSION | grep -Po "\d+\.\d+") -Dspark.version=$SPARK_VERSION -Phadoop-$HADOOP_VERSION

USER root
ENTRYPOINT ["bin/zeppelin.sh"]
