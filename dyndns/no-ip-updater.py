#!/usr/bin/env python

import requests
import re
import base64
import time

##
#     Change this variables
##

USERNAME = "username@gmail.com"
PASSWORD = "pass"
HOSTNAME = "hostname.ddns.net"
LOCATION = "C:\\Log\\no-ip\\"  # if Linux use "/var/log/no-ip/"

AUTH64_Bytes = base64.b64encode(str(USERNAME+':'+PASSWORD).encode("utf-8"))
AUTHORIZATION = str(AUTH64_Bytes, "utf-8")
DATE = time.strftime("%Y-%m-%d %H:%M:%S")
r = requests.get("http://www.ddnss.de/meineip.php").text
IP = re.findall(r'[0-9]+(?:\.[0-9]+){3}', r)


# check if the file exists and then exit etc....
if False:
    exit(1)

f1 = open(LOCATION+"oldip.log", 'r+')
OLDIP = f1.read()


f2 = open(LOCATION+"no-ip.log", 'a', newline='')

if IP[0] == OLDIP:
    f2.write(DATE+" - IP is the same - NO UPDATE!\n")
else:
    f2.write(DATE+" - New-IP: "+str(IP[0])+" / Old-IP: "+OLDIP+" - UPDATE!\n")
    h = {'User-Agent': 'no-ip python script/Raspbian10 1.0 maintainer-username@gmail.com',
         'Authorization': 'Basic %s' % AUTHORIZATION}
    r = requests.get("http://dynupdate.no-ip.com/nic/update?hostname=" + HOSTNAME + "&myip=" + str(IP[0]),
                     headers=h)
    f2.write(str(r.text))       # write the result of the ip update
    f1.seek(0)                  # we put the pointer at the start of the file
    f1.truncate(0)              # we truncate the file to 0 chars from the start of the file
    f1.write(str(IP[0]))        # we write the new IP
f1.close()
f2.close()
exit(0)
