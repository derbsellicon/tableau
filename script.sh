#!/bin/bash - 
#===============================================================================
#
#          FILE:  script.sh
# 
#         USAGE:  ./script.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Zakaria ElQotbi (M), zakaria.elqotbi@openwide.fr
#       COMPANY:  OpenWide, Paris
#       VERSION:  1.0
#       CREATED:  01/18/2015 11:52:53 PM CET
#      REVISION:  ---
#===============================================================================

#dependencies: bc #TODO

mkdir -p tmp
rm -f tmp/*

ROOT=

usage(){
	echo "$0 [start|stop]"
	exit
}

__generate_image(){
	text=$1
	out=$2
	pre=$3
	post=$4
	ppmmake black $(echo "8.5 * $(echo $text | wc -m)" |bc) 16 > tmp/template.ppm
	ppmlabel -x 2 -y 12 -size 10 -text "$text" tmp/template.ppm > tmp/msg.ppm
	pnmcat -lr images/blank16x32.ppm $pre tmp/msg.ppm $post images/blank16x32.ppm > $out
}

_gather_bus_info() {
(python ./ratp-bus.py) | while read text
do
	line=$(echo $text | awk '{print $2}' )
	text=$(echo $text | sed 's/Bus .. //')
	__generate_image "$text" tmp/bus-${line}.ppm "images/bus.ppm images/${line}.ppm"
done
}

_gather_velib_info() {
(python ./velib.py) | while read text
do
	station=$(echo $text | awk '{print $2}' )
	text=$(echo $text | sed 's/ velib disponibles//')
	__generate_image "$text" tmp/velib-${station}.ppm images/velib2.ppm images/velib-logo3.ppm
done
}

do_display(){
while :;
do
	for file in $(ls tmp/bus-*.ppm tmp/velib-*.ppm 2>/dev/null)
	do
		sudo ./led-matrix -r 16 -t $(echo "$(head -2 $file | tail -1 | awk '{print $1}') / 25" | bc) -D 1 $file
		#display $file
	done
done
}

do_gather_info(){
while :;
do
	_gather_velib_info
	_gather_bus_info
	sleep 60
done
}

do_start_all() {
	do_gather_info &
	gather_pid=$!

	do_display &
	display_pid=$!

	echo gather_pid:$gather_pid > /tmp/.tableau.lock
	echo display_pid:$display_pid >> /tmp/.tableau.lock
}

do_stop_all(){
	read gather_pid display_pid <<< $(cat /tmp/.tableau.lock 2>/dev/null| cut -f2 -d:)
	[ -n "$gather_pid" ] && kill $gather_pid
	[ -n "$display_pid" ] && kill $display_pid
	rm -f /tmp/.tableau.lock
}

case "$1" in
	"stop")
		do_stop_all
		;;
	"start")
		do_start_all
		;;
	*)
		usage
		;;
esac
