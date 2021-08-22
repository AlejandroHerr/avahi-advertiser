#!/bin/sh

git clone https://github.com/jwilder/docker-gen
cd /go/docker-gen
git -c advice.detachedHead=false checkout 0.7.7
go mod download && CGO_ENABLED=0 GOOS=linux go build -ldflags "-X main.buildVersion=0.7.7" ./cmd/docker-gen
cp /go/docker-gen/cmd/docer-gen /build
