#!/usr/bin/bash

LOG=/tmp/roboshop.log
rm -f $LOG

echo -n -e "Installing nginx\t\t\t..."
yum install nginx -y   &>>$LOG
# if you given &> then output and error will be going in to the same files.
if [ $? -eq 0 ]; then
  echo done
else
  echo fail
fi

echo "Enabling nginx"
systemctl enable nginx &>>$LOG
echo $?

echo "Starting nginx"
systemctl start nginx &>>$LOG
echo $?
