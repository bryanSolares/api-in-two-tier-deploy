#!/bin/bash
cd /home/ec2-user/app
git pull origin main
npm install
pm2 start src/app.js
