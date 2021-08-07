#!/usr/bin/bash

LOG=/tmp/roboshop.log
rm -f $LOG

STAT_CHECK() {
  if [ $1 -eq 0 ]; then
  echo done
else
  echo fail
  echo -e "Check the log file more details, Log File - $LOG"
  exit 1
fi
}

PRINT() {
#  echo -e "#################\t$1###################" &>>
  echo -n -e "$1\t\t..."
}

NODEJS() {
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
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
  STAT_CHECK $?

  PRINT "Extract Downloaded content"                      #remove the old content and new content to the old directory, because it shows catalogue aleready exist
  cd /home/roboshop && unzip -o /tmp/${COMPONENT}.zip &>>$LOG && rm -rf ${COMPONENT} && mv catalogue-main ${COMPONENT}
  ##I'm running the script with root user. so, i'm getting acess denied. To overcome these i'm giving unsafe-perm
  STAT_CHECK $?

  PRINT "Install NodeJS dependencies"
  cd /home/roboshop/${COMPONENT} && npm install --unsafe-perm &>>$LOG
  STAT_CHECK $?

  PRINT "Fix Application Permissions"
  ##changing the root user as roboshop user
  chown roboshop:roboshop /home/roboshop -R  &>>$LOG
  STAT_CHECK $?

  PRINT "setup SystemD file\t"
  sed -i -e "s/MONGO_DNSNAME/mongodb.roboshop.internal/" -e "s/REDIS_ENDPOINT/redis.roboshop.internal/" -e "s/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/" /home/roboshop/${COMPONENT}/systemd.service && mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
  STAT_CHECK $?

  PRINT "Start ${COMPONENT} service\t\t"
  systemctl daemon-reload &>>$LOG && systemctl start ${COMPONENT} &>>$LOG && systemctl enable ${COMPONENT} &>>$LOG
  STAT_CHECK $?
}