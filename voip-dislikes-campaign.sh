#!/bin/bash - 
#===============================================================================
#
#          FILE:  voip-dislikes-campaign.sh
# 
#         USAGE:  ./voip-dislikes-campaign.sh [start|stop|status]
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Zakaria ElQotbi (M), zakaria@derbsellicon.com
#       COMPANY:  Derbsellicon, Paris
#       VERSION:  1.0
#       CREATED:  02/27/2016 11:52:53 PM CET
#      REVISION:  ---
#===============================================================================

#dependencies: bc netpbm #TODO
ROOT=
GENIMAGE_MACHINE=zakaria@192.168.0.15
GENIMAGE_PATH=/home/zakaria/workspace/electronics/rasberry-pi/tableau

usage(){
	echo "$0 [start|stop|status]"
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

__remote_gen_image(){
	text=$1
	out=$2
	pre=$3
	post=$4
        ssh $GENIMAGE_MACHINE $GENIMAGE_PATH/tableau_genimage.sh $*
        sleep 5
        scp $GENIMAGE_MACHINE:$GENIMAGE_PATH/$out $out
}

_gather_operators_info() {
(./operators-fblikes.sh) | while read text
do
	operator=$(echo $text | cut -f1 -d: )
	likesnum=$(echo $text | cut -f2 -d: )
	__remote_gen_image "$likesnum" tmp/${operator}-likes.ppm images/${operator}.ppm images/fb-like.ppm
done
}

do_display(){
[ "$(uname -m)" = "armv6l" ] || DISPLAY_CMD=yes
while :;
do
	for file in $(ls tmp/*.ppm 2>/dev/null)
	do
		[ "$DISPLAY_CMD" = "yes" ] && { display $file ; } || \
			./led-matrix -r 16 -t 12 -D 1 $file
	done
done
}

do_gather_info(){
while :;
do
	_gather_operators_info
	sleep 15
done
}

do_start_all() {
	_sanity
	do_gather_info &
	gather_pid=$!

	do_display &
	display_pid=$!

	echo gather_pid:$gather_pid > /tmp/.tableau.lock
	echo display_pid:$display_pid >> /tmp/.tableau.lock
}

_parse_lockfile()
{
	#read gather_pid display_pid <<< $(cat /tmp/.tableau.lock 2>/dev/null| cut -f2 -d:)
        echo
}

_sanity(){
	rm -fr tmp/*
	rm -f /tmp/.tableau.lock
}

do_stop_all(){
	_parse_lockfile
	[ -n "$gather_pid" ] && kill $gather_pid
	[ -n "$display_pid" ] && kill $display_pid
	_sanity
}

do_status(){
	_parse_lockfile
	[ -n "$gather_pid" ] &&  echo "Gathering .. RUNNING on pid:$gather_pid"  || echo "Gathering .. STOPPED"
	[ -n "$display_pid" ] && echo "Display   .. RUNNING on pid:$display_pid" || echo "DISPLAY   .. STOPPED"
}

mkdir -p tmp

case "$1" in
	"status") do_status ;;
	"stop")   do_stop_all ;;
	"start")  do_start_all ;;
	*)        usage ;;
esac
