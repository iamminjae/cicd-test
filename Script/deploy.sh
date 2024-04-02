#!/bin/bash
BUILD_JAR=$(ls /home/ubuntu/cicd-test/build/libs/*.jar)
JAR_NAME=$(basename $BUILD_JAR)
echo "> build : $JAR_NAME" >> /home/ubuntu/deploy.log

echo "> build 파일 복사" >> /home/ubuntu/deploy.log
DEPLOY_PATH=/home/ubuntu/demo
cp $BUILD_JAR $DEPLOY_PATH

echo "> 실행중인 애플리케이션 pid 확인" >> /home/ubuntu/deploy.log
CURRENT_PID=$(pgrep -f $JAR_NAME)

if [ -z $CURRENT_PID ]
then
  echo "> 실행중인 애플리케이션이 없으므로 종료하지 않음" >> /home/ubuntu/deploy.log
else
  echo "> kill -15 $CURRENT_PID" >> /home/ubuntu/deploy.log
  kill -15 $CURRENT_PID
  sleep 10
fi

DEPLOY_JAR=$DEPLOY_PATH$JAR_NAME
echo "> DEPLOY_JAR 배포"    >> /home/ubuntu/deploy.log
nohup java -jar $DEPLOY_JAR >> /home/ubuntu/deploy.log 2>/home/ubuntu/deploy_err.log &