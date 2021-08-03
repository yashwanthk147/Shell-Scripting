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

PRINT() {
  echo -n -e " $1\t\t..."
}