#!/usr/bin/env python
from bs4 import BeautifulSoup
import requests

ratp_baseurl = 'http://www.ratp.fr/horaires/fr/ratp/bus/prochains_passages/PP/'
stations = {'58':'528','62':'1336_1378'}

def get_bus_times(bus_line, bus_station):
	url = ratp_baseurl + 'B' + bus_line + '/' + bus_line + '_' + bus_station + '/A'
	page = requests.get(url)
	soup = BeautifulSoup(page.text,"lxml")
	timetable = soup.find("tbody")
	if timetable is None:
		return None
	times = [td.string for td in timetable.findAll("td")]
	del times[0]
	del times[1]
	return times

def print_bus(line):
	times = get_bus_times(line, stations[line])
	if times is None or times == [None, None]:
		print 'Bus ' + line + ' Service Termine'
	elif times[1] is None:
		print 'Bus ' + line + ' Prochain: ' + times[0]
	else:
		print 'Bus ' + line + ' Prochain: ' + times[0] + ' Suivant: ' + times[1]

print_bus('58')
print_bus('62')
