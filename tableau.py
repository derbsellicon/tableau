from bs4 import BeautifulSoup
import requests

ratp_baseurl = 'http://www.ratp.fr/horaires/fr/ratp/bus/prochains_passages/PP/'
stations = {'58':'528','62':'1336_1378'}

def get_bus_times(bus_line, bus_station):
	url = ratp_baseurl + 'B' + bus_line + '/' + bus_line + '_' + bus_station + '/A'
	page = requests.get(url)
	soup = BeautifulSoup(page.text,"lxml")
	timetable = soup.find("tbody")
	times = [ td.string for td in timetable.findAll("td")]
	del times[0]
	del times[1]
	return times

def print_bus(line):
	times = get_bus_times(line, stations[line])
	print 'bus:' , line
	print 'prochain: ' + times[0]
	print 'suivant: ' + times[1]

print_bus('58')
print '===================='
print_bus('62')
