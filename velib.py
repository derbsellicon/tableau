#!/usr/bin/env python
import json 
import requests

apikey = 'c26e154766e007b2de4096e1c64a63396e46a712'
velib_baseurl = 'https://api.jcdecaux.com/vls/v1/stations/'
stations = {'JACQUIER':'14025', 'GERGOVIE':'14027'}

def get_velib_dispo(nstation):
	url = velib_baseurl + nstation + '?contract=Paris&apiKey=' + apikey
	result = requests.get(url)
	items = json.loads(result.text)
	return items['available_bikes']

def print_velib(station_name):
	print "Station " + station_name + " :" , get_velib_dispo(stations[station_name]) , "velib disponibles"

print_velib('JACQUIER')
print_velib('GERGOVIE')
