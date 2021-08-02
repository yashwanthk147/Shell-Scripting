#!/usr/bin/bash
#sample() {
#  echo Hello, I am a sample function
#}
#sample

#sample(){
#  echo value of a=$a
#}
#a=100
#sample
#
#sample1(){
#  b=566876
#}
#sample1
#echo value of b=$b


sample(){
  echo value of a ={$a}
  b=200
  echo first argument in function =$1
}
a=1000
sample
echo value of b =${b}
echo first argument in function =$1
