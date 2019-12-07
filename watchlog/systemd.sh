#!/bin/bash

log_parsing() {
     cp /vagrant/watchlog.sh /opt/
     cp /vagrant/watchlog.service /etc/systemd/system/
     cp /vagrant/watchlog.timer /etc/systemd/system/
     cp /vagrant/watchlog.log /var/log/
     cp /vagrant/watchlog /etc/sysconfig/
     systemctl daemon-reload
     systemctl enable watchlog.service
     systemctl enable watchlog.timer
     systemctl start watchlog.timer
}

main() {
	log_parsing
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
