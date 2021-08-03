#!/usr/bin/bash

Source common.sh

PRINT "Installing nginx"
yum install nginx -y   &>>$LOG
# if you given &> then output and error will be going in to the same files.
STAT_CHECK $?

PRINT "Enabling nginx\t"
systemctl enable nginx &>>$LOG
STAT_CHECK $?

PRINT "Starting nginx\t"
systemctl start nginx &>>$LOG
STAT_CHECK $?