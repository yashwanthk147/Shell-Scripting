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
echo welcome, Today date is $DATE

#readwrite
a=10
echo $a
b=20
echo $b

#array
c=(10,70)
echo ${c[*]:0:2}
echo ${c[1]}

#command substitution
COURSE NAME = ${COURSE_NAME}




