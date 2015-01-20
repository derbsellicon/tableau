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
(python ./tableau.py) | while read text
do
	line=$(echo $text | awk '{print $2}' )
	text=$(echo $text | sed 's/Bus ..//')
	ppmmake black $[ 10 * $(echo $text | wc -m )] 16 > tmp/template.ppm
	ppmlabel -x 0 -y 12 -size 10 -text "$text" tmp/template.ppm > tmp/msg-bus${line}.ppm
	pnmcat -lr images/blank16x32.ppm images/bus.ppm images/${line}.ppm tmp/msg-bus${line}.ppm images/blank16x32.ppm > tmp/bus-${line}.ppm
done

for file in tmp/ratp-bus*
do
	sudo ./led-matrix -r 16 -t $(echo "$(head -2 $file | tail -1 | awk '{print $1}') / 25" | bc) -D 1 $file
	#display $file
done
