#!/bin/bash

spawn() {
	yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y
	cp /vagrant/spawn-fcgi /etc/sysconfig/
	cp /vagrant/spawn-fcgi.service /etc/sysconfig/
	systemctl start spawn-fcgi
}

main() {
	spawn
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
