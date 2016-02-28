#!/bin/bash - 
#===============================================================================
#
#          FILE:  operators-fblikes.sh
# 
#         USAGE:  ./operators-fblikes.sh
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
#       CREATED:  27/02/2016 12:21:10 AM CET
#      REVISION:  ---
#===============================================================================

URL='https://graph.facebook.com/_PAGE_?fields=likes&access_token=__TOKEN__'

#TOKEN="18738970308098490|JKHKEJHJLMKEMDMLKLLHJK60"
TOKEN=$(cat .token)

[ -z "$TOKEN" ] && {
    echo "no token has been specified. FATAL !"
    echo "Please get your token from https://developers.facebook.com/tools/accesstoken/"
    echo "And put it in .token file"
    exit 
}

#TTY_ARDUINO=/dev/ttyUSB1
LOG_FILE=fb-likes.log

echo "$(date)" >> $LOG_FILE 
for page in maroctelecom meditel inwi.ma
do
	LIKES_NMBR=$(curl 2>/dev/null $(echo $URL | sed 's/_PAGE_/'$page'/;s/__TOKEN__/'$TOKEN'/' ) | sed 's/.*:\([0-9]*\),.*/\1/')
	#echo $LIKES_NMBR > $TTY_ARDUINO
	echo "$page:$LIKES_NMBR FB likes" >> $LOG_FILE 
	echo "$page:$LIKES_NMBR"
done
