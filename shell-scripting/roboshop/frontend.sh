#!/usr/bin/bash

LOG=/tmp/roboshop.log
rm -f $LOG

echo -e "Installing nginx \e[32mdone\e[0m"
yum install nginx -y   >>$LOG

echo "Enabling nginx"
systemctl enable nginx >>$LOG

echo "Starting nginx"
systemctl start nginx >>$LOG

