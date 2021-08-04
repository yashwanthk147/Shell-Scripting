#!/usr/bin/bash

source common.sh

PRINT "Installing nginx"
yum install nginx -y   &>>$LOG
# if you given &> then output and error will be going in to the same files.
STAT_CHECK $?

PRINT "Downloading Frontend"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG
STAT_CHECK $?

PRINT "Remove old Htdocs"
cd /usr/share/nginx/html && rm -rf * &>>$LOG
STAT_CHECK $?

PRINT "Extract Frontend Archive"
unzip /tmp/frontend.zip &>>$LOG && mv frontend-main/* . &>>$LOG && mv static/* . &>>$LOG &&rm -rf frontend-master static &>>$LOG
STAT_CHECK $?

PRINT "copy roboshop config"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
STAT_CHECK $?

PRINT "Update roboshop config"
sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
STAT_CHECK $?

PRINT "Enabling nginx\t"
systemctl enable nginx &>>$LOG
STAT_CHECK $?

PRINT "Starting nginx\t"
systemctl start nginx &>>$LOG
STAT_CHECK $?