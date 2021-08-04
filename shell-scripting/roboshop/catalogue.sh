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
cd /home/roboshop && unzip -o /tmp/catalogue.zip &>>$LOG && rm -rf catalogue && mv catalogue-main catalogue
#I'm running the script with root user. so, i'm getting acess denied. To overcome these i'm giving unsafe-perm
STAT_CHECK $?

PRINT "Install NodeJS dependencies"
cd /home/roboshop/catalogue && npm install --unsafe-perm &>>$LOG
STAT_CHECK $?

PRINT "Fix Application Permissions"
#changing the root user as roboshop user
chown roboshop:roboshop /home/roboshop -R  &>>$LOG
STAT_CHECK $?

PRINT "Update SystemD file\t"
sed -i -e "s/MONGO_DNSNAME/mongodb.roboshop.internal/" /home/roboshop/catalogue/systemd.service && mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
STAT_CHECK $?


PRINT "Start catalogue service\t\t"
systemctl daemon-reload &>>$LOG && systemctl start catalogue &>>$LOG && systemctl enable catalogue &>>$LOG