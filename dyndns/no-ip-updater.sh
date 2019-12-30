#!/bin/bash
# URL: https://github.com/dmz-madrid/rpi/edit/master/dyndns/no-ip-updater.sh
##
#		VARIABLES
##

# STATIC vars: you must CHANGE THIS
USERNAME="mymail@gmail.com" 									# here we put the email associated with the no-ip account
PASSWORD="foobar"										# here we put the password associated with the no-ip account
HOSTNAME="domain.ddns.net"									# the hostname that we want to update
HOSTNAME2="" # leave empty if you only have one hostname
HOSTNAME3="" 	
LOCATION="/var/log/no-ip" 									# the logs location /var/log/no-ip.log & /var/log/no-ip/oldip.txt
USERAGENT="--user-agent=no-ip shell script/myO.S. 1.0 maintainer-mymail@gmail.com"

# DYNAMIC vars: don't alter this
BASE64AUTH=$(echo $USERNAME:$PASSWORD | base64)							# same for all hostnames
AUTHORIZATION="--header=Authorization: Basic $BASE64AUTH" 					# this is a header parameter for wget
DATE=$(date +%Y-%m-%d\ %H:%M:%S) 								# date and time
WGETPASS="--password=$PASSWORD"									# password parameter for wget
WGETUSER="--user=$USERNAME"									# user parameter for wget
IP=`wget -q -O - http://www.ddnss.de/meineip.php| grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`

##
#		MAIN SCRIPT
##

# checking if log files created and credentials entered...
if [ -z "$USERNAME" ]; then # -z string - Checks if it's null, that is, has zero length
	echo "No user was set"
	exit 10
fi

if [ ! -f "$LOCATION/no-ip.log" ] || [ ! -f "$LOCATION/oldip.log" ]; then # -f filename - Checks for regular file existence 
	echo "Log file and/or old ip file not found. Please create $LOCATION/no-ip.log and $LOCATION/oldip.log"
	exit	10
else
	OLDIP=`cat $LOCATION/oldip.log`
	echo "Current IP=$OLDIP"
fi



if [ "$IP" == "$OLDIP" ]; then
	echo "$DATE - IP is the same - NO UPDATE" >> $LOCATION/no-ip.log
else
	echo "$DATE -  New-IP: $IP / Old-IP: $OLDIP - UPDATE!" >> $LOCATION/no-ip.log
	echo $IP > $LOCATION/oldip.log
	# we redirect the output of wget to a file, we use the '-' to use stdout instead of a file, and then concatenate stdout
	# at the end of the log file...
	# since wget doesn't let you use an email '@ 'inside of an url, we use the --user and --password options:
	# https://username'@'gmail.com:userpass@dynupdate.no-ip.com/nic.........&myip=1.1.1.1 -> error
	# --user=username'@'gmail.com --password=userpass dynupdate.no-ip.com/nic.........&myip=1.1.1.1 -> OK
	echo "$WGETUSER"
	echo "$WGETPASS"
	echo "$USERAGENT"
	echo "$AUTHORIZATION"
	sudo wget -q -O - "$WGETUSER" "$WGETPASS" "$USERAGENT" "$AUTHORIZATION" 'http://dynupdate.no-ip.com/nic/update?hostname='${HOSTNAME}'&myip='$IP''>> $LOCATION/no-ip.log
	if [ ! -z "$HOSTNAME2" ]; then
		sudo wget -q -O - "$WGETUSER" "$WGETPASS" "$USERAGENT" "$AUTHORIZATION" 'http://dynupdate.no-ip.com/nic/update?hostname='${HOSTNAME2}'&myip='$IP''>> $LOCATION/no-ip.log
		echo "hostname 1 found"
	fi
	if [ ! -z "$HOSTNAME2" ]; then
		sudo wget -q -O - "$WGETUSER" "$WGETPASS" "$USERAGENT" "$AUTHORIZATION" 'http://dynupdate.no-ip.com/nic/update?hostname='${HOSTNAME3}'&myip='$IP''>> $LOCATION/no-ip.log
		echo "hostname 2 found"
	fi
	echo " " >> $LOCATION/no-ip.log
	echo "Update ..."
	find $LOCATION/no-ip.log -type f -size +1M -exec rm -f {} \;
fi

##
#		END OF SCRIPT
##

exit 0

