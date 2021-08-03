#!/usr/bin/bash

LOG=/tmp/roboshop.log
rm -f $LOG

STAT_CHECK() {
  if [ $1 -eq 0 ]; then
  echo done
else
  echo fail
  exit 1
fi
}

PRINT() {
  echo -n -e " $1\t\t..."
}
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