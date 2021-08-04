#!/usr/bin/bash

source common.sh

PRINT "Install NodeJS"
yum install nodejs make gcc-c++ -y &>>$LOG
STAT_CHECK $?

PRINT "Add Roboshop Application User"
useradd roboshop &>>$LOG
#usernot exist then adding the user
if [ $? -ne 0]; then
  useradd roboshop &>>$LOG
fi
STAT_CHECK $?



#$ curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
#$ cd /home/roboshop
#$ unzip /tmp/catalogue.zip
#$ mv catalogue-main catalogue
#$ cd /home/roboshop/catalogue
#$ npm install

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue