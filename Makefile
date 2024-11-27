VERSION ?= noble-1.0.0
ifdef BASE_IMAGE
	BUILD_ARG = --build-arg BASE_IMAGE=$(BASE_IMAGE)
	ifndef NAME
		NAME = phusion/baseimage-$(subst :,-,${BASE_IMAGE})
	endif
else
	NAME ?= phusion/baseimage
endif
ifdef TAG_ARCH
	# VERSION_ARG = $(VERSION)-$(subst /,-,$(subst :,-,${BASE_IMAGE}))-$(TAG_ARCH)
	VERSION_ARG = $(VERSION)-$(TAG_ARCH)
	LATEST_VERSION = latest-$(TAG_ARCH)
else
	# VERSION_ARG = $(VERSION)-$(subst /,-,$(subst :,-,${BASE_IMAGE}))
	VERSION_ARG = $(VERSION)
	LATEST_VERSION = latest
endif
VERSION_ARG ?= $(VERSION)

.PHONY: all build test tag_latest release ssh

all: build

build:
	docker build -t $(NAME):$(VERSION) --rm image

test:
	env NAME=$(NAME) VERSION=$(VERSION) ./test/runner.sh

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

ssh: SSH_COMMAND?=
ssh:
	ID=$$(docker ps | grep -F "$(NAME):$(VERSION_ARG)" | awk '{ print $$1 }') && \
		if test "$$ID" = ""; then echo "Container is not running."; exit 1; fi && \
		tools/docker-ssh $$ID ${SSH_COMMAND}

test_release:
	echo test_release
	env

test_master:
	echo test_master
	env
