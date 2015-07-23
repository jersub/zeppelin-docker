NAME=zeppelin
BASE_IMAGE=java:8-jdk
VERSION=master
SPARK_VERSION=1.4.1
HADOOP_VERSION=2.4
TAG=$(REGISTRY)/$(NAME):$(VERSION)_spark$(SPARK_VERSION)_hadoop${HADOOP_VERSION}

dockerfile:
	sed \
  -e "s#{{ *BASE_IMAGE *}}#$(BASE_IMAGE)#g" \
  -e "s/{{ *VERSION *}}/$(VERSION)/g" \
  -e "s/{{ *SPARK_VERSION *}}/$(SPARK_VERSION)/g" \
  -e "s/{{ *HADOOP_VERSION *}}/$(HADOOP_VERSION)/g" \
  Dockerfile.tpl > Dockerfile

build: dockerfile
	docker pull $(BASE_IMAGE)
	docker build --no-cache=true -t $(TAG) .

push: check-spark-version
	docker push $(TAG)
