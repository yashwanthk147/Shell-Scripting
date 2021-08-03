#!/usr/bin/bash

echo "Installing nginx"
yum install nginx -y

echo "Enabling nginx"
systemctl enable nginx

echo "Starting nginx"
systemctl start nginx

