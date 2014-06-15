# Welcome to blockticker


This bash/php script will scrape [blockorigin](http://blockorigin.pfoe.be) every 5 minutes and display any new found blocks along with the pool that found them.

It also keeps a log of all the blocks and their respective finders in the file BTCBlocks.txt for future reference.

If you set the NAME variable in blockticker.sh to the name of your pool you will also get desktop notifications whenever your pool finds a block.

If you set the NUMBER variable to your number you can make use of the excellent service provided by [textbelt](http://textbelt.com) to receive SMS notifications when your pool finds a block. 


How to use:

>sudo chmod +x blockticker.sh

>./blockticker.sh


To run headless comment out the desktop notification line in blockticker.sh and run the script in a [screen](http://en.wikipedia.org/wiki/GNU_Screen) session and leave the session connected.



Enjoy!