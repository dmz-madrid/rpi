#!/usr/bin/python

from gpiozero import CPUTemperature
import datetime

now = datetime.datetime.now()
r=CPUTemperature()

print(str(now.strftime("%Y-%m-%d\t%H:%M\t"))+str(r.temperature)+'\'C')
