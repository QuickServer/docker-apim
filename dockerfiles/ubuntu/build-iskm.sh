#!/bin/bash

if [[ "$(docker images -q amreeshtyagi/is-km:5.7.0 2> /dev/null)" != "" ]]; 
then
echo "IMAGE amreeshtyagi/is-km:5.7.0 already exists"
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

if [ ! -f /tmp/wso2is-km-5.7.0.zip ]; then
echo "DOWNLOADING wso2is-km-5.7.0.zip"
python ../../../../../tools/gdrive_download.py 1NbBopoiLYQHIHXY3k9JanDToRCEdU3bq  /tmp/wso2is-km-5.7.0.zip
echo "DONE"
fi

echo "ALL BASE BINARIES DOWNLOADED TO /tmp"

echo "COPYING files from /tmp"

echo "COPYING wso2is-km-5.7.0.zip & other binaries to /files"
unzip -o /tmp/wso2is-km-5.7.0.zip -d is-as-km/files
tar xvf /tmp/jdk-8u161-linux-x64.tar.gz -C is-as-km/files
cp -R -u -p  /tmp/mysql-connector-java-5.1.45-bin.jar is-as-km/files

echo "BUILDING WSO2 IS-KM IMAGE"
cd is-as-km
docker build -t amreeshtyagi/is-km:5.7.0 .
rm -Rf files/wso2is-km-5.7.0
rm -Rf files/mysql-connector-java-5.1.45-bin.jar
rm -Rf files/jdk1.8.0_161
fi
