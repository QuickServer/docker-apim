#!/bin/bash

if [[ "$(docker images -q amreeshtyagi/am-analytics:2.6.0 2> /dev/null)" != "" ]]; 
then
echo "IMAGE amreeshtyagi/am-analytics:2.6.0 already exists"
else
echo "Installing python pip"

which pip
if [ $? -eq 0 ]
then
echo "python-pip is already installed"
else
apt-get -y install python-pip
pip install requests
fi

echo "DOWNLOADING jdk-8u161-linux-x64.tar.gz"
if [ ! -f /tmp/jdk-8u161-linux-x64.tar.gz ]; then
python ../../../../../tools/gdrive_download.py 1QbeHMFrvLUA14-eBRkKZH7_B_-S0_itg /tmp/jdk-8u161-linux-x64.tar.gz
echo "DONE"
fi

if [ ! -f /tmp/mysql-connector-java-5.1.45-bin.jar ]; then
echo "DOWNLOADING mysql-connector-java-5.1.45-bin.jar"
python ../../../../../tools/gdrive_download.py 1-yXEJvUSsBieXjUyC0mra99j7k3cuSTj /tmp/mysql-connector-java-5.1.45-bin.jar
echo "DONE"
fi

if [ ! -f /tmp/wso2am-analytics-2.6.0.zip ]; then
echo "DOWNLOADING wso2am-analytics-2.6.0.zip"
apim-analytics/python ../../../../../tools/gdrive_download.py 1cF3qZQXGJEtDXDIlCbl7KRdDyfQCo70X /tmp/wso2am-analytics-2.6.0.zip
echo "DONE"
fi

echo "ALL BASE BINARIES DOWNLOADED TO /tmp"

echo "COPYING files from /tmp"

echo "COPYING wso2am-analytics-2.6.0.zip & other binaries to /base/files"
unzip -o /tmp/wso2am-analytics-2.6.0.zip -d apim-analytics/base/files
tar xvf /tmp/jdk-8u161-linux-x64.tar.gz -C apim-analytics/base/files
cp -R -u -p  /tmp/mysql-connector-java-5.1.45-bin.jar apim-analytics/base/files

echo "BUILDING WSO2 APIM-ANALYTICS BASE IMAGE"
cd apim-analytics/base
docker build -t amreeshtyagi/am-analytics-base:2.6.0 .
rm -Rf files/wso2am-analytics-2.6.0
rm -Rf files/mysql-connector-java-5.1.45-bin.jar
rm -Rf files/jdk1.8.0_161
cd ../dashboard
docker build -t amreeshtyagi/am-analytics-dashboard:2.6.0 .
cd ../worker
docker build -t amreeshtyagi/am-analytics-worker:2.6.0 .
fi
