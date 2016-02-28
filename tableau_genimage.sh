#!/bin/bash - 
#===============================================================================
#
#          FILE:  tableau.sh
# 
#         USAGE:  ./tableau.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Zakaria ElQotbi (M), zakaria@elqotbi.com
#       COMPANY:  Derbsellicon, Paris
#       VERSION:  1.0
#       CREATED:  01/18/2015 11:52:53 PM CET
#      REVISION:  ---
#===============================================================================

#dependencies: bc netpbm #TODO

__generate_image(){
	text=$1
	out=$2
	pre=$3
	post=$4
	ppmmake black $(echo "8.5 * $(echo $text | wc -m)" |bc) 16 > tmp/template.ppm
	ppmlabel -x 2 -y 12 -size 10 -text "$text" tmp/template.ppm > tmp/msg.ppm
	pnmcat -lr images/blank16x32.ppm $pre tmp/msg.ppm $post images/blank16x32.ppm > $out
}

root=$(dirname $0)
cd $root
mkdir -p tmp
__generate_image $*
