#!/bin/bash
# ami_id ami-04169656fea786776 (Ubuntu 16.04.5 xenial)
set -xe

# Printing ubuntu version
lsb_release -a

# Fixing perl warnings
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export DEBIAN_FRONTEND=noninteractive

# Updating OS
sudo apt-get -y update
sudo apt-get -y upgrade

# Setting debconf answers for mysql and graphite-carbon
echo "mysql-server-5.7 mysql-server/root_password password ${ROOT_PASSWORD}" | sudo debconf-set-selections
echo "mysql-server-5.7 mysql-server/root_password_again password ${ROOT_PASSWORD}" | sudo debconf-set-selections
echo "graphite-carbon graphite-carbon/postrm_remove_databases boolean false" | sudo debconf-set-selections

# Installing graphite, apache2 and mysql packages
sudo apt-get -y install mysql-server-5.7
sudo apt-get -y install python-mysqldb
sudo apt-get -y install python-pymysql
sudo apt-get -y install graphite-web
sudo apt-get -y install graphite-carbon
sudo apt-get -y install apache2
sudo apt-get -y install libapache2-mod-wsgi
sudo apt-get -y install apt-transport-https 