#!/bin/bash

LOCATION="/var/log/temperature"                   # the logs location /var/log/no-ip.log & /var/log/no-ip/oldip.txt
TEMP=`/opt/vc/bin/vcgencmd measure_temp`          # temp
DATE=$(date +%Y-%m-%d\ %H:%M:%S)                  # date and time
echo "$DATE - $TEMP" >> $LOCATION/temp.log
