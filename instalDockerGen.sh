#!/bin/sh

function checkSudo() {
  if ((EUID != 0)); then
    echo "Granting root privileges for script ( $SCRIPT_NAME )"
    if [[ -t 1 ]]; then
      sudo "$0" "$@"
    else
      exec 1>output_file
      gksu "$0" "$@"
    fi
    exit
  fi
}

function cdPath() {
  SCRIPT=$(realpath $0)
  SCRIPTPATH=$(dirname $SCRIPT)

  cd $SCRIPTPATH
}

function dockerClean() {
  rm -rfv .build

  docker rmi docker-gen-builder
}

function buildAndInstallDockerGen() {
  dockerClean

  mkdir ./build
  docker build -t docker-gen-builder ./docker-gen-builder
  docker run --rm -v $SCRIPTPATH/build:/build docker-gen-builder cp -rv /go/docker-gen/docker-gen /build
  mv -v ./build/docker-gen /usr/local/bin/

  dockerClean
}

checkSudo
cdPath

buildAndInstallDockerGen
