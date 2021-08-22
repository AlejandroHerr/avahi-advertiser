# setup build arguments for version of dependencies to use
ARG DOCKER_GEN_VERSION=0.7.7
ARG FOREGO_VERSION=v0.17.0

# Use a specific version of golang to build both binaries
FROM golang:1.16.6 as gobuilder

# Build docker-gen from scratch
FROM gobuilder as dockergen

ARG DOCKER_GEN_VERSION

RUN mkdir /etc/docker-gen

RUN git clone https://github.com/jwilder/docker-gen \
  && cd /go/docker-gen \
  && git -c advice.detachedHead=false checkout $DOCKER_GEN_VERSION \
  && go mod download \
  && CGO_ENABLED=0 GOOS=linux go build -ldflags "-X main.buildVersion=${DOCKER_GEN_VERSION}" ./cmd/docker-gen
