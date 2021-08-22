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

checkSudo
cdPath

rm -rfv /etc/advertiser
mkdir /etc/advertiser

cp -rv ./etc/* /etc/advertiser/
cp -rv ./service/* /etc/systemd/system/
cp ./advertiser_avahi_publish /usr/bin/advertiser_avahi_publish

systemctl stop advertiser-docker-gen.service
systemctl stop advertiser-avahi.service

systemctl daemon-reload
