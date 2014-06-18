#!/bin/bash
#    Copyright 2014 Dave Umrysh
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

ALERT_IMAGE="/home/dave/bin/btc.png"
NAME="slush"
NUMBER="5554443333"

function Addcolor
{
  while read DATA
  do
    if [[ "$DATA" =~ "$NAME" ]]
    then
        BLOCK=`echo $DATA | cut -d '|' -f 1`
        ######################################################################
        # Leave the line below uncommented if you want desktop notifications #
        ######################################################################
        DISPLAY=:0.0 XAUTHORITY=~/.Xauthority notify-send -i $ALERT_IMAGE -t 5000 --hint=int:transient:1 -- "Pool Won Block" "$BLOCK";
        ######################################################################
        # Leave the line below uncommented if you want SMS notifications     #
        ######################################################################
        #curl "http://textbelt.com/text" -d "number=$NUMBER" -d "message=$DATA" > /dev/null 2>&1
        ######################################################################
        # Color the text blue                                                #
        ######################################################################
        echo -e "\e[1;34m$DATA\e[0m"
    else
        echo "$DATA"
    fi
  done
}

# From http://stackoverflow.com/a/12199798
convertsecs() {
   ((m=(${1}%3600)/60))
   ((s=${1}%60))
   printf "%02d:%02d\n" $m $s
}

function ConvertDates
{
  while read DATA
  do
    BLOCK=`echo $DATA | cut -d '|' -f 1`
    FOUNDTIME=`echo $DATA | cut -d '|' -f 2 | { read UNIXDATE ; date -d @$UNIXDATE; }`
    DIFFTIME=`echo $DATA | cut -d '|' -f 3`
    FOUNDER=`echo $DATA | cut -d '|' -f 4`
    echo "$BLOCK - $FOUNDTIME - $(convertsecs $DIFFTIME) - $FOUNDER"
  done
}

cd $(dirname $0)
(
while true
 do
  /usr/bin/php blockticker.php > /dev/null 2>&1
  sleep 10m
 done
) &

printf "#################\n#  BlockTicker  #   [Ctrl+C] to stop.\n#################\nBlock              Time Found           Duration  Founder\n#########################################################\n"

if [[ ! -f BTCBlocks.txt ]]; then
    printf "File not found\nWaiting 5 minutes\n\n"
    sleep 300
fi
tail -f BTCBlocks.txt | ConvertDates | Addcolor