#!/usr/bin/bash
#var=data
#a=100
#echo $a
#b=Rani
#echo $b

a=100
who | wc -l
a=$(who|wc -l)
echo $a

A=10
echo A = $A
DATE="2021-07-14"
DATE=$(date+%F)
echo welcome, Today date is $DATE
