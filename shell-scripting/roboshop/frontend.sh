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

PRINT "Copy RoboShop config\t"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
STAT_CHECK $?

PRINT "Update RoboShop Config\t"
sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
STAT_CHECK $?

PRINT "Enabling Nginx\t\t"
systemctl enable nginx &>>$LOG
STAT_CHECK $?

PRINT "Starting nginx\t"
systemctl restart nginx &>>$LOG
STAT_CHECK $?