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

ADD_APPLICATION_USER() {
  PRINT "Add Roboshop Application User"
  id roboshop &>>$LOG
  if [ $? -ne 0 ]; then                    #usernot exist then adding the user
    useradd roboshop &>>$LOG
  fi
  STAT_CHECK $?
}

DOWNLOAD_APP_CODE(){
  PRINT "Download Application Code"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip"
  STAT_CHECK $?

  PRINT "Extract Downloaded code\t"                      #remove the old content and new content to the old directory, because it shows catalogue aleready exist
  cd /home/roboshop && unzip -o /tmp/${COMPONENT}.zip &>>$LOG && rm -rf ${COMPONENT} && mv ${COMPONENT}-main ${COMPONENT}
  ##I'm running the script with root user. so, i'm getting acess denied. To overcome these i'm giving unsafe-perm
  STAT_CHECK $?
}

FIX_PERMI(){
  PRINT "Fix Application Permissions"
  ##changing the root user as roboshop user
  chown roboshop:roboshop /home/roboshop -R  &>>$LOG
  STAT_CHECK $?
}

SETUP_SYSTEMD() {
  PRINT "Setup SystemD file\t"
  sed -i -e "s/MONGO_DNSNAME/mongodb.roboshop.internal/" -e "s/REDIS_ENDPOINT/redis.roboshop.internal/" -e "s/MONGO_ENDPOINT/mongodb.roboshop.internal/" -e "s/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/" -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/'  /home/roboshop/${COMPONENT}/systemd.service && mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
  STAT_CHECK $?

  PRINT "Start ${COMPONENT} Service\t"
  systemctl daemon-reload &>>$LOG && systemctl restart ${COMPONENT} &>>$LOG && systemctl enable ${COMPONENT} &>>$LOG
  STAT_CHECK $?
}

NODEJS() {
  PRINT "Install NodeJS"
  yum install nodejs make gcc-c++ -y &>>$LOG
  STAT_CHECK $?

  ADD_APPLICATION_USER
  DOWNLOAD_APP_CODE

  PRINT "Install NodeJS dependencies"
  cd /home/roboshop/${COMPONENT} && npm install --unsafe-perm &>>$LOG
  STAT_CHECK $?

  FIX_PERMI
  SETUP_SYSTEMD


}

JAVA() {
  PRINT "Install Maven"
  yum install maven -y &>>$LOG
  STAT_CHECK $?

  ADD_APPLICATION_USER
  DOWNLOAD_APP_CODE

  PRINT "Compile Code\t\t"
  cd /home/roboshop/${COMPONENT} && mvn clean package &>>$LOG &&  mv target/shipping-1.0.jar shipping.jar
  STAT_CHECK $?

  FIX_PERMI
  SETUP_SYSTEMD

}

PYTHON3() {
  PRINT "Install Python3\t\t"
  yum install python36 gcc python3-devel -y &>>$LOG
  STAT_CHECK $?

  ADD_APPLICATION_USER
  DOWNLOAD_APP_CODE

  PRINT "Install Python Dependencies"
  cd /home/roboshop/${COMPONENT} && pip3 install -r requirements.txt &>>$LOG
  STAT_CHECK $?

  PRINT "Update Service Configuration"
  userID=$(id -u roboshop)
  groupID=$(id -g roboshop)
  sed -i -e "/uid/ c uid = ${userID}" -e "/gid/ c gid = ${groupID}" payment.ini &>>$LOG
  STAT_CHECK $?

  FIX_PERMI
  SETUP_SYSTEMD
}
