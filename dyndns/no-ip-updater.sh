#!/bin/bash

# copy this to /usr/sbin:
# sudo cp ddupdate.sh /usr/sbin/ddupdate.sh
# this script uses wget to update no-ip dynamic dns
USERNAME=""
PASSWORD=""
HOSTNAME=""
LOCATION="/var/log/no-ip" # logs location /var/log/no-ip.log & /var/log/no-ip/oldip.txt
USERAGENT="no-ip shell script/OS 1.0 maintainer-username@mail.com"

DATE=$(date +%Y-%m-%d\ %H:%M:%S)
echo $DATE
IP=`wget -q -O - http://www.ddnss.de/meineip.php| grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
echo $IP

# checking if log files created and credentials entered...

if [ -z "$USERNAME" ]; then # -z string is null, that is, has zero length
	echo "No user was set."
	exit 10
fi

if [ ! -f "$LOCATION/no-ip.log" ] || [ ! -f "$LOCATION/oldip.log" ]; then #  -f filename - Check for regular file existence not a directory
	echo "Log file and/or old ip file not found. Please create $LOCATION/no-ip.log and $LOCATION/oldip.log"
	exit 10
else
	OLDIP=`cat $LOCATION/oldip.log`
	echo "Current IP=$OLDIP"
fi

# updating ip...
# using --output-document=- (FILE=-) or -O, - we reroute the output to stdout
# then, we append stdout to a file
if [ "$IP" == "$OLDIP" ]; then
	echo "$DATE - IP is the same - NO UPDATE"
	echo "$DATE - IP is the same - NO UPDATE" >> $LOCATION/no-ip.log
else
	echo "$DATE -  New-IP: $IP / Old-IP: $OLDIP - UPDATE!"
	echo "$DATE -  New-IP: $IP / Old-IP: $OLDIP - UPDATE!" >> $LOCATION/no-ip.log
	echo $IP > $LOCATION/oldip.log
	wget -q -O - --user-agent="$USERAGENT" 'https://'$USERNAME':'$PASSWORD'@dynupdate.no-ip.com/nic/update?hostname='$HOSTNAME'&myip='$IP''>> $LOCATION/no-ip.log
	echo " " >> $LOCATION/no-ip.log
	echo "Update ..."
	find $LOCATION/no-ip.log -type f -size +1M -exec rm -f {} \;
fi
exit 0
