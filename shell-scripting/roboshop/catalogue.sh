#!/usr/bin/bash

source common.sh

PRINT "Install NodeJS"
yum install nodejs make gcc-c++ -y &>>$LOG
STAT_CHECK $?

PRINT "Add Roboshop Application User"
id roboshop &>>$LOG
if [ $? -ne 0 ]; then                    #usernot exist then adding the user
  useradd roboshop &>>$LOG
fi
STAT_CHECK $?

PRINT "Download Application Code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
STAT_CHECK $?

PRINT "Extract Downloaded content"                      #remove the old content and new content to the old directory, because it shows catalogue aleready exist
cd /home/roboshop && unzip -o /tmp/catalogue.zip &>>$LOG && rm catalogue -f mv catalogue-main catalogue && cd /home/roboshop/catalogue && npm install --unsafe-perm &>>$LOG
#I'm running the script with root user. so, i'm getting acess denied. To overcome these i'm giving unsafe-perm
STAT_CHECK $?

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue