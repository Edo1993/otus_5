#!/bin/bash

# fix locale problem
echo "export LC_ALL=en_US.utf-8" >> /etc/profile.d/locale.sh
echo "export LANG=en_US.utf-8" >> /etc/profile.d/locale.sh

yum update -y
yum install -y vim

# we could not listen to some ports when enforcing mode is enabled
# set permissive mode
setenforce 0

yum install -y httpd

# remove default port. We will provide port in config file
sed -i '/Listen 80/d' /etc/httpd/conf/httpd.conf

cp /vagrant/httpd/httpd@.service /etc/systemd/system
cp /vagrant/httpd/tmp.conf /etc/httpd/conf.d/tmp.conf
cp /vagrant/httpd/httpd{1,2} /etc/sysconfig

systemctl enable --now httpd@httpd1.service
systemctl enable --now httpd@httpd2.service
