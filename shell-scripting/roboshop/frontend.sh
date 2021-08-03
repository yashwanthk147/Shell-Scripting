#!/usr/bin/bash

LOG=/tmp/roboshop.log
rm -f $LOG

echo -e "Installing nginx \e[32mdone\e[0m"
yum install nginx -y   &>>$LOG
# if you given &> then output and error will be going in to the same files.

echo "Enabling nginx"
systemctl enable nginx &>>$LOG

echo "Starting nginx"
systemctl start nginx &>>$LOG

