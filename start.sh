 #! /bin/bash

sudo -i
rm -f /var/run/yum.pid  #1

yum -y install wget  #2

wget --no-check-certificate https://raw.github.com/Lozy/danted/master/install.sh -O install.sh   #1

bash install.sh  --port=12555 --user=xxx --passwd=xxxxxxxx --whitelist="xx.xx.xx.xx/12"  #2