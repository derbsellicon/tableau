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
i=0
(python ./tableau.py) | while read line
do
	ppmmake black $[ 11 * $(echo $line | wc -m )] 16 > tmp/template.ppm
	ppmlabel -x 15 -y 14 -text "$line" tmp/template.ppm > tmp/ratp-bus${i}.ppm
	i=$[i+1]
done

for file in tmp/ratp-bus*
do
	sudo ./led-matrix -r 16 -t $(echo "$(head -2 $file | tail -1 | awk '{print $1}') / 16.6" | bc) -D 1 $file
	#display $file
done
