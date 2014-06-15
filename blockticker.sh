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

ALERT_IMAGE="$(dirname $0)/btc.png"
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
        curl "http://textbelt.com/text" -d "number=$NUMBER" -d "message=$DATA" > /dev/null 2>&1
        ######################################################################
        # Color the text blue                                                #
        ######################################################################
        echo -e "\e[1;34m$DATA\e[0m"
    else
        echo "$DATA"
    fi
  done
}

cd $(dirname $0)
(
while true
 do
  /usr/bin/php blockticker.php
  sleep 10m
 done
) &

printf "#################\n#  BlockTicker  #   [Ctrl+C] to stop.\n#################\n"

if [[ ! -f BTCBlocks.txt ]]; then
    printf "File not found\nWaiting 15 seconds\n\n"
    sleep 15
fi
tail -f BTCBlocks.txt | Addcolor