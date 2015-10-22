NAME=zeppelin
BASE_IMAGE=buildpack-deps:jessie-curl
VERSION=master
TAG=$(REGISTRY)/$(NAME):$(VERSION)

dockerfile:
	sed \
  -e "s#{{ *BASE_IMAGE *}}#$(BASE_IMAGE)#g" \
  -e "s/{{ *VERSION *}}/$(VERSION)/g" \
  -e "s/{{ *BUILD_OPTS *}}/$(BUILD_OPTS)/g" \
  Dockerfile.tpl > Dockerfile

build: dockerfile
	docker pull $(BASE_IMAGE)
	docker build --no-cache=true -t $(TAG) .

push:
	docker push $(TAG)
