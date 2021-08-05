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