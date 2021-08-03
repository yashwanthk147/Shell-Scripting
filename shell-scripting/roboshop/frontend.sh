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

echo -n -e "Installing nginx\t\t\t..."
yum install nginx -y   &>>$LOG
# if you given &> then output and error will be going in to the same files.
STAT_CHECK $?

echo -n -e "Enabling nginx\t\t\t..."
systemctl enable nginx &>>$LOG
STAT_CHECK $?

echo -n -e "Starting nginx\t\t\t..."
systemctl start nginx &>>$LOG
STAT_CHECK $?