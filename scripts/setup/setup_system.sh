#!/bin/bash

scripts="$HOME/github/1sudo.github.io/scripts"

echo "Updating package database ... Please wait ..."
sudo apt-get update -qq
echo "Upgrading system ... Please wait ..."
sudo apt-get upgrade -y -qq
echo -e "Installing required packages ... Please wait ..."
sudo apt-get install build-essential libmysqlclient-dev liblua5.3-dev libdb5.3-dev libssl-dev cmake git default-jre mysql-server curl -y -qq
echo "Done."

$scripts/setup.sh