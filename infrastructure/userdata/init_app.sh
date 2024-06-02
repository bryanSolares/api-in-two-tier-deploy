#!/bin/bash

yum update -y
yum install git -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install 18
nvm use 18


mkdir /home/ec2-user/app
git clone https://github.com/bryanSolares/simple-skeleton-backend-nodejs-express.git /home/ec2-user/app

cd /home/ec2-user/app
cp .env.example .env
npm install
npm install pm2 -g
pm2 start src/app.js